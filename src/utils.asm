# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente a funções gerais que serão usadas no projeto

.include "Q1_strings.asm"
.include "io_utils.asm"
.include "banco_dados.asm"

.data
	msgEncontrado:	  .asciiz "Cliente encontrado"
	msgNaoEncontrado: .asciiz "Não foi encontrado um cliente com este número de conta."

.text

.globl encontrarCliente
encontrarCliente:
	#Registradores
	addi $sp, $sp, -8
	sw $ra, 0($sp) # Endereço de retorno
	sw $s0, 4($sp) # Usado para salvar $a0
	
	move $a0, $a0 # endereço da string da conta
	
	li $t0, 0 # Índice para o loop
	lw $t1, contador_clientes # $t1 = limite de clientes
	la $t2, banco_clientes # $t2 = endereço do banco
	
encontrarLoop:
	bge $t0, $t1, naoEncontrado # Condição de parada do sistema
	
	# Calcula o endereço em que o cliente está armazenado
	li $t3, 6505 
	mul $t3, $t0, $t3
	add $t3, $t2, $t3 # Armazena o endereço base en $t3
	
	# Preparação para a comparação de strings
	move $a0, $s0 # string de input
	
	add $a1, $t3, 76 # Endereço do cliente + desvio
	
	jal strcmp
	
	# Reação ao resultado
	beq $v0, 1, encontrado
	
	# Dá sequência ao loop
	addi $t0, $t0, 1
	j encontrarLoop

encontrado:
	move $v0, $t3 # Mover o resultado para o registrador de retorno
	la $a2, msgEncontrado
	jal print_string_mmio
	j encontrarTerminar
	
naoEncontrado:
	la $a2, msgNaoEncontrado
	jal print_string_mmio
	li $v0, 0 # Retorna 0 (NULL) 
	
encontrarTerminar:
	# Restaura registradores
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra # Retorno

.globl stringParaInteiro
stringParaInteiro:
	li $v0, 0           # $v0 = resultado = 0
   	li $t1, 10          # $t1 = 10 (para multiplicação)

conversorLoop:
	lb $t0, 0($a0)
	
	blt $t0, '0', conversorTerminar
	bgt $t0, '9', conversorTerminar
	
	subi $t0, $t0, 48
	
	mul $v0, $v0, $t1
	add $v0, $v0, $t0
	
	addi $a0, $a0, 1
	j conversorLoop

conversorTerminar:
	jr $ra