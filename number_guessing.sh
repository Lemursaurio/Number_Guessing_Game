#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=guessing_name -t -c"

echo "Enter your username: "
read USERNAME

# search username
# if not found
# welcome new user
# if found
# show previous data