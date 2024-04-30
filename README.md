
## Extended PL/0 Parser
### CMPE 425: Compiler Design
#### Department of Computer Engineering, Boğaziçi University, Spring 2024

### Introduction
This project enhances the PL/0 language by integrating new features such as multi-line comments, advanced control structures, functions, and arrays, among others. These enhancements required modifications to the grammar and the development of an updated lexer and parser.

### Extended PL/0 Grammar
We extended the grammar to support:
- Multi-line comments: `/* comment */`
- Control structures: `if`, `else`, `for`, `break`
- Functions with parameter lists and return capabilities
- Array declarations and index access
- I/O operations: `read()`, `write()`, and `writeline()`

### Design Choices
- **Block Structure**: Reordered to have function declarations follow procedure declarations.
- **Recursive Function and Procedure Declarations**: Allows nested definitions within blocks.
- **Improved Error Handling**: Strategies implemented to manage and recover from errors during parsing, though some limitations exist due to Bison's default handling mechanisms.

### Implementation Details
- **Lexer (`pl0_lexer.l`)**: Responsible for token recognition and management, including comment handling and error detection.
- **Parser (`pl0_parser.y`)**: Manages grammar rules and the parsing process, directly reporting errors to the terminal.

### Error Handling & Recovery
Implemented mechanisms within the parser aim to detect and recover from errors robustly, attempting to continue parsing and reporting as accurately as possible.

### Setup Instructions
To compile and run the parser:
```bash
$ flex pl0_lexer.l
$ bison -d pl0_parser.y
$ gcc -o pl0_parser lex.yy.c pl0_parser.tab.c
$ ./pl0_parser < path/to/pl0_code_file
```
Alternatively, a `Makefile` or `compile.sh` script is provided for ease of use.

### Testing
Comprehensive testing was conducted with both valid and corrupted PL/0 code files to ensure the parser's effectiveness and error recovery capabilities.

### Conclusion & Further Improvements
The parser effectively extends PL/0, enhancing its functionality. Future improvements could focus on refining error recovery and expanding feature support.
