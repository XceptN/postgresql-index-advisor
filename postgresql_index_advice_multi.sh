#!/bin/bash
#
# Script to read a *.sql file with multiple (and multi-line) SQL statements
# and then to feed them to postgresql_index_advice.sh
#

#
# TODO: Show usage by default or with --help or lack of argument
#
print_usage () {
    echo "USAGE: $0 <regular file with multiple SQL statements>"
    echo
}

if [ "$#" -ne 1 ]; then
    print_usage
    exit 1
fi

if [ "$1" == "--help" ]; then
    print_usage
    exit 0
fi

# Input file is the first argument
INFILE=$1

# Check SQL file 
if [ ! -f ${INFILE} ]; then
    echo "ERROR: Missing or invalid input file"
    echo
    exit 2
fi

#
# TODO: Call postgresql_index_advice.sh with single SQL statement on commandline
#
# CURRENTLY: This expects a blank line at the end of the file

#INFILE="testinput.sql"
LINE=""
SQLSTMT=""

# Function to process a single line of input from file
process_line () {
    if [ -n "${LINE}" ]; then
        SQLSTMT+="${LINE} "
    fi
    if printf '%s\n' "$LINE" | grep -q ";[ ]*$"; then
        echo "$SQLSTMT"
        SQLSTMT=""
    fi

}

# Main loop
while read -r LINE
do
    process_line
done < "$INFILE"
# Handle last line (if any)
process_line
