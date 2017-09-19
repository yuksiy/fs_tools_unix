#!/bin/sh

# ==============================================================================
#   機能
#     ファイルシステムをチェックする
#   構文
#     USAGE 参照
#
#   Copyright (c) 2007-2017 Yukio Shiiya
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
FSCK_OPTIONS=""

# システム環境 依存変数

# プログラム内部変数

######################################################################
# 関数定義
######################################################################
USAGE() {
	cat <<- EOF 1>&2
		Usage:
		  fs_check.sh DEVICE [FSCK_OPTIONS ...]
		
		  DEVICE : Specify the device to check.
		  FSCK_OPTIONS : Specify options which execute fsck command with.
	EOF
}

# ファイルシステムのチェック
FS_CHECK() {
	# 処理開始メッセージの表示
	echo "-I デバイス($1) のチェックを開始します"

	# マウント済み判定
	IFS_SAVE=${IFS}
	IFS='
'
	MOUNTED=0
	for line in `LANG=C mount 2>&1 | grep -i -F -e "$1"` ; do
		DEV=`echo "${line}" | awk '{print $1}'`
		MNT=`echo "${line}" | awk '{print $3}'`
		MOUNTED=1
		echo "-E デバイス($1) がマウントポイント(${MNT}) にマウントされています" 1>&2
	done
	IFS=${IFS_SAVE}
	unset IFS_SAVE
	if [ ${MOUNTED} -ne 0 ];then
		return 1
	fi

	# チェック
	LANG=C fsck ${FSCK_OPTIONS} $1
	FSCK_RC=$?

	# 処理終了メッセージの表示
	if [ ${FSCK_RC} -eq 0 ];then
		# 成功
		echo "-I デバイス($1) のチェックが正常終了しました"
		return 0
	else
		# 失敗
		echo "-E デバイス($1) のチェックが異常終了しました" 1>&2
		echo "     'fsck' return code: ${FSCK_RC}" 1>&2
		return ${FSCK_RC}
	fi
}

######################################################################
# メインルーチン
######################################################################

# 第1引数のチェック
if [ "$1" = "" ];then
	echo "-E Missing DEVICE argument" 1>&2
	USAGE;exit 1
else
	DEVICE="$1"
fi

# FSCK_OPTIONSの取得
shift 1
FSCK_OPTIONS="${FSCK_OPTIONS} $@"

# ファイルシステムのチェック
FS_CHECK "${DEVICE}"

