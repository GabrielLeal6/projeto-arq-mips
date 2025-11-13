# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente ao comando de formatar todos os dados

.data
	msg_formatado: .asciiz "Sistema formatado. Use o comando 'salvar' para persistir as mudanças\n"
	
.text
.globl funcao_formatar
funcao_formatar: # ponto de entrada de funcao_formatar
	la $t0, contador_clientes # carrega o endereço do contador de clientes
	sw $zero, 0($t0) # zera o contador de clientes (salva 0)
	
	la $t0, banco_clientes # $t0 = ponteiro do início do banco de dados
	li $t1, 325250 # $t1 = tamanho total do banco (em bytes)
	add $t2, $t0, $t1 # $t2 = endereço final do banco ($t0 + $t1)
	
formatar_loop: # loop principal para zerar o banco
	bge $t0, $t2, formatar_fim # se $t0 (atual) >= $t2 (final), termina o loop
	
	sw $zero, 0($t0) # zera 4 bytes (uma word) no endereço atual
	addi $t0, $t0, 4 # avança o ponteiro 4 bytes
	j formatar_loop # repete o loop
	
formatar_fim: # ponto de saída do loop
	la $a0, msg_formatado # carrega o endereço da mensagem de formatado
	jal print_string_mmio # imprime a mensagem
	
	jr $ra # retorna para o código de onde foi invocado