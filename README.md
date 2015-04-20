Organizacion del Computador 2
=========
Mirar esto...
Comandos para Git frecuentemente usados:

1. Clonar el repositorio `git clone https://github.com/soviet47/Orga2`
2. Ver estado de los archivos `git status`
3. Agregar nuevos archivos/cambios `git add (nombre de archivo)` (alternativamente se puede escribir * para agregar todo)
4. Aceptar nuevos cambios `git commit -m "mensaje del commit"` (por favor poner cosas con sentido en el mensaje, i.e: "arreglados bugs de tal y tal cosa")
5. Subir cambios `git push origin master`

Los pasos 3 y 4 se pueden hacer en uno solo: `git commit -am "mensaje del commit"` (cuidado que agrega todos los archivos!)

Para mas informacion y comandos se puede encontrar en https://www.atlassian.com/es/git/tutorial, o si se sienten mas cancheros escriban 'git --help'


=========

###Links de interes

http://en.wikipedia.org/wiki/X86

http://en.wikipedia.org/wiki/X86_instruction_listings

###Registros y funciones

* AL/AH/AX/EAX/RAX: Accumulator
* BL/BH/BX/EBX/RBX: Base index (for use with arrays)
* CL/CH/CX/ECX/RCX: Counter (for use with loops and strings)
* DL/DH/DX/EDX/RDX: Extend the precision of the accumulator (e.g. combine 32-bit EAX  and EDX for 64-bit integer operations in 32-bit code)
* SI/ESI/RSI: Source index for string operations.
* DI/EDI/RDI: Destination index for string operations.
* SP/ESP/RSP: Stack pointer for top address of the stack.
* BP/EBP/RBP: Stack base pointer for holding the address of the current stack frame.
* IP/EIP/RIP: Instruction pointer. Holds the program counter, the current instruction  address.
* R8-R12/D/W/B

######Segment registers:

* CS: Code
* DS: Data
* SS: Stack
* ES: Extra data
* FS: Extra data #2
* GS: Extra data #3
