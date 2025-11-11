inicio_strcpy: # entrada da função strcpy
	move $v0, $a0 # retorna o endereço de destino para o registrador $v0

loop_strcpy: # label de loop da função strcpy
	lb $t0, 0($a1) # carrega o byte do endereço de origem para $t0
	sb $t0, 0($a0) # salva o byte de $t0 para o endereço de destino $a0
	beq $t0, $zero, fim_strcpy # checa pelo fim da string, caso encerrada pula para o label de fim da função
	addi $a1, $a1, 1 # move o ponteiro um byte para cima na string de origem
	addi $a0, $a0, 1 # move o ponteiro um byte para cima na string nova
	
	j loop_strcpy # pula de volta para o começo do loop

fim_strcpy:
	jr $ra # retorna para o código na seção que invocou a função strcpy