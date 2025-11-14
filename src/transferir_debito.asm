# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente ao comando transferir no débito

.data
	msgSucessoDebito .asciiz "Pagamento realizado com sucesso.\n"
	msgErroCliente	 .asciiz "Falha: Cliente não existe||não encontrado.n"
	msgErroSaldo	 .asciiz "Falha: Saldo insuficiente.\n"

.text
# -----------------------------------------------------------------
# Função: transferir_debito
# Realiza uma transferência entre duas contas no débito
# Argumento: $a0: Endereço da string da Conta Destino
#   	     $a1: Endereço da string da Conta Origem
#  	     $a2: Endereço da string do Valor
# -----------------------------------------------------------------
.globl transferir_debito
transferir_debito:
	# Registradores
	addi $sp, $sp, $-24
	sw $ra, 0($sp)	# $ra = endereço de retorno
	sw $s0, 4($sp)	# $s0 = endereço da string da conta do cliente 1
	sw $s1, 8($sp)	# $s1 = endereço da string da conta do cliente 2
	sw $s2, 12($sp)	# $s2 = endereço do valor a ser debitado
	sw $a1, 16($sp)	# $a1 = salva a conta origem
	sw $a2, 20($sp)	# $a2 = salva o valor da transferência
	
	# Busca do Cliente 1
	jal encontrarCliente	 # procura o cliente
	# Condição de parada da função
	beqz $v0, debitoTerminar # Se $v0 = 0, interrompe o loop 
	move $s0, $v0 		 # $s0 = endereço do cliente 1 pois se chegou até aqui, o cliente foi encontrado

	# Busca do Cliente 2
	lw $a0, 16($sp)		 # Carrega a conta do Cliente 2
	jal encontrarCliente 	 # procura o cliente
	# Condição de parada da função
	beqz $v0, debitoTerminar # Se $v0 = 0, interrompe o loop 
	move $s1, $v0 		 # $s1 = endereço do cliente 1 pois se chegou até aqui, o cliente foi encontrado
	
	# Converte a string do valor a ser debitado para inteiro
	lw $s0, 20($sp)		# Carrega o valor a ser debitado
	jal stringParaInteiro
	move $s2, $v0		# $s2 = valor a ser debitado (inteiro)
	
	# Verificar o saldo do Cliente 2
	lw $t0, 85($s1)			# Carrega o saldo de origem
	slt $t1, $t0, $s2		# Verifica se há saldo suficiente
	bnez $t1, debitoErroSaldo	# Se $t1 = 0. Interrompe o loop
	
	# Realizar transferência
	# Subtrair o valor debitado da conta do Cliente 2
	sub $t0, $t0, $s2 # $t0 = saldo atual do Cliente 1 - valor a ser depositado por Cliente 2
	sw $t0, 85($s1)	# Salva novo saldo na Origem
	# Adicionar o valor debitado à conta do Cliente 1
	lw $t2, 85($s0)	# Carrega o saldo do destino
	add $t2, $t2, $s2 # $t2 = saldo destino + valor 
	sw $t2, 85($s0) # Salva novo saldo do destino
	
	# Conclusão
	la $a0, msgSucessoDebito # Carrega a mensagem de sucesso
	jal print_string_mmio # Imprime a mensagem
	j debitoTerminar # Finaliza o debito
	
debitoErroCliente:
	la $a0, msgErroCliente # Carrega a mensagem de erro cliente
	jal print_string_mmio # Imprime a mensagem
	j debitoTerminar # Finaliza o debito
	
debitoErroSaldo:
	la $a0, msgErroSaldo # Carrega a mensagem de erro saldo
	jal print_string_mmio # Imprime a mensagem
	
debitoTerminar:
	# Restaurar registradores
	lw $ra, 0($sp)
    	lw $s0, 4($sp)
    	lw $s1, 8($sp)
    	lw $s2, 12($sp)
    	lw $a1, 16($sp)
    	lw $a2, 20($sp)
    	addi $sp, $sp, 24
    	jr $ra # retorno