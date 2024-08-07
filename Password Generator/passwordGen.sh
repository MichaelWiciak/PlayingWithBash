#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 [-l length] [-s] [-n] [-u] [-d]"
    echo "  -l LENGTH    Length of the password"
    echo "  -s           Include special characters"
    echo "  -n           Include numbers"
    echo "  -u           Include uppercase letters"
    echo "  -d           Include lowercase letters"
    exit 1
}

# Initialize variables
LENGTH=8
INCLUDE_SPECIAL=false
INCLUDE_NUMBERS=false
INCLUDE_UPPERCASE=false
INCLUDE_LOWERCASE=false

# Parse command-line arguments
while getopts "l:snude" opt; do
    case $opt in
        l) LENGTH=$OPTARG ;;
        s) INCLUDE_SPECIAL=true ;;
        n) INCLUDE_NUMBERS=true ;;
        u) INCLUDE_UPPERCASE=true ;;
        d) INCLUDE_LOWERCASE=true ;;
        *) usage ;;
    esac
done

# Check if at least one character set is selected
if [ "$INCLUDE_SPECIAL" = false ] && [ "$INCLUDE_NUMBERS" = false ] && [ "$INCLUDE_UPPERCASE" = false ] && [ "$INCLUDE_LOWERCASE" = false ]; then
    echo "You must include at least one type of character set: special, numbers, uppercase, or lowercase."
    usage
fi

# Character sets
SPECIAL_CHARS="!@#$%^&*()-_=+[]{}|;:,.<>?/~"
NUMBERS="0123456789"
UPPERCASE="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
LOWERCASE="abcdefghijklmnopqrstuvwxyz"

# Build the character pool
CHAR_POOL=""

if [ "$INCLUDE_SPECIAL" = true ]; then
    CHAR_POOL+="$SPECIAL_CHARS"
fi

if [ "$INCLUDE_NUMBERS" = true ]; then
    CHAR_POOL+="$NUMBERS"
fi

if [ "$INCLUDE_UPPERCASE" = true ]; then
    CHAR_POOL+="$UPPERCASE"
fi

if [ "$INCLUDE_LOWERCASE" = true ]; then
    CHAR_POOL+="$LOWERCASE"
fi

# Generate password
PASSWORD=$(LC_ALL=C tr -dc "$CHAR_POOL" < /dev/urandom | head -c $LENGTH)

echo "Generated password pre anything: $PASSWORD"
echo "CHAR_POOL: $CHAR_POOL"

# Ensure the password meets the inclusion criteria
if [ "$INCLUDE_SPECIAL" = true ] && ! echo "$PASSWORD" | grep -q "[$SPECIAL_CHARS]"; then
    PASSWORD+=$(echo "$SPECIAL_CHARS" | fold -w1 | shuf | head -c1)
fi

if [ "$INCLUDE_NUMBERS" = true ] && ! echo "$PASSWORD" | grep -q "[$NUMBERS]"; then
    PASSWORD+=$(echo "$NUMBERS" | fold -w1 | shuf | head -c1)
fi

if [ "$INCLUDE_UPPERCASE" = true ] && ! echo "$PASSWORD" | grep -q "[$UPPERCASE]"; then
    PASSWORD+=$(echo "$UPPERCASE" | fold -w1 | shuf | head -c1)
fi

if [ "$INCLUDE_LOWERCASE" = true ] && ! echo "$PASSWORD" | grep -q "[$LOWERCASE]"; then
    PASSWORD+=$(echo "$LOWERCASE" | fold -w1 | shuf | head -c1)
fi

# Shuffle the final password to ensure randomness
PASSWORD=$(echo "$PASSWORD" | fold -w1 | shuf | tr -d '\n' | head -c $LENGTH)

echo "Generated password: $PASSWORD"
