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
	
	# verifica se o input é "salvar"
	la $a0, input_buffer
	la $a1, cmd_salvar
	jal strcmp
	beqz $v0, executar_salvar
	
	# verifica se o input é "recarregar"
	la $a0, input_buffer
	la $a1, cmd_recarregar
	jal strcmp
	beqz $v0, executar_recarregar
	
	# verifica se o input é "formatar"
	la $a0, input_buffer
	la $a1, cmd_formatar
	jal strcmp
	beqz $v0, executar_formatar
	
	# caso todas o input passe por todas as verificações então é inválido 
	la $a0, msg_cmd_invalido # carrega o endereço da string da mensagem de comando inválido para o registrador de argumento
	jal print_string_mmio # printa a menssagem de comando inválido
	
	j main_loop # repete o loop da shell



executar_conta_cadastrar:
	jr $ra

executar_conta_format:
	jr $ra

executar_debito_extrato:
	jr $ra

executar_credito_extrato:
	jr $ra

executar_transferir_debito:
	jr $ra

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
		
