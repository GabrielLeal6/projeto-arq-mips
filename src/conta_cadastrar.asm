# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente ao cadastro de contas no sistema

.data
	#Strings de mensagens necessárias
	msgSucesso:   .asciiz "Cliente cadastrado com sucesso. Número da conta "
	msgErroCPF:   .asciiz "Já existe conta neste CPF."	
	msgErroConta: .asciiz "Número da conta já em uso."
	
.text
calcularDV:
    # Registradores:
    # $s0 = acumulador da soma
    # $t0 = endereço base ($a0)
    # $t1 = dígito (char)
    # $t2 = dígito (int) 
    # $t3 = multiplicador
	move $t0, $a0
	li $s0, 0 # Reinicia o acumulador
	
	# (d0 * 2) - d0 está em input_conta[5]
	lb $t1, 5($t0) # Carrega o byte d0
	subi $t2, $t1, 48 # Converter o char para inteiro
	li $t3, 2
	mul $t2, $t2, $t3
	add $s0, $s0, $t2 #Acumula
	
	# (d1 * 3) - d1 está em input_conta[4]
	lb $t1, 4($t0) # Carrega o byte d1
	subi $t2, $t1, 48 # Converter o char para inteiro
	li $t3, 3
	mul $t2, $t2, $t3
	add $s0, $s0, $t2 #Acumula
	
	# (d2 * 4) - d2 está em input_conta[3]
	lb $t1, 3($t0) # Carrega o byte d2
	subi $t2, $t1, 48 # Converter o char para inteiro
	li $t3, 4
	mul $t2, $t2, $t3
	add $s0, $s0, $t2 #Acumula
	
	# (d3 * 5) - d3 está em input_conta[2]
	lb $t1, 2($t0) # Carrega o byte d3
	subi $t2, $t1, 48 # Converter o char para inteiro
	li $t3, 5
	mul $t2, $t2, $t3
	add $s0, $s0, $t2 #Acumula
	
	# (d4 * 6) - d4 está em input_conta[1]
	lb $t1, 1($t0) # Carrega o byte d4
	subi $t2, $t1, 48 # Converter o char para inteiro
	li $t3, 6
	mul $t2, $t2, $t3
	add $s0, $s0, $t2 #Acumula
	
	# (d5 * 7) - d5 está em input_conta[0]
	lb $t1, 0($t0) # Carrega o byte d5
	subi $t2, $t1, 48 # Converter o char para inteiro
	li $t3, 7
	mul $t2, $t2, $t3
	add $s0, $s0, $t2 #Acumula
	
	# Calcula o resto da divisão por 11
	li $t2, 11
	div $s0, $t2
	mfhi $s0
	
	# Checagrem do caso especial em que resto = 10
	li $t2, 10
	bne $s0, $t2, resto_dez
	
	# Caso o resto seja 10, o DV é 'X'
	li $v0, 'X'
	jr $ra

resto_dez:
	# Converte o resto de inteiro para char
	addi $v0, $s0, 48
	jr $ra