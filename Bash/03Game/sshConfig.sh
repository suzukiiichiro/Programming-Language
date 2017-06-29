#!/bin/bash

#
#sshサーバーへパスワードの入力なしでログインするための設定の自動化スクリプト
# sshConfig.sh
#
# このスクリプトは、トークンベースの認証に対応できるよう、鍵を作成し、
# 所定の位置にコピーし、パーミッションを設定します。
# シェルスクリプトを実行すると、メッセージが出力され、
# キーボードからの入力が求められます。
#
# 実行例
# ./sshConfig.sh root@192.168.11.54 ;
#
#bash-3.2$ ./sshConfig.sh root@192.168.11.54
#Generating public/private dsa key pair.
#Enter file in which to save the key (/Users/suzukiiichiro/.ssh/id_dsa):[ENTER]
#/Users/suzukiiichiro/.ssh/id_dsa already exists.
#Enter passphrase (empty for no passphrase):[Enter]
#Enter same passphrase again:[ENTER]
#Your identification has been saved in /Users/suzukiiichiro/.ssh/id_dsa.
#Your public key has been saved in /Users/suzukiiichiro/.ssh/id_dsa.pub.
#The key fingerprint is:
#fe:15:8c:92:61:3f:81:96:05:b5:c2:c4:7b:93:b4:cc suzukiiichiro@suzukiiichiro-2.local
#The key's randomart image is:
#+--[ DSA 1024]----+
#|       .ooo      |
#|       o.+..     |
#|        O=oo     |
#|       o.=E+     |
#|        S.+.o    |
#|       . . . .   |
#|        .   .    |
#|         . .     |
#|          .      |
#+-----------------+
#root@192.168.11.54's password:[root@192.168.11.54のパスワードを入力]
#root@192.168.11.54's password:[root@192.168.11.54のパスワードを入力]
#id_dsa.pub                                                                                                 100%  625     0.6KB/s   00:00
#root@192.168.11.54's password:[root@192.168.11.54のパスワードを入力]
#bash-3.2$
#
#
if [ $# -ne 1 ]; then
  echo "対象のsshサーバーのIPアドレスをパラメータで付与して下さい" ;
  exit ;
fi
#
sshServer=$1 ;
#鍵を作成
ssh-keygen -t dsa

# 作成された鍵をsshサーバーへコピーするための準備です。コピー先はユーザーのホームディレクトリ以下の.sshディレクトリです。
# .sshディレクトリが存在しない場合は、mkdirコマンドで作成し、ディレクトリのパーミッションを700へ設定します。
# sshコマンドにsshサーバーを指定し、その後にコマンドを"でくくって実行すると、
# sshサーバーへログインした後に"内のコマンドがsshサーバー上で実行されます。
ssh $sshServer "if ! [ -d ~/.ssh ]; then mkdir .ssh ; fi ; chmod 0700 .ssh; "

# 作成された鍵は、id_dsa.pubファイルに格納されています。このファイルをsshサーバーへコピーします。
# ファイルのコピーにはscpコマンドを使用します。
scp ~/.ssh/id_dsa.pub $sshServer:~/.ssh ;

# コピーされたファイルの名前をauthorized_keysへ変更し、パーミッションを0600に設定しています。
ssh $sshServer "cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys ; rm -f ~/.ssh/id_dsa.pub; chmod 0600 ~/.ssh/authorized_keys ";

# 最後にsshクライアント側の鍵のパーミッションを0600に設定しています。
chmod 0600 ~/.ssh/id_dsa ;

exit ;

