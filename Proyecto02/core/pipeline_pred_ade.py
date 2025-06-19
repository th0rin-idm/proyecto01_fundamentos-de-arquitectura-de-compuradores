class ForwardingPrediction:
    def __init__(self):
        # Aquí se puede agregar la lógica de predicción para el adelanto de datos
        self.prediction = True  # Si habilitamos la predicción, asumimos que el adelanto se aplicará

    def predict_forwarding(self, instruction, ex_mem, mem_wb):
        """
        Predice si el adelanto de datos debe aplicarse en una instrucción.
        :param instruction: Instrucción que está siendo ejecutada
        :param ex_mem: Registro EX/MEM con los datos de la etapa anterior
        :param mem_wb: Registro MEM/WB con los datos de la etapa de writeback
        :return: Verdadero si se debe adelantar el dato, falso de lo contrario
        """
        # Lógica de predicción de adelanto de datos
        if instruction['rs1'] == ex_mem['rd'] or instruction['rs1'] == mem_wb['rd']:
            return True
        if instruction['rs2'] == ex_mem['rd'] or instruction['rs2'] == mem_wb['rd']:
            return True
        return False
