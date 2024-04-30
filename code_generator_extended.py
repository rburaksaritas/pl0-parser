import random
import string

MAX_RECURSION_DEPTH = 500  # Set the maximum recursion depth

def generate_ident():
    return ''.join(random.choices(string.ascii_letters, k=random.randint(1, 10)))

def generate_number():
    return str(random.randint(0, 100))

def generate_program(recursion_depth=0):
    print("generating program...", recursion_depth)
    if recursion_depth > MAX_RECURSION_DEPTH:
        return "var x; x := 1"  # Base case: return a valid baseline
    
    block = generate_block(recursion_depth + 1)
    print("generating block.")
    return block + "."

def generate_block(recursion_depth=0):
    print("generating block...", recursion_depth)
    if recursion_depth > MAX_RECURSION_DEPTH/100 + 2:
        return "var x; x := 1"  # Base case: return a valid baseline
    consts = []
    if random.random() < 0.5:
        num_consts = random.randint(1, 5)
        consts = [generate_ident() + " = " + generate_number() for _ in range(num_consts)]
        consts = "const " + ", ".join(consts) + ";\n"

    arrays = []
    if random.random() < 0.5:
        num_arrays = random.randint(1, 5)
        arrays = [generate_ident() + "[" + generate_number() + "]" for _ in range(num_arrays)]
        arrays = "var " + ", ".join(arrays) + ";\n"
    vars = []
    if random.random() < 0.5:
        num_vars = random.randint(1, 5)
        vars = [generate_ident() for _ in range(num_vars)]
        vars = "var " + ", ".join(vars) + ";\n"

    procedures = []
    if recursion_depth < MAX_RECURSION_DEPTH and random.random() < 0.5:
        num_procedures = random.randint(1, 3)
        procedures = [generate_procedure(recursion_depth + 1) for _ in range(num_procedures)]

    functions = []
    if recursion_depth < MAX_RECURSION_DEPTH and random.random() < 0.5:
        num_functions = random.randint(1, 3)
        functions = [generate_func_decl(recursion_depth + 1) for _ in range(num_functions)]

    statement = generate_statement(recursion_depth + 1)

    block_parts = []
    if consts:
        block_parts.append(consts)
    if vars:
        block_parts.append(vars)
    block_parts.extend(procedures)
    block_parts.extend(functions)
    block_parts.append(statement)

    block = "\n".join(block_parts)
    return block

def generate_procedure(recursion_depth=0):
    print("generating procedure...", recursion_depth)
    ident = generate_ident()
    block = generate_block(recursion_depth + 1)
    return "procedure " + ident + ";\n" + "\n".join("    " + line for line in block.split("\n")) + ";\n"

def generate_func_call(recursion_depth=0):
    print("generating function call...", recursion_depth)
    identifier = generate_ident()
    return identifier + "()"

def generate_func_decl(recursion_depth=0):
    print("generating function...", recursion_depth)
    identifier = generate_ident()
    params = generate_param_list(recursion_depth + 1)
    block = generate_block(recursion_depth + 1)
    print(f"function {identifier}({params}) {{ {block} }}")
    return f"function {identifier}({params}) ;\n{"\n".join("    " + line for line in block.split("\n"))} ;\n"

def generate_param_list(recursion_depth=0):
    print("generating paramlist...", recursion_depth)
    num_params = random.randint(1, 3)  # Generate up to 3 parameters
    params = [generate_ident() for _ in range(num_params)]
    params = "var " + ", var ".join(params)
    return params


def generate_statement(recursion_depth=0):
    print("generating statement...", recursion_depth)
    if recursion_depth > MAX_RECURSION_DEPTH/100 + 2:
        return generate_simple_statement(recursion_depth + 1)
    
    statement_types = ["assignment", "call", "compound", "conditional", "conditional2", "loop", "loop2", "break", "return", "read", "write", "writeline"]
    statement_type = random.choice(statement_types)
    
    if statement_type == "assignment":
        ident = generate_ident()
        expression = generate_expression(recursion_depth + 1)
        return ident + " := " + expression
    elif statement_type == "call":
        ident = generate_ident()
        return "call " + ident
    elif statement_type == "compound":
        num_statements = random.randint(1, 5)
        statements = [generate_statement(recursion_depth + 1) for _ in range(num_statements)]
        return "begin " + ";\n".join(statements) + " end"
    elif statement_type == "conditional":
        condition = generate_condition(recursion_depth + 1)
        statement = generate_statement(recursion_depth)
        return "if " + condition + " then " + "\n" + statement
    elif statement_type == "conditional2":
        condition = generate_condition(recursion_depth + 1)
        statement_then = generate_statement(recursion_depth + 1)
        statement_else = generate_statement(recursion_depth + 1)
        return "if " + condition + " then " + statement_then + " else " + statement_else

    elif statement_type == "loop":
        condition = generate_condition(recursion_depth + 1)
        statement = generate_statement(recursion_depth + 1)
        return "while " + condition + " do " + "\n" + statement

    elif statement_type == "loop2":
        ident = generate_ident()
        expression = generate_expression(recursion_depth + 1)
        expression2 = generate_expression(recursion_depth + 1)
        statement = generate_statement(recursion_depth + 1)
        return "for " + ident + ":=" + expression + " to " + expression2 + " do " + "\n" + statement

    elif statement_type == "break":
        return "break"

    elif statement_type == "return":
        expression = generate_expression(recursion_depth + 1)
        return "return " + expression

    elif statement_type == "read":
        statement = generate_read_stmt(recursion_depth + 1)
        return statement

    elif statement_type == "write":
        statement = generate_write_stmt(recursion_depth + 1)
        return statement

    elif statement_type == "writeline":
        statement = generate_writeline_stmt(recursion_depth + 1)
        return statement

