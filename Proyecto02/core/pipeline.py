from core.pipeline_ade import DataForwarding
from core.pipeline_pred_ade import ForwardingPrediction
from core.registers import Registers
from core.memory import Memory

class Pipeline:
    def __init__(self):
        # Inicialización de las etapas del pipeline
        self.fetch_decode = None
        self.decode_execute = None
        self.execute_memory = None
        self.memory_writeback = None

        # Etapas de memoria y registros
        self.ex_mem = {}  # Inicializa ex_mem como un diccionario vacío
        self.mem_wb = {}  # Inicializa mem_wb como un diccionario vacío

        # El contador de programa y el ciclo actual
        self.pc = 0
        self.cycle_count = 0
        self.registers = Registers()  # Usamos la clase Registers para manejar los registros
        self.memory = Memory()  # Usamos la clase Memory para manejar la memoria

        # Inicializamos los módulos de adelanto de datos y predicción de saltos
        self.data_forwarding = DataForwarding()  # Ahora se inicializa correctamente
        self.forwarding_prediction = ForwardingPrediction()  # Añadir la predicción si es necesario

    def execute_stage(self):
        """
        Ejecuta una iteración del ciclo del pipeline:
        - Fetch
        - Decode
        - Execute
        - Memory Access
        - Writeback
        """
        if not self.stall:
            self.fetch()
            self.decode()
            self.execute()
            self.memory_access()
            self.writeback()
        else:
            print("Stall detected! Waiting for data...")

    def fetch(self):
        # Simulación de la etapa IF: Buscar la instrucción
        print(f"Fetching instruction at PC: {self.pc}")
        # Convertimos la instrucción cargada en la memoria a su formato binario (como cadena de 32 bits)
        instruction = self.memory.load(self.pc)
        # Convertir el número de la instrucción a binario, rellenado con ceros a la izquierda para asegurarse de que tenga 32 bits
        self.fetch_decode = f"{instruction:032b}"
        self.pc += 4  # Avanzar el contador de programa (suponiendo instrucciones de 4 bytes)

    def decode(self):
        # Simulación de la etapa ID: Decodificar la instrucción
        print(f"Decoding instruction: {self.fetch_decode}")
        # Aquí decodificamos la instrucción y extraemos los registros y operación
        self.decode_execute = {
            'opcode': self.fetch_decode[:6],  # Tomamos los primeros 6 bits como ejemplo
            'rs1': self.fetch_decode[6:11],  # Registro fuente 1
            'rs2': self.fetch_decode[11:16],  # Registro fuente 2
            'rd': self.fetch_decode[16:21],  # Registro destino
            'imm': self.fetch_decode[21:],  # Inmediato
        }

        # Detección de riesgos de datos (Data Hazard)
        if self.decode_execute['opcode'] in ['ADD', 'SUB', 'MUL']:
            if self.decode_execute['rs1'] == self.decode_execute['rd'] or self.decode_execute['rs2'] == self.decode_execute['rd']:
                print("Data hazard detected! Inserting stall cycle.")
                self.stall = True
            else:
                self.stall = False

        # Aplicar adelanto de datos si es necesario
        self.decode_execute = self.data_forwarding.apply_forwarding(self.decode_execute, self.registers, self.ex_mem, self.mem_wb)

    def execute(self):
        # Simulación de la etapa EX: Ejecutar la instrucción
        print(f"Executing instruction: {self.decode_execute}")
        opcode = self.decode_execute['opcode']

        if opcode == 'ADD':
            result = self.registers.read(self.decode_execute['rs1']) + self.registers.read(self.decode_execute['rs2'])
        elif opcode == 'SUB':
            result = self.registers.read(self.decode_execute['rs1']) - self.registers.read(self.decode_execute['rs2'])
        elif opcode == 'LW':
            address = self.registers.read(self.decode_execute['rs1']) + self.decode_execute['imm']
            result = self.memory.load(address)
        elif opcode == 'SW':
            address = self.registers.read(self.decode_execute['rs1']) + self.decode_execute['imm']
            self.memory.store(address, self.registers.read(self.decode_execute['rs2']))
            result = None
        elif opcode == 'JUMP':
            if self.branch_prediction:
                self.pc = self.decode_execute['imm']
            result = None
        else:
            result = None

        self.execute_memory = result
        
        # Asegurarnos de que ex_mem tenga los valores esperados
        self.ex_mem = {
            'rd': self.decode_execute['rd'],  # Asignar el valor de 'rd' a ex_mem
            'alu_result': result,  # Almacenamos el resultado de la ejecución
            'opcode': self.decode_execute['opcode'],
            'rs1': self.decode_execute['rs1'],
            'rs2': self.decode_execute['rs2'],
            'imm': self.decode_execute['imm']
        }

        # Pasar a la siguiente etapa, si es necesario
        print(f"ex_mem: {self.ex_mem}")



    def memory_access(self):
        # Simulación de la etapa MEM: Acceder a memoria si es necesario
        print(f"Memory access: {self.execute_memory}")
        if self.decode_execute['opcode'] == 'LW':
            address = self.registers.read(self.decode_execute['rs1']) + self.decode_execute['imm']
            self.execute_memory = self.memory.load(address)
        elif self.decode_execute['opcode'] == 'SW':
            address = self.registers.read(self.decode_execute['rs1']) + self.decode_execute['imm']
            self.memory.store(address, self.execute_memory)

    def writeback(self):
        # Simulación de la etapa WB: Escribir el resultado en los registros
        print(f"Writeback: {self.execute_memory}")
        if self.execute_memory is not None:
            self.registers.write(self.decode_execute['rd'], self.execute_memory)
        self.mem_wb = self.decode_execute  # Asignamos el resultado de la escritura a mem_wb

