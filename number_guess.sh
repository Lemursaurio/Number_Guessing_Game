#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=guessing_game -t -c"

GUESSING_GAME() {
  NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES+1))

  if [[ -z $1 ]]
  then
    echo -e "\nGuess the secret number between 1 and 1000:"
  else
    echo -e "$1" 
  fi
  read GUESS

  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    # if not a number 
    # print 'not an integer'
    GUESSING_GAME "\nThat is not an integer, guess again:"
  elif (( GUESS > NUMBER ))
  then
    # if lower than number
    # print 'lower'
    GUESSING_GAME "\nIt's lower than that, guess again:"
  elif (( GUESS < NUMBER ))
  then
    # if higher than number
    # print higher
    GUESSING_GAME "\nIt's higher than that, guess again:"
  else
    # print 'you guessed the number'
    echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $NUMBER. Nice job!"
    # add new data to database
    if (( NUMBER_OF_GUESSES < BEST_GAME || BEST_GAME == null ))
    then
      # if number of guesses is (<) best game
      INSERT_DATA_RESULT=$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED, best_game=$NUMBER_OF_GUESSES WHERE username='$USERNAME'")
    else
      # if number of guesses is not (>=) best game
      INSERT_DATA_RESULT=$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED WHERE username='$USERNAME'")
    fi  
  fi  
}

echo "Enter your username:"
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
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

# generate the random number and store it in a variable
NUMBER=$((RANDOM%1000+1))
echo $NUMBER
NUMBER_OF_GUESSES=0
GAMES_PLAYED=$((GAMES_PLAYED+1))
   
GUESSING_GAME



