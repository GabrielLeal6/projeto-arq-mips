# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente a funções gerais que serão usadas no projeto

.data
	.eqv DESVIO_CONTA 76

.text
encontrarConta:
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
	li $t3, SIZE_CLIENTE 
	mul $t3, $t0, $t3
	add $t3, $t2, $t3 # Armazena o endereço base en $t3
	
	# Preparação para a comparação de strings
	move $a0, $s0 # string de input
	
	add $a1, $t3, DESVIO_CONTA # Endereço do cliente + desvio
	
	jal strcmp
	
	# Reação ao resultado
	beq $v0, 1, encontrado
	
	# Sequência no loop
	addi $t0, $t0, 1
	j encontrarLoop

encontrado:
	move $v0, $t3 # Mover o resultado para o registrador de retorno
	j terminar
	
naoEncontrado:
	li $v0, 0 # Retorna 0 (NULL) 
	
terminar:
	# Restaura registradores
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra # Retorno