#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=guessing_game -t -c"

echo "Enter your username: "
read USERNAME

# search username (and other data)
SEARCH_USERNAME_RESULT=$($PSQL "SELECT games_played, best_game FROM users WHERE username='$USERNAME'")

# if not found
if [[ -z $SEARCH_USERNAME_RESULT ]]
then
  # welcome new user
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  # insert new register
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME')")
else
  # if found
  # show previous data
  echo $SEARCH_USERNAME_RESULT | while read GAMES_PLAYED BAR BEST_GAME
  do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

# generate the random number and store it in a variable
NUMBER=$(($RANDOM%1000+1))
echo $NUMBER

#echo "Guess the secret number between 1 and 1000: "
#read GUESS