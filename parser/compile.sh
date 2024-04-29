#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
BOLD='\033[1m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Default values
DEBUG_FLAG=""
REMOVE_FLAG=""

echo -e "${GREEN}  ---------------------------------------------------------${NC}"
echo -e "${GREEN}          CMPE425: Project 1 - Extended PL/0 Parser        ${NC}"
echo -e "${GREEN}     Authors: Ramazan Burak Sarıtaş & Ali Alperen Sönmez   ${NC}"
echo -e "${GREEN}  ---------------------------------------------------------${NC}"
echo -e "${YELLOW}  Available options:  -debug: Runs Bison in debug mode.${NC}"
echo -e "${YELLOW}                              creates: pl0_parser.output${NC}"
echo -e "${YELLOW}                      -clean: Removes intermediate files.${NC}"
echo -e "${YELLOW}                              removes: lex.yy.c${NC}"
echo -e "${YELLOW}                              removes: pl0_parser.tab.c${NC}"
echo -e "${YELLOW}                              removes: pl0_parser.tab.h${NC}"
echo -e "${GREEN}  ---------------------------------------------------------${NC}"

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -debug)
        DEBUG_FLAG="-v"
        shift # past argument
        ;;
        -clean)
        REMOVE_FLAG="yes"
        shift # past argument
        ;;
        *)
        echo -e "${RED}  Error: Unknown option: $1${NC}"
        echo -e "${RED}  To run without options: ${YELLOW}./compile.sh ${NC}${RED}${NC}"
        echo -e "${RED}           in debug mode: ${YELLOW}./compile.sh -debug${NC}${RED}${NC}"
        echo -e "${RED}           in clean mode: ${YELLOW}./compile.sh -clean${NC}${RED}${NC}"
        echo -e "${RED}                 or both: ${YELLOW}./compile.sh -debug -clean${NC}${RED}${NC}"
        echo -e "${GREEN}  ---------------------------------------------------------${NC}"
        exit 1
        ;;
    esac
done

if [ -f pl0_parser ]; then
        rm pl0_parser
fi

# Compile the lexer and parser
flex pl0_parser.l
bison -d $DEBUG_FLAG pl0_parser.y

# Compile the C code
gcc -o pl0_parser lex.yy.c pl0_parser.tab.c

echo -e "${GREEN}  PL/0 Parser compiled successfully.${NC}"
echo -e "${GREEN}       executable: ${YELLOW}+ pl0_parser${NC}${GREEN}${NC}"
echo -e "${GREEN}     intermediate: ${YELLOW}+ lex.yy.c${NC}${GREEN}${NC}"
echo -e "${GREEN}     intermediate: ${YELLOW}+ pl0_parser.tab.c${NC}${GREEN}${NC}"
echo -e "${GREEN}     intermediate: ${YELLOW}+ pl0_parser.tab.h${NC}${GREEN}${NC}"
# Check if debug mode is enabled and inform about the creation of the output file
if [ "$DEBUG_FLAG" == "-v" ]; then
    echo -e "${GREEN}           -debug: ${YELLOW}+ pl0_parser.output${NC}${GREEN}${NC}"
fi

# Remove intermediate files if the flag is provided
if [ "$REMOVE_FLAG" == "yes" ]; then
    # Check if the files exist before attempting to remove them
    if [ -f lex.yy.c ]; then
        rm lex.yy.c
        echo -e "${GREEN}           -clean: ${YELLOW}- lex.yy.c${NC}${GREEN}${NC}"
    fi
    if [ -f pl0_parser.tab.c ]; then
        rm pl0_parser.tab.c
        echo -e "${GREEN}                   ${YELLOW}- pl0_parser.tab.c${NC}${GREEN}${NC}"
    fi
    if [ -f pl0_parser.tab.h ]; then
        rm pl0_parser.tab.h
        echo -e "${GREEN}                   ${YELLOW}- pl0_parser.tab.h${NC}${GREEN}${NC}"
    fi
fi


echo -e "${GREEN}  ---------------------------------------------------------${NC}"
echo -e "${GREEN}  To parse a PL/0 code, execute the following command:${NC}"
echo -e "${GREEN}  \$${YELLOW} ./pl0_parser < path/to/pl0_code_file${NC}"
echo -e "${GREEN}  ---------------------------------------------------------${NC}"