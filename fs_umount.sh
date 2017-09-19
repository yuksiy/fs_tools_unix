#!/bin/sh

# ==============================================================================
#   機能
#     ファイルシステムをマウント解除する
#   構文
#     USAGE 参照
#
#   Copyright (c) 2006-2017 Yukio Shiiya
#
#   This software is released under the MIT License.
#   https://opensource.org/licenses/MIT
# ==============================================================================

######################################################################
# 基本設定
######################################################################
trap "" 28				# TRAP SET
trap "exit 1" 1 2 15	# TRAP SET

######################################################################
# 変数定義
######################################################################
# ユーザ変数
MOUNT_OPTIONS=""
UMOUNT_OPTIONS=""

# システム環境 依存変数
SLEEP="sleep"

# プログラム内部変数

######################################################################
# 関数定義
######################################################################
USAGE() {
	cat <<- EOF 1>&2
		Usage:
		  fs_umount.sh MOUNT_TYPE DEVICE MOUNT [UMOUNT_OPTIONS ...]
		
		  MOUNT_TYPE : {local|remote}
		  DEVICE : Specify the device to unmount.
		  MOUNT  : Specify the mount point directory to unmount the device from.
		  UMOUNT_OPTIONS : Specify options which execute umount command with.
	EOF
}

# ファイルシステムのマウント解除
FS_UMOUNT() {
	# 処理開始メッセージの表示
	echo "-I デバイス($1) のマウントポイント($2) からのマウント解除を開始します"

	# マウント済み判定
	IFS_SAVE=${IFS}
	IFS='
'
	MOUNTED=0
	for line in `LANG=C mount 2>&1 | grep -i -F -e "$1"` ; do
		DEV=`echo "${line}" | awk '{print $1}'`
		MNT=`echo "${line}" | awk '{print $3}'`
		if [ "${MNT}" = "$2" ];then
			MOUNTED=1
			break
		fi
	done
	IFS=${IFS_SAVE}
	unset IFS_SAVE
	if [ ${MOUNTED} -ne 1 ];then
		echo "-W デバイス($1) はマウントポイント($2) にマウントされていません" 1>&2
		return 0
	fi

	# マウント解除
	sync;sync;sync
	umount $2 ${UMOUNT_OPTIONS}
	UMOUNT_RC=$?

	# 処理終了メッセージの表示
	if [ ${UMOUNT_RC} -eq 0 ];then
		# 成功
		echo "-I デバイス($1) のマウントポイント($2) からのマウント解除が正常終了しました"
		return 0
	else
		# 失敗
		echo "-E デバイス($1) のマウントポイント($2) からのマウント解除が異常終了しました" 1>&2
		echo "     'umount' return code: ${UMOUNT_RC}" 1>&2
		return ${UMOUNT_RC}
	fi
}

######################################################################
# メインルーチン
######################################################################

# 第1引数のチェック
if [ "$1" = "" ];then
	echo "-E Missing MOUNT_TYPE argument" 1>&2
	USAGE;exit 1
else
	MOUNT_TYPE="$1"
	case "${MOUNT_TYPE}" in
	local|remote)
		# 何もしない
		:
		;;
	*)
		echo "-E Invalid MOUNT_TYPE argument -- \"${MOUNT_TYPE}\"" 1>&2
		USAGE;exit 1
		;;
	esac
fi

# 第2引数のチェック
if [ "$2" = "" ];then
	echo "-E Missing DEVICE argument" 1>&2
	USAGE;exit 1
else
	DEVICE="$2"
fi

# 第3引数のチェック
if [ "$3" = "" ];then
	echo "-E Missing MOUNT argument" 1>&2
	USAGE;exit 1
else
	MOUNT="$3"
fi

# UMOUNT_OPTIONSの取得
shift 3
UMOUNT_OPTIONS="${UMOUNT_OPTIONS} $@"

# ファイルシステムのマウント解除
FS_UMOUNT "${DEVICE}" "${MOUNT}"

