#!/bin/bash

# Check if directory argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory_or_file>"
    exit 1
fi

# Check if the argument is a directory
if [ -d "$1" ]; then
    # Directory containing the PL/0 code files
    PL0_CODE_DIR="$1"

    # Iterate over each file in the directory
    for file in "$PL0_CODE_DIR"/*; do
        # Check if the file is a regular file
        if [ -f "$file" ]; then
            echo "Processing file: $file"
            ./pl0_parser < "$file"
            echo "--------------------------------------"
        fi
    done
# Check if the argument is a file
elif [ -f "$1" ]; then
    echo "Processing file: $1"
    ./pl0_parser < "$1"
    echo "--------------------------------------"
else
    echo "Error: Argument '$1' is neither a directory nor a file."
    exit 1
fi
