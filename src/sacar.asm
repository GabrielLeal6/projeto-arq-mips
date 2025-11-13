# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente ao comando saque

.data
	msgSucessoSaque: .asciiz "Saque realizado com sucesso.\n"
	msgErro:	 .asciiz "Erro: Saldo insuficiente.\n"
	
.text

.globl sacar
sacar:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	move $s2, $a1
	
	jal encontrarCliente
	
	beqz $v0, sacarTerminar
	move $s0, $v0 
	
	move $a0, $s2
	jal stringParaInteiro
	move $s1, $v0
	
	lw $t0, 85($s0)
	
	slt $t1, $t0, $s1
	bnez $t1, sacarErro
	
	sub $t0, $t0, $s1 
	sw $t0, 85($s0)
	
	la $a0, msgSucessoSaque
	jal print_string_mmio
	j sacarTerminar

sacarErro:
	la $a0, msgErro
	jal print_string_mmio
	
sacarTerminar:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra	