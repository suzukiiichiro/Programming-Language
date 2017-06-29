#/bin/bash

## コンフィグレーション
#
strength=2;             #先読み
sleep=2;                #スリープ

namePlayerA="あなた" namePlayerB="AI" aiPlayerA="AI" aiPlayerB="AI" ;
colorPlayerA=4 colorPlayerB=1 ;
aikeyword="ai" colorHover=4 hoverInit=false  timestamp=$( date +%s );
selectedX=-1 selectedY=-1 selectedNewX=-1 selectedNewY=-1 A=-1 B=1;
originY=4 originX=7 hoverX=0 hoverY=0 labelX=-2 labelY=9;

# lookup tables
declare -A cacheLookup;
declare -A cacheFlag;
declare -A cacheDepth;
# associative arrays are faster than numeric ones and way more readable
declare -A redraw;
# initialize setting - first row
declare -A field;
declare -a initline=( 4  2  3  6  5  3  2  4 );
# readable figure names
declare -a figNames=( "(空)" "ポーン" "ナイト" "ビショップ" "ルーク" "クイーン" "キング" );
# ascii figure names (for ascii output)
declare -a asciiNames=( "k" "q" "r" "b" "n" "p" " " "P" "N" "B" "R" "Q" "K" );
# figure weight (for heuristic)
declare -a figValues=( 0 1 5 5 6 17 42 );
type stty >/dev/null 2>&1 && useStty=true || useStty=false;
# Choose unused color for hover
while((colorHover==colorPlayerA || colorHover==colorPlayerB)); do
  ((colorHover++));
