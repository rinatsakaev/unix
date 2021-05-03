figure=$1;
enemy_figure="o";
pipe=/tmp/mypipe;
if_my_turn=0;

declare -A map;

for ((i=1;i<=3;i++)) do
    for ((j=1;j<=3;j++)) do
        map[$i,$j]=".";
    done
done

function setMapState(){
  map[$1,$2]=$3;
}

function checkWinner(){
  for ((i=1;i<=3;i++)) do
      has_winner=1
      for ((j=2;j<=3;j++)) do
          if [[ map[$i,$j] == '.' ]]; then
            has_winner=0;
            break;
          fi;
          if [[ map[$i,$j] != map[$i,$j-1] ]]; then
            has_winner=0
            break;
          fi;
      done
      if [[ has_winner == 1 ]]; then
        echo $map[$i, $j];
        return;
      fi;
    done;

    for ((i=1;i<=3;i++)) do
        has_winner=1
        for ((j=2;j<=3;j++)) do
            if [[ map[$j,$i] == '.' ]]; then
              has_winner=0;
              break;
            fi;
            if [[ map[$j,$i]!=map[$j-1,$i] ]]; then
              has_winner=0
              break;
            fi;
        done
        if [[ has_winner == 1 ]];  then
          echo $map[$i, $j];
          return;
        fi;
    done;

    echo $".";
}

function renderMap() {
  for ((i=1;i<=3;i++)) do
    echo ${map[$i,1]} ${map[$i,2]} ${map[$i,3]};
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
    read position <$pipe;
    setMapState $position $enemy_figure;
    echo $position;
    is_my_turn=1;
  fi;
  renderMap;
  winner=$(checkWinner);
  if [[ $winner == $figure ]]; then
    echo "you win";
    return;
  fi;
  if [[ $winner == $enemy_figure ]]; then
    echo "you loose";
    return;
  fi;
done;
