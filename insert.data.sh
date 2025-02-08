#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY;"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then

    TEAM1_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      TEAM2_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    
      if [[ -z $TEAM1_ID ]]
      then
        INSERT_TEAM1_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      fi

      if [[ -z $TEAM2_ID ]]
      then
        INSERT_TEAM2_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      fi

      TEAM1_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      TEAM2_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

      $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) \
           VALUES($YEAR, '$ROUND', $TEAM1_ID, $TEAM2_ID, $WINNER_GOALS, $OPPONENT_GOALS)"
  fi
done
