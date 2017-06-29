#!/bin/sh

#
#移植性のための統一シェル関数
# echo -e の挙動                    #-eオプションが必要かどうかのチェック
case "`echo -e`" in                 #試しにecho -eを実行してみる
  -e)
                                    #/bin/sh -e が出力されてしまった場合
    ECHO() { echo "$@"; }           #ECHOをそのままechoとして定義
    ;;
  *)
                                    #/bin/bash #それ以外
    ECHO() { echo -e "$@"; }        #ECHOをecho -e として定義
    ;;
esac
# printコマンドの挙動               #printまたは/usr/5binでの対応が必要かチェック
case "`ECHO '\r'`" in               #ECHOが\rを解釈できるかチェック
  '\r')                             #\rのまま出力されてしまった場合
    case "`(print X) 2> /dev/null`" in  #printコマンドが使えるか
                                    #シェルによっては標準エラー出力をリダイレクトしてもシェル自身からの
                                    #エラーメッセージは表示されてしまう場合があるため、
                                    #print Xを()で囲んでサブシェルとして実行
      X)                            #Xが出力された場合
        ECHO() { print "$@"; }      #ECHO をprintで定義
        ;;
      *)
        PATH=/usr/5bin:$PATH        #PATHに/usr/5binを先に含ませるとSystemV仕様になる
        export PATH
        ;;
    esac
    ;;
esac
#算術式展開が可能か
case "$((1))" in                    #算術式展開で、数値１が展開できるかどうかをテスト
  1)                                #正しく１と展開された場合
    expr() {                        #算術式展開を使うexprシェル関数を定義
      echo "$(($*))"                #算術式展開
    }
    ;;
esac 2> /dev/null                   #エラーメッセージを表示しないようにしてcase文を終了
#画面クリアのためのシェル関数
cls() {                             #\033はESC [Hは文字列 
                                    #\033[H    カーソルを左上に移動
                                    #\033[2J   画面をクリア
                                    #\cは余分な改行コードをつけない
  ECHO '\033[H\033[2J\c';           #シェル関数ECHOのエスケープ文字を使って画面クリアのエスケープシーケンスを出力
}
#カーソルを移動する方法
cursor() {                          #シェル関数cursorの定義
                                    #X座標 $1 Y座標 $2
                                    # ( Ｘ座標, Ｙ座標)
                                    ######################->X座標
                                    #
                                    #
                                    #
                                  # ↓
                                  #Y座標
  ECHO '\033['$2';'$1'H\c'          #X座標・Y座標の引数を含めたエスケープシーケンス
}
#ビープ音発生
beep() {                            #シェル関数beepの定義
  ECHO '\07\c' ;                    #８進数表記でコントロールコードのBELを出力 
}
#新しいスクリーンを開くシェル関数の定義
new_screen() {
  ECHO '\033\067\033[?47h\c'        #新しいスクリーンを開くエスケープシーケンス
                                    # ESC 7 ESC [ ? 4 7 h
}
#元のスクリーンに戻るシェル関数の定義
exit_screen() {
  ECHO '\033[?47l\033\070\c' ;      #元のスクリーンに戻るエスケープシーケンス
                                    # ESC [ ? 4 7 l ESC 8
}
#画面とキーボード入力の初期化
init_tty() {
  stty -icanon -echo min 1 -ixon ;  #sttyコマンドで行バッファを無効にして１文字単位入力にする -echoはエコーバックをoffにする
  new_screen ;                      #新しいスクリーンを開く
  cls ;                             #画面のクリア
}
#sttyコマンドで行バッファを元に戻す
quit_tty() {
  cls ;                             #画面のクリア
  exit_screen ;                     #元のスクリーンに戻る
  stty icanon echo eof '^d' ixon ;  #再び通常の行バッファ状態に戻します
                                    #行バッファを有効、エコーバックをONにする
}
#１文字のみを入力する
getchar() {                         #シェル関数getcharの定義開始
  dd bs=1 count=1 2> /dev/null ;    #ddコマンドで１バイトのみ入力 標準エラー出力は捨てる
}
# trap コマンドでラベルが使えるかチェック
if (trap '' INT) 2> /dev/null; then   #ラベルが使える場合
  SIGINT=INT; SIGQUIT=QUIT ; SIGTERM=TERM ; SIGTSTP=TSTP ; # ラベルが使える場合は変数にラベルを代入
else                                                 #ラベルが使えない場合
  SIGINT=2 ; SIGQUIT=3 ; SIGTERM=15 ; SIGTSTP=18  ;  #変数にシグナルを代入
fi
# Ctrl+C等を無視する設定
#INT QUIT TSTPを無視する
# INT Ctrl+C
# QUIT Ctrl+\
# TSTP Ctrl+Z
trap '' $SIGINT $SIGQUIT $SIGTSTP
#
# random

if [ "$RANDOM" != "$RANDOM" ]; then
  #シェル関数の第一引数が示す変数に$RANDOMの値を代入
  random_short() {
    eval $1=$RANDOM ;
  }
elif [ -c /dev/urandom ]; then
  #$RANDOMの値を標準出力に出力
  random_short() {
    #サブシェルで実行し、結果を変数rand_sに取り込む
    #bs=2 /dev/urandomの2バイトを10進数に変換
    #echo "$2" setの結果の乱数部分を出力
    rand_s=`(
      set \`dd if=/dev/urandom bs=2 count=1 2> /dev/null | od -d\`
      echo "$2"
    )`
    #結果の乱数をシェル関数の第一引数が示す変数に代入
    eval $1=$rand_s ;
  }
#M系列乱数を作る方法
else
  seed=$$ ; #乱数の種をシェル自身のプロセスIDで初期化
  #シェル関数random_shortの定義
  random_short() {
    #exprを使ってM系列乱数を同時に８ビット分計算
    seed=`expr $seed \* 256 % 32768 + \
      \( $seed / 16384 + $seed / 8192 \) % 2 \* 128 + \
      \( $seed / 8192 + $seed / 4096 \) % 2 \* 64 + \
      \( $seed / 4096 + $seed / 2048 \) % 2 \* 32 + \
      \( $seed / 2048 + $seed / 1024 \) % 2 \* 16 + \
      \( $seed / 1024 + $seed / 512 \) % 2 \* 8 + \
      \( $seed / 512 + $seed / 256 \) % 2 \* 4 + \
      \( $seed / 257 + $seed / 128 \) % 2 \* 2 + \
      \( $seed / 128 + $seed / 64 \) % 2`
    # 結果の乱数をシェル関数の第１引数が示す変数に代入
    eval $1=$seed ;
  }
fi
# 最大値・最小値を指定できる乱数のシェル関数randの定義
rand() {
  # random_shortを呼び出して元の乱数を取得
  random_short rand_val ;
  # 乱数が指定範囲になるように数式で計算
  rand_val=`expr $rand_val % 256 \* \( "$3" - "$2" + 1 \) / 256 + "$2"` ;
  #結果の乱数をシェル関数の第１引数が示す変数に代入
  eval $1=$rand_val ;
}
#
# init_mapの定義とスコア表示機能
#ゲーム初期画面の描画
#mapの初期化
#スコアを呼び出して表示
init_map() {
  cursor 30 1 ;                             #本体マップの描画
  ECHO '┏━━━━━━━━━━━━━━━━━━━━━┓\c'
  i=2 ;                                     #本体マップの２行目から
  while [ $i -le 23 ]; do                   #２３行目（最下行の１行手前）までループ
    cursor 30 $i ;                          #その行の本体マップの左端に移動
  ECHO '┃                     ┃\c'           #１行分の左右枠を描画
    i=`expr $i + 1`                         #次の行へ
  done                                      #本体マップ最下行の左端に移動
  cursor 30 24 ;
  ECHO '┗━━━━━━━━━━━━━━━━━━━━━┛\c'

  #NEXTボタン
  cursor 54 1 ;                             #NEXT表示部分の左上にカーソル移動
  ECHO '┌──────────┐\c'
  cursor 54 2 ;                             #次の行に移動
  ECHO '│  (N)EXT  │\c'
  cursor 54 3 ;                             #次の行に移動
  ECHO '└──────────┘\c'
  cursor 54 4 ;                             #次の行に移動
  ECHO '┌──────────┐\c'
  i=5 ;                                     #5行目から
  while [ $i -le 10 ]; do                   #10行目までループ
    cursor 54 $i ;                          #その行のNEXT表示本体の左端に移動
    ECHO '│          │\c'
    i=`expr $i + 1` ;                       #次の行へ
  done
  cursor 54 11 ;                            #NEXT表示本体の最下行の左端に移動
  ECHO '└──────────┘\c'

  #SCOREボタン
  cursor 54 12
  ECHO '┌──────────┐\c'
  cursor 54 13
  ECHO '│  (S)CORE │\c'
  cursor 54 14
  ECHO '└──────────┘\c'
  cursor 54 15
  ECHO '┌──────────┐\c'
  cursor 54 16
  ECHO '│          │\c'
  cursor 54 17
  ECHO '└──────────┘\c'

  #キー操作説明表示の開始位置に移動
  cursor 11 10 ;
   ECHO  '  ROTATE
              [K]
            ┏━━━┓
            ┃ ↑ ┃
            ┗━━━┛      
       ┏━━━┓┏━━━┓┏━━━┓
LEFT[H]┃ ← ┃┃ ↓ ┃┃ → ┃[L]RIGHT
       ┗━━━┛┗━━━┛┗━━━┛   
             [J]
             DROP

 [Q] - Quit\c' ; #終了
  cursor 80 24 ;                           #カーソルを画面右下へ
  j=1 ;                                    #Y座標の開始は１から
  while [ $j -le 23 ]; do                  #Y座標２３までの間をループ
    eval map_30_"$j"=NO ;                  #左端(X=30)の壁に文字列NOを代入
    for i in 32 34 36 38 40 42 44 46 48 50; do 
      eval map_"$i"_"$j"=0 ;               #マップ内部のX座標には空白を示す０を代入
    done
    eval map_52_"$j"=NO ;                   #右端(X=52)の壁に文字列NOを代入
    eval map_54_"$j"=NO ;                   #さらに(X=54)右の壁にも文字列NOを代入
    j=`expr $j + 1` ;                       #次のY座標へ
  done
  i=30 ;                                    #X座標30から
  while [ $i -le 54 ]; do                   #X座標54までの間をループ
    eval map_"$i"_24=NO ;                   #最下行の壁(床)に文字列NOを代入
    i=`expr $i + 2` ;                       #次のX座標へ
  done
}
#
#put_scoreの定義
put_score() {
  cursor 56 16 ;                            #スコア表示部分にカーソル表示
  printf %8d $1 ;                           #右詰８桁でスコア表示
}
#
#スコア表示機能とピースのデータ保持方法
#ピースの形データ配列で持つ
#
#ピースの形データ
piece_face_0='  ' ;                         #空白用表示キャラクタ
#
#ピース番号1のデータ
# OOO
#   O
piece_face_1='■'
piece_xmin_10=34  piece_xmax_10=48
piece_x_101=-1  piece_y_101=0
piece_x_102=1   piece_y_102=0
piece_x_103=1   piece_y_103=1

piece_xmin_11=32  piece_xmax_11=48
piece_x_111=0   piece_y_111=1
piece_x_112=0   piece_y_112=-1
piece_x_113=1   piece_y_113=-1

piece_xmin_12=34  piece_xmax_12=48
piece_x_121=1   piece_y_121=0
piece_x_122=-1  piece_y_122=0
piece_x_123=-1  piece_y_123=-1

piece_xmin_13=34  piece_xmax_13=50
piece_x_131=0   piece_y_131=-1
piece_x_132=0   piece_y_132=1
piece_x_133=-1  piece_y_133=1

#ピース番号2のデータ
# OOO
# O
piece_face_2='●'
piece_xmin_20=34  piece_xmax_20=48
piece_x_201=-1  piece_y_201=0
piece_x_202=1   piece_y_202=0
piece_x_203=-1  piece_y_203=1

piece_xmin_21=32  piece_xmax_21=48
piece_x_211=0   piece_y_211=1
piece_x_212=0   piece_y_212=-1
piece_x_213=1   piece_y_213=1

piece_xmin_22=34  piece_xmax_22=48
piece_x_221=1   piece_y_221=0
piece_x_222=-1  piece_y_222=0
piece_x_223=1   piece_y_223=-1

piece_xmin_23=34  piece_xmax_23=50
piece_x_231=0   piece_y_231=-1
piece_x_232=0   piece_y_232=1
piece_x_233=-1  piece_y_233=-1

#ピース番号3のデータ
#  OO
# OO
piece_face_3='□'
piece_xmin_30=34  piece_xmax_30=48
piece_x_301=-1  piece_y_301=1
piece_x_302=1   piece_y_302=0
piece_x_303=0   piece_y_303=1

piece_xmin_31=32  piece_xmax_31=48
piece_x_311=1   piece_y_311=1
piece_x_312=0   piece_y_312=-1
piece_x_313=1   piece_y_313=0

piece_xmin_32=34  piece_xmax_32=48
piece_x_321=-1  piece_y_321=1
piece_x_322=1   piece_y_322=0
piece_x_323=0   piece_y_323=1

piece_xmin_33=32  piece_xmax_33=48
piece_x_331=1   piece_y_331=1
piece_x_332=0   piece_y_332=-1
piece_x_333=1   piece_y_333=0

#ピース番号4のデータ
# OO
#  OO
piece_face_4='☆'
piece_xmin_40=34  piece_xmax_40=48
piece_x_401=-1  piece_y_401=0
piece_x_402=1   piece_y_402=1
piece_x_403=0   piece_y_403=1

piece_xmin_41=32  piece_xmax_41=48
piece_x_411=0   piece_y_411=1
piece_x_412=1   piece_y_412=-1
piece_x_413=1   piece_y_413=0

piece_xmin_42=34  piece_xmax_42=48
piece_x_421=-1  piece_y_421=0
piece_x_422=1   piece_y_422=1
piece_x_423=0   piece_y_423=1

piece_xmin_43=32  piece_xmax_43=48
piece_x_431=0   piece_y_431=1
piece_x_432=1   piece_y_432=-1
piece_x_433=1   piece_y_433=0

#ピース番号5のデータ
# OOO
#  O
piece_face_5='◎'
piece_xmin_50=34  piece_xmax_50=48
piece_x_501=-1  piece_y_501=0
piece_x_502=1   piece_y_502=0
piece_x_503=0   piece_y_503=1

piece_xmin_51=32  piece_xmax_51=48
piece_x_511=0   piece_y_511=1
piece_x_512=0   piece_y_512=-1
piece_x_513=1   piece_y_513=0

piece_xmin_52=34  piece_xmax_52=48
piece_x_521=1   piece_y_521=0
piece_x_522=-1  piece_y_522=0
piece_x_523=0   piece_y_523=-1

piece_xmin_53=34  piece_xmax_53=50
piece_x_531=0   piece_y_531=-1
piece_x_532=0   piece_y_532=1
piece_x_533=-1  piece_y_533=0

#ピース番号6のデータ
# OOOO
#
piece_face_6='◆'
piece_xmin_60=34  piece_xmax_60=46
piece_x_601=-1  piece_y_601=0
piece_x_602=1   piece_y_602=0
piece_x_603=2   piece_y_603=0

piece_xmin_61=32  piece_xmax_61=50
piece_x_611=0   piece_y_611=-1
piece_x_612=0   piece_y_612=1
piece_x_613=0   piece_y_613=2

piece_xmin_62=34  piece_xmax_62=46
piece_x_621=-1  piece_y_621=0
piece_x_622=1   piece_y_622=0
piece_x_623=2   piece_y_623=0

piece_xmin_63=32  piece_xmax_63=50
piece_x_631=0   piece_y_631=-1
piece_x_632=0   piece_y_632=1
piece_x_633=0   piece_y_633=2

#ピース番号7のデータ
# OO
# OO
piece_face_7='◇'
piece_xmin_70=32  piece_xmax_70=48
piece_x_701=1   piece_y_701=0
piece_x_702=1   piece_y_702=1
piece_x_703=0   piece_y_703=1

piece_xmin_71=32  piece_xmax_71=48
piece_x_711=1   piece_y_711=0
piece_x_712=1   piece_y_712=1
piece_x_713=0   piece_y_713=1

piece_xmin_72=32  piece_xmax_72=48
piece_x_721=1   piece_y_721=0
piece_x_722=1   piece_y_722=1
piece_x_723=0   piece_y_723=1

piece_xmin_73=32  piece_xmax_73=48
piece_x_731=1   piece_y_731=0
piece_x_732=1   piece_y_732=1
piece_x_733=0   piece_y_733=1
#
#ピースの表示と消去
put_piece() {
  eval piece_face=\$piece_face_$3 ;               #配列データから表示用キャラクタを取得
  cursor $1 $2 ;                                  #引数指定座標にカーソル移動
  ECHO "$piece_face\c" ;                          #中心座標のピース断片を描画

  for i in 1 2 3; do                                #中心以外のピース断片３個分ループ
    eval px=\$piece_x_$3$4$i  py=\$piece_y_$3$4$i ; #断片の相対座標を取得
    px=`expr $1 + $px \* 2` ;                     #断片の表示用X座標を計算
    py=`expr $2 + $py` ;                          #断片の表示用Y座標を計算
    cursor $px $py ;                              #計算した座標にカーソル移動
    ECHO "$piece_face\c" ;                        #ピース断片を描画
  done
}
#
remove_piece() {
  cursor $1 $2 ;                  #引数指定座標にカーソル移動
  ECHO '  \c' ;                   #中心座標のピース断片をスペースで消去
  for i in 1 2 3; do              #中心以外のピース断片３個分ループ
    eval px=\$piece_x_$3$4$i  py=\$piece_y_$3$4$i ; #断片の相対座標を取得
    px=`expr $1 + $px \* 2` ;     #断片の表示用X座標を計算
    py=`expr $2 + $py` ;          #断片の表示Y座標を計算
    cursor $px $py ;              #計算した座標にカーソル移動
    if [ $py -ge 2 ]; then        #断片の座標が最上行でない場合
      ECHO '  \c' ;               #ピースの断片をスペースで消去
    else                          #ピースの断片が最上行の場合
      ECHO '━\c' ;                #ピース断片を━で消去
    fi
  done
}
#
#ピースの配置可否判断と配置データの保存
#ピースが指定の位置、無機に配置できるかどうかを判定
#ピースの配置状態を記録する
check_piece()
{
  eval i=\$piece_xmin_$3$4 ;      #指定ピースのX座標が最小値を取得
  if [ $1 -lt $i ]; then          #引数のＸ座標が最小値未満なら
    echo 2 ;                      #標準出力にプラスの値を出力して
    return ;                      #関数を終了
  fi

#  eval i=\$piece_xmin_$3$4
#  if [ $1 -lt $i ]; then
#    echo 2
#    return
#  fi

  eval i=\$piece_xmax_$3$4 ;      #指定ピースのX座標が最大値を取得
  if [ $1 -gt $i ]; then          #引数のX座標が最大値を超えていたら
    echo -2 ;                     #標準出力にマイナスの値を出力して
    return ;                      #関数を終了
  fi

#  eval i=\$piece_xmax_$3$4
#  if [ $1 -gt $i ]; then
#    echo -2
#    return
#  fi

  eval pm=\$map_"$1"_"$2" ;       #中心座標のmap配列を参照
  if [ $pm != 0 ]; then           #中心座標のmap配列が空白でなければ
    echo NO ;                     #標準出力に文字列NOを出力して
    return ;                      #関数を終了
  fi

#  eval pm=\$map_"$1"_"$2"
#  if [ $pm != 0 ]; then
#    echo NO
#    return
#  fi

  for i in 1 2 3; do #中心以外のピース断片３個分ループ
    eval px=\$piece_x_$3$4$i  py=\$piece_y_$3$4$i #断片の相対座標を取得
    px=`expr $1 + $px \* 2` ;     #断片の表示用X座標を計算
    py=`expr $2 + $py` ;          #断片の表示用Y座標を計算
    eval pm=\$map_"$px"_"$py" ;   #中心座標のmap配列を参照
    if [ $pm != 0 ]; then         #中心座標のmap配列が空白でなければ
      echo NO ;                   #中心座標のmap配列が空白でなければ
      return ;                    #関数を終了
    fi
  done
  echo 0 ;                        #標準出力に0を出力して関数を終了
}
#
put_piece_map() {
  eval map_"$1"_"$2"=$3 ;         #中心座標のmap配列にピース番号を代入
  for i in 1 2 3; do              #中心以外のピース断片３個分ループ
    eval px=\$piece_x_$3$4$i  py=\$piece_y_$3$4$i ; #断片の相対座標を取得
    px=`expr $1 + $px \* 2` ;     #断片の表示用X座標を計算
    py=`expr $2 + $py`            #断片の表示用Y座標を計算
    eval map_"$px"_"$py"=$3       #中心座標のmap配列を参照
  done
}
#
#ラインにピースがそろった場合の処理
#ピースがライン上にそろったかどうかを判定
#そろったピースをラインごと消去、スコアを加算
clear_line() {
  j=$1 ;                                        #Y座標の引数をjに代入
  while [ $j -ge 2 ]; do                        #Y座標が２以上（最上行より下）でループ
    jj=`expr $j - 1` ;                          #jの一つ上のY座標をjjに代入
    cursor 32 $j ;                              #jの指す行の壁でない左側にカーソル移動
    line=                                       #lineを初期化
    for i in 32 34 36 38 40 42 44 46 48 50; do  #壁以外のX座標についてループ
      eval pm=\$map_"$i"_"$jj" ;                #ひとつ上の行のmap配列の値を
      eval map_"$i"_"$j"=$pm ;                  #jの指す行のmap配列に代入
      eval piece_face=\$piece_face_$pm ;        #そのピース番号の表示キャラクタを
      line=$line$piece_face ;                   #line変数に追加
    done
    ECHO "$line\c" ;                            #上行から詰められた１行分のピースを表示
    j=`expr $j - 1` ;                           #一つ上の行に処理を進める
  done
  cursor 32 1  ;                                #最上行の壁でない左端にカーソル移動
  for i in 32 34 36 38 40 42 44 46 48 50; do    #壁以外のX座標についてループ
    eval map_"$i"_1=0 ;                         #その座標のmap配列に0(空白)を代入
  done
  ECHO '━━━━━━━━━━\c' ;                         #最上行の枠(mapは空白)を再描画
}
#
check_one_line() {
  for px in 32 34 36 38 40 42 44 46 48 50; do   #壁以外のX座標についてループ
    eval pm=\$map_"$px"_"$1" ;                  #指定行のmap配列の内容を参照
    if [ $pm = 0 ]; then                        #map配列が空白なら
      return 1 ;                                #ラインがそろっていないのでfalseでリターン
    fi
  done
  return 0 ;                                    #そろっているのでtrueでリターン
}
#
check_line() {
  py=`expr $1 - 1` ;                            #指定Y座標の１つ上の行をpyに代入
  py_max=`expr $1 + 2` ;                        #指定Y座標の二つ下の行をpy_maxに代入
  if [ $py_max -gt 23 ]; then                   #py_maxが最下行よりしたならば
    py_max=23 ;                                 #py_maxに最下行を代入
  fi
  line_score=0 ;                                #スコア計算用変数を0で初期化
  while [ $py -le $py_max ]; do                 #pyの行からpy_maxの行までループ
    if check_one_line $py ; then                
      beep ;                                    #そろっている場合はビープ音を鳴らす
      line_score=`expr $line_score \* 2 + 100` ; #１ライン分のスコアを計算
      clear_line $py ;                          #そのラインを消去する
    fi
    py=`expr $py + 1` ;                         #次のラインの処理へ
  done
  if [ $line_score -gt 0 ]; then                #１ライン以上消去されてスコアがある場合
    score=`expr $score + $line_score` ;         #そのスコアを加算
    put_score $score ;                          #加算結果のスコアを表示
  fi
}
#
# メインプログラム
# 
trap '' $SIGINT $SIGQUIT $SIGTSTP ;             #INT QUIT TSTPシグナルを無視
trap : $SIGTERM ;                               #メインシェルのみTERMシグナルを無視

init_tty ;                                      #端末の初期化
init_map ;                                      #ゲームの初期画面を描画

x=40 ; y=2 ; dir=0 ;                            #ピース座標、向きを初期化
old_x=$x ; old_y=$y ; old_dir=$dir ;            #直前のピース座標、向きも同じ値に
rand piece 1 7 ;                                #最初のピース番号を乱数で初期化
draw=1 ;                                        #描画フラグをセット

rand next_piece 1 7 ;                           #next_pieceを乱数で初期化
put_piece 60 7 $next_piece 0 ;                  #next_pieceを表示
score=0 ;                                       #スコアを０点に初期化
put_score $score ;                              #スコアを表示

#サブシェル開始
(
  while :           #周期的タイムアウト発生用の１秒間隔の無限ループ
  do
    sleep 1 ;       #1秒待つ
    ECHO '~\c' ;    #タイムアウト用文字「~」を標準出力に出力
  done &            #以上の無限ループをバックグラウンドで実行
  /bin/cat          #標準入力を標準出力catにそのままパイプ出力
) | while :         #以上のサブシェルをパイプの上流として接続
do
  if [ "$draw" ]; then                          #描画フラグがセットされていたら
    draw=                                       #描画フラグをクリア
    remove_piece $old_x $old_y $piece $old_dir; #直前のピースを削除
    put_piece $x $y $piece $dir ;               #現在のピースを描画
    old_x=$x; old_y=$y; old_dir=$dir;           #直前のピースの座標と向きを現在のものに
    cursor 80 24 ;                              #目立たないように画面右下にカーソルを移動
  fi
  key=`getchar` ;   #標準入力から１文字を読み込む
  case "$key" in    #読み込んだ文字を場合分け
    '~')            #~だった場合
                    #タイムアウト時の処理を実行
      y=`expr $y + 1` ;                                 #Y座標を加算に、ピースを一つ下に落下
      if [ `check_piece $x $y $piece $dir` != 0 ]; then #落下できない場合
        y=$old_y ;                                      #前のY座標に戻す
        put_piece_map $x $y $piece $dir ;               #このピースをmap配列に記録
        check_line $y ;                                 #ラインがそろったかどうかチェック

        x=40; y=2; dir=0 ;                              #次のピースのため座標と向きを初期化
        old_x=$x; old_y=$y; old_dir=$dir;               #直前の座標も同座標に初期化
        piece=$next_piece ;                             #next_pieceを次のピースにする
        remove_piece 60 7 $next_piece 0 ;               #nexe_pieceの表示を削除
        rand next_piece 1 7 ;                           #新しいnext_pieceを乱数で決める
        put_piece 60 7 $next_piece 0 ;                  #新しいnext_pieceを表示

        if [ `check_piece $x $y $piece $dir` != 0 ]; then #もう置けない場合
          put_piece $x $y $piece $dir ;                   #新しいピースを一応表示
          cursor 1 1 ;                                    #カーソルを左上に移動
          ECHO 'Game Over\nHit [Q] to quit...\c' ;        #改行なしでピリオドを表示ゲームオーバー
          while :; do                                     #キー入力待ちのループ
            case "`getchar`" in                           #一文字入力
              q|Q)                                        #Qが入力された場合
                break                                     #メインシェルもwhileループを抜ける
                ;;
            esac
          done
          kill -TERM 0                                    #TERMシグナルを送ってサブシェルを終了
          break
        fi
      fi
      draw=1 ;                                            #描画フラグをセット
      ;;
    q|Q)
      kill -TERM 0
      break
      ;;
    h|D|4)
      x=`expr $x - 2`
      if [ `check_piece $x $y $piece $dir` != 0 ]; then   #移動できない場合
        x=$old_x
      else
        draw=1
      fi
      ;;
    l|C|7)
      x=`expr $x + 2`
      if [ `check_piece $x $y $piece $dir` != 0 ]; then   #移動できない場合
        x=$old_x
      else
        draw=1
      fi
      ;;
    j|B|2|' ')
      remove_piece $old_x $old_y $piece $old_dir          #ピース表示を一旦削除
      while                                               #ピースをしたまで落下させる
        y=`expr $y + 1`
        [ `check_piece $x $y $piece $dir` = 0 ]           #落下できる限りループ
      do
        cursor $x $y ;                                    #落下できるカーソルのみ表示
      done
      y=`expr $y - 1`
      put_piece $x $y $piece $dir ;                       #落下後の位置にピースを表示
      score=`expr $score + $y - $old_y` ;                 #落下したY座標分をスコアに加算
      old_x=$x old_y=$y old_dir=$dir ;                    #直前の座標を現在の座標と同じにする
      put_score $score ;                                  #加算されたスコアを表示
      cursor 80 24 ;                                      #画面右下にカーソル移動
      ;;
    k|A|8)
      dir=`expr \( $dir + 1 \) % 4` ;                     #向きを反時計回りに90度回転
      while :
      do
        mod_x=`check_piece $x $y $piece $dir` ;           #配置可能かチェック
        case $mod_x in
          NO)       #配置できない
            dir=$old_dir
            break
            ;;
          0)        #配置可能
            draw=1
            break
            ;;
          *)
            x=`expr $x + $mod_x` ;  #X座標を修正し再チェック
            ;;
        esac
      done
      ;;
  esac
#パイプ下流側無限ループの終了
done
quit_tty ;  #端末を元に戻す
exit
