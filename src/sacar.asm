# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente ao comando saque

.data
	msgSucessoSaque: .asciiz "Saque realizado com sucesso.\n"
	msgErro:	 	 .asciiz "Erro: Saldo insuficiente.\n"
	
.text
# Função: sacar
# Subtrai um valor da conta de um cliente usando o número da conta.
# Argumentos: $a0 = endereço da string com o número da conta
# 			  $a1 = endereço da string com o valor a ser sacado
# Retorno:    $v0 = endereço base do cliente, ou 1 se não encontrar
# -----------------------------------------------------------------
.globl sacar
sacar:
	# Registradores
	addi $sp, $sp, -16
	sw $ra, 0($sp)			# $ra = endereço de retorno
	sw $s0, 4($sp)			# $s0 = endereço do cliente
	sw $s1, 8($sp)			# $s1 = string do valor a ser sacado
	sw $s2, 12($sp)			# $s2 = endereço do valor a ser sacado
	
	move $s2, $a1			# salva o endereço com o valor da string
	
	jal encontrarCliente	# procura o cliente
	
	# Condição de parada da função
	beqz $v0, sacarTerminar	# Se $v0 = 0, interrompe o loop 
	move $s0, $v0 			# $s0 = $v0 pois se chegou até aqui, o cliente foi encontrado
	
	# Converte a string do valor a ser sacado para inteiro
	move $a0, $s2 			# $a0 = endereço da string a ser convertida
	jal stringParaInteiro
	move $s1, $v0			# $s1 = valor a ser sacado (inteiro)

	# Carrega o saldo atual do cliente
	lw $t0, 85($s0)			# $t0 = saldo atual || 85 = offset do saldo
	
	# Condição de parada da função
	slt $t1, $t0, $s1		# Verifica se há saldo suficiente
	bnez $t1, sacarErro		# Se $t1 != 0, interrompe o loop
	
	# Se chegou aqui, há saldo e o saque é realizadoe
	sub $t0, $t0, $s1 		# $t0 = saldo atual - valor a ser sacado 
	sw $t0, 85($s0)			# Salva o novo saldo

	# Conclusão 
	la $a0, msgSucessoSaque	# Carrega a mensagem de sucesso
	jal print_string_mmio	# Imprime a mensagem
	j sacarTerminar			# Finaliza o saque

sacarErro:
	la $a0, msgErro			# Carrega a mensagem de erro
	jal print_string_mmio	# Imprime a mensagem
	
sacarTerminar:
	# Restaura os registradores
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra				# Retorno