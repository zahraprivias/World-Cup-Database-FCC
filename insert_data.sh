#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
	if [[ $YEAR != "year" && $ROUND != "round" && $WINNER != "winner" && $OPPONENT != "opponent" && $WGOALS != "winner_goals" && $OGOALS != "opponent_goals" ]]
	then
		# get winner id
		 WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		 # if not found
		 if [[ -z $WINNER_ID ]]
		 then
			# insert winner team
			INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
			if [[ $INSERT_WINNER == "INSERT 0 1" ]]
			then
				echo Inserted winner into teams, $WINNER
			fi
			# get new team id
			WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		fi
		 # get opponent id
		 OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
		 # if not found
		 if [[ -z $OPPONENT_ID ]]
		 then
			# insert opponent team
			INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
			if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
			then
				echo Inserted opponent into teams, $OPPONENT
			fi
			# get new team id
			OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
		 fi
		 # insert game
		 INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WGOALS, $OGOALS);")
		 if [[ $INSERT_GAME == "INSERT 0 1" ]]
			then
				echo Inserted game, $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WGOALS, $OGOALS
			fi
	fi
done
