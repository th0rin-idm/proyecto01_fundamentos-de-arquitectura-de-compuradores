class Pipeline:
    def __init__(self):
        # Inicializando las etapas del pipeline
        self.fetch_decode = None
        self.decode_execute = None
        self.execute_memory = None
        self.memory_writeback = None

        # El contador de programa y el ciclo actual
        self.pc = 0
        self.cycle_count = 0

    def execute_stage(self):
        """
        Ejecuta una iteración del ciclo del pipeline:
        - Fetch
        - Decode
        - Execute
        - Memory Access
        - Writeback
        """
        self.fetch()
        self.decode()
        self.execute()
        self.memory_access()
        self.writeback()

    def fetch(self):
        # Simulación de la etapa IF: Buscar la instrucción
        print(f"Fetching instruction at PC: {self.pc}")
        # Aquí agregaríamos la lógica de obtener la instrucción de memoria

    def decode(self):
        # Simulación de la etapa ID: Decodificar la instrucción
        print(f"Decoding instruction at PC: {self.pc}")
        # Lógica para decodificar la instrucción

    def execute(self):
        # Simulación de la etapa EX: Ejecutar la instrucción
        print(f"Executing instruction at PC: {self.pc}")
        # Lógica de ejecución de la instrucción

    def memory_access(self):
        # Simulación de la etapa MEM: Acceder a memoria si es necesario
        print(f"Memory access at PC: {self.pc}")
        # Acceso a la memoria si se trata de una instrucción LOAD o STORE

    def writeback(self):
        # Simulación de la etapa WB: Escribir el resultado en los registros
        print(f"Writeback at PC: {self.pc}")
        # Escribir resultados en los registros si es necesario
