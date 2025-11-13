# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente a main do projeto

.data
	banner: .asciiz "Banco Tempero-shell>> " # Banner do banco estilo terminal (Requisito 12)
	
	.globl input_buffer
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
	
	# R10: Recarrega dados automaticamente ao iniciar
	la $t9, funcao_recarregar # carrega o endereço da função de recarregar
	jalr $t9 # chama função recarregar no startup
	
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
	
	j imprimir_invalido_e_loop # caso o comando seja inválido



executar_conta_cadastrar: # ponto de entrada do comando conta_cadastrar
	la $a0, input_buffer # carrega o endereço da string do input_buffer para o registrador $t0
	
	# fazendo o parsing dos argumentos do comando do usuário:
	li $t1, 45 # carrega o "-" para $a1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s0, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $v0 # carrega o endereço da string retornado da função anterior para buscar pelo proximo "-"
	li $a1, 45 # carrega o "-" para $t1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s1, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $v0 # carrega o endereço da string retornado da função anterior para buscar pelo proximo "-"
	li $a1, 45 # carrega o "-" para $t1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s2, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $s0 # passa os resultados do parsing das opções do usuário como argumento
	move $a1, $s1 # passa os resultados do parsing das opções do usuário como argumento
	move $a2, $s2 # passa os resultados do parsing das opções do usuário como argumento

	j imprimir_invalido_e_loop # caso o comando seja inválido 

executar_conta_format: # ponto de entrada do comando conta_format 
	la $a0, input_buffer # carrega o endereço da string do input_buffer para o registrador $t0
	
	# fazendo o parsing dos argumentos do comando do usuário:
	li $t1, 45 # carrega o "-" para $a1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s0, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $s0 # passa os resultados do parsing das opções do usuário como argumento

	la $t9, funcao_conta_format # carrega o endereço da função
	jalr $t9 # chama a função em si
	
	j main_loop # retorna para o loop central

executar_debito_extrato: # ponto de entrada do comando debito_extrato
	la $a0, input_buffer # carrega o endereço da string do input_buffer para o registrador $t0
	
	# fazendo o parsing dos argumentos do comando do usuário:
	li $t1, 45 # carrega o "-" para $a1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s0, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $s0 # passa os resultados do parsing das opções do usuário como argumento

	#la $t9, funcao_debito_extrato # carrega o endereço da função
	jalr $t9 # chama a função em si
	j main_loop # retorna para o loop central

executar_credito_extrato: # ponto de entrada do comando credito_extrato
	la $a0, input_buffer # carrega o endereço da string do input_buffer para o registrador $t0
	
	# fazendo o parsing dos argumentos do comando do usuário:
	li $t1, 45 # carrega o "-" para $a1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s0, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $s0 # passa os resultados do parsing das opções do usuário como argumento

	# la $t9, funcao_credito_extrato # carrega o endereço da função
	jalr $t9 # chama a função em si
	j main_loop # retorna para o loop central

executar_transferir_debito: # ponto de entrada do comando transferir_debito
	la $a0, input_buffer # carrega o endereço da string do input_buffer para o registrador $t0
	
	# fazendo o parsing dos argumentos do comando do usuário:
	li $t1, 45 # carrega o "-" para $a1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s0, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $v0 # carrega o endereço da string retornado da função anterior para buscar pelo proximo "-"
	li $a1, 45 # carrega o "-" para $t1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s1, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $v0 # carrega o endereço da string retornado da função anterior para buscar pelo proximo "-"
	li $a1, 45 # carrega o "-" para $t1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s2, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $s0 # passa os resultados do parsing das opções do usuário como argumento
	move $a1, $s1 # passa os resultados do parsing das opções do usuário como argumento
	move $a2, $s2 # passa os resultados do parsing das opções do usuário como argumento

	# la $t9, funcao_transferir_debito # carrega o endereço da função
	jalr $t9 # chama a função em si
	j main_loop # retorna para o loop central

executar_transferir_credito: # ponto de entrada do comando transferir_credito
	la $a0, input_buffer # carrega o endereço da string do input_buffer para o registrador $t0
	
	# fazendo o parsing dos argumentos do comando do usuário:
	li $t1, 45 # carrega o "-" para $a1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s0, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $v0 # carrega o endereço da string retornado da função anterior para buscar pelo proximo "-"
	li $a1, 45 # carrega o "-" para $t1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s1, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $v0 # carrega o endereço da string retornado da função anterior para buscar pelo proximo "-"
	li $a1, 45 # carrega o "-" para $t1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s2, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $s0 # passa os resultados do parsing das opções do usuário como argumento
	move $a1, $s1 # passa os resultados do parsing das opções do usuário como argumento
	move $a2, $s2 # passa os resultados do parsing das opções do usuário como argumento

	# la $t9, funcao_transferir_credito # carrega o endereço da função
	jalr $t9 # chama a função em si
	j main_loop # retorna para o loop central
	
