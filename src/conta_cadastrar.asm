# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente ao cadastro de contas no sistema (cmd_1)

.data
    #Strings de mensagens necessárias
    msgSucesso:   .asciiz "Cliente cadastrado com sucesso. Numero da conta "
    msgErroCPF:   .asciiz "Ja existe conta neste CPF.\n"
    msgErroConta: .asciiz "Numero da conta ja em uso.\n"
    msgErroBancoCheio: .asciiz "Erro: Banco de dados cheio.\n"
    
    charHifen:    .asciiz "-"
    
    buffer_temp: .space 16

.text
# ----------------------------------------------------------------------
# Função: funcao_conta_cadastrar
# Argumentos: $a0=Ptr CPF, $a1=Ptr Conta, $a2=Ptr Nome
# ----------------------------------------------------------------------
.globl funcao_conta_cadastrar
funcao_conta_cadastrar:
    	# --- Prólogo (Salva registradores $s) ---
    	addi $sp, $sp, -20
    	sw $ra, 0($sp)
    	sw $s0, 4($sp) # $s0 = Ptr CPF
    	sw $s1, 8($sp) # $s1 = Ptr Conta
    	sw $s2, 12($sp) # $s2 = Ptr Nome
    	sw $s3, 16($sp) # $s3 = Ptr Base do Novo Cliente
    
    	# Salva os argumentos
    	move $s0, $a0
    	move $s1, $a1
   	move $s2, $a2

    	# --- 1. Checar se o Banco está Cheio (R1) ---
    	lw $t0, contador_clientes
    	li $t1, 50
    	bge $t0, $t1, erro_banco_cheio

    	# --- 2. Checar Duplicata de CPF (R1) ---
    	move $a0, $s0           # $a0 = Ptr CPF
    	jal encontrarClientePorCPF 
    	bnez $v0, erro_cpf 
    
	# --- 3. Checar Duplicata de Conta (R1) ---
	# Precisamos verificar se já existe alguma conta com os mesmos 6 dígitos
	la $t0, buffer_temp
	move $a0, $t0
	move $a1, $s1           # Copia os 6 dígitos da conta
	jal strcpy

	# Busca por clientes com mesma conta (usando strncmp para comparar apenas 6 caracteres)
	move $a0, $s1           # $a0 = 6 dígitos da conta
	li $a1, 0               # índice
	la $a2, banco_clientes
	lw $a3, contador_clientes
	jal verificarContaExistente
	bnez $v0, erro_conta
    	# --- 4. Criar o cliente. ---
    
    	# 4a. Calcular o endereço do novo cliente
    	lw $t0, contador_clientes   # $t0 = índice (ex: 0)
    	la $t1, banco_clientes
    	li $t2, 6508              # CORREÇÃO: SIZE_CLIENTE numérico (para alinhamento)
    	mul $t0, $t0, $t2         
    	add $s3, $t1, $t0         # $s3 = Endereço Base do Novo Cliente

    	# 4b. Salvar Nome (R1)
    	move $a0, $s3             # Destino: Base + 0
    	move $a1, $s2             # Origem: Ptr Nome
    	jal strcpy

    	# 4c. Salvar CPF (R1)
    	la $a0, ($s3)
    	addi $a0, $a0, 64         # Destino: Base + 64 (Offset do CPF)
    	move $a1, $s0             # Origem: Ptr CPF
    	jal strcpy

    	# 4d. Calcular DV (R1)
    	move $a0, $s1             # Passa o Ptr Conta ("765432") para calcularDV
    	jal calcularDV
    	move $t4, $v0             # Salva o char DV (ex: 'X') em $t4

    	# 4e. Salvar a Conta (Formato XXXXXX-X)
    	la $t5, ($s3)
    	addi $t5, $t5, 76         # $t5 = Ponteiro para o campo da conta (Offset 76)
    
    	move $a0, $t5             # $a0 = Destino
    	move $a1, $s1             # $a1 = Origem ("765432")
    	jal strcpy                # Copia "765432" para o campo (6 bytes + \0)

    	# Adiciona "-X\0"
    	addi $t5, $t5, 6          # Avança 6 bytes (pula o "765432")
    	li $t6, '-'
    	sb $t6, 0($t5)            # Salva '-' (no 7º byte)
    	sb $t4, 1($t5)            # Salva o DV (no 8º byte)
    	sb $zero, 2($t5)          # Salva o \0 final (no 9º byte)

    	# 4f. Inicializar Campos (R2, R3) - (Offsets Alinhados)
    	li $t0, 150000            # R$ 1500.00 (Limite Padrão R2)
    	sw $zero, 88($s3)         # Salva Saldo (Offset 88)
    	sw $t0, 92($s3)           # Salva Limite (Offset 92)
    	sw $zero, 96($s3)         # Salva Dívida (Offset 96)
    	sw $zero, 100($s3)        # Salva Idx_Debito (Offset 100)
    	sw $zero, 104($s3)        # Salva Idx_Credito (Offset 104)

    	# 4g. Incrementar contador de clientes
    	lw $t0, contador_clientes
    	addi $t0, $t0, 1
    	sw $t0, contador_clientes
    
    	# --- 4h. Imprimir Sucesso (R1) ---
    	la $a0, msgSucesso
    	jal print_string_mmio
    	# Imprime a conta (XXXXXX-X)
    	la $a0, ($s3)
    	addi $a0, $a0, 76         # $a0 = Ptr da Conta (Offset 76)
    	jal print_string_mmio
    	# (Adicione um print_linebreak aqui se necessário)
    	j cadastro_fim

