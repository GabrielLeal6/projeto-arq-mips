# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente a gestão do MMIO para o projeto principal


.data
	.eqv ASCII_NL 10
	.eqv ASCII_NULL 0

.text

# função que trata do MMIO
.globl read_line_mmio
read_line_mmio: # ponto de entrada do funcionamento do MMIO
	lui $t0, 0xffff # Carrega o endereço base 0xffff0000

loop_ler_mmio: # entrada do loop de leitura do teclado
	lw $t1, 0($t0) # carrega o status do teclado
	andi $t1, $t1, 1 # Isola o bit "pronto"
	beqz $t1, loop_ler_mmio # Se não estiver pronto, volta para o começo do loop

	lw $t2, 4($t0) # carrega o caractere pronto em $t2

loop_display_mmio: # entrada da parte de display
	lw $t3, 8($t0) # carrega o status do display
	andi $t3, $t3, 1 # Isola o bit "pronto"
	beqz $t3, loop_display_mmio # Se não estiver pronto, volta para o começo do loop
	sw $t2, 12($t0) # salva o caractere em $t2 para o display

	addi $a0, $a0, 1 # avança o ponteiro do buffer

	li $t3, ASCII_NL # carrega o valor de escape (10)
	beq $t2, $t3, fim_read_line # se a tecla pressionada vai para o fim

	j loop_ler_mmio # se não foi enter, continua o loop

fim_read_line: # saída do MMIO para 
	li $t2, ASCII_NULL # Carrega o valor nulo (0)
	sb $t2, 0($a0) # salva o sinal de parada (\0) no final da string

	jr $ra # retorna para a parte do código de onde foi invocado
	

	
			
# função para fazer a impressão de uma string via MMIO
.globl print_string_mmio
print_string_mmio: # ponto de entrada da função print_string_mmio
	lui $t0, 0xffff # carrega o endereço base 0xffff0000
	
loop_print_caractere: # label de loop para carregar o proximo caractere
	lb $t2, 0($a0) # carrega o caractere a ser impresso
	
	beqz $t2, fim_print_string # se for o caractere de parada (\0) vai para o fim
	
loop_esperar_display: # loop para esperar o display estar pronto
	lw $t1, 8($t0) # Carrega o status do display
	andi $t1, $t1, 1 # isola o bit "pronto"
	beqz $t1, loop_esperar_display # espera se não estiver pronto ainda o display
	
	sw $t2, 12($t0) # escreve o caractere no display
	
	addi $a0, $a0, 1 # avança o ponteiro da string
	
	j loop_print_caractere # continua o loop
	
fim_print_string: # ponto de saída da função print_string_mmio
	jr $ra # retorna para a parte do código de onde foi invocado
	
	
	
