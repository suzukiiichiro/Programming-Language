#!/bin/bash
#
#圧縮されているファイルを解凍する
# uncomp.sh を /usr/bin/にuncompとしてコピーすると
# 通常のコマンドとして本実行ファイルを利用する事が出来ます。
#
# cp uncomp.sh /usr/bin/uncomp
#
# 実行例
# $ uncomp 
#
if [ $# -ne 1 ]; then
  echo ""
  exit ;
fi
#
case $1 in
  *.tgz | *.tar.gz)   tar zxvf $1 ;;
  *.tar.Z)            gunzip $1
                      tar xvf $( echo "$1" | sed 's/\.Z$//')
                      ;;
  *.tar.bz2)          tar xvfj $1;;
  *.tar)              tar xvfz $1;;
  *.gz)               gunzip $1;;
  *.Z)                gunzip $1;;
  *.bz2)              bunzip2 $1;;
  *.zip)              unzip $1;;
  *)                  echo "ファイルの拡張子が対応していません:$1"
esac
exit ;
