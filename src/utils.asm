# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente a funções gerais que serão usadas no projeto

.data
	msgEncontrado:	  .asciiz "Cliente encontrado"
	msgNaoEncontrado: .asciiz "Não foi encontrado um cliente com este número de conta//CPF."

.text
# -----------------------------------------------------------------
# Função: encontrarCliente
# Acha um cliente usando o número da conta.
# Argumento: $a0 = endereço da string com o número da conta
# Retorno:   $v0 = endereço base do cliente, ou 1 se não encontrar
# -----------------------------------------------------------------
.globl encontrarCliente
encontrarCliente:
	# Registradores
	addi $sp, $sp, -8
	sw $ra, 0($sp) 		  # $ra = Endereço de retorno
	sw $s0, 4($sp) 		  # $s0 = Usado para salvar $a0
	
	move $s0, $a0      	  # move endereço do número da conta para $s0
	
	li $t0, 0                 # Índice para o loop
	lw $t1, contador_clientes # $t1 = limite de clientes
	la $t2, banco_clientes    # $t2 = endereço do banco
	
encontrarLoop:
	# Condição de parada da função
	bge $t0, $t1, naoEncontrado # Caso o índice ultrapasse o limite, interrompe o loop
	
	# Calcula o endereço em que o cliente está armazenado
	li $t3, 6508 		    # $t3 = endereço em que o cliente está armazenado
	mul $t3, $t0, $t3	    # $t3 = i * 6508
	add $t3, $t2, $t3 	    # $t3 += banco de clientes
	
	# Preparação para a comparação de strings
	move $a0, $s0 		    # string de input
	add $a1, $t3, 76 	    # $a1 = Endereço do cliente + desvio
	jal strcmp		    # Comparação entre $a0 e $a1
	
	# Condição de parada da função
	beqz $v0, encontrado        # Caso $v0 = 1, interrompe o loop
	
	# Dá sequência ao loop
	addi $t0, $t0, 1	    # Incrementa o índice do loop
	j encontrarLoop		    # Repete

encontrado:
	move $v0, $t3		# Move o resultado para o registrador de retorno
	la $a2, msgEncontrado 	# Carrega a mensagem a ser impressa	
	jal print_string_mmio	# Imprime a mensagem
	j encontrarTerminar	# Finaliza a busca
	
naoEncontrado:
	la $a2, msgNaoEncontrado # Carrega a mensagem a ser impressa
	jal print_string_mmio	 # Imprime a mensagem
	li $v0, 1 		 # Retorna 1  
	
encontrarTerminar:
	# Restaura registradores
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra 		 		# Retorno

# -----------------------------------------------------------------
# Função: encontrarClienteCPF
# Acha um cliente usando o CPF
# Argumento: $a0 = endereço da string com o CPF
# Retorno:   $v0 = endereço base do cliente, ou 1 se não encontrar
# -----------------------------------------------------------------
.globl encontrarClienteCPF
encontrarClienteCPF:
	# Registradores
	addi $sp, $sp, -8
	sw $ra, 0($sp)		  # $ra = Endereço de retorno
	sw $s0, 4($sp) 		  # $s0 = Usado para salvar $a0
	
	move $s0, $a0 		  # move endereço do CPF para $s0
	
	li $t0, 0 			# Índice para o loop
	lw $t1, contador_clientes # $t1 = limite de clientes	
	la $t2, banco_clientes 	  # $t2 = endereço do banco
	
encontrarCPFLoop:
	# Condição de parada da função
	bge $t0, $t1, CPFNaoEncontrado # Caso o índice ultrapasse o limite, interrompe o loop
	
	# $t3 = endereço em que o cliente está armazenado
	mul $t3, $t0, $t3	       # $t3 = i * 6508
	add $t3, $t2, $t3 	       # $t3 += banco de clientes
	
	# Calcula o endereço em que o cliente está armazenado
	li $t3, 6508 		       # Calcula o endereço em que o cliente está armazenado
	mul $t3, $t0, $t3	       # $t3 = i * 6508
	add $t3, $t2, $t3 	       # $t3 += banco de clientes

	# Preparação para a comparação de strings
	move $a0, $s0		       # string de input
	addi $a1, $t3, 64	       # $a1 = Endereço do cpf armazenado + desvio
	jal strcmp		       # Comparação entre $a0 e $a1
	
	# Condição de parada da função
	beqz $v0, CPFEncontrado      # Caso $v0 = 1, interrompe o loop	
	
	# Dá sequência ao loop
	addi $t0, $t0, 1	     # Incrementa o índice do loop
	j encontrarCPFLoop	     # Repete

CPFEncontrado:
	move $v0, $t3 		# Move o resultado para o registrador de retorno
	la $a2, msgEncontrado 	# Carrega a mensagem a ser impressa	
	jal print_string_mmio	# Imprime a mensagem
	j encontrarCPFTerminar	# Finaliza a busca
		
CPFNaoEncontrado:
	la $a2, msgNaoEncontrado # Carrega a mensagem a ser impressa
	jal print_string_mmio	 # Imprime a mensagem
	li $v0, 1 		 # Retorna 1  
	
encontrarCPFTerminar:
	# Restaura registradores
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra		 # Retorno

# -----------------------------------------------------------------
# Função: stringParaInteiro
# Converte uma string para inteiro.
# Argumento: $a0 = endereço da string recebida
# Retorno:   $v0 = o valor com inteiro
# -----------------------------------------------------------------
.globl stringParaInteiro
stringParaInteiro:
    # --- Prólogo ---
    addi $sp, $sp, -12
	li $v0, 0	# $v0 = resultado = 0
   	li $t1, 10      # $t1 = 10 (para multiplicação)

conversorLoop:
	lb $t0, 0($a0)	  # Carrega o próximo dígito
	
	# Pula caracteres não númericos
	blt $t0, '0', conversorTerminar	
	bgt $t0, '9', conversorTerminar	
	
	subi $t0, $t0, 48 # Converte char '0'-'9' para int 0-9
	
	mul $v0, $v0, $t1 # resultado *= 10
	add $v0, $v0, $t0 # resultado += digito
	
	addi $a0, $a0, 1  # Avança o ponteiro da string
	j conversorLoop	  # Dá sequência ao loop

conversorTerminar:
	jr $ra