erro_banco_cheio:
  	la $a0, msgErroBancoCheio
    	jal print_string_mmio
    	j cadastro_fim

erro_cpf:
    	la $a0, msgErroCPF
    	jal print_string_mmio
    	j cadastro_fim

erro_conta:
    la $a0, msgErroConta
    jal print_string_mmio
    j cadastro_fim

cadastro_fim:
    # --- Epílogo ---
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    addi $sp, $sp, 20
    jr $ra

# ----------------------------------------------------------------------
# Função: encontrarClientePorCPF (Função de Busca Faltante)
# ----------------------------------------------------------------------


# ----------------------------------------------------------------------
# Função: calcularDV (Cálculo do Dígito Verificador - R1)
# ----------------------------------------------------------------------
.globl calcularDV
calcularDV:
    move $t0, $a0
    li $s0, 0 
    
    lb $t1, 5($t0) 
    subi $t2, $t1, 48 
    li $t3, 2
    mul $t2, $t2, $t3
    add $s0, $s0, $t2 
    
    lb $t1, 4($t0) 
    subi $t2, $t1, 48 
    li $t3, 3
    mul $t2, $t2, $t3
    add $s0, $s0, $t2 
    
    lb $t1, 3($t0) 
    subi $t2, $t1, 48 
    li $t3, 4
    mul $t2, $t2, $t3
    add $s0, $s0, $t2 
    
    lb $t1, 2($t0) 
    subi $t2, $t1, 48 
    li $t3, 5
    mul $t2, $t2, $t3
    add $s0, $s0, $t2 
    
    lb $t1, 1($t0) 
    subi $t2, $t1, 48 
    li $t3, 6
    mul $t2, $t2, $t3
    add $s0, $s0, $t2 
    
    lb $t1, 0($t0) 
    subi $t2, $t1, 48 
    li $t3, 7
    mul $t2, $t2, $t3
    add $s0, $s0, $t2 
    
    li $t2, 11
    div $s0, $t2
    mfhi $s0 
    
    li $t2, 10
    bne $s0, $t2, resto_nao_dez
    
    li $v0, 'X'
    jr $ra

resto_nao_dez:
    addi $v0, $s0, 48
    jr $ra
    
   # ----------------------------------------------------------------------
# Função: verificarContaExistente
# Verifica se já existe uma conta com os mesmos 6 primeiros dígitos
# ----------------------------------------------------------------------
verificarContaExistente:
    # $a0 = 6 dígitos da conta, $a1 = índice, $a2 = banco, $a3 = contador
    move $t0, $a1
    move $t1, $a3
    move $t2, $a2
    move $t3, $a0
    
verificar_loop:
    bge $t0, $t1, verificar_nao_encontrado
    
    # Calcula endereço do cliente
    li $t4, 6508
    mul $t5, $t0, $t4
    add $t5, $t2, $t5
    
    # Compara os 6 primeiros dígitos da conta
    addi $a0, $t5, 76      # Campo conta do cliente
    move $a1, $t3          # 6 dígitos da nova conta
    li $a2, 6              # Compara apenas 6 caracteres
    jal strncmp
    
    beqz $v0, verificar_encontrado
    
    addi $t0, $t0, 1
    j verificar_loop

verificar_encontrado:
    li $v0, 1
    jr $ra

verificar_nao_encontrado:
    li $v0, 0
    jr $ra