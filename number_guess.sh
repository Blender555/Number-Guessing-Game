#!/bin/bash
DB_FILE="number_guessing_game.db"
if [[ ! -f $DB_FILE ]]; then
    touch $DB_FILE
fi

DB_FILE="number_guessing_game.db"

if [[ ! -f $DB_FILE ]]; then
    touch $DB_FILE
fi

echo "Enter your username:"
read USERNAME
if [[ ${#USERNAME} -gt 22 ]]; then
    echo "Username should not be longer than 22 characters."
    exit 1
fi

if [[ ${#USERNAME} -gt 22 ]]; then
    echo "Username should not be longer than 22 characters."
    exit 1
fi

USER_DATA=$(grep "^$USERNAME:" $DB_FILE)
if [[ -z $USER_DATA ]]; then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    echo "$USERNAME:0:1000" >> $DB_FILE
    GAMES_PLAYED=0
    BEST_GAME=1000
else
    IFS=":" read -r NAME GAMES_PLAYED BEST_GAME <<< "$USER_DATA"
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
NUMBER_OF_GUESSES=0

echo "Guess the secret number between 1 and 1000:"
while true; do
    read GUESS
if ! [[ $GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
fi

    if ! [[ $GUESS =~ ^[0-9]+$ ]]; then
        echo "That is not an integer, guess again:"
        continue
    fi

    NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))

    if [[ $GUESS -lt $SECRET_NUMBER ]]; then
        echo "It's higher than that, guess again:"
    elif [[ $GUESS -gt $SECRET_NUMBER ]]; then
        echo "It's lower than that, guess again:"
    else
        echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
        break
    fi
done

if [[ $NUMBER_OF_GUESSES -lt $BEST_GAME ]]; then
    BEST_GAME=$NUMBER_OF_GUESSES
fi

GAMES_PLAYED=$((GAMES_PLAYED + 1))

grep -v "^$USERNAME:" $DB_FILE > temp.db
mv temp.db $DB_FILE
echo "$USERNAME:$GAMES_PLAYED:$BEST_GAME" >> $DB_FILE
