class ExecutionStats:
    def __init__(self):
        self.stats = []

    def add_stat(self, cycles, instructions, cpi, time):
        """
        Añade una nueva entrada de estadísticas a la lista.
        :param cycles: Número de ciclos
        :param instructions: Número de instrucciones ejecutadas
        :param cpi: Ciclos por instrucción
        :param time: Tiempo de ejecución en nanosegundos
        """
        self.stats.append({
            'cycles': cycles,
            'instructions': instructions,
            'cpi': cpi,
            'time': time
        })

    def get_stats(self):
        """
        Devuelve las estadísticas acumuladas.
        :return: Lista de estadísticas
        """
        return self.stats
