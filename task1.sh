figure=$1;
enemy_figure="o";
pipe=/tmp/mypipe;
if_my_turn=0;

declare -A map;

for ((i=0;i<3;i++)) do
    for ((j=0;j<3;j++)) do
        map[$i,$j]=".";
    done
done

function setMapState(){
  map[$1,$2]=$3;
}

function checkWinner(){
  for ((i=0;i<3;i++)) do
      has_winner=1
      for ((j=0;j<2;j++)) do
          if [[ map[$i,$j] == '.' ]]; then
            has_winner=0;
            break;
          fi;
          if [[ "echo ${map[$i,$j]}" != "echo ${map[$i,$((j+1))]}" ]]; then
            has_winner=0;
            break;
          fi;
      done

      if [[ ${has_winner} == 1 ]]; then
      	if [[ "echo ${map[$i,$j]}" == "echo x" ]]; then
      		return 1;
        elif [[ "echo ${map[$i,$j]}" == "echo o" ]]; then
        	return 2;
        fi;
      fi;

    done;

    for ((i=0;i<3;i++)) do
      has_winner=1
      for ((j=0;j<2;j++)) do
          if [[ map[$j,$i] == '.' ]]; then
            has_winner=0;
            break;
          fi;
          if [[ "echo ${map[$j,$i]}" != "echo ${map[$((j+1)),$i]}" ]]; then
            has_winner=0;
            break;
          fi;
      done

      if [[ ${has_winner} == 1 ]]; then
      	if [[ "echo ${map[$j,$i]}" == "echo x" ]]; then
      		return 1;
        elif [[ "echo ${map[$j,$i]}" == "echo o" ]]; then
        	return 2;
        fi;
      fi;

    done;

    return 0;
}

function renderMap() {
  for ((i=0;i<3;i++)) do
    echo ${map[$i,0]} ${map[$i,1]} ${map[$i,2]};
  done
}

trap "rm -f $pipe" EXIT

if [[ ! -p $pipe ]]; then
    mknod $pipe p;
fi

if [[ $figure == "x" ]]
then
  is_my_turn=1;
else
  enemy_figure="x";
  figure="o";
fi;

while true; do
  if [[ $is_my_turn == 1 ]]; then
    echo "your turn";
    echo ">";
    read position;
    setMapState $position $figure;
    echo $position > $pipe;
    is_my_turn=0;
  else
  	echo "waiting enemy turn";
    read position <$pipe;
    setMapState $position $enemy_figure;
    echo $position;
    is_my_turn=1;
  fi;
  renderMap;
  checkWinner;
  winner=$?;
  if [[ "echo ${winner}" == "echo 0" ]]; then
  	continue;
  fi;

  if [[ "echo ${winner}" == "echo 1" && "echo ${figure}" == "echo x" ]]; then
    echo "you win";
    break;
  elif [[ "echo ${winner}" == "echo 2" && "echo ${figure}" == "echo o" ]]; then
    echo "you win";
    break;
  else
  	echo "you loose";
  	break;
  fi;
done;
