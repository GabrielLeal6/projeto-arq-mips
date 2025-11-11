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


inicio_memcpy:
	move $v0, $a0 # retorna o endereço de destino para o registrador $v0
	add $t1, $zero, $a2 # cria em $t1 um contador com o valor de num ($a2)
	
loop_memcpy:
	beq $t1, $zero, fim_memcpy # verifica se é o fim do número de repetições do loop
	lb $t0, 0($a1) # carrega o byte do endereço de origem para o $t0
	sb $t0, 0($a0) # salva o byte de $t0 para o endereço de destino $a0
	addi $a1, $a1, 1 # move o ponteiro um byte para cima na string de origem
	addi $a0, $a0, 1 # move o ponteiro um byte para cima na string nova
	subi $t1, $t1, 1 # subtrai um do contador de repetições em $t1
	
	j loop_memcpy # pula de volta para o começo do loop
	
	
fim_memcpy:
	jr $ra # retorna para o código na seção que invocou a função memcpy