def generate_condition(recursion_depth=0):
    print("generating condition...", recursion_depth)
    if random.random() < 0.5:
        print("generated odd condition.")
        return "odd " + generate_expression(recursion_depth + 1)
    else:
        expr1 = generate_expression(recursion_depth + 1)
        ops = ["=", "<", "<=", ">", ">="]
        op = random.choice(ops)
        expr2 = generate_expression(recursion_depth + 1)
        print("generated condition expr operation")
        return expr1 + " " + op + " " + expr2

def generate_expression(recursion_depth=0):
    print("generating expression...", recursion_depth)
    if recursion_depth > MAX_RECURSION_DEPTH/100 + 2:
        return generate_term(recursion_depth + 1)
    
    term = generate_term(recursion_depth + 1)
    if random.random() < 0.5:
        print("generated expression: term")
        return term
    else:
        ops = ["+", "-"]
        op = random.choice(ops)
        expr = term + " " + op + " " + generate_expression(recursion_depth + 10)
        print("generated expression.")
        return expr



def generate_term(recursion_depth=0):
    print("generating term...", recursion_depth)
    if recursion_depth > MAX_RECURSION_DEPTH / 10:
        print("generated term: factor.")
        return generate_factor(recursion_depth + 1)
    
    factor = generate_factor(recursion_depth + 1)
    if random.random() < 0.29:
        print("generated term: factor.")
        return factor
    elif random.random() < 0.29:
        ops = ["*", "/", "%"]
        op = random.choice(ops)
        term = factor + " " + op + " " + generate_term(recursion_depth + 1)
        print("generated term: muldiv.")
        return term
    else:
        print("generated term: function call.")
        return generate_func_call(recursion_depth + 1)



def generate_factor(recursion_depth=0):
    print("generating factor...", recursion_depth)
    factor_types = ["ident", "number", "expression", "array"]
    factor_type = random.choice(factor_types)
    
    if factor_type == "ident":
        print("generated factor: ident")
        return generate_ident()
    elif factor_type == "number":
        print("generated factor: number")
        return generate_number()
    elif factor_type == "array":
        identifier = generate_ident()
        expression = generate_expression(recursion_depth + 1)
        print("generated factor: array access")
        return identifier + "[" + expression + "]"
    else:
        expression = generate_expression(recursion_depth + 1)
        print("generated factor: expression")
        return "(" + expression + ")"

def generate_read_stmt(recursion_depth=0):
    print("generating read...", recursion_depth)
    identifier = generate_ident()
    print("generated read.")
    return f"read({identifier})"

def generate_write_stmt(recursion_depth=0):
    print("generating write...", recursion_depth)
    identifier = generate_ident()
    print("generated write.")
    return f"write({identifier})"

def generate_writeline_stmt(recursion_depth=0):
    print("generating writeline...", recursion_depth)
    identifier = generate_ident()
    print("generated writeline.")
    return f"writeline({identifier})"


def generate_simple_statement(recursion_depth=0):
    print("generating simple statement...", recursion_depth)
    ident = generate_ident()
    number = generate_number()
    print("generated simple statement.")
    return f"{ident} := {number}"

def generate_comment(recursion_depth=0):
    print("generating comment...", recursion_depth)
    print("generated comment.")
    return "/* This is a comment */"

def introduce_errors(program):
    characters = ['!', '?', '#']
    error_frequency = 0.05  # 5% chance of introducing an error at each token or newline

    # Split the program on spaces and newlines to preserve the structure
    tokens = []
    for line in program.split('\n'):
        for token in line.split():
            tokens.append(token)
        tokens.append('\n')  # Add newline as a separate token

    new_tokens = []
    for token in tokens:
        if token == '\n':
            new_tokens.append(token)  # Preserve newlines as they are
        else:
            # Randomly decide to add an error
            if random.random() < error_frequency:
                if random.random() < 0.5:
                    # Add random character in token
                    pos = random.randint(0, len(token))
                    token = token[:pos] + random.choice(characters) + token[pos:]
                else:
                    # Add extra whitespace
                    token = token + ' ' * random.randint(1, 3)
            new_tokens.append(token)
    
    # Randomly insert extra spaces between tokens, except for newlines
    modified_program = ''
    for token in new_tokens:
        if token == '\n':
            modified_program += token
        else:
            modified_program += token + ' ' * random.randint(0, 3)
    
    return modified_program

def generate_programs(num, prefix, corrupt = False):
    program = ""
    for i in range(0, num):
        program = generate_program()

        if corrupt:
            program = introduce_errors(program)

        # save the program to destination folder
        with open(f"./examples/generated/extended_corrupt/{prefix}_{i}.txt", "w") as f:
            f.write(program)

generate_programs(100, "extended_corrupt", True)