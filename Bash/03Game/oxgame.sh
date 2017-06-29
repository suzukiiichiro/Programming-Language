# !/bin/bash

# Explanation of usage
function usage() {
cat <<_EOT_
Usage:
	$0

Description:
	2 Players ox game

Options:
	-h help

_EOT_
exit 1
}

# option check
if [ "$OPTIND" = 1 ]; then
	while getopts h OPT
	do
	case $OPT in
			h)
				usage
				exit 1
				;;
			\?)
				;;
		esac
	done
fi

# CONSTANTS
# SIZE of the board
readonly SIZE=3
# PLAYER IDS
readonly NONE=0
readonly P1=1
readonly P2=2
readonly PLAYER_NAME=("None" "Player1(o)" "Player2(x)")
readonly MARKS=(" " "o" "x")
# BORAD STATE FULL
readonly IS_NOT_FULL=0
readonly IS_FULL=1

# Initialize ox board
for ((x=0; x<$SIZE; x++)) {
	for ((y=0; y<$SIZE; y++)) {
		eval board${x}${y}=$NONE
	}
}

# ----------------------------------------------------------------
# Judge who is the winner
function judge_winner() {
	# Horizontal line
	for ((x=0;x<$SIZE;x++)) {
		local _winner=$((board${x}0))
		for ((y=1;y<$SIZE;y++)) {
			if [ $_winner -ne $((board${x}${y})) ]; then
				_winner=$NONE
				break
			fi
		}
		# return winner if winner is not $NONE player
		if [ $_winner -ne $NONE ]; then
			return $_winner
		fi
	}

	# Vertical line
	for ((y=0;y<$SIZE;y++)) {
		local _winner=$((board0${y}))
		for ((x=1;x<$SIZE;x++)) {
			if [ $_winner -ne $((board${x}${y})) ]; then
				_winner=$NONE
				break
			fi
		}
		# return winner if winner is not $NONE player
		if [ $_winner -ne $NONE ]; then
			return $_winner
		fi
	}

	# Crossing line
	local _winner=$((board00))
	for ((c=1;c<$SIZE;c++)) {
		if [ $_winner -ne $((board${c}${c})) ]; then
			_winner=$NONE
			break
		fi
	}
	if [ $_winner -ne $NONE ]; then
		return $_winner
	fi
	
	_winner=$((board$((SIZE-1))0))
	for ((c=1;c<$SIZE;c++)) {
		if [ $_winner -ne $((board$((SIZE-1-c))${c})) ]; then
			_winner=$NONE
			break
		fi
	}
	if  [ $_winner -ne $NONE ]; then
		return $_winner
	fi

	# return NONE result if no winner
	return $NONE
}

# ----------------------------------------------------------------
function check_full() {
	for ((x=0; x<$SIZE; x++)) {
		for ((y=0; y<$SIZE; y++)) {
			if [ $board${x}${y} -eq $NONE ]; then
				return $IS_NOT_FULL
			fi
		}
	}
	return $IS_FULL
}

# ----------------------------------------------------------------
function print_board() {
	local _line="+"
	for ((x=0;x<$((SIZE*2-1));x++)) {
		_line=$_line"-"
	}
	_line=$_line"+"
	# Upper line
	echo $_line
	# Board cells
	for ((x=0;x<$SIZE;x++)) {
		local _row="|"
		for ((y=0;y<$SIZE;y++)) {
			# print "o" if P1, elif "x" if P2, else " "
			local _mark=${MARKS[$((board${x}${y}))]}
			_row=$_row$_mark"|"
		}
		echo $_row
	}
	# Bottom line
	echo $_line
	echo ""
}

# ----------------------------------------------------------------
function turn() {
	# print turn start message
	echo "${PLAYER_NAME[${1}]}'s turn"
	echo "Please input pos (x, y) to place ${MARKS[${1}]}"
	# stdin
	while :
	do
		# row pos
		while :
		do 
			/bin/echo -n 'row > '
			read _row
			if [[ ! $_row =~ ^([0-9]|[1-9][0-9]*)$ ]]; then
				echo "row must be integer"
				continue
			fi
			if [ $_row -lt 0 -o $_row -ge $SIZE ]; then
				echo "row must be 0 <= row < ${SIZE}"
			else
				break
			fi
		done

		# col pos
		while :
		do
			/bin/echo -n 'col > '
			read _col
			if [[ ! $_col =~ ^([0-9]|[1-9][0-9]*)$ ]]; then
				echo "col must be integer"
				continue
			fi
			if [ $_col -lt 0 -o $_col -ge $SIZE ]; then
				echo "col must be 0 <= col < ${SIZE}"
			else
				break
			fi
		done

		# check if no mark exist in (row, col)
		if [ $((board${_row}${_col})) -eq $NONE ]; then
			eval board${_row}${_col}=$1
			break
		else
			echo "$((board${_row}${_col})) is already placed at ${_row},${_col} "
		fi
	done
}

# ----------------------------------------------------------------
# Main Loop 
echo "OX Game Start!"
active_player=$P1
winner=$NONE
board_full=$IS_NOT_FULL
while [ $winner -eq $NONE -a $board_full -eq $IS_NOT_FULL ]
do
	print_board
	
	turn $active_player
	
	judge_winner
	winner=$?
	
	check_full
	board_full=$?
	
	# switch player
	if [ $active_player -eq $P1 ];then
		active_player=$P2
	else
		active_player=$P1
	fi
done

# Show result
if [ $winner -ne $NONE ]; then
	echo "*******************"
	echo "Winner is ${winner}!"
	echo "*******************"
else
	echo "Draw!"
fi
print_board
