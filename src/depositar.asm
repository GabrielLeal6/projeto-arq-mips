# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente ao comando depósito

.data
	msgSucessoDeposito: .asciiz "Depósito realizado com suceso.\n"
	
.text

.globl depositar
depositar:
	# Registradores
	addi $sp, $sp, -16
	sw $ra, 0($sp)				# $ra = endereço de retorno
	sw $s0, 4($sp)				# $s0 = endereço do cliente
	sw $s1, 8($sp)				# $s1 = string do valor a ser depositado
	sw $s2, 12($sp)				# $s2 = endereço do valor a ser depositado
	
	move $s2, $a1				# salva o endereço com o valor da string
	
	jal encontrarCliente		# procura o cliente
	
	# Condição de parada da função	
	beqz $v0, depositarTerminar	# Se $v0 = 0, interrompe o loop 
	move $s0, $v0				# $s0 = $v0 pois se chegou até aqui, o cliente foi encontrado
	
	# Converte a string do valor a ser depositado para inteiro
	move $a0, $s2				# $a0 = endereço da string a ser convertida
	jal stringParaInteiro		
	move $s1, $v0				# $s1 = valor a ser depositado (inteiro)
	
	# Carrega o saldo atual do cliente
	lw $t0, 85($s0)				# $t0 = saldo atual || 85 = offset do saldo
	add $t0, $t0, $s1			# $t0 = saldo atual + valor a ser depositado
	sw $t0, 85($s0)				# Salva o novo saldo
	
	la $a0, msgSucessoDeposito	# Carrega a mensagem de sucesso
	jal print_string_mmio		# Imprime a mensagem
	
depositarTerminar:
	# Restaura os registradores
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra				# Retorno