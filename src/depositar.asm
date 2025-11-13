# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente ao comando depósito

.data
	msgSucessoDeposito: .asciiz "Depósito realizado com suceso.\n"
	
.text

.globl depositar
depositar:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	move $s2, $a1
	
	jal encontrarCliente
	beqz $v0, depositarTerminar
	move $s0, $v0
	
	move $a0, $s2
	jal stringParaInteiro
	move $s1, $v0
	
	lw $t0, 85($s0)
	add $t0, $t0, $s1
	sw $t0, 85($s0)
	
	la $a0, msgSucessoDeposito
	jal print_string_mmio
	
depositarTerminar:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra		
