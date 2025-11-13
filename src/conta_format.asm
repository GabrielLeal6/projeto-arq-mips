# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente ao comando de formatar conta


.data
	msgConfirmarFormat: .asciiz "Você tem certeza que deseja apagar? (s/n): "
	msgOkFormat:	    .asciiz "Transações apagadas com sucesso.\n"
	msgErroFormat:	    .asciiz "Erro: Conta não encontrada.\n"
	msgCancelarFormat:  .asciiz "Operação cancelada.\n"

.text

.globl
conta_format:
	addi $sp, $sp, 12
	sw $ra, 0($sp)
	sw $s0, 4($sp) # Armazena o endereço da conta
	sw $s1, 8($sp) # Armazena o endereço do cliente
	
	move $s0, $a0 # Guarda o endereço da conta
	
	jal encontrarCliente
	
	beqz $v0, contaFormatErro
	move $s1, $v0
	
	la $a0, msgConfirmarFormat
	jal print_string_mmio
	
	la $a0, input_buffer
	jal read_line_mmio
	
	lb $t0, input_buffer
	li $t1, 's'
	bne $t0, $t1, contaFormatCancelar
	
	add $t0, $s1, 76
	li $t1, 6400
	add $t1, $t0, $t1

contaFormatLoop:
	bge $t0, $t1, contaFormatZerar
	sw $zero, 0($t0)
	addi $t0, $t0, 4
	j contaFormatLoop
contaFormatZerar:
	la $a0, msgOkFormat
	jal print_string_mmio
	j contaFormatTerminar
	
contaFormatErro:
	la $a0, msgErroFormat
	jal print_string_mmio
	j contaFormatTerminar

contaFormatCancelar:
	la $a0, msgCancelarFormat
	jal print_string_mmio

contaFormatTerminar:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $ra
