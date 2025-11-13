# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente a main do projeto

.data
	banner: .asciiz "Banco Tempero-shell>> " # Banner do banco estilo terminal (Requisito 12)
	
	input_buffer: .space 128 # reserva 128 bytes para os inputs

	# lista de comandos disponíveis para o usuário (na shell)
	cmd_conta_cadastrar:    .asciiz "conta_cadastrar"
	cmd_conta_format:       .asciiz "conta_format"
	cmd_debito_extrato:     .asciiz "debito_extrato"
	cmd_credito_extrato:    .asciiz "credito_extrato"
	cmd_transferir_debito:  .asciiz "transferir_debito"
	cmd_transferir_credito: .asciiz "transferir_credito"
	cmd_pagar_fatura:       .asciiz "pagar_fatura"
	cmd_sacar:              .asciiz "sacar"
	cmd_depositar:          .asciiz "depositar"
	cmd_alterar_limite:     .asciiz "alterar_limite"
	cmd_conta_fechar:       .asciiz "conta_fechar"
	cmd_data_hora:          .asciiz "data_hora"
	# esses 3 em específico não precisam de argumentos/parametros extras, então são mais simples
	cmd_salvar: 		.asciiz "salvar\n"
	cmd_recarregar: 	.asciiz "recarregar\n"
	cmd_formatar: 		.asciiz "formatar\n"
	
	msg_cmd_invalido: 	.asciiz "Comando invalido\n"
	
	
.text
.globl main
main: # ponto de entrada principal do projeto
	
	# provavelmente aqui vai ter alguma forma de startup que a gente só quer rodar uma vez
	
	j main_loop # pula para o loop da função main

