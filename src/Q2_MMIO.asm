# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente à questão 2 da seção de exercícios
# Implementa um "Echo" de terminal usando MMIO (Memory-Mapped I/O)

.text
main_q2:
	lui $t0, 0xffff # Carrega o endereço base 0xffff0000

	loop_ler_q2: # entrada do loop de leitura do teclado
		lw $t1, 0($t0) # carrega o status do teclado
		andi $t1, $t1, 1 # Isola o bit "pronto"
		beqz $t1, loop_ler_q2 # Se não estiver pronto, volta para o começo do loop
		
		lw $t2, 4($t0) # carrega o caractere pronto em $t2
	
	
	loop_display_q2: # entrada da parte de display
		lw $t3, 8($t0) # carrega o status do display
		andi $t3, $t3, 1 # Isola o bit "pronto"
		beqz $t3, loop_display_q2 # Se não estiver pronto, volta para o começo do loop
		sw $t2, 12($t0) # salva o caractere em $t2 para o display
		
		j loop_ler_q2 # volta para o começo do loop maior
		 
