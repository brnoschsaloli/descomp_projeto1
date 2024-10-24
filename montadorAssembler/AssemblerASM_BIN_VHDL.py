# -*- coding: utf-8 -*-
"""
- Criado em 07/Fevereiro/2022
- Atualizado em [Data Atual]

@autor: Marco Mello e Paulo Santos

Modificações:
- Ajustado para aceitar instruções com registradores no formato 'MNEMONIC ADDRESS, REGISTER'
- Ajustado para incluir os bits do registrador como os 2 bits mais significativos da codificação da instrução
- Ajustado para endereços de 9 bits
- Ajustado o formato da saída para corresponder ao formato solicitado
- Corrigido o tratamento de labels como operandos em instruções
- Corrigido o parsing no arquivo .mif para evitar erros de conversão
"""

inputASM = 'ASM.txt'     # Arquivo de entrada que contém o assembly
outputBIN = 'BIN.txt'    # Arquivo de saída que contém o binário formatado para VHDL
outputMIF = 'initROM.mif' # Arquivo de saída que contém o binário formatado para .mif

noveBits = True

# Definição dos mnemônicos e seus respectivos OPCODEs (em Hexadecimal)
mne = { 
        "NOP":  "0",
        "LDA":  "1",
        "ADD":  "2",
        "SUB":  "3",
        "LDI":  "4",
        "STA":  "5",
        "JMP":  "6",
        "JEQ":  "7",
        "CEQ":  "8",
        "JSR":  "9",
        "RET":  "A",
        "AND":  "B",
        "ANDi": "C",
        "CEQi": "D",
        "ADDi": "E",
        "SUBi": "F"
    }

# Lista de instruções que envolvem registradores
instructions_with_registers = ["LDI", "LDA", "STA", "ADD", "ADDi", "SUB", "SUBi", "AND", "ANDi", "CEQ", "CEQi"]

def defineComentario(line):
    if '#' in line:
        line = line.split('#')
        line = line[0].strip() + "\t#" + line[1]
        return line
    else:
        return line.strip()

def defineInstrucao(line):
    line = line.split('#')
    line = line[0].strip()
    return line

def trataMnemonico(mnemonic):
    return mne.get(mnemonic, None)

def identificarLabels(lines):
    labels = {}
    cont = 0
    for line in lines:
        line = line.strip()
        if line.endswith(':'):
            label = line[:-1]
            labels[label] = cont
        elif line != '':
            cont += 1
    return labels

def substituirLabels(lines, labels):
    novaLista = []
    for line in lines:
        line_original = line.strip()
        if line_original.endswith(':'):
            continue
        novaLista.append(line)
    return novaLista

def parseInstructionWithRegister(line, labels):
    line = line.strip()
    # Remove multiple spaces
    line = ' '.join(line.split())
    # Split on comma
    if ',' in line:
        parts = line.split(',')
        if len(parts) != 2:
            raise ValueError("Invalid instruction format: {}".format(line))
        left_part = parts[0].strip()
        right_part = parts[1].strip()
        # Split left part into mnemonic and address
        tokens = left_part.split()
        if len(tokens) != 2:
            raise ValueError("Invalid instruction format: {}".format(line))
        mnemonic = tokens[0]
        address = tokens[1]
        # Extract register number
        register = right_part
        if register[0] != 'R' and not register[0].isdigit():
            raise ValueError("Invalid register: {}".format(register))
        if register.startswith('R'):
            register_number = int(register[1:])
        else:
            register_number = int(register)
        if register_number < 0 or register_number > 3:
            raise ValueError("Invalid register number (should be 0-3): {}".format(register_number))
        # Resolve address (could be a label)
        if address in labels:
            address_value = labels[address]
        else:
            try:
                address_value = int(address)
            except ValueError:
                raise ValueError(f"Invalid address '{address}' in instruction '{line}'")
        if address_value < 0 or address_value > 511:
            raise ValueError("Address out of range (0-511): {}".format(address_value))
        return mnemonic, address_value, register_number
    else:
        raise ValueError("Invalid instruction format (missing comma): {}".format(line))

def parseInstructionWithoutRegister(line, labels):
    tokens = line.strip().split()
    if len(tokens) == 1:
        # Instructions like NOP or RET
        mnemonic = tokens[0]
        return mnemonic, None
    elif len(tokens) == 2:
        mnemonic = tokens[0]
        operand = tokens[1]
        if operand.startswith('@') or operand.startswith('$'):
            value = int(operand[1:])
            return mnemonic, value
        else:
            # Handle labels or addresses without @ or $
            if operand in labels:
                value = labels[operand]
            else:
                try:
                    value = int(operand)
                except ValueError:
                    raise ValueError(f"Invalid operand '{operand}' for instruction '{line}'")
            return mnemonic, value
    else:
        raise ValueError("Invalid instruction format: {}".format(line))

def int_to_bin_str(value, bits):
    return bin(value)[2:].zfill(bits)

with open(inputASM, "r") as f:
    lines = f.readlines()

# Primeira varredura para identificar labels
labels = identificarLabels(lines)

