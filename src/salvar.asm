# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente a persistência dos dados gerados

# .data
#	nome_arquivo: .asciiz "banco.data" # REMOVIDO - Agora está em banco_dados.asm


.globl funcao_salvar
funcao_salvar: # ponto de entrada de funcao_salvar
	
	# --- CORREÇÃO DE CRASH: Salvar $ra e $s0 ---
	addi $sp, $sp, -8 # aloca espaço na pilha (stack) para 2 registradores
	sw $ra, 0($sp) # salva o endereço de retorno ($ra)
	sw $s0, 4($sp) # salva o registrador $s0
	

	# bloco para abrir o arquivo:
	li $v0, 13 # Syscall 13 para abrir arquivo
	la $a0, nome_arquivo # carrega o endereço do 'nome_arquivo' (de banco_dados.asm)
	
	# --- CORREÇÃO DE CRIAÇÃO: Flag 9 ---
	# Flag 9 = Write (1) + Create (8). Garante que o arquivo seja criado.
	li $a1, 1 
	syscall # executa a chamada de sistema (abrir arquivo)
	
	move $s0, $v0 # armazena o file descriptor (FD) em $s0
	
	# --- Adicionando verificação de erro para robustez ---
	# Se $s0 (FD) for negativo, a abertura falhou. Pular para o fim.
	bltz $s0, salvar_fim_erro 
	
	# bloco para escrever os dados dos clientes no arquivo:
	li $v0, 15 # Syscall 15 para escrever no arquivo
	move $a0, $s0 # Passa o FD (file descriptor) em $a0
	la $a1, banco_clientes # passa o ponteiro do começo do bloco de dados na memória [cite: banco_dados.asm]
	li $a2, 325250 # passando o tamanho exato do bloco (definido em banco_dados.asm) [cite: banco_dados.asm]
	syscall # executa a chamada de sistema (escrever no arquivo)
	
	# bloco para escrever o contador de clientes
	li $v0, 15 # carrega o código 15 (escrever no arquivo) em $v0
	move $a0, $s0 # passa o file descriptor (FD) em $a0
	la $a1, contador_clientes # carrega o endereço do contador de clientes em $a1
	li $a2, 4 # carrega o tamanho do contador (4 bytes) [cite: banco_dados.asm]
	syscall # executa a chamada de sistema (escrever no arquivo)
	
	# bloco para fechar o arquivo:
	li $v0, 16 # Sycall 16 para fechar o arquivo
	move $a0, $s0 # Passa o FD (file descriptor) em $a0
	syscall # executa a chamada de sistema (fechar arquivo)
	
salvar_fim_erro: # Ponto de saída (normal ou em caso de erro)
	# --- CORREÇÃO DE CRASH: Restaurar $ra e $s0 ---
	lw $ra, 0($sp) # restaura o registrador $ra da pilha
	lw $s0, 4($sp) # restaura o registrador $s0 da pilha
	addi $sp, $sp, 8 # desaloca (libera) espaço na pilha
	
	jr $ra # volta para o código de onde foi invocado
