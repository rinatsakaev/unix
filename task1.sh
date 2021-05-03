figure=$1;
pipe=/tmp/mypipe;
if_my_turn=0;
trap "rm -f $pipe" EXIT

if [[ ! -p $pipe ]]; then
    mknod $pipe p;
fi

if [[ $figure == "x" ]]
then
  is_my_turn=1;
fi;

while true; do
  if [[ $is_my_turn == 1 ]]; then
    echo "your turn";
    echo ">";
    read position;
    echo $position > $pipe;
    is_my_turn=0;
  else
    read position <$pipe;
    echo $position;
    is_my_turn=1;
  fi;
done;
# while true; do
#   echo $figure > /tmp/mypipe;
# done;
# echo $FIGURE > p;
# if [ "$FIGURE" = "x" ]
# then
#   while true; do
#   echo "your turn";
#   echo ">";
#   read line;
#   echo "$line" > test_output1;
#   read -r cmd;
#   echo $cmd;
# done;
# else
#   while true; do
#   read -r cmd;
#   echo $cmd;
#   echo "your turn";
#   echo ">";
#   read line;
#   echo "$line" > test_output1;
# done;
# fi

# while true; do
#   read -r cmd;
#   echo "hello";
# done
# coproc nc -l localhost 3000
#
# while true; do
#   read -r cmd;
#   case $cmd in
#     d) date ;;
#     q) break ;;
#     *) echo 'What?'
#   esac
# done <&"${COPROC[0]}" >&"${COPROC[1]}"
#
# kill "$COPROC_PID"
