

SQUARES=16          
FAIL=70             
Puzzle=( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 " " )
swap() {
  local tmp
  tmp=${Puzzle[$1]}
  Puzzle[$1]=${Puzzle[$2]}
  Puzzle[$2]=$tmp
}
Jumble() {
  local i pos1 pos2
  for i in {1..100}
  do
    pos1=$(( $RANDOM % $SQUARES))
    pos2=$(( $RANDOM % $SQUARES ))
    swap $pos1 $pos2
  done
}
PrintPuzzle() {
  local i1 i2 puzpos
  puzpos=0
  clear
  echo "Enter  quit  to exit."; echo   
  echo ",----.----.----.----."   
  for i1 in {1..4}
  do
    for i2 in {1..4} 
    do
      printf "| %2s " "${Puzzle[$puzpos]}"
      (( puzpos++ ))
    done
    echo "|"                     
    test $i1 = 4 || echo "+----+----+----+----+"
  done
  echo "'----'----'----'----'"   
}
GetNum() { 
  local puznum garbage
  while true
  do 
	  echo "Moves: $moves" 
    read -p "Number to move: " puznum garbage
      if [ "$puznum" = "quit" ]; then echo; exit $E_PREMATURE_EXIT; fi
    test -z "$puznum" -o -n "${puznum//[0-9]/}" && continue
    test $puznum -gt 0 -a $puznum -lt $SQUARES && break
  done
  return $puznum
}
GetPosFromNum() { 
  local puzpos

  for puzpos in {0..15}
  do
    test "${Puzzle[$puzpos]}" = "$1" && break
  done
  return $puzpos
}
Move() { 
  test $1 -gt 3 && test "${Puzzle[$(( $1 - 4 ))]}" = " "\
       && swap $1 $(( $1 - 4 )) && return 0
  test $(( $1%4 )) -ne 3 && test "${Puzzle[$(( $1 + 1 ))]}" = " "\
       && swap $1 $(( $1 + 1 )) && return 0
  test $1 -lt 12 && test "${Puzzle[$(( $1 + 4 ))]}" = " "\
       && swap $1 $(( $1 + 4 )) && return 0
  test $(( $1%4 )) -ne 0 && test "${Puzzle[$(( $1 - 1 ))]}" = " " &&\
       swap $1 $(( $1 - 1 )) && return 0
  return 1
}


Solved() {
  local pos
  for pos in {0..14}
  do
    test "${Puzzle[$pos]}" = $(( $pos + 1 )) || return $FAIL
  done
  return 0  
}
moves=0
Jumble
while true   
do
  echo; echo
  PrintPuzzle
  echo
  while true
  do
    GetNum
    puznum=$?
    GetPosFromNum $puznum
    puzpos=$?
    ((moves++))
    Move $puzpos && break
  done
  Solved && break
done

echo;echo
PrintPuzzle
echo; echo "BRAVO!"; echo
exit 0
