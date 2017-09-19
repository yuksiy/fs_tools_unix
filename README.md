# fs_tools_unix

## 概要

ファイルシステム関連ツール (UNIX)

## 使用方法

### fs_mount.sh

    ローカルファイルシステムをマウントします。
    # fs_mount.sh local デバイスファイル名 マウントディレクトリ名 [mount コマンド オプション(例：-o noatime)]

### fs_umount.sh

    ローカルファイルシステムをマウント解除します。
    # fs_umount.sh local デバイスファイル名 マウントディレクトリ名 [umount コマンド オプション(例：-f)]

### fs_check.sh

    ファイルシステムをチェックします。
    # fs_check.sh デバイスファイル名 [fsck コマンド オプション(例：-f -a -v -C)]

### その他

* 上記で紹介したツールの詳細については、各ファイルのヘッダー部分を参照してください。

## 動作環境

OS:

* Linux

依存パッケージ または 依存コマンド:

* make (インストール目的のみ)

## インストール

ソースからインストールする場合:

    (Linux の場合)
    # make install

fil_pkg.plを使用してインストールする場合:

[fil_pkg.pl](https://github.com/yuksiy/fil_tools_pl/blob/master/README.md#fil_pkgpl) を参照してください。

## インストール後の設定

環境変数「PATH」にインストール先ディレクトリを追加してください。

## 最新版の入手先

<https://github.com/yuksiy/fs_tools_unix>

## License

MIT License. See [LICENSE](https://github.com/yuksiy/fs_tools_unix/blob/master/LICENSE) file.

## Copyright

Copyright (c) 2006-2017 Yukio Shiiya
