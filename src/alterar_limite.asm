	# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente ao comando de alterar limite

.data
	msgSucessoLimite: .asciiz "Limite alterado com suceso.\n"
	
.text

.globl alterar_limite
alterar_limite:
	# Registradores
	addi $sp, $sp, -16
	sw $ra, 0($sp)				# $ra = endereço de retorno
	sw $s0, 4($sp)				# $s0 = endereço do cliente
	sw $s1, 8($sp)				# $s1 = string do novo limite da conta
	sw $s2, 12($sp)				# $s2 = endereço do novo limite da conta

	move $s2, $a1				# salva o endereço com o valor da string
	
	jal encontrarCliente		# procura o cliente
	
	# Condição de parada da função
	beqz $v0, limiteTerminar	# Se $v0 = 0, interrompe o loop
	move $s0, $v0				# $s0 = $v0 pois se chegou até aqui, o cliente foi encontrado
	
	# Converte a string do novo limite para inteiro
	move $a0, $s2				# $a0 = endereço da string a ser convertida
	jal stringParaInteiro		
	move $s1, $v0				# $s1 = novo limite (inteiro)

	# Atualiza o limite do cliente, não é necessário carregar o valor antigo
	sw $s1, 89($s0)				# 89 = offset do limite da conta
	
	la $a0, msgSucessoLimite	# Carrega a mensagem de sucesso
	jal print_string_mmio 		# Imprime a mensagem
	
limiteTerminar:
	# Restaura os registradores
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra				# Retorno