class Assembler:
    def __init__(self):
        # Definir un diccionario de instrucciones y sus correspondientes códigos de operación
        self.instructions = {
            'ADD': 0b000000,
            'SUB': 0b000001,
            'LW': 0b000010,
            'SW': 0b000011,
            'JUMP': 0b000100,
            'BEQ': 0b000101  # Añadido BEQ
        }

    def assemble(self, instruction):
        """
        Convierte una instrucción en ensamblador a su formato binario correspondiente.
        :param instruction: Instrucción en formato de texto.
        :return: Código binario de la instrucción.
        """
        parts = instruction.split()
        opcode = self.instructions.get(parts[0], None)

        if opcode is None:
            raise ValueError(f"Instrucción desconocida: {parts[0]}")

        # Eliminar comas u otros caracteres no numéricos
        def clean_register(reg):
            return reg.strip('x,')  # Elimina "x" y "," del registro

        if parts[0] in ['ADD', 'SUB']:
            reg1 = int(clean_register(parts[1]))
            reg2 = int(clean_register(parts[2]))
            reg3 = int(clean_register(parts[3]))
            return f"{opcode:06b} {reg1:05b} {reg2:05b} {reg3:05b}"

        if parts[0] in ['LW', 'SW']:
            reg1 = int(clean_register(parts[1]))
            offset_base = parts[2].split('(')
            offset = int(offset_base[0])
            base = int(offset_base[1][1:-1])  # Eliminar el paréntesis final
            return f"{opcode:06b} {reg1:05b} {base:05b} {offset:012b}"

        if parts[0] == 'JUMP':
            offset = int(parts[1])
            return f"{opcode:06b} {offset:026b}"

        if parts[0] == 'BEQ':
            reg1 = int(clean_register(parts[1]))
            reg2 = int(clean_register(parts[2]))
            offset = int(parts[3])
            return f"{opcode:06b} {reg1:05b} {reg2:05b} {offset:016b}"

    def disassemble(self, binary):
        """
        Convierte un código binario de vuelta a su instrucción en ensamblador.
        :param binary: Código binario de la instrucción.
        :return: Instrucción en ensamblador.
        """
        opcode = int(binary[:6], 2)
        if opcode == self.instructions['ADD']:
            return f"ADD x{int(binary[6:11], 2)}, x{int(binary[11:16], 2)}, x{int(binary[16:21], 2)}"
        elif opcode == self.instructions['SUB']:
            return f"SUB x{int(binary[6:11], 2)}, x{int(binary[11:16], 2)}, x{int(binary[16:21], 2)}"
        elif opcode == self.instructions['LW']:
            return f"LW x{int(binary[6:11], 2)}, {int(binary[21:], 2)}(x{int(binary[11:16], 2)})"
        elif opcode == self.instructions['SW']:
            return f"SW x{int(binary[6:11], 2)}, {int(binary[21:], 2)}(x{int(binary[11:16], 2)})"
        elif opcode == self.instructions['JUMP']:
            return f"JUMP {int(binary[6:], 2)}"
        elif opcode == self.instructions['BEQ']:
            return f"BEQ x{int(binary[6:11], 2)}, x{int(binary[11:16], 2)}, {int(binary[21:], 2)}"
        else:
            raise ValueError("Instrucción binaria desconocida")
