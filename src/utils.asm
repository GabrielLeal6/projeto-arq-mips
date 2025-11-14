# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente a funções gerais que serão usadas no projeto

.data
    # Mensagens removidas para evitar interferência na saída do programa

.text

# -----------------------------------------------------------------
# Função: encontrarCliente (Busca por CONTA)
# Argumento: $a0 = endereço da string com o número da conta (6 dígitos)
# Retorno:   $v0 = endereço base do cliente, ou 0 (NULL) se não encontrar
# -----------------------------------------------------------------
.globl encontrarCliente
encontrarCliente:
    # --- Prólogo ---
    addi $sp, $sp, -12
    sw $ra, 0($sp)          # Salva o endereço de retorno
    sw $s0, 4($sp)          # Salva $s0 (para o Ptr da Conta)
    sw $s1, 8($sp)          # Salva $s1 (para o Ptr do Cliente[i])
    
    move $s0, $a0           # $s0 = Ptr Conta (Input)
    
    li $t0, 0               # $t0 = i (Índice)
    lw $t1, contador_clientes # $t1 = Limite
    la $t2, banco_clientes    # $t2 = Endereço Base do Banco
    
encontrarLoop:
    bge $t0, $t1, naoEncontrado # Se i >= limite, Fim
    
    # Calcula o endereço do Cliente[i]
    li $s1, 6508            # SIZE_CLIENTE correto
    mul $s1, $t0, $s1       # $s1 = i * 6508 (Offset)
    add $s1, $t2, $s1       # $s1 = Endereço Base Cliente[i]
    
    # Prepara para comparação de strings
    move $a0, $s0           # $a0 = Ptr Conta (Input, ex: "123123")
    addi $a1, $s1, 76       # $a1 = Endereço da Conta Armazenada (Offset 76)
    li $a3, 6               # CORREÇÃO: n=6 em $a3 (strncmp espera n em $a3)
    jal strncmp             # Compara apenas os primeiros 6 dígitos
    
    beqz $v0, encontrado    # Se 0 (iguais), achou
    
    addi $t0, $t0, 1
    j encontrarLoop

encontrado:
    move $v0, $s1           # $v0 = Endereço do cliente
    j encontrarTerminar
    
naoEncontrado:
    move $v0, $zero         # Retorna 0 (NULL) em caso de falha
    
encontrarTerminar:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

# -----------------------------------------------------------------
# Função: encontrarClientePorCPF (Busca por CPF)
# Argumento: $a0 = endereço da string com o CPF
# Retorno:   $v0 = endereço base do cliente, ou 0 (NULL) se não encontrar
# -----------------------------------------------------------------
.globl encontrarClienteCPF
encontrarClienteCPF:
    # --- Prólogo ---
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    
    move $s0, $a0           # $s0 = Ptr CPF (Input)
    
    li $t0, 0               # $t0 = i (Índice)
    lw $t1, contador_clientes
    la $t2, banco_clientes

encontrarCPFLoop:
    bge $t0, $t1, CPFNaoEncontrado
    
    # Calcula o endereço do Cliente[i]
    li $s1, 6508            # SIZE_CLIENTE correto
    mul $s1, $t0, $s1
    add $s1, $t2, $s1       # $s1 = Endereço Base Cliente[i]

    # Prepara para comparação de strings
    move $a0, $s0           # $a0 = Ptr CPF (Input)
    addi $a1, $s1, 64       # $a1 = Ptr CPF Armazenado (Offset 64)
    jal strcmp
    
    beqz $v0, CPFEncontrado
    
    addi $t0, $t0, 1
    j encontrarCPFLoop

CPFEncontrado:
    move $v0, $s1           # $v0 = Endereço do cliente
    j encontrarCPFTerminar
        
CPFNaoEncontrado:
    move $v0, $zero         # Retorna 0 (NULL)
    
encontrarCPFTerminar:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

# -----------------------------------------------------------------
# Função: stringParaInteiro (atoi)
# -----------------------------------------------------------------
.globl stringParaInteiro
stringParaInteiro:
    # --- Prólogo ---
    addi $sp, $sp, -8
    sw $t0, 0($sp)      # Salva $t0 (dígito)
    sw $t1, 4($sp)      # Salva $t1 (multiplicador 10)
    
    li $v0, 0           # $v0 = resultado = 0
    li $t1, 10          # $t1 = 10 (para multiplicação)

conversorLoop:
    lb $t0, 0($a0)      # Carrega o próximo dígito
    
    # Pula caracteres não numéricos
    blt $t0, '0', conversorTerminar
    bgt $t0, '9', conversorTerminar
    
    subi $t0, $t0, 48   # Converte char '0'-'9' para int 0-9
    
    mul $v0, $v0, $t1   # resultado *= 10
    add $v0, $v0, $t0   # resultado += digito
    
    addi $a0, $a0, 1    # Avança o ponteiro da string
    j conversorLoop

conversorTerminar:
    # --- Epílogo ---
    lw $t0, 0($sp)      # Restaura $t0
    lw $t1, 4($sp)      # Restaura $t1
    addi $sp, $sp, 8
    jr $ra