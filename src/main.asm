# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente a main do projeto

.data
	banner: .asciiz "Banco Tempero-shell>> " # Banner do banco estilo terminal (Requisito 12)
	
	input_buffer: .space 128 # reserva 128 bytes para os inputs

	
	
	
.text
.globl main
main: # ponto de entrada principal do projeto
	
	# provavelmente aqui vai ter alguma forma de startup que a gente só quer rodar uma vez
	
	j main_loop # pula para o loop da função main

main_loop: # loop principal da função main (funciona como uma shell)
	
	# imprime o banner
	la $a0, banner # carrega o endereço da string do banner para o registrador de argumento
	jal print_string_mmio # printa a string do banner
	
	la $a0, input_buffer # carrega o endereço da string do input_buffer para o registrador de argumento
	jal read_line_mmio # faz a leitura da digitação
	
	
	
	
	j main_loop # repete o loop da shell
	
