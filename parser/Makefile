# ANSI color codes
GREEN = \033[0;32m
RED = \033[0;31m
BOLD = \033[1m
YELLOW = \033[0;33m
NC = \033[0m

# Default values
DEBUG_FLAG =
REMOVE_FLAG =

# Binary target
TARGET = pl0_parser

# Source files
LEX_SOURCE = pl0_lexer.l
YACC_SOURCE = pl0_parser.y

# Compiler and flags
CC = gcc
CFLAGS = 

.PHONY: all clean debug

all: $(TARGET)
	@echo -e "${GREEN} ---------------------------------------------------------${NC}"
	@echo -e "${GREEN} 	   CMPE425: Project 1 - Extended PL/0 Parser ${NC}"
	@echo -e "${GREEN}    Authors: Ramazan Burak Sarıtaş & Ali Alperen Sönmez ${NC}"
	@echo -e "${GREEN} ---------------------------------------------------------${NC}"
	@echo -e "${YELLOW} Available options:  -debug: Runs Bison in debug mode.${NC}"
	@echo -e "${YELLOW} 				creates: pl0_parser.output${NC}"
	@echo -e "${YELLOW} 			-clean: Removes intermediate files.${NC}"
	@echo -e "${YELLOW} 				removes: lex.yy.c${NC}"
	@echo -e "${YELLOW} 				removes: lex.yy.o${NC}"
	@echo -e "${YELLOW} 				removes: pl0_parser.tab.c${NC}"
	@echo -e "${YELLOW} 				removes: pl0_parser.tab.h${NC}"
	@echo -e "${YELLOW} 				removes: pl0_parser.tab.o${NC}"
	@echo -e "${GREEN} ---------------------------------------------------------${NC}"
	@echo -e "${GREEN} To parse a PL/0 code, execute the following command:${NC}"
	@echo -e "${YELLOW} 	./$(TARGET) < path/to/pl0_code_file${NC}"
	@echo -e "${GREEN} ---------------------------------------------------------${NC}"

$(TARGET): lex.yy.o $(TARGET).tab.o
	$(CC) $(CFLAGS) -o $@ lex.yy.o $(TARGET).tab.o
	@echo -e "${GREEN} PL/0 Parser compiled successfully.${NC}"
	@echo -e "${GREEN} executable: ${YELLOW}+ $(TARGET)${NC}${GREEN}${NC}"
	@echo -e "${GREEN} intermediate: ${YELLOW}+ lex.yy.c${NC}${GREEN}${NC}"
	@echo -e "${GREEN} intermediate: ${YELLOW}+ lex.yy.o${NC}${GREEN}${NC}"
	@echo -e "${GREEN} intermediate: ${YELLOW}+ $(TARGET).tab.c${NC}${GREEN}${NC}"
	@echo -e "${GREEN} intermediate: ${YELLOW}+ $(TARGET).tab.h${NC}${GREEN}${NC}"
	@echo -e "${GREEN} intermediate: ${YELLOW}+ $(TARGET).tab.o${NC}${GREEN}${NC}"
	@if [ "$(DEBUG_FLAG)" = "-v" ]; then \
		echo -e "${GREEN} -debug: ${YELLOW}+ $(TARGET).output${NC}${GREEN}${NC}"; \
	fi
	@if [ "$(REMOVE_FLAG)" = "yes" ]; then \
		if [ -f lex.yy.c ]; then \
			rm lex.yy.c; \
			echo -e "${GREEN} -clean: ${YELLOW}- lex.yy.c${NC}${GREEN}${NC}"; \
		fi; \
		if [ -f $(TARGET).tab.c ]; then \
			rm $(TARGET).tab.c; \
			echo -e "${GREEN} ${YELLOW}- $(TARGET).tab.c${NC}${GREEN}${NC}"; \
		fi; \
		if [ -f $(TARGET).tab.h ]; then \
			rm $(TARGET).tab.h; \
			echo -e "${GREEN} ${YELLOW}- $(TARGET).tab.h${NC}${GREEN}${NC}"; \
		fi; \
	fi

lex.yy.o: lex.yy.c
	$(CC) $(CFLAGS) -c lex.yy.c

lex.yy.c: $(LEX_SOURCE) $(TARGET).tab.h
	flex $(LEX_SOURCE)

$(TARGET).tab.o: $(TARGET).tab.c
	$(CC) $(CFLAGS) -c $(TARGET).tab.c

$(TARGET).tab.c $(TARGET).tab.h: $(YACC_SOURCE)
	bison -d $(DEBUG_FLAG) $(YACC_SOURCE)

clean:
	@echo -e "${GREEN} Cleaning intermediate files...${NC}"
	-rm -f lex.yy.c $(TARGET).tab.c $(TARGET).tab.h $(TARGET).output $(TARGET).tab.o lex.yy.o
	@echo -e "${GREEN} Intermediate files removed.${NC}"

debug:
	$(MAKE) DEBUG_FLAG=-v