# Segunda varredura para preparar as linhas (remover labels)
lines = substituirLabels(lines, labels)

with open(outputBIN, "w+") as f:
    cont = 0
    for line in lines:
        line = line.strip()
        # Ignora linhas vazias ou comentários
        if not line or line.startswith(';') or line.startswith('#'):
            continue
        comentarioLine = defineComentario(line)
        instrucaoLine = defineInstrucao(line)
        try:
            # Verifica se a instrução é uma label (e pula)
            if instrucaoLine.endswith(':'):
                continue
            # Verifica se a instrução é uma das que envolvem registradores
            mnemonic = instrucaoLine.split()[0]
            if mnemonic in instructions_with_registers:
                # Parse instruction with register
                mnemonic, address_value, register_number = parseInstructionWithRegister(instrucaoLine, labels)
                opcode = int(trataMnemonico(mnemonic), 16)
                # Construir a codificação da instrução
                # Bits:
                # [15:14] - Register bits
                # [13:10] - Opcode (4 bits)
                # [9]     - Bit extra (we'll set to 0 or as needed)
                # [8:0]   - Address (9 bits)
                # We will split the instruction to match the output format
                reg_bits_str = int_to_bin_str(register_number, 2)
                opcode_str = int_to_bin_str(opcode, 4)
                address_bits_str = int_to_bin_str(address_value, 9)
                # If noveBits is True and address is 9 bits, we need to handle bit 9 separately
                bit9 = address_bits_str[0]  # Most significant bit of address
                address_bits_str = address_bits_str[1:]  # Remaining 8 bits of address
                # Now, construct the output string
                line_out = f'tmp({cont}) := "{reg_bits_str}" & x"{int(opcode_str,2):X}" & \'{bit9}\' & x"{int(address_bits_str,2):02X}";\t-- {comentarioLine}\n'
            else:
                # Parse instruction without register
                result = parseInstructionWithoutRegister(instrucaoLine, labels)
                if len(result) == 2:
                    mnemonic, operand = result
                    opcode = int(trataMnemonico(mnemonic), 16)
                    reg_bits_str = "00"  # No register, so set to '00'
                    if operand is not None:
                        address_value = operand
                        address_bits_str = int_to_bin_str(address_value, 9)
                        bit9 = address_bits_str[0]
                        address_bits_str = address_bits_str[1:]
                    else:
                        bit9 = '0'
                        address_bits_str = "00"
                    opcode_str = int_to_bin_str(opcode, 4)
                    # Now, construct the output string
                    line_out = f'tmp({cont}) := "{reg_bits_str}" & x"{int(opcode_str,2):X}" & \'{bit9}\' & x"{int(address_bits_str,2):02X}";\t-- {comentarioLine}\n'
                else:
                    raise ValueError("Invalid instruction format: {}".format(instrucaoLine))
            cont += 1
            f.write(line_out)
            print(line_out, end='')
        except ValueError as e:
            print(f"Erro na linha {cont+1}: {e}")
            continue

# Conversão para arquivo .mif
with open(outputMIF, "r") as f:
    headerMIF = f.readlines()

with open(outputBIN, "r") as f:
    bin_lines = f.readlines()

with open(outputMIF, "w") as f:
    # Escreve o header
    for lineHeader in headerMIF:
        f.write(lineHeader)
    # Escreve as instruções
    for line in bin_lines:
        # Remove caracteres indesejados e formata para o .mif
        line_parts = line.split('--')[0].strip()  # Remove comentário
        # Extract tmp(index) and the assignment
        if ':=' in line_parts:
            index_part, value_part = line_parts.split(':=')
            index = index_part.strip()[4:-1]  # Extract index number
            value_part = value_part.strip(';').strip()  # Remove ';' at the end and extra spaces
            # Now, we need to parse the value_part
            # Expected format: "RegBits" & x"Opcode" & 'Bit9' & x"Address"
            # Remove spaces
            value_part = value_part.replace(' ', '')
            # Extract RegBits
            reg_bits = value_part[1:3]  # Between the first pair of quotes
            # Extract Opcode
            opcode_start = value_part.find('x"') + 2
            opcode_end = value_part.find('"', opcode_start)
            opcode_hex = value_part[opcode_start:opcode_end]
            # Extract Bit9
            bit9_index = value_part.find("'", opcode_end) + 1
            bit9 = value_part[bit9_index]
            # Extract Address
            address_start = value_part.find('x"', bit9_index) + 2
            address_end = value_part.find('"', address_start)
            address_hex = value_part[address_start:address_end]
            # Convert all parts to binary
            reg_bits_bin = reg_bits
            opcode_bin = int_to_bin_str(int(opcode_hex, 16), 4)
            address_bin = int_to_bin_str(int(address_hex, 16), 8)
            # Combine all bits
            full_instruction_bin = reg_bits_bin + opcode_bin + bit9 + address_bin
            # Convert to hex for .mif file
            full_instruction_hex = hex(int(full_instruction_bin, 2))[2:].upper().zfill(4)
            # Write to .mif file
            f.write(f"{index}: {full_instruction_hex};\n")
    f.write("END;")
