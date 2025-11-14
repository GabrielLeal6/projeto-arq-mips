# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente ao comando transferir no crédito

.data
	msgSucessoCredito .asciiz "Pagamento realizado com sucesso.\n"
	msgErroCliente	  .asciiz "Falha: Cliente não existe||não encontrado.n"
	msgErroLimite	  .asciiz "Falha: Limite insuficiente.\n"

.text
# -----------------------------------------------------------------
# Função: transferir_credito
# Realiza uma transferência entre duas contas no crédito
# Argumento: $a0: Endereço da string da Conta Destino
#   	     $a1: Endereço da string da Conta Origem
#  	     $a2: Endereço da string do Valor
# -----------------------------------------------------------------
.globl transferir_credito
transferir_credito:
	# Registradores
	addi $sp, $sp, $-24
	sw $ra, 0($sp)	# $ra = endereço de retorno
	sw $s0, 4($sp)	# $s0 = endereço da string da conta do cliente 1
	sw $s1, 8($sp)	# $s1 = endereço da string da conta do cliente 2
	sw $s2, 12($sp)	# $s2 = endereço do valor a ser creditado
	sw $a1, 16($sp)	# $a1 = salva a conta origem
	sw $a2, 20($sp)	# $a2 = salva o valor da transferência
	
	# Busca do Cliente 1
	jal encontrarCliente	 # procura o cliente
	# Condição de parada da função
	beqz $v0, creditoTerminar # Se $v0 = 0, interrompe o loop 
	move $s0, $v0 		 # $s0 = endereço do cliente 1 pois se chegou até aqui, o cliente foi encontrado

	# Busca do Cliente 2
	lw $a0, 16($sp)		 # Carrega a conta do Cliente 2
	jal encontrarCliente 	 # procura o cliente
	# Condição de parada da função
	beqz $v0, creditoTerminar # Se $v0 = 0, interrompe o loop 
	move $s1, $v0 		 # $s1 = endereço do cliente 1 pois se chegou até aqui, o cliente foi encontrado
	
	# Converte a string do valor a ser creditado para inteiro
	lw $s0, 20($sp)		# Carrega o valor a ser creditado
	jal stringParaInteiro
	move $s2, $v0		# $s2 = valor a ser creditado (inteiro)
	
	# Verificar o limite do Cliente 2
	lw $t0, 92($s1)			# Carrega o limite de origem
	lw $t1, 96($s1) 		# Carrega a divida da origem
	sub $t2, $t0, $t1          	# $t2 = limite - divida, calcula o limite disponível
	slt $t3, $t2, $s2		# Verifica se há limite suficiente
	bnez $t3, creditoErroLimite	# Se $t1 = 0. Interrompe o loop
	
	# Realizar transferência
	# Aumenta a divida do Cliente 2
	add $t1, $t1, $s2 # $t0 = divida atual + valor
	sw $t1, 96($s1)	# Salva novo limite na Origem
	# Adicionar o valor creditado ao limite do Cliente 1
	lw $t0, 92($s0)	# Carrega o limite do destino
	add $t0, $t0, $s2 # $t2 = limite destino + valor 
	sw $t0, 02($s0) # Salva novo limite do destino
	
	# Conclusão
	la $a0, msgSucessoCredito # Carrega a mensagem de sucesso
	jal print_string_mmio # Imprime a mensagem
	j creditoTerminar # Finaliza o debito
	
creditoErroCliente:
	la $a0, msgErroCliente # Carrega a mensagem de erro cliente
	jal print_string_mmio # Imprime a mensagem
	j creditoTerminar # Finaliza o debito
	
creditoErroLimite:
	la $a0, msgErroLimite # Carrega a mensagem de erro limite
	jal print_string_mmio # Imprime a mensagem
	
creditoTerminar:
	# Restaurar registradores
	lw $ra, 0($sp)
    	lw $s0, 4($sp)
    	lw $s1, 8($sp)
    	lw $s2, 12($sp)
    	lw $a1, 16($sp)
    	lw $a2, 20($sp)
    	addi $sp, $sp, 24
    	jr $ra # retorno