done
# Named ANSI colors get terminal dimension
echo -en '\e[18t';
((read -d "t" -s -t 1 tmp))&&{
	termDim=(${tmp//;/ });
	termHeight=${termDim[1]};
	termWidth=${termDim[2]};
}||{
	termHeight=24;
	termWidth=80;
}
echo -e "\e7\e[s\e[?47h\e[?25l\e[2J\e[H"
for((y=0;y<10;y++)); do       # Save screen
  for((x=-2;x<8;x++)); do
    redraw[$y,$x]="";
  done
done
for((x=0;x<8;x++)) ; do
	field[0,$x]=${initline[$x]};
	field[7,$x]=$((-1*initline[$x]));
done
for((x=0;x<8;x++)); do        # set pawns
	field[1,$x]=1;
	field[6,$x]=-1;
done
for((y=2;y<6;y++)); do        # set empty fields
	for((x=0;x<8;x++)); do
		field[$y,$x]=0;
	done
done
initializedGameLoop=true;

##
# minimax (game theory) algorithm for evaluate possible movements
# (the heart of your computer enemy)
# currently based on negamax with alpha/beta pruning and transposition tables liked described in
# http://en.wikipedia.org/wiki/Negamax#NegaMax_with_Alpha_Beta_Pruning_and_Transposition_Tables
# Params:
#	  $1	current search depth
#	  $2	alpha (for pruning)
#	  $3	beta (for pruning)
#	  $4	current moving player
#	  $5	preserves the best move (for ai) if true
#   Returns best value as status code
function negamax() {
	local depth=$1
	local a=$2
	local b=$3
	local player=$4
	local save=$5
	# transposition table
	local aSave=$a
	local hash
	hash="$player ${field[@]}"
	if ! $save && test "${cacheLookup[$hash]+set}" && (( ${cacheDepth[$hash]} >= depth )) ; then
		local value=${cacheLookup[$hash]}
		local flag=${cacheFlag[$hash]}
		if (( flag == 0 )) ; then
			return $value
		elif (( flag == 1 && value > a )) ; then
			a=$value
		elif (( flag == -1 && value < b )) ; then
			b=$value
		fi
		if (( a >= b )) ; then
			return $value
		fi
	fi
	# lost own king?
	if ! hasKing "$player" ; then
		cacheLookup[$hash]=$(( strength - depth + 1 ))
		cacheDepth[$hash]=$depth
		cacheFlag[$hash]=0
		return $(( strength - depth + 1 ))
	# use heuristics in depth
	elif (( depth <= 0 )) ; then
		local values=0
		for (( y=0; y<8; y++ )) ; do
			for (( x=0; x<8; x++ )) ; do
				local fig=${field[$y,$x]}
				if (( ${field[$y,$x]} != 0 )) ; then
					local figPlayer=$(( fig < 0 ? -1 : 1 ))
					# a more simple heuristic would be values=$(( $values + $fig ))
					(( values += ${figValues[$fig * $figPlayer]} * figPlayer ))
					# pawns near to end are better
					if (( fig == 1 )) ; then
						if (( figPlayer > 0 )) ; then
							(( values += ( y - 1 ) / 2 ))
						else
							(( values -= ( 6 + y ) / 2 ))
						fi
					fi
				fi
			done
		done
		values=$(( 127 + ( player * values ) ))
		# ensure valid bash return range
		if (( values > 253 - strength )) ; then
			values=$(( 253 - strength ))
		elif (( values < 2 + strength )) ; then
			values=$(( 2 + strength ))
		fi
		cacheLookup[$hash]=$values
		cacheDepth[$hash]=0
		cacheFlag[$hash]=0
		return $values
	# ベストを選択
	else
		local bestVal=0
		local fromY
		local fromX
		local toY
		local toX
		local i
		local j
		for (( fromY=0; fromY<8; fromY++ )) ; do
			for (( fromX=0; fromX<8; fromX++ )) ; do
				local fig=$(( ${field[$fromY,$fromX]} * ( player ) ))
				# precalc possible fields (faster then checking every 8*8 again)
				local targetY=()
				local targetX=()
				local t=0
				# empty or enemy
				if (( fig <= 0 )) ; then
					continue
				# ポーン
				elif (( fig == 1 )) ; then
					targetY[$t]=$(( player + fromY ))
					targetX[$t]=$(( fromX ))
					(( t += 1 ))
					targetY[$t]=$(( 2 * player + fromY ))
					targetX[$t]=$(( fromX ))
					(( t += 1 ))
					targetY[$t]=$(( player + fromY ))
					targetX[$t]=$(( fromX + 1 ))
					(( t += 1 ))
					targetY[$t]=$(( player + fromY ))
					targetX[$t]=$(( fromX - 1 ))
					(( t += 1 ))
				# ナイト
				elif (( fig == 2 )) ; then
					for (( i=-1 ; i<=1 ; i=i+2 )) ; do
						for (( j=-1 ; j<=1 ; j=j+2 )) ; do
							targetY[$t]=$(( fromY + 1 * i ))
							targetX[$t]=$(( fromX + 2 * j ))
							(( t + 1 ))
							targetY[$t]=$(( fromY + 2 * i ))
							targetX[$t]=$(( fromX + 1 * j ))
							(( t + 1 ))
						done
					done
				# キング
				elif (( fig == 6 )) ; then
					for (( i=-1 ; i<=1 ; i++ )) ; do
						for (( j=-1 ; j<=1 ; j++ )) ; do
							targetY[$t]=$(( fromY + i ))
							targetX[$t]=$(( fromX + j ))
							(( t += 1 ))
						done
					done
				else
					# ビショップかクイーン
					if (( fig != 4 )) ; then
						for (( i=-8 ; i<=8 ; i++ )) ; do
							if (( i != 0 )) ; then
								# can be done nicer but avoiding two loops!
								targetY[$t]=$(( fromY + i ))
								targetX[$t]=$(( fromX + i ))
								(( t += 1 ))
								targetY[$t]=$(( fromY - i ))
								targetX[$t]=$(( fromX - i ))
								(( t += 1 ))
								targetY[$t]=$(( fromY + i ))
								targetX[$t]=$(( fromX - i ))
								(( t += 1 ))
								targetY[$t]=$(( fromY - i ))
								targetX[$t]=$(( fromX + i ))
								(( t += 1 ))
							fi
						done
					fi
					# ルークかクイーン
					if (( fig != 3 )) ; then
						for (( i=-8 ; i<=8 ; i++ )) ; do
							if (( i != 0 )) ; then
								targetY[$t]=$(( fromY + i ))
								targetX[$t]=$(( fromX ))
								(( t += 1 ))
								targetY[$t]=$(( fromY - i ))
								targetX[$t]=$(( fromX ))
								(( t += 1 ))
								targetY[$t]=$(( fromY ))
								targetX[$t]=$(( fromX + i ))
								(( t += 1 ))
								targetY[$t]=$(( fromY ))
								targetX[$t]=$(( fromX - i ))
								(( t += 1 ))
							fi
						done
					fi
				fi
				# 全て有効
				for (( j=0; j < t; j++ )) ; do
					local toY=${targetY[$j]}
					local toX=${targetX[$j]}
					# 動かせない
					if (( toY >= 0 && toY < 8 && toX >= 0 && toX < 8 )) &&  canMove "$fromY" "$fromX" "$toY" "$toX" "$player" ; then
						local oldFrom=${field[$fromY,$fromX]};
						local oldTo=${field[$toY,$toX]};
						field[$fromY,$fromX]=0
						field[$toY,$toX]=$oldFrom
						# ポーンからクイーン
						if (( oldFrom == player && toY == ( player > 0 ? 7 : 0 ) )) ;then
							field["$toY,$toX"]=$(( 5 * player ))
						fi
						# 再帰
						negamax $(( depth - 1 )) $(( 255 - b )) $(( 255 - a )) $(( player * (-1) )) false
						local val=$(( 255 - $? ))
						field[$fromY,$fromX]=$oldFrom
						field[$toY,$toX]=$oldTo
						if (( val > bestVal )) ; then
							bestVal=$val
							if $save ; then
								selectedX=$fromX
								selectedY=$fromY
								selectedNewX=$toX
								selectedNewY=$toY
							fi
						fi
						if (( val > a )) ; then
							a=$val
						fi
						if (( a >= b )) ; then
							break 3
						fi
					fi
				done
			done
		done
		cacheLookup[$hash]=$bestVal
		cacheDepth[$hash]=$depth
		if (( bestVal <= aSave )) ; then
			cacheFlag[$hash]=1
		elif (( bestVal >= b )) ; then
			cacheFlag[$hash]=-1
		else
			cacheFlag[$hash]=0
		fi
		return $bestVal
	fi
}
##
# 動かせる範囲を描画
#	  $1	y 軸
#	  $2	x 軸
#	  $3	マウスカーソル true
#
function drawField(){
	local y=$1 x=$2;
	echo -en "\e[0m";
	$3 &&{ # カーソルを絶対位置に移動
		local yScr=$(( y + originY ));
		local xScr=$(( x * 2 + originX ));
		echo -en "\e[${yScr};${xScr}H";
	}
	((x==labelX&&y>=0&&y<8))&&{ # 縦方向のラベルを描画
		$hoverInit && ((hoverY==y)) &&{ echo -en "\e[3${colorHover}m"; }
		((selectedY==y))&&{
			((field[$selectedY,$selectedX]<0))&&{
				echo -en "\e[3${colorPlayerA}m";
			}||{ echo -en "\e[3${colorPlayerB}m"; }
		}
		echo -en "$(unicode e2 92 bd -$y) " # 縦軸の数字
  }
	((x>=0&&y==labelY))&&{ # 横方向のラベルを描画
		$hoverInit && ((hoverX==x))&&{ echo -en "\e[3${colorHover}m"; }
		((selectedX==x))&&{
			((field[$selectedY,$selectedX]<0))&&{
				echo -en "\e[3${colorPlayerA}m";
			}||{ echo -en "\e[3${colorPlayerB}m"; }
		}||{ echo -en "\e[0m"; }
    echo -en "$(unicode e2 9e 80 $x )\e[0m ";
  }
	((y>=0&&y<8&&x>=0&&x<8))&&{  # 黒と白のフィールドを描画
		local f=${field["$y,$x"]};
		local black=false;
		(( (x+y)%2==0 ))&&{ local black=true; }
		$black &&{ echo -en "\e[47;107m"; }||{ $color && echo -en "\e[40m"; }
		$hoverInit &&((hoverX==x&&hoverY==y))&&{ # 背景
			$black &&{ echo -en "\e[4${colorHover};10${colorHover}m";
			}||{ echo -en "\e[4${colorHover}m"; }
		}
    ((selectedX!=-1&&selectedY!=-1))&&{
			local selectedPlayer=$(( field[$selectedY,$selectedX] > 0 ? 1 : -1 ));
			((selectedX==x&&selectedY==y))&&{ 
        $black &&{ echo -en "\e[47m"; 
        }||{ echo -en "\e[40;100m"; }
      }
			canMove "$selectedY" "$selectedX" "$y" "$x" "$selectedPlayer" &&{
				$black &&{
					((selectedPlayer<0))&&{ echo -en "\e[4${colorPlayerA};10${colorPlayerA}m";
					}||{ echo -en "\e[4${colorPlayerB};10${colorPlayerB}m"; }
				}||{
					((selectedPlayer<0))&&{ echo -en "\e[4${colorPlayerA}m";
					}||{ echo -en "\e[4${colorPlayerB}m"; }
				}
			}
		}
		((f==0))&&{ echo -en "  "; }||{ #フィールドが空だったら
      ((selectedX==x&&selectedY==y))&&{ # フィギュアの色
        ((f<0))&&{ echo -en "\e[3${colorPlayerA}m"; 
        }||{ echo -en "\e[3${colorPlayerB}m"; }
      }||{
        ((f<0))&&{ echo -en "\e[3${colorPlayerA};9${colorPlayerA}m";
        }||{ echo -en "\e[3${colorPlayerB};9${colorPlayerB}m"; }
      }
			((f>0))&&{ echo -en "$( unicode e2 99 a0 -$f ) ";
			}||{ echo -en "$( unicode e2 99 a0 $f ) "; }
		}
	}||{ echo -n "  "; } # それ以外：二つの文字が空
	echo -en "\e[0m\e[8m"; # クリア
}
##
# 駒が動かせる範囲であるかをチェック
# Return 0/1
#
function canMove() {
	local fromY=$1 fromX=$2 toY=$3 toX=$4 player=$5  i;
	((fromY<0||fromY>=8||fromX<0||fromX>=8||toY<0||toY>=8||toX<0||toX>=8||(fromY==toY&&fromX==toX)))&&{ return 1;}
	local from=$((field[$fromY,$fromX]));
	local to=$((field[$toY,$toX]));
	local fig=$((from*player));
	((from==0||from*player<0||to*player>0||player*player!=1))&&{ return 1; }
  ((fig==1))&&{ # ポーン
    ((fromX==toX && to==0 && (toY-fromY==player || (toY-fromY==2*player && \
    field["$((player+fromY)),$fromX"]==0&&fromY==(player> 0 ? 1 : 6 )))))&&{ return 0 ;
    }||{ return $(( ! ( (fromX-toX)*(fromX - toX) == 1 && \
          toY - fromY == player && \
          to * player < 0 ) ));
    }
  }
  ((fig==5||fig==4 ||fig==3))&&{ # クイーン、ルーク、ビショップ
    ((fig!=3))&&{     # ルークとクイーン
      ((fromX==toX))&&{
        for((i=(fromY<toY?fromY:toY)+1;i< (fromY>toY?fromY:toY);i++)); do
          ((field[$i,$fromX]!=0))&& return 1;
        done
        return 0;
      }
      ((fromY==toY))&&{
        for((i=(fromX<toX?fromX:toX)+1;i< (fromX>toX?fromX:toX);i++)); do
          ((field[$fromY,$i]!= 0))&& return 1;
        done
        return 0;
      }
    }
    ((fig!=4))&&{ # ビショップとクイーン
      (((fromY-toY)*(fromY-toY)!=(fromX-toX)*(fromX-toX)))&&{ return 1; }
      for((i=1;i< ($fromY>toY?fromY-toY:toY-fromY);i++)); do
        ((field[$((fromY+i*(toY-fromY> 0?1:-1))),$((fromX+i*(toX-fromX> 0?1:-1)))]!=0))&&{ return 1;}
      done
      return 0;
    }
    return 1; # nothing found? wrong move.
  }
  ((fig==2))&&{ # ナイト
    return $(( ! ( ( (fromY-toY==2||fromY-toY==-2)&(fromX-toX==1||fromX-toX==-1))|| \
    ( (fromY-toY==1||fromY-toY==-1)&&(fromX-toX==2||fromX-toX==-2) ) ) ));
  }
  ((fig==6))&&{ # キング
    return $(( ! ( ((fromX-toX)*(fromX-toX))<=1&&((fromY-toY)*(fromY-toY))<= 1) ));
  }||{ error "そこへは移動できません '$from'!"; exit 1; }
}
##
# 駒の動き
# $1:player
# return 0/1
#
function move() {
	canMove "$selectedY" "$selectedX" "$selectedNewY" "$selectedNewX" "$1";
  (($?==0))&&{
		fig=${field[$selectedY,$selectedX]};
		field[$selectedY,$selectedX]=0;
		field[$selectedNewY,$selectedNewX]=$fig;
		((fig==$1 && selectedNewY==($1>0 ? 7 : 0)))&&{
			field[$selectedNewY,$selectedNewX]=$((5*$1));
		}
		return 0;
	}
	return 1;
}
##
# 次の一手を読み込む
# return 0/1
#
function inputCoord(){
	local ret=0 t= tx= ty= oldHoverX=$hoverX oldHoverY=$hoverY IFS='';
	$useStty && stty echo;
	echo -en "\e[?9h";
	((inputY=-1,inputX=-1));
	while((inputY<0||inputY>=8||inputX<0||inputX>=8)); do
		read -sN1 a;
		case "$a" in
			$'\e' )  
        if read -t0.1 -sN2 b ; then ##ここの書き方が判りません
        case "$b" in
          '[A' | 'OA' ) hoverInit=true; ((--hoverY<0))&&{ hoverY=0; } ;;
          '[B' | 'OB' ) hoverInit=true; ((++hoverY>7))&&{ hoverY=7; } ;;
          '[C' | 'OC' ) hoverInit=true; ((++hoverX>7))&&{ hoverX=7; } ;;
          '[D' | 'OD' ) hoverInit=true; ((--hoverX<0))&&{ hoverX=0; } ;;
          '[3' )        ret=1; break; ;;
          '[5' )        hoverInit=true; (( hoverY == 0 ))||{ hoverY=0; } ;;
          '[6' )        hoverInit=true; (( hoverY == 7 ))||{ hoverY=7; } ;;
          'OH' )        hoverInit=true; (( hoverX == 0 ))||{ hoverX=0; } ;;
          'OF' )        hoverInit=true; (( hoverX == 7 ))||{ hoverX=7; } ;;
          '[M' )        read -sN1 t; read -sN1 tx; read -sN1 ty;
                        ty=$(($(ord "$ty")-32-originY)); tx=$((($(ord "$tx")-32-originX)/2));
                        ((tx>=0&&tx<8&&ty>=0&&ty<8))&&{
                          ((inputY=$ty,inputX=$tx,hoverY=$ty,hoverX=$tx));
                        }||{ ret=1; break; } ;;
          * ) :
        esac
			else
        ret=1; break; 
      fi 
      ;;
			$'\t'|$'\n'|' ') [[ $hoverInit == true ]]&&{ ((inputY=$hoverY,inputX=$hoverX)); } ;;
			'~' ) ;;
			$'\x7f'|$'\b') ret=1; break; ;;
			[A-Ha-h]) t=$(ord $a);
			          ((t<90))&&{ inputY=$((72-$(ord $a))); }||{ inputY=$((104-$(ord $a))); }
				        hoverY=$inputY; ;;
			[1-8]) inputX=$((a-1)); hoverX=$inputX; ;;
			* ) ;;
		esac
		$hoverInit && ((oldHoverX!=hoverX||oldHoverY!=hoverY))&&{
			((oldHoverX=$hoverX,oldHoverY=$hoverY));
			draw;
		}
	done
	echo -en "\e[?9l";
	$useStty && stty -echo;
	return $ret;
}
##
# 人間の手番か？
# $1	 player 
# return 0/1
#
function input() {
	local player=$1 figName=;
	message="\e[1m$(namePlayer "$player")\e[0m: の手番です(例:b3)"
	while [[ 1 ]]; do
    ((selectedY=-1,selectedX=-1));
		title="$(namePlayer "$player")の手番";
		draw >&3;
		inputCoord;
    (($?==0))&&{
			((selectedY=$inputY,selectedX=$inputX));
			((field[$selectedY,$selectedX]==0))&&{ warn "駒がありません" >&3; }
      ((field[$selectedY,$selectedX]*player<0))&&{
				warn "その駒は選べません" >&3;
			}||{
        figName=$(nameFigure field[$selectedY,$selectedX]);
        message="\e[1m$(namePlayer "$player")\e[0m: \e[3m$figName\e[0m を \
                $(coord "$selectedY" "$selectedX") から(例:d3)";
        draw >&3;
				inputCoord ;
        (($?==0))&&{
					((selectedNewY=$inputY,selectedNewX=$inputX));
					((selectedNewY==selectedY&&selectedNewX==selectedX ))&&{
						warn "動かせません..." >&3;
					}
          ((field[$selectedNewY,$selectedNewX]*$player>0))&&{
						warn "自分の駒を取る事は出来ません..." >&3;
					}
          move "$player";
          (($?==0))&&{
            title="$(namePlayer "$player")\e[3m$figName\e[0m を \
                   $(coord "$selectedY" "$selectedX") から \
                   $(coord "$selectedNewY" "$selectedNewX") へ";
            return 0;
				  }||{ warn "その駒は動かせません" >&3; }
				}
			}
		}
	done
}
##
# アスキーを入力してdecimal asciiを出力する
# $1	ascii character
#
function ord() {
	LC_CTYPE=C printf '%d' "'$1";
}
#------------------------------------------------
# unicodeをエスケープ付きで出力
# params:
#	  $1	first hex unicode character number
#	  $2	second hex unicode character number
#	  $3	third hex unicode character number
#	  $4	integer offset of third hex
function unicode() {
		printf '\\x%s\\x%s\\x%x' "$1" "$2" "$(( 0x$3 + ( $4 ) ))" ;
}
##
# エラーメッセージの出力
#
function error() {
	echo -e "\e[0;1;41m $1 \e[0m\n\e[3m(Script exit)\e[0m" >&2;
	anyKey;
	exit 1;
}
##
# 無効な移動などの警告
# 
function warn() {
	message="\e[41m\e[1m$1\e[0m\n" ;
	draw ;
}
##
# 入力を待つ
#
function anyKey(){
	$useStty && stty echo;
	echo -e "\e[2m(次手を選択して下さい)\e[0m";
	read -sN1;
	$useStty && stty -echo;
}
##
# 盤面を描画
#
function draw() {
	$useStty && stty -echo;
	echo -e "\e[H\e[?25l\e[0m\n\e[K$title\e[0m\n\e[K";
	for((ty=0;ty<10;ty++));do
		for((tx=-2;tx<8;tx++));do
      t="$(drawField "$ty" "$tx" true)";
      [[ redraw[ty,tx]!=t ]]&&{
        echo -n "$t";
        redraw[ty,tx]="$t";
        log="[ty,tx]";
      }
		done
	done
	$useStty && stty echo;
	echo -en "\e[0m\e[$((originY+10));0H\e[2K\n\e[2K$message\e[8m";
}
##
# 配置を出力
# Params: $1	row position
#	$2	column position
#
function coord() {
	echo -en "\x$((48-$1))$(($2+1))";
}
##
# 駒の名前を出力
# $1:player
#
function nameFigure() {
	(($1<0))&&{ echo -n "${figNames[$1*(-1)]}"; }||{ echo -n "${figNames[$1]}"; }
}
##
# プレイヤー名を取得
# $1:player
#
function namePlayer() {
	(($1<0))&&{
		echo -en "\e[3${colorPlayerA}m";
		isAI "$1" ;
    (($?==0))&&{ echo -n "$aiPlayerA"; }||{ echo -n "$namePlayerA"; }
	}||{
		echo -en "\e[3${colorPlayerB}m"
		isAI "$1" ;
    (($?==0))&&{ echo -n "$aiPlayerB"; }||{ echo -n "$namePlayerB"; }
	}
	echo -en "\e[0m";
}
##
# 打ち手がAIの場合の挙動
#
function ai() {
	local pl=$1 val= figName= ; # pl:player
	title="$(namePlayer "$pl")の手番";
	message="\e[1m$(namePlayer "$pl")\e[0m 思考中...";
	draw >&3;
  #--------
	negamax "$strength" 0 255 "$pl" true ; #AI処理メイン部分
	val=$?
  #--------
	figName=$(nameFigure ${field[$selectedY,$selectedX]} )
	message="\e[1m$( namePlayer "$pl" )\e[0m \e[3m$figName\e[0m を \
          $(coord "$selectedY" "$selectedX")から";
	draw >&3;
	sleep "$sleep";
	move $pl ;
  (($?==0))&&{
		message="\e[1m$( namePlayer "$pl" )\e[0m \e[3m$figName\e[0m を \
            $(coord "$selectedY" "$selectedX") から \
            $(coord "$selectedNewY" "$selectedNewX") へ";
		draw >&3;
		sleep "$sleep";
		title="$( namePlayer "$pl" ) $figName を \
          $(coord "$selectedY" "$selectedX") から \
          $(coord "$selectedNewY" "$selectedNewX" ) へ";
	}||{ error "[バグ] AIプレイヤーの禁じ手です！"; }
}
##
# プレイヤーはAIか？
# $1:player
#
function isAI() {
	(($1<0))&&{ [[ "${namePlayerA,,}" == "${aikeyword,,}" ]] &&{ return 0; }||{ return 1; }
	}||{ [[ "${namePlayerB,,}" == "${aikeyword,,}" ]] &&{ return 0; }||{ return 1; } }
}
##
# チェックされているかを判別
# $1:player
# return 0/1
#
function hasKing() {
	for((y=0;y<8;y++));do
		for((x=0;x<8;x++));do
			((field[$y,$x]*$1==6))&&{ return 0 ; }
		done
	done
	return 1;
}
##
# 手番管理
# $1:player
#
function teban(){
  hasKing "$1";       #チェック？
  (($?==0))&&{ 
    isAI "$1";        #AIの手番
    (($?==0))&&{ ai "$1"; }||{ input "$1"; }
  }||{                #チェックだわ
    title="ゲームオーバー"
    message="\e[1m$(namePlayer $((p*(-1))) )の勝利!\e[1m\n"
    draw >&3;         #盤面の描画
    anyKey ;          #入力を待ちます
    exit 0 ;          #終了
  }
}
##
#メイン 
#
function main(){
	local p=1;                #打ち手
	while [[ 1 ]]; do
		((p*=(-1)))       #打ち手の切り替え
    teban "$p";
	done 
} 3>&1
##
# 実行
#
main ;
exit ;
