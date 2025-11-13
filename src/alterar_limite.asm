# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente ao comando de alterar limite

.data
	msgSucessoLimite: .asciiz "Limite alterado com suceso.\n"
	
.text

.globl alterar_limite
alterar_limite:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	jal encontrarCliente
	beqz $v0, limiteTerminar
	move $s0, $v0
	
	move $a0, $s2
	jal stringParaInteiro
	move $s0, $v0
	
	sw $s1, 89($s0)
	
	la $a0, msgSucessoLimite
	jal print_string_mmio
	
limiteTerminar:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra	