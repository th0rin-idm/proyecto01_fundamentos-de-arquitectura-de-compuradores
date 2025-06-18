class Memory:
    def __init__(self, size=1024):
        """
        Inicializa la memoria del procesador con el tamaño especificado
        :param size: Tamaño de la memoria en palabras (por defecto 1024)
        """
        self.memory = [0] * size

    def load(self, address):
        """
        Carga un valor de la memoria en una dirección específica.
        :param address: Dirección de memoria
        :return: Valor almacenado en la dirección de memoria
        """
        return self.memory[address]

    def store(self, address, value):
        """
        Almacena un valor en una dirección específica de la memoria.
        :param address: Dirección de memoria
        :param value: Valor a almacenar
        """
        self.memory[address] = value
