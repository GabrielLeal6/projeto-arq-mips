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
    addi $sp, $sp, -24      # aloca 24 bytes na pilha
    sw $ra, 0($sp)          # salva o endereço de retorno
    sw $s0, 4($sp)          # salva $s0 (para Ptr CPF)
    sw $s1, 8($sp)          # salva $s1 (para Ptr Conta)
    sw $s2, 12($sp)         # salva $s2 (para Ptr Nome)
    sw $s3, 16($sp)         # salva $s3 (para Ptr Base do Novo Cliente)
    sw $s4, 20($sp)         # salva $s4 (para Valor do limite)
    
    # Salva os argumentos nos registradores $s
    move $s0, $a0           # move o Ptr CPF ($a0) para $s0
    move $s1, $a1           # move o Ptr Conta ($a1) para $s1
    move $s2, $a2           # move o Ptr Nome ($a2) para $s2

    # --- 1. Checar se o Banco está Cheio (R1) ---
    lw $t0, contador_clientes # carrega o número atual de clientes
    li $t1, 50                # carrega o limite (50)
    bge $t0, $t1, erro_banco_cheio # se contador >= 50, pula para erro

    # --- 2. Checar Duplicata de CPF (R1) ---
    move $a0, $s0           # $a0 = Ptr CPF (argumento para a busca)
    jal encontrarClientePorCPF # invoca a função de busca por CPF
    bnez $v0, erro_cpf      # se $v0 != 0 (cliente encontrado), pula para erro_cpf
    
    # --- 3. Checar Duplicata de Conta (R1) ---
    # Precisamos verificar se já existe alguma conta com os mesmos 6 dígitos
    la $t0, buffer_temp     # carrega o endereço do buffer temporário
    move $a0, $t0           # $a0 = destino da cópia
    move $a1, $s1           # $a1 = origem (Ptr Conta)
    jal strcpy              # copia a string da conta para o buffer

    # Busca por clientes com mesma conta (usando strncmp para comparar apenas 6 caracteres)
    move $a0, $s1           # $a0 = 6 dígitos da conta (Ptr Conta)
    li $a1, 0               # $a1 = índice inicial (0)
    la $a2, banco_clientes
    lw $a3, contador_clientes
    jal verificarContaExistente # invoca a função de verificação (baseada em strncmp)
    bnez $v0, erro_conta    # se $v0 != 0 (conta já existe), pula para erro_conta

    # --- 4. Criar o cliente. ---
    
    # 4a. Calcular o endereço do novo cliente
    lw $t0, contador_clientes   # $t0 = índice (ex: 0)
    la $t1, banco_clientes    # $t1 = endereço base do banco
    li $t2, 6508              # carrega o tamanho de 1 cliente (SIZE_CLIENTE)
    mul $t0, $t0, $t2         # calcula o deslocamento (offset)
    add $s3, $t1, $t0         # $s3 = Endereço Base do Novo Cliente
    
    # 4b. Salvar Nome (R1)
    move $a0, $s3             # $a0 = Destino (Base + 0)
    move $a1, $s2             # $a1 = Origem (Ptr Nome)
    jal strcpy                # invoca a função strcpy

    # 4c. Salvar CPF (R1)
    la $a0, ($s3)             # carrega o endereço base do cliente
    addi $a0, $a0, 64         # $a0 = Destino (Base + 64, Offset do CPF)
    move $a1, $s0             # $a1 = Origem (Ptr CPF)
    jal strcpy                # invoca a função strcpy

    # 4d. Calcular DV (R1)
    move $a0, $s1             # $a0 = Ptr Conta ("765432")
    jal calcularDV            # invoca a função de cálculo do DV
    move $t4, $v0             # salva o caractere DV (ex: 'X') em $t4

    # 4e. Salvar a Conta (Formato XXXXXX-X)
    la $t5, ($s3)
    addi $t5, $t5, 76         # $t5 = Ponteiro para o campo da conta (Offset 76)
    
    move $a0, $t5             # $a0 = Destino
    move $a1, $s1             # $a1 = Origem ("765432")
    jal strcpy                # copia "765432" para o campo
    
    # Adiciona "-X\0"
    addi $t5, $t5, 6          # avança o ponteiro 6 bytes (para o fim de "765432")
    li $t6, '-'
    sb $t6, 0($t5)            # salva o caractere '-'
    sb $t4, 1($t5)            # salva o caractere DV
    sb $zero, 2($t5)          # salva o terminador nulo ('\0')

    # 4f. Inicializar Campos (R2, R3) - Usando store não alinhado
    li $s4, 150000            # carrega o Limite Padrão (1500.00) em $s4
    
    # Salva Saldo (Offset 88)
    addi $a0, $s3, 88         # $a0 = Endereço (Base + 88)
    li $a1, 0                 # $a1 = Valor (0)
    jal store_word_unaligned  # invoca a função de salvar 4 bytes (não alinhado)

    # Salva Limite (Offset 92)  
    addi $a0, $s3, 92
    move $a1, $s4             # $a1 = Valor (150000)
    jal store_word_unaligned

    # Salva Dívida (Offset 96)
    addi $a0, $s3, 96
    li $a1, 0
    jal store_word_unaligned

    # Salva Idx_Debito (Offset 100)
    addi $a0, $s3, 100
    li $a1, 0
    jal store_word_unaligned

    # Salva Idx_Credito (Offset 104)
    addi $a0, $s3, 104
    li $a1, 0
    jal store_word_unaligned

    # 4g. Incrementar contador de clientes
    lw $t0, contador_clientes
    addi $t0, $t0, 1
    sw $t0, contador_clientes # salva o novo contador (contador + 1)
    
    # --- 4h. Imprimir Sucesso (R1) ---
    la $a0, msgSucesso
    jal print_string_mmio     # imprime a mensagem de sucesso
    # Imprime a conta (XXXXXX-X)
    la $a0, ($s3)
    addi $a0, $a0, 76         # $a0 = Ptr da Conta (Offset 76)
    jal print_string_mmio     # imprime a string da conta
    j cadastro_fim

