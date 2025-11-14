.data
    msg_formatado: .asciiz "Sistema formatado. Use o comando 'salvar' para persistir as mudanças\n"
    
.text
.globl funcao_formatar
funcao_formatar:
    # --- Prólogo ---
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # 1. Zera o contador de clientes
    sw $zero, contador_clientes
    
    # 2. Limpa todo o banco de dados de forma segura
    la $t0, banco_clientes    # Início do banco
    li $t1, 325400            # Tamanho total em bytes
    add $t2, $t0, $t1         # Endereço final
    
limpar_loop:
    bge $t0, $t2, fim_limpeza
    sb $zero, 0($t0)          # Store byte para evitar problemas de alinhamento
    addi $t0, $t0, 1
    j limpar_loop

fim_limpeza:
    # 3. Imprime mensagem de confirmação
    la $a0, msg_formatado
    jal print_string_mmio
    
    # --- Epílogo ---
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra