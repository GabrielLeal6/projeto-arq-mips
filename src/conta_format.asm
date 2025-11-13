# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente ao comando de formatar conta


.data
	msgConfirmarFormat: .asciiz "Você tem certeza que deseja apagar? (s/n): "
	msgOkFormat:	    .asciiz "Transações apagadas com sucesso.\n"
	msgErroFormat:	    .asciiz "Erro: Conta não encontrada.\n"
	msgCancelarFormat:  .asciiz "Operação cancelada.\n"

.text
.globl funcao_conta_format
funcao_conta_format: # ponto de entrada de funcao_conta_format
	addi $sp, $sp, -12 # aloca espaço na pilha para 3 registradores
	sw $ra, 0($sp) # salva o endereço de retorno ($ra) na pilha
	sw $s0, 4($sp) # salva $s0 (endereço da conta) na pilha
	sw $s1, 8($sp) # salva $s1 (endereço do cliente) na pilha
	
	move $s0, $a0 # Guarda o endereço da conta (passado em $a0) em $s0
	
	jal encontrarCliente # chama a função para buscar o cliente (ainda usa $a0)
	
	beqz $v0, formatarErro # se $v0 for 0 (cliente não encontrado), pula para o erro
	move $s1, $v0 # se encontrou, salva o endereço base do cliente em $s1
	
	la $a0, msgConfirmarFormat # carrega o endereço da mensagem de confirmação
	jal print_string_mmio # imprime a mensagem via MMIO
	
	la $a0, input_buffer # carrega o endereço do buffer de input
	jal read_line_mmio # lê a resposta do usuário
	
	lb $t0, input_buffer # carrega o primeiro byte (caractere) da resposta
	li $t1, 's' # carrega o caractere 's' para $t1
	bne $t0, $t1, formatarCancelar # se a resposta não for 's', cancela
	
	# se a resposta for 's', continua para zerar as transações
	li $t2, 105 # carrega o offset dos dados fixos (105 bytes)
	add $t0, $s1, $t2 # $t0 = endereço base do cliente ($s1) + 105 (início das transações)
	li $t1, 6400 # carrega o tamanho total da área de transações
	add $t1, $t0, $t1 # $t1 = endereço final da área de transações

formatarLoop: # loop para zerar a área de transações
	bge $t0, $t1, formatarZerar # se o ponteiro $t0 chegou ao fim, pula
	sw $zero, 0($t0) # zera 4 bytes (uma word) na memória
	addi $t0, $t0, 4 # avança o ponteiro 4 bytes
	j formatarLoop # repete o loop
	
formatarZerar: # rotina de sucesso
	la $a0, msgOkFormat # carrega a mensagem de sucesso
	jal print_string_mmio # imprime a mensagem
	j formatarTerminar # pula para o fim da função
	
formatarErro: # rotina de erro (cliente não encontrado)
	la $a0, msgErroFormat # carrega a mensagem de erro
	jal print_string_mmio # imprime a mensagem
	j formatarTerminar # pula para o fim da função

formatarCancelar: # rotina de cancelamento (usuário digitou algo != 's')
	la $a0, msgCancelarFormat # carrega a mensagem de cancelamento
	jal print_string_mmio # imprime a mensagem

formatarTerminar: # ponto de saída da função
	lw $ra, 0($sp) # restaura $ra da pilha
	lw $s0, 4($sp) # restaura $s0 da pilha
	lw $s1, 8($sp) # restaura $s1 da pilha
	addi $sp, $sp, 12 # desaloca (libera) o espaço na pilha
	jr $ra # retorna para a função main