executar_pagar_fatura: # ponto de entrada do comando pagar_fatura
		la $a0, input_buffer # carrega o endereço da string do input_buffer para o registrador $t0
	
	# fazendo o parsing dos argumentos do comando do usuário:
	li $t1, 45 # carrega o "-" para $a1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s0, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $v0 # carrega o endereço da string retornado da função anterior para buscar pelo proximo "-"
	li $a1, 45 # carrega o "-" para $t1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s1, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $v0 # carrega o endereço da string retornado da função anterior para buscar pelo proximo "-"
	li $a1, 45 # carrega o "-" para $t1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s2, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $s0 # passa os resultados do parsing das opções do usuário como argumento
	move $a1, $s1 # passa os resultados do parsing das opções do usuário como argumento
	move $a2, $s2 # passa os resultados do parsing das opções do usuário como argumento

	# la $t9, funcao_pagar_fatura # carrega o endereço da função
	jalr $t9 # chama a função em si

	j main_loop # retorna para o loop central

executar_sacar: # ponto de entrada do comando sacar
	la $a0, input_buffer # carrega o endereço da string do input_buffer para o registrador $t0
	
	# fazendo o parsing dos argumentos do comando do usuário:
	li $t1, 45 # carrega o "-" para $a1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s0, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $v0 # carrega o endereço da string retornado da função anterior para buscar pelo proximo "-"
	li $a1, 45 # carrega o "-" para $t1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s1, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $s0 # passa os resultados do parsing das opções do usuário como argumento
	move $a1, $s1 # passa os resultados do parsing das opções do usuário como argumento

	# la $t9, funcao_sacar # carrega o endereço da função
	jalr $t9 # chama a função em si
	j main_loop # retorna para o loop central

executar_depositar: # ponto de entrada do comando depositar
	la $a0, input_buffer # carrega o endereço da string do input_buffer para o registrador $t0
	
	# fazendo o parsing dos argumentos do comando do usuário:
	li $t1, 45 # carrega o "-" para $a1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s0, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $v0 # carrega o endereço da string retornado da função anterior para buscar pelo proximo "-"
	li $a1, 45 # carrega o "-" para $t1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s1, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $s0 # passa os resultados do parsing das opções do usuário como argumento
	move $a1, $s1 # passa os resultados do parsing das opções do usuário como argumento

	# la $t9, funcao_depositar # carrega o endereço da função
	jalr $t9 # chama a função em si
	j main_loop # retorna para o loop central

executar_alterar_limite: # ponto de entrada do comando alterar_limite
	la $a0, input_buffer # carrega o endereço da string do input_buffer para o registrador $t0
	
	# fazendo o parsing dos argumentos do comando do usuário:
	li $t1, 45 # carrega o "-" para $a1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s0, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $v0 # carrega o endereço da string retornado da função anterior para buscar pelo proximo "-"
	li $a1, 45 # carrega o "-" para $t1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s1, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $s0 # passa os resultados do parsing das opções do usuário como argumento
	move $a1, $s1 # passa os resultados do parsing das opções do usuário como argumento

	#la $t9, funcao_alterar_limite # carrega o endereço da função
	jalr $t9 # chama a função em si
	j main_loop # retorna para o loop central

executar_conta_fechar: # ponto de entrada do comando conta_fechar
	la $a0, input_buffer # carrega o endereço da string do input_buffer para o registrador $t0
	
	# fazendo o parsing dos argumentos do comando do usuário:
	li $t1, 45 # carrega o "-" para $a1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s0, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $s0 # passa os resultados do parsing das opções do usuário como argumento

	# la $t9, funcao_conta_fechar # carrega o endereço da função
	jalr $t9 # chama a função em si
	j main_loop # retorna para o loop central

executar_data_hora: # ponto de entrada do comando data_hora
	la $a0, input_buffer # carrega o endereço da string do input_buffer para o registrador $t0
	
	# fazendo o parsing dos argumentos do comando do usuário:
	li $t1, 45 # carrega o "-" para $a1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s0, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $v0 # carrega o endereço da string retornado da função anterior para buscar pelo proximo "-"
	li $a1, 45 # carrega o "-" para $t1 (45 é o "-" em ASCII)
	jal encontrar_caractere_e_anular # chama a função para elimar o "-"
	beqz $v0, imprimir_invalido_e_loop # Se $v0 == 0, argumento não foi encontrado
	move $s1, $v0 # salva em $s0 o retorno de encontrar_caractere_e_anular (o argumento a ser passado)
	
	move $a0, $s0 # passa os resultados do parsing das opções do usuário como argumento
	move $a1, $s1 # passa os resultados do parsing das opções do usuário como argumento

	# la $t9, funcao_data_hora # carrega o endereço da função
	jalr $t9 # chama a função em si
	j main_loop # retorna para o loop central

executar_salvar: # ponto de entrada do comando salvar
	la $t9, funcao_salvar # armazena o endereço da função_salvar
	jalr $t9 # chama a função
	j main_loop # retorna para o loop central
	
executar_recarregar: # ponto de entrada do comando recarregar 
	la $t9, funcao_recarregar # armazena o endereço da função_recarregar
	jalr $t9 # chama a função
	j main_loop # retorna para o loop central

executar_formatar: # ponto de entrada do comando formatar
	la $t9, funcao_formatar # armazena o endereço da função_formatar
	jalr $t9 # chama a função
	j main_loop # retorna para o loop central
		
		
imprimir_invalido_e_loop: # caso todas o input passe por todas as verificações então é inválido 
	la $a0, msg_cmd_invalido # carrega o endereço da string da mensagem de comando inválido para o registrador de argumento
	jal print_string_mmio # printa a menssagem de comando inválido
	
	j main_loop # repete o loop da shell