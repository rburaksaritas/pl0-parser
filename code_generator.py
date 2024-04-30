import random
import string

MAX_RECURSION_DEPTH = 10  # Set the maximum recursion depth

def generate_ident():
    return ''.join(random.choices(string.ascii_letters, k=random.randint(1, 10)))

def generate_number():
    return str(random.randint(0, 100))

def generate_program(recursion_depth=0):
    if recursion_depth > MAX_RECURSION_DEPTH:
        return "var x; x := 1."  # Base case: return a valid baseline
    
    block = generate_block(recursion_depth + 1)
    return block + "."

def generate_block(recursion_depth=0):
    consts = []
    if random.random() < 0.5:
        num_consts = random.randint(1, 5)
        consts = [generate_ident() + " = " + generate_number() for _ in range(num_consts)]
        consts = "const " + ", ".join(consts) + ";\n"

    vars = []
    if random.random() < 0.5:
        num_vars = random.randint(1, 5)
        vars = [generate_ident() for _ in range(num_vars)]
        vars = "var " + ", ".join(vars) + ";\n"

    procedures = []
    if recursion_depth < MAX_RECURSION_DEPTH and random.random() < 0.5:
        num_procedures = random.randint(1, 3)
        procedures = [generate_procedure(recursion_depth + 1) for _ in range(num_procedures)]

    statement = generate_statement(recursion_depth + 1)

    block_parts = []
    if consts:
        block_parts.append(consts)
    if vars:
        block_parts.append(vars)
    block_parts.extend(procedures)
    block_parts.append(statement)

    block = "\n".join(block_parts)
    return block

def generate_procedure(recursion_depth=0):
    ident = generate_ident()
    block = generate_block(recursion_depth + 1)
    return "procedure " + ident + ";\n" + block + ";\n"

def generate_statement(recursion_depth=0):
    if recursion_depth > MAX_RECURSION_DEPTH:
        return generate_simple_statement()
    
    statement_types = ["assignment", "call", "compound", "conditional", "loop"]
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
        statement = generate_statement(recursion_depth + 1)
        return "if " + condition + " then " + "\n" + statement
    elif statement_type == "loop":
        condition = generate_condition(recursion_depth + 1)
        statement = generate_statement(recursion_depth + 1)
        return "while " + condition + " do " + "\n" + statement

def generate_condition(recursion_depth=0):
    if random.random() < 0.5:
        return "odd " + generate_expression(recursion_depth + 1)
    else:
        expr1 = generate_expression(recursion_depth + 1)
        ops = ["=", "<", "<=", ">", ">="]
        op = random.choice(ops)
        expr2 = generate_expression(recursion_depth + 1)
        return expr1 + " " + op + " " + expr2

def generate_expression(recursion_depth=0):
    if recursion_depth > MAX_RECURSION_DEPTH:
        return generate_term(recursion_depth + 1)
    
    term = generate_term(recursion_depth + 1)
    if random.random() < 0.5:
        return term
    else:
        ops = ["+", "-"]
        op = random.choice(ops)
        expr = term + " " + op + " " + generate_expression(recursion_depth + 1)
        return expr

def generate_term(recursion_depth=0):
    if recursion_depth > MAX_RECURSION_DEPTH:
        return generate_factor(recursion_depth + 1)
    
    factor = generate_factor(recursion_depth + 1)
    if random.random() < 0.5:
        return factor
    else:
        ops = ["*", "/"]
        op = random.choice(ops)
        term = factor + " " + op + " " + generate_term(recursion_depth + 1)
        return term

def generate_factor(recursion_depth=0):
    factor_types = ["ident", "number", "expression"]
    factor_type = random.choice(factor_types)
    
    if factor_type == "ident":
        return generate_ident()
    elif factor_type == "number":
        return generate_number()
    else:
        expression = generate_expression(recursion_depth + 1)
        return "(" + expression + ")"

def generate_simple_statement():
    ident = generate_ident()
    number = generate_number()
    return f"{ident} := {number}"

def introduce_errors(program):
    characters = ['!', '?', '#']
    error_frequency = 0.02  # 5% chance of introducing an error at each token or newline

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
    for i in range(num):
        program = generate_program()

        if corrupt:
            program = introduce_errors(program)

        # save the program to destination folder
        with open(f"./examples/generated/corrupt/{prefix}_{i}.txt", "w") as f:
            f.write(program)

generate_programs(100, "corrupt", True)