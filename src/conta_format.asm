# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente a definição dos tamanhos dos dados usados

calcular_format:
	addi $sp, $sp, 12
	sw $ra, 0($sp)
	sw $s0, 4($sp) # Armazena o endereço da conta
	sw $s1, 8($sp) # Armazena o endereço do cliente
	
	move $s0, $a0 # Guarda o endereço da conta
	