erro_banco_cheio:
    la $a0, msgErroBancoCheio # carrega a msg de erro (banco cheio)
    jal print_string_mmio     # imprime a mensagem
    j cadastro_fim

erro_cpf:
    la $a0, msgErroCPF        # carrega a msg de erro (CPF duplicado)
    jal print_string_mmio     # imprime a mensagem
    j cadastro_fim

erro_conta:
    la $a0, msgErroConta      # carrega a msg de erro (Conta duplicada)
    jal print_string_mmio     # imprime a mensagem
    j cadastro_fim

cadastro_fim:
    # --- Epílogo ---
    lw $ra, 0($sp)            # restaura o endereço de retorno
    lw $s0, 4($sp)            # restaura $s0
    lw $s1, 8($sp)            # restaura $s1
    lw $s2, 12($sp)           # restaura $s2
    lw $s3, 16($sp)           # restaura $s3
    lw $s4, 20($sp)           # restaura $s4
    addi $sp, $sp, 24         # libera 24 bytes da pilha
    jr $ra                    # retorna para o main_loop

# ----------------------------------------------------------------------
# Função: calcularDV (Cálculo do Dígito Verificador - R1)
# ----------------------------------------------------------------------
.globl calcularDV
calcularDV:
    move $t0, $a0           # $t0 = ponteiro para a string da conta
    li $s0, 0               # $s0 = acumulador
    
    lb $t1, 5($t0)          # carrega d0 (char)
    subi $t2, $t1, 48       # $t2 = d0 (int)
    li $t3, 2
    mul $t2, $t2, $t3       # $t2 = d0 * 2
    add $s0, $s0, $t2       # acumula
    
    lb $t1, 4($t0)          # carrega d1
    subi $t2, $t1, 48
    li $t3, 3
    mul $t2, $t2, $t3
    add $s0, $s0, $t2
    
    lb $t1, 3($t0)          # carrega d2
    subi $t2, $t1, 48
    li $t3, 4
    mul $t2, $t2, $t3
    add $s0, $s0, $t2
    
    lb $t1, 2($t0)          # carrega d3
    subi $t2, $t1, 48
    li $t3, 5
    mul $t2, $t2, $t3
    add $s0, $s0, $t2
    
    lb $t1, 1($t0)          # carrega d4
    subi $t2, $t1, 48
    li $t3, 6
    mul $t2, $t2, $t3
    add $s0, $s0, $t2
    
    lb $t1, 0($t0)          # carrega d5
    subi $t2, $t1, 48
    li $t3, 7
    mul $t2, $t2, $t3
    add $s0, $s0, $t2
    
    # Calcula o resto
    li $t2, 11
    div $s0, $t2
    mfhi $s0                # $s0 = resto
    
    # Checa o caso 10
    li $t2, 10
    bne $s0, $t2, resto_nao_dez # se resto != 10, pula
    
    li $v0, 'X'             # $v0 = 'X' (se resto == 10)
    jr $ra

resto_nao_dez:
    addi $v0, $s0, 48       # $v0 = char(resto + 48)
    jr $ra

# ----------------------------------------------------------------------
# Função: verificarContaExistente
# Verifica se já existe uma conta com os mesmos 6 primeiros dígitos
# ----------------------------------------------------------------------
verificarContaExistente:
    # $a0 = Ptr Conta (Input), $a1 = i (índice), $a2 = banco_clientes, $a3 = contador
    move $t0, $a1           # $t0 = i (índice)
    move $t1, $a3           # $t1 = limite (contador_clientes)
    move $t2, $a2           # $t2 = banco_clientes
    move $t3, $a0           # $t3 = Ptr Conta (Input)
    
verificar_loop:
    bge $t0, $t1, verificar_nao_encontrado # se i >= limite, fim
    
    # Calcula endereço do cliente
    li $t4, 6508            # $t4 = SIZE_CLIENTE
    mul $t5, $t0, $t4       # $t5 = offset
    add $t5, $t2, $t5       # $t5 = Endereço Cliente[i]
    
    # Compara os 6 primeiros dígitos da conta
    addi $a0, $t5, 76       # $a0 = Ptr Conta Armazenada (Offset 76)
    move $a1, $t3           # $a1 = Ptr Conta (Input)
    li $a2, 6               # $a2 = 6 (comprimento)
    jal strncmp
    
    beqz $v0, verificar_encontrado # se 0 (iguais), pula
    
    addi $t0, $t0, 1        # i++
    j verificar_loop

verificar_encontrado:
    li $v0, 1               # retorna 1 (encontrado)
    jr $ra

verificar_nao_encontrado:
    li $v0, 0               # retorna 0 (não encontrado)
    jr $ra

# ----------------------------------------------------------------------
# Função: store_word_unaligned
# Armazena uma word em endereço potencialmente não alinhado
# Argumentos: $a0 = endereço, $a1 = valor
# ----------------------------------------------------------------------
store_word_unaligned:
    sb $a1, 0($a0)          # salva byte 0 (menos significativo)
    srl $a1, $a1, 8         # shift 8 bits para a direita
    sb $a1, 1($a0)          # salva byte 1
    srl $a1, $a1, 8
    sb $a1, 2($a0)          # salva byte 2
    srl $a1, $a1, 8
    sb $a1, 3($a0)          # salva byte 3 (mais significativo)
    jr $ra