main_loop: # loop principal da função main (funciona como uma shell)
	
	# imprime o banner
	la $a0, banner # carrega o endereço da string do banner para o registrador de argumento
	jal print_string_mmio # printa a string do banner
	
	# faz a leitura do comando do usuário
	la $a0, input_buffer # carrega o endereço da string do input_buffer para o registrador de argumento
	jal read_line_mmio # faz a leitura da digitação
	
	
	# Bloco de verificação de cada possível input do usuário
	# verifica se o input começa com "conta_cadastrar"
	la $a0, input_buffer # carrega em $a0 o buffer do input do usuário
	la $a1, cmd_conta_cadastrar # carrega em $a0 o nome do comando para comparação
	li $a3, 15 # carrega em $a3 o numero de caracteres a serem comparados em strncmp
	jal strncmp # faz a comparação dos dois strings
	beqz $v0, executar_conta_cadastrar # executa a função executar_conta_cadastrar
	
	# verifica se o input começa com "conta_format"
	la $a0, input_buffer # carrega em $a0 o buffer do input do usuário
	la $a1, cmd_conta_format # carrega em $a0 o nome do comando para comparação
	li $a3, 12 # carrega em $a3 o numero de caracteres a serem comparados em strncmp
	jal strncmp # faz a comparação dos dois strings
	beqz $v0, executar_conta_format # executa a função executar_conta_format
	
	# verifica se o input começa com "debito_extrato"
	la $a0, input_buffer # carrega em $a0 o buffer do input do usuário
	la $a1, cmd_debito_extrato # carrega em $a0 o nome do comando para comparação
	li $a3, 14 # carrega em $a3 o numero de caracteres a serem comparados em strncmp
	jal strncmp # faz a comparação dos dois strings
	beqz $v0, executar_debito_extrato # executa a função executar_debito_extrato
	
	# verifica se o input começa com "credito_extrato"
	la $a0, input_buffer # carrega em $a0 o buffer do input do usuário
	la $a1, cmd_credito_extrato # carrega em $a0 o nome do comando para comparação
	li $a3, 15 # carrega em $a3 o numero de caracteres a serem comparados em strncmp
	jal strncmp # faz a comparação dos dois strings
	beqz $v0, executar_credito_extrato # executa a função executar_credito_extrato
	
	# verifica se o input começa com "transferir_debito"
	la $a0, input_buffer # carrega em $a0 o buffer do input do usuário
	la $a1, cmd_transferir_debito # carrega em $a0 o nome do comando para comparação
	li $a3, 17 # carrega em $a3 o numero de caracteres a serem comparados em strncmp
	jal strncmp # faz a comparação dos dois strings
	beqz $v0, executar_transferir_debito # executa a função executar_transferir_debito
	
	# verifica se o input começa com "transferir_credito"
	la $a0, input_buffer # carrega em $a0 o buffer do input do usuário
	la $a1, cmd_transferir_credito # carrega em $a0 o nome do comando para comparação
	li $a3, 18 # carrega em $a3 o numero de caracteres a serem comparados em strncmp
	jal strncmp # faz a comparação dos dois strings
	beqz $v0, executar_transferir_credito # executa a função executar_transferir_credito

	# verifica se o input começa com "pagar_fatura"
	la $a0, input_buffer # carrega em $a0 o buffer do input do usuário
	la $a1, cmd_pagar_fatura # carrega em $a0 o nome do comando para comparação
	li $a3, 12 # carrega em $a3 o numero de caracteres a serem comparados em strncmp
	jal strncmp # faz a comparação dos dois strings
	beqz $v0, executar_pagar_fatura # executa a função executar_pagar_fatura

	# verifica se o input começa com "sacar"
	la $a0, input_buffer # carrega em $a0 o buffer do input do usuário
	la $a1, cmd_sacar # carrega em $a0 o nome do comando para comparação
	li $a3, 5 # carrega em $a3 o numero de caracteres a serem comparados em strncmp
	jal strncmp # faz a comparação dos dois strings
	beqz $v0, executar_sacar # executa a função executar_sacar
		
	# verifica se o input começa com "depositar"
	la $a0, input_buffer # carrega em $a0 o buffer do input do usuário
	la $a1, cmd_depositar # carrega em $a0 o nome do comando para comparação
	li $a3, 10 # carrega em $a3 o numero de caracteres a serem comparados em strncmp
	jal strncmp # faz a comparação dos dois strings
	beqz $v0, executar_depositar # executa a função executar_depositar
	
	# verifica se o input começa com "alterar_limite"
	la $a0, input_buffer # carrega em $a0 o buffer do input do usuário
	la $a1, cmd_alterar_limite # carrega em $a0 o nome do comando para comparação
	li $a3, 14 # carrega em $a3 o numero de caracteres a serem comparados em strncmp
	jal strncmp # faz a comparação dos dois strings
	beqz $v0, executar_alterar_limite # executa a função executar_alterar_limite
	
	# verifica se o input começa com "conta_fechar"
	la $a0, input_buffer # carrega em $a0 o buffer do input do usuário
	la $a1, cmd_conta_fechar # carrega em $a0 o nome do comando para comparação
	li $a3, 12 # carrega em $a3 o numero de caracteres a serem comparados em strncmp
	jal strncmp # faz a comparação dos dois strings
	beqz $v0, executar_conta_fechar # executa a função executar_conta_fechar
	
	# verifica se o input começa com "data_hora"
	la $a0, input_buffer # carrega em $a0 o buffer do input do usuário
	la $a1, cmd_data_hora # carrega em $a0 o nome do comando para comparação
	li $a3, 9 # carrega em $a3 o numero de caracteres a serem comparados em strncmp
	jal strncmp # faz a comparação dos dois strings	
	beqz $v0, executar_data_hora # executa a função executar_data_hora
	
	# verifica se o input é "salvar"
	la $a0, input_buffer # carrega em $a0 o buffer do input do usuário
	la $a1, cmd_salvar # carrega em $a1 o nome do comando para comparação
	jal strcmp # faz a comparação dos dois strings
	beqz $v0, executar_salvar # executa a função salvar
	
	# verifica se o input é "recarregar"
	la $a0, input_buffer # carrega em $a0 o buffer do input do usuário
	la $a1, cmd_recarregar # carrega em $a1 o nome do comando para comparação
	jal strcmp # faz a comparação dos dois strings
	beqz $v0, executar_recarregar # executa a função recarregar
	
	# verifica se o input é "formatar"
	la $a0, input_buffer # carrega em $a0 o buffer do input do usuário
	la $a1, cmd_formatar # carrega em $a1 o nome do comando para comparação
	jal strcmp # faz a comparação dos dois strings
	beqz $v0, executar_formatar # executa a função formatar
	
	# caso todas o input passe por todas as verificações então é inválido 
	la $a0, msg_cmd_invalido # carrega o endereço da string da mensagem de comando inválido para o registrador de argumento
	jal print_string_mmio # printa a menssagem de comando inválido
	
	j main_loop # repete o loop da shell



executar_conta_cadastrar:
	la $t0, input_buffer
	li $t1, 45 # carrega o "-" para $t1 (45 é o "-" em ASCII)
	

	
	j main_loop

executar_conta_format:
	j main_loop

executar_debito_extrato:
	j main_loop

executar_credito_extrato:
	j main_loop

executar_transferir_debito:
	j main_loop

executar_transferir_credito:
	j main_loop
	
executar_pagar_fatura:
	j main_loop

executar_sacar:
	j main_loop

executar_depositar:
	j main_loop

executar_alterar_limite:
	j main_loop

executar_conta_fechar:
	j main_loop

executar_data_hora:
	j main_loop

executar_salvar:
	j main_loop
	
executar_recarregar:
	j main_loop

executar_formatar:
	j main_loop
		
