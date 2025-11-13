# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente a funções gerais que serão usadas no projeto

.data
	# Mensagens removidas para evitar interferência

.text

# -----------------------------------------------------------------
# Função: encontrarCliente
# Acha um cliente usando o NÚMERO DA CONTA (String XXXXXX-X).
# Argumento: $a0 = endereço da string com o número da conta
# Retorno:   $v0 = endereço base do cliente, ou 0 (NULL) se não encontrar
# -----------------------------------------------------------------
.globl encontrarCliente
encontrarCliente:
	# --- Prólogo (Salva $ra, $s0, $s1) ---
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp) 
	sw $s1, 8($sp)
	
	move $s0, $a0 				# $s0 = Ptr Conta (Input)
	
	li $t0, 0 					# $t0 = i (Índice para o loop)
	lw $t1, contador_clientes 	# $t1 = Limite de clientes
	la $t2, banco_clientes 		# $t2 = Endereço base do banco
	
encontrarLoop:
	bge $t0, $t1, naoEncontrado # Se i >= limite, interompe e retorna 0
	
	# Calcula o endereço em que o cliente[i] está armazenado
	li $t3, 6508 				# CORREÇÃO: SIZE_CLIENTE (6508)
	mul $t3, $t0, $t3			# $t3 = i * 6508 (Deslocamento)
	add $t3, $t2, $t3 			# $t3 = Endereço base do Cliente[i]
	
	# Preparação para a comparação de strings
	move $a0, $s0 				# $a0 = String da Conta (Input)
	
	# $a1 = Endereço da CONTA armazenada (Offset 76)
	addi $a1, $t3, 76 			
	
	jal strcmp				# Compara ($a0) vs (Cliente[i].conta)
	
	# Se $v0 == 0 (iguais), achou!
	beqz $v0, encontrado 
	
	# Dá sequência ao loop
	addi $t0, $t0, 1
	j encontrarLoop

encontrado:
	move $v0, $t3 			# $v0 = Endereço base do cliente
	j encontrarTerminar
	
naoEncontrado:
	move $v0, $zero 			# CORREÇÃO: Retorna 0 (NULL) em caso de falha
	
encontrarTerminar:
	# Restaura registradores
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $ra

# -----------------------------------------------------------------
# Função: encontrarClientePorCPF (BUSCA ADICIONAL)
# Acha um cliente usando o CPF (Offset 64).
# Argumento: $a0 = endereço da string com o CPF
# Retorno:   $v0 = endereço base do cliente, ou 0 (NULL) se não encontrar
# -----------------------------------------------------------------
.globl encontrarClientePorCPF
encontrarClientePorCPF:
	# --- Prólogo (Salva $ra, $s0, $s1) ---
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp) 
	
	move $s0, $a0 				# $s0 = Ptr CPF (Input)
	
	li $t0, 0 					# $t0 = i (Índice para o loop)
	lw $t1, contador_clientes 	
	la $t2, banco_clientes 		
	
loop_find_cpf:
	bge $t0, $t1, find_cpf_naoEncontrado 
	
	# Calcula o endereço do Cliente[i]
	li $t3, 6508 				# CORREÇÃO: SIZE_CLIENTE (6508)
	mul $t3, $t0, $t3
	add $t3, $t2, $t3 			# $t3 = Endereço base do Cliente[i]
	
	# Preparação para a comparação de strings
	move $a0, $s0 				# $a0 = String CPF (Input)
	
	# $a1 = Endereço do CPF armazenado (Offset 64)
	addi $a1, $t3, 64 			
	
	jal strcmp
	
	# Se $v0 == 0 (iguais), achou!
	beqz $v0, find_cpf_encontrado
	
	# Dá sequência ao loop
	addi $t0, $t0, 1
	j loop_find_cpf

find_cpf_encontrado:
	move $v0, $t3 				# Retorna o ponteiro do cliente
	j find_cpf_terminar
	
find_cpf_naoEncontrado:
	move $v0, $zero 			# Retorna 0 (NULL) 
	
find_cpf_terminar:
	# Restaura registradores
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
	
# -----------------------------------------------------------------
# Função: stringParaInteiro
# Converte uma string numérica em um inteiro
# Argumento: $a0 = endereço da string numérica
# Retorno:   $v0 = valor inteiro
# -----------------------------------------------------------------
.globl stringParaInteiro
stringParaInteiro:
    # --- Prólogo ---
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    
    move $s0, $a0           # $s0 = ponteiro da string
    li $v0, 0               # Inicializa o resultado com 0
    li $s1, 10              # $s1 = 10 (base decimal)

loop_string_para_int:
    lb $t0, 0($s0)          # Carrega um caractere
    beqz $t0, fim_string_para_int  # Se for null, termina
    blt $t0, 48, fim_string_para_int  # Se não for um dígito (ASCII < '0')
    bgt $t0, 57, fim_string_para_int  # Se não for um dígito (ASCII > '9')
    
    # Converte o caractere para inteiro
    subi $t0, $t0, 48       # $t0 = digito (0-9)
    
    # Multiplica o resultado atual por 10 e adiciona o novo dígito
    mul $v0, $v0, $s1
    add $v0, $v0, $t0
    
    addi $s0, $s0, 1        # Avança para o próximo caractere
    j loop_string_para_int

fim_string_para_int:
    # --- Epílogo ---
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra