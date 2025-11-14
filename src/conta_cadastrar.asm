# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente ao cadastro de contas no sistema (cmd_1)

.data
    # Strings de mensagens necessárias para o cadastro
    msgSucesso:   .asciiz "Cliente cadastrado com sucesso. Numero da conta " # Mensagem de sucesso no cadastro
    msgErroCPF:   .asciiz "Ja existe conta neste CPF.\n"                     # Mensagem de erro para CPF duplicado
    msgErroConta: .asciiz "Numero da conta ja em uso.\n"                     # Mensagem de erro para conta duplicada
    msgErroBancoCheio: .asciiz "Erro: Banco de dados cheio.\n"               # Mensagem de erro para banco cheio
    
    charHifen:    .asciiz "-"                                                # Caractere hífen para formatação

.text
# ----------------------------------------------------------------------
# Função: funcao_conta_cadastrar
# Argumentos: $a0=Ptr CPF, $a1=Ptr Conta, $a2=Ptr Nome
# ----------------------------------------------------------------------
.globl funcao_conta_cadastrar
funcao_conta_cadastrar:
    # --- Prólogo (Salva registradores $s) ---
    addi $sp, $sp, -24                                                       # Reserva 24 bytes na pilha
    sw $ra, 0($sp)                                                           # Salva endereço de retorno
    sw $s0, 4($sp)                                                           # $s0 = Ptr CPF (preserva argumento)
    sw $s1, 8($sp)                                                           # $s1 = Ptr Conta (preserva argumento)
    sw $s2, 12($sp)                                                          # $s2 = Ptr Nome (preserva argumento)
    sw $s3, 16($sp)                                                          # $s3 = Ptr Base do Novo Cliente
    sw $s4, 20($sp)                                                          # $s4 = Valor do limite
    
    # Salva os argumentos nos registradores preservados
    move $s0, $a0                                                            # Salva ponteiro do CPF em $s0
    move $s1, $a1                                                            # Salva ponteiro da Conta em $s1
    move $s2, $a2                                                            # Salva ponteiro do Nome em $s2

    # --- 1. Checar se o Banco está Cheio (R1) ---
    lw $t0, contador_clientes                                                # Carrega contador atual de clientes
    li $t1, 50                                                               # $t1 = limite máximo de clientes
    bge $t0, $t1, erro_banco_cheio                                           # Se contador >= 50, erro de banco cheio

    # --- 2. Checar Duplicata de CPF (R1) ---
    move $a0, $s0                                                            # $a0 = Ptr CPF para verificação
    jal encontrarClienteCPF                                               # Chama função para buscar CPF existente
    bnez $v0, erro_cpf                                                       # Se retorno ≠ 0, CPF já existe
    
    # --- 3. Checar Duplicata de Conta (R1) ---
    move $a0, $s1                                                            # $a0 = Ptr Conta para verificação
    jal encontrarCliente                                                     # Chama função para buscar conta existente
    bnez $v0, erro_conta                                                     # Se retorno ≠ 0, conta já existe

    # --- 4. Criar o cliente. ---
    
    # 4a. Calcular o endereço do novo cliente
    lw $t0, contador_clientes                                                # $t0 = índice do novo cliente
    la $t1, banco_clientes                                                   # $t1 = endereço base do banco
    li $t2, 6508                                                             # $t2 = tamanho de cada cliente (6508 bytes)
    mul $t0, $t0, $t2                                                        # $t0 = offset = índice × tamanho_cliente
    add $s3, $t1, $t0                                                        # $s3 = endereço do novo cliente

    # 4b. Salvar Nome (R1)
    move $a0, $s3                                                            # $a0 = destino (campo nome do cliente)
    move $a1, $s2                                                            # $a1 = origem (nome fornecido)
    jal strcpy                                                               # Copia nome para estrutura do cliente

    # 4c. Salvar CPF (R1)
    la $a0, ($s3)                                                            # $a0 = endereço base do cliente
    addi $a0, $a0, 64                                                        # $a0 = destino (offset 64 = campo CPF)
    move $a1, $s0                                                            # $a1 = origem (CPF fornecido)
    jal strcpy                                                               # Copia CPF para estrutura do cliente

    # 4d. Calcular DV (R1)
    move $a0, $s1                                                            # $a0 = ponteiro para número da conta
    jal calcularDV                                                           # Calcula dígito verificador
    move $t4, $v0                                                            # $t4 = dígito verificador calculado

    # 4e. Salvar a Conta (Formato XXXXXX-X)
    la $t5, ($s3)                                                            # $t5 = endereço base do cliente
    addi $t5, $t5, 76                                                        # $t5 = destino (offset 76 = campo conta)
    
    move $a0, $t5                                                            # $a0 = destino para cópia
    move $a1, $s1                                                            # $a1 = origem (6 dígitos da conta)
    jal strcpy                                                               # Copia 6 dígitos para campo conta

    # Adiciona "-X\0" para completar formatação XXXXXX-X
    addi $t5, $t5, 6                                                         # Avança 6 bytes (pula os dígitos copiados)
    li $t6, '-'                                                              # $t6 = caractere hífen
    sb $t6, 0($t5)                                                           # Armazena hífen na posição 7
    sb $t4, 1($t5)                                                           # Armazena dígito verificador na posição 8
    sb $zero, 2($t5)                                                         # Armazena null terminator na posição 9

    # 4f. Inicializar Campos (R2, R3) - Usando store não alinhado
    li $s4, 150000                                                           # $s4 = R$ 1500.00 (limite padrão em centavos)
    
    # Salva Saldo (Offset 88) - CORRIGIDO para offsets alinhados
    addi $a0, $s3, 88                                                        # $a0 = endereço do campo saldo
    li $a1, 0                                                                # $a1 = valor zero para saldo inicial
    jal store_word_unaligned                                                 # Armazena saldo inicial

    # Salva Limite (Offset 92) - CORRIGIDO para offsets alinhados
    addi $a0, $s3, 92                                                        # $a0 = endereço do campo limite
    move $a1, $s4                                                            # $a1 = valor do limite (150000)
    jal store_word_unaligned                                                 # Armazena limite

    # Salva Dívida (Offset 96) - CORRIGIDO para offsets alinhados
    addi $a0, $s3, 96                                                        # $a0 = endereço do campo dívida
    li $a1, 0                                                                # $a1 = valor zero para dívida inicial
    jal store_word_unaligned                                                 # Armazena dívida inicial

    # Salva Idx_Debito (Offset 100) - CORRIGIDO para offsets alinhados
    addi $a0, $s3, 100                                                       # $a0 = endereço do campo índice débito
    li $a1, 0                                                                # $a1 = valor zero para índice inicial
    jal store_word_unaligned                                                 # Armazena índice débito

    # Salva Idx_Credito (Offset 104) - CORRIGIDO para offsets alinhados
    addi $a0, $s3, 104                                                       # $a0 = endereço do campo índice crédito
    li $a1, 0                                                                # $a1 = valor zero para índice inicial
    jal store_word_unaligned                                                 # Armazena índice crédito

    # 4g. Incrementar contador de clientes
    lw $t0, contador_clientes                                                # Carrega contador atual
    addi $t0, $t0, 1                                                         # Incrementa contador
    sw $t0, contador_clientes                                                # Armazena novo valor do contador
    
    # --- 4h. Imprimir Sucesso (R1) ---
    la $a0, msgSucesso                                                       # Carrega mensagem de sucesso
    jal print_string_mmio                                                    # Imprime mensagem inicial
    # Imprime a conta (XXXXXX-X)
    la $a0, ($s3)                                                            # Carrega endereço base do cliente
    addi $a0, $a0, 76                                                        # $a0 = endereço do campo conta
    jal print_string_mmio                                                    # Imprime número da conta formatado
    j cadastro_fim                                                           # Salta para final do cadastro

erro_banco_cheio:
    la $a0, msgErroBancoCheio                                                # Carrega mensagem de banco cheio
    jal print_string_mmio                                                    # Imprime mensagem de erro
    j cadastro_fim                                                           # Salta para final do cadastro

erro_cpf:
    la $a0, msgErroCPF                                                       # Carrega mensagem de CPF duplicado
    jal print_string_mmio                                                    # Imprime mensagem de erro
    j cadastro_fim                                                           # Salta para final do cadastro

erro_conta:
    la $a0, msgErroConta                                                     # Carrega mensagem de conta duplicada
    jal print_string_mmio                                                    # Imprime mensagem de erro
    j cadastro_fim                                                           # Salta para final do cadastro

cadastro_fim:
    # --- Epílogo ---
    lw $ra, 0($sp)                                                           # Restaura endereço de retorno
    lw $s0, 4($sp)                                                           # Restaura $s0 (Ptr CPF)
    lw $s1, 8($sp)                                                           # Restaura $s1 (Ptr Conta)
    lw $s2, 12($sp)                                                          # Restaura $s2 (Ptr Nome)
    lw $s3, 16($sp)                                                          # Restaura $s3 (Ptr Base Cliente)
    lw $s4, 20($sp)                                                          # Restaura $s4 (Valor Limite)
    addi $sp, $sp, 24                                                        # Libera espaço na pilha
    jr $ra                                                                   # Retorna para chamador

# ----------------------------------------------------------------------
# Função: calcularDV (Cálculo do Dígito Verificador - R1)
# ----------------------------------------------------------------------
.globl calcularDV
calcularDV:
    move $t0, $a0                                                            # $t0 = ponteiro para número da conta
    li $s0, 0                                                                # $s0 = acumulador para cálculo
    
    # Calcula: (d5×2) + (d4×3) + (d3×4) + (d2×5) + (d1×6) + (d0×7)
    lb $t1, 5($t0)                                                           # Carrega dígito 5 (menos significativo)
    subi $t2, $t1, 48                                                        # Converte ASCII para inteiro
    li $t3, 2                                                                # $t3 = peso 2
    mul $t2, $t2, $t3                                                        # d5 × 2
    add $s0, $s0, $t2                                                        # Adiciona ao acumulador
    
    lb $t1, 4($t0)                                                           # Carrega dígito 4
    subi $t2, $t1, 48                                                        # Converte ASCII para inteiro
    li $t3, 3                                                                # $t3 = peso 3
    mul $t2, $t2, $t3                                                        # d4 × 3
    add $s0, $s0, $t2                                                        # Adiciona ao acumulador
    
    lb $t1, 3($t0)                                                           # Carrega dígito 3
    subi $t2, $t1, 48                                                        # Converte ASCII para inteiro
    li $t3, 4                                                                # $t3 = peso 4
    mul $t2, $t2, $t3                                                        # d3 × 4
    add $s0, $s0, $t2                                                        # Adiciona ao acumulador
    
    lb $t1, 2($t0)                                                           # Carrega dígito 2
    subi $t2, $t1, 48                                                        # Converte ASCII para inteiro
    li $t3, 5                                                                # $t3 = peso 5
    mul $t2, $t2, $t3                                                        # d2 × 5
    add $s0, $s0, $t2                                                        # Adiciona ao acumulador
    
    lb $t1, 1($t0)                                                           # Carrega dígito 1
    subi $t2, $t1, 48                                                        # Converte ASCII para inteiro
    li $t3, 6                                                                # $t3 = peso 6
    mul $t2, $t2, $t3                                                        # d1 × 6
    add $s0, $s0, $t2                                                        # Adiciona ao acumulador
    
    lb $t1, 0($t0)                                                           # Carrega dígito 0 (mais significativo)
    subi $t2, $t1, 48                                                        # Converte ASCII para inteiro
    li $t3, 7                                                                # $t3 = peso 7
    mul $t2, $t2, $t3                                                        # d0 × 7
    add $s0, $s0, $t2                                                        # Adiciona ao acumulador
    
    li $t2, 11                                                               # $t2 = divisor 11
    div $s0, $t2                                                             # Divide acumulador por 11
    mfhi $s0                                                                 # $s0 = resto da divisão
    
    li $t2, 10                                                               # $t2 = 10 para comparação
    bne $s0, $t2, resto_nao_dez                                              # Se resto ≠ 10, salta
    
    li $v0, 'X'                                                              # Se resto = 10, DV = 'X'
    jr $ra                                                                   # Retorna

resto_nao_dez:
    addi $v0, $s0, 48                                                        # Converte resto para ASCII (0-9)
    jr $ra                                                                   # Retorna

# ----------------------------------------------------------------------
# Função: store_word_unaligned
# Armazena uma word em endereço potencialmente não alinhado
# Argumentos: $a0 = endereço, $a1 = valor
# ----------------------------------------------------------------------
store_word_unaligned:
    sb $a1, 0($a0)                                                           # Salva byte 0 (menos significativo)
    srl $a1, $a1, 8                                                          # Shift 8 bits para a direita
    sb $a1, 1($a0)                                                           # Salva byte 1
    srl $a1, $a1, 8                                                          # Shift 8 bits para a direita
    sb $a1, 2($a0)                                                           # Salva byte 2
    srl $a1, $a1, 8                                                          # Shift 8 bits para a direita
    sb $a1, 3($a0)                                                           # Salva byte 3 (mais significativo)
    jr $ra                                                                   # Retorna