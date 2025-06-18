import time
import random

# Definición de las etapas del pipeline
IF = "Fetch Instruction"
ID = "Decode Instruction"
EX = "Execute Instruction"
MEM = "Memory Access"
WB = "Write Back"

# Simulación de registros y memoria
registers = [0] * 32  # 32 registros de propósito general
memory = [0] * 256  # Memoria simulada de 256 celdas

# Definición de las instrucciones (Ejemplo: ADD, SUB, LOAD, STORE)
instructions = {
    'ADD': 0,  # Operación de suma
    'SUB': 1,  # Operación de resta
    'LOAD': 2,  # Carga desde memoria
    'STORE': 3,  # Almacenamiento a memoria
    'JUMP': 4,  # Instrucción de salto
}

# Ciclo de ejecución del procesador
def execute_cycle(instruction, registers, memory):
    print(f"Executing: {instruction}")
    # Ejemplo de operaciones de instrucciones simples
    if instruction == 'ADD':
        registers[0] = registers[1] + registers[2]
    elif instruction == 'SUB':
        registers[0] = registers[1] - registers[2]
    elif instruction == 'LOAD':
        registers[0] = memory[registers[1]]
    elif instruction == 'STORE':
        memory[registers[1]] = registers[0]
    elif instruction == 'JUMP':
        print("Jumping to another instruction (not implemented in this step)")

# Función de simulación del ciclo de ejecución
def simulation_mode():
    cycle_count = 0
    while cycle_count < 10:  # 10 ciclos para demostrar
        print(f"Ciclo {cycle_count + 1}:")
        instruction = random.choice(list(instructions.keys()))  # Elegir una instrucción aleatoria
        execute_cycle(instruction, registers, memory)
        print(f"Registros: {registers}\nMemoria: {memory}\n")
        cycle_count += 1
        time.sleep(1)  # Retardo de 1 segundo por ciclo para simular tiempo

# Modo de ejecución step-by-step
def step_by_step_mode():
    while True:
        user_input = input("Ingrese la instrucción a ejecutar (ADD, SUB, LOAD, STORE, JUMP): ").upper()
        if user_input in instructions:
            execute_cycle(user_input, registers, memory)
            print(f"Registros: {registers}\nMemoria: {memory}\n")
        else:
            print("Instrucción no válida.")
        cont = input("¿Desea ejecutar otra instrucción? (s/n): ").lower()
        if cont != 's':
            break

# Función principal que define el flujo del programa
def main():
    print("Bienvenido a la simulación del procesador")
    mode = input("Seleccione el modo de ejecución (1: Simulación, 2: Paso a paso): ")
    if mode == '1':
        simulation_mode()
    elif mode == '2':
        step_by_step_mode()
    else:
        print("Opción no válida.")

if __name__ == "__main__":
    main()
