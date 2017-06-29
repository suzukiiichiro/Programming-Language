#!/bin/bash

# ./Hanoni.sh 5 

E_NOPARAM=86
E_BADPARAM=87   
E_NOEXIT=88
DELAY=0.3         
DISKS=$1
Moves=0
MWIDTH=7
MARGIN=2
let "basewidth = $MWIDTH * $DISKS + $MARGIN" 
let "disks1 = $DISKS - 1"
let "spaces1 = $DISKS" 
let "spaces2 = 2 * $DISKS" 
let "lastmove_t = $DISKS - 1"                
declare -a Rod1 Rod2 Rod3
function repeat  {  
  local n           
  
  for (( n=0; n<$2; n++ )); do
    echo -n "$1"
  done
}
function FromRod  {
  local rod summit weight sequence
  while true; do
    rod=$1
    test ${rod/[^123]/} || continue
    
    sequence=$(echo $(seq 0 $disks1 | tail -r ))
    for summit in $sequence; do
      eval weight=\${Rod${rod}[$summit]}
      test $weight -ne 0 &&
           { echo "$rod $summit $weight"; return; }
    done
  done
}
function ToRod  { 
  local rod firstfree weight sequence
  
  while true; do
    rod=$2
    test ${rod/[^123]} || continue
    
    sequence=$(echo $(seq 0 $disks1 | tail -r))
    for firstfree in $sequence; do
      eval weight=\${Rod${rod}[$firstfree]}
      test $weight -gt 0 && { (( firstfree++ )); break; }
    done
    test $weight -gt $1 -o $firstfree = 0 &&
         { echo "$rod $firstfree"; return; }
  done
}
function PrintRods  {
  local disk rod empty fill sp sequence
  tput cup 5 0
  repeat " " $spaces1
  echo -n "|"
  repeat " " $spaces2
  echo -n "|"
  repeat " " $spaces2
  echo "|"
  
  sequence=$(echo $(seq 0 $disks1 | tail -r))
  for disk in $sequence; do
    for rod in {1..3}; do
      eval empty=$(( $DISKS - (Rod${rod}[$disk] / 2) ))
      eval fill=\${Rod${rod}[$disk]}
      repeat " " $empty
      test $fill -gt 0 && repeat "*" $fill || echo -n "|"
      repeat " " $empty
    done
    echo
  done
  repeat "=" $basewidth   
  echo
}
display ()
{
  echo
  PrintRods
  
  first=( `FromRod $1` )
  eval Rod${first[0]}[${first[1]}]=0
  
  second=( `ToRod ${first[2]} $2` )
  eval Rod${second[0]}[${second[1]}]=${first[2]}
  if [ "${Rod3[lastmove_t]}" = 1 ]
  then   
    tput cup 0 0
    echo; echo "+  Final Position: $Moves moves"
    PrintRods
  fi
  sleep $DELAY
}
dohanoi() {   
    case $1 in
    0)
        ;;
    *)
        dohanoi "$(($1-1))" $2 $4 $3
	if [ "$Moves" -ne 0 ]
        then
	  tput cup 0 0
	  echo; echo "+  Position after move $Moves"
        fi
        ((Moves++))
        echo -n "   Next move will be:  "
        echo $2 "-->" $3
        display $2 $3
        dohanoi "$(($1-1))" $4 $3 $2
        ;;
    esac
}
setup_arrays ()
{
  local dim n elem
  let "dim1 = $1 - 1"
  elem=$dim1
  for n in $(seq 0 $dim1)
  do
   let "Rod1[$elem] = 2 * $n + 1"
   Rod2[$n]=0
   Rod3[$n]=0
   ((elem--))
  done
}
trap "tput cnorm" 0
tput civis
clear
setup_arrays $DISKS
tput cup 0 0
echo; echo "+  Start Position"
case $# in 
    1) case $(($1>0)) in     
       1)
           disks=$1
           dohanoi $1 1 3 2
	   echo
           exit 0;
           ;;
       *)
           echo "$0: Illegal value for number of disks";
           exit $E_BADPARAM;
           ;;
       esac
    ;;
    *)
       echo "usage: $0 N"
       echo "       Where \"N\" is the number of disks."
       exit $E_NOPARAM;
       ;;
esac
exit $E_NOEXIT   
