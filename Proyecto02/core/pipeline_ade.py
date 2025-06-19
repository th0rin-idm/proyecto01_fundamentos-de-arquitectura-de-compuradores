class DataForwarding:
    def __init__(self):
        # Inicializamos las variables que controlan el adelanto de datos
        self.forwarding_enabled = True  # Habilitar o deshabilitar el adelanto de datos

    def apply_forwarding(self, instruction, registers, ex_mem, mem_wb):
        """
        Aplica el adelanto de datos si es necesario.
        :param instruction: Instrucción que está siendo ejecutada
        :param registers: Registros del procesador
        :param ex_mem: Registro EX/MEM con los datos de la etapa anterior
        :param mem_wb: Registro MEM/WB con los datos de la etapa de writeback
        :return: Valor de registro actualizado (si es necesario)
        """
        if ex_mem and instruction['rs1'] == ex_mem['rd']:
            instruction['rs1'] = ex_mem['alu_result']
        if ex_mem and instruction['rs2'] == ex_mem['rd']:
            instruction['rs2'] = ex_mem['alu_result']
        if mem_wb and instruction['rs1'] == mem_wb['rd']:
            instruction['rs1'] = mem_wb['alu_result']
        if mem_wb and instruction['rs2'] == mem_wb['rd']:
            instruction['rs2'] = mem_wb['alu_result']
        return instruction
