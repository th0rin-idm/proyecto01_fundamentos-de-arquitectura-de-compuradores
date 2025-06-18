class Registers:
    def __init__(self):
        """
        Inicializa los 32 registros del procesador (con valores por defecto de 0).
        """
        self.registers = [0] * 32

    def read(self, reg_num):
        """
        Lee el valor de un registro específico.
        :param reg_num: Número de registro (0-31)
        :return: Valor almacenado en el registro
        """
        return self.registers[reg_num]

    def write(self, reg_num, value):
        """
        Escribe un valor en un registro específico.
        :param reg_num: Número de registro (0-31)
        :param value: Valor a almacenar en el registro
        """
        self.registers[reg_num] = value
