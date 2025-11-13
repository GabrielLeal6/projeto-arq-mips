# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente a persistência dos dados gerados

.text
.globl funcao_recarregar
funcao_recarregar: # ponto de entrada de funcao_recarregar
	addi $sp, $sp, -4 # aloca espaço na pilha (stack)
	sw $s0, 0($sp) # salva o registrador $s0 na pilha
	
	# abre o arquivo
	li $v0, 13 # Syscall 13 para abrir arquivo
	la $a0, nome_arquivo # carrega o endereço do nome do arquivo em $a0
	li $a1, 0 # flag read-only (modo de leitura)
	syscall # executa a chamada de sistema (abrir arquivo)
	
	move $s0, $v0 # armazena o file descriptor (FD) em $s0
	
	# Lê os dados dos clientes
	li $v0, 14 # Syscall 14 para ler do arquivo
	move $a0, $s0 # Passa o FD (file descriptor) em $a0
	la $a1, banco_clientes # passa o ponteiro do destino (bloco de dados)
	li $a2, 325250 # passando o tamanho exato do bloco a ser lido
	syscall # executa a chamada de sistema (ler do arquivo)
	
	# lê o contador de clientes
	li $v0, 14 # carrega o código 14 (ler do arquivo) em $v0
	move $a0, $s0 # passa o file descriptor (FD) em $a0
	la $a1, contador_clientes # carrega o endereço de destino (contador)
	li $a2, 4 # carrega o tamanho a ser lido (4 bytes)
	syscall # executa a chamada de sistema (ler do arquivo)
	
	#  fecha o arquivo
	li $v0, 16 # Sycall 16 para fechar o arquivo
	move $a0, $s0 # Passa o FD (file descriptor) em $a0
	syscall # executa a chamada de sistema (fechar arquivo)
	
	lw $s0, 0($sp) # restaura o registrador $s0 da pilha
	addi $sp, $sp, 4 # desaloca (libera) espaço na pilha
	
	jr $ra # volta para a parte do código que invocou a função
