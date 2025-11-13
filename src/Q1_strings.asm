# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente a criação das funções pedidas na questão 1 da seção de de exercícios do projeto
# Define as funções strcpy, memcpy, strcmp, strncmp e strcat

#j main

# Função que cópia uma string para outro endereço
.globl strcpy
strcpy: # entrada da função strcpy
	move $v0, $a0 # retorna o endereço de destino para o registrador $v0

# loop princiapl que faz a cópia
loop_strcpy: # label de loop da função strcpy
	lb $t0, 0($a1) # carrega o byte do endereço de origem para $t0
	sb $t0, 0($a0) # salva o byte de $t0 para o endereço de destino $a0
	beqz $t0, fim_strcpy # checa pelo fim da string, caso encerrada pula para o label de fim da função
	addi $a1, $a1, 1 # move o ponteiro um byte para cima na string de origem
	addi $a0, $a0, 1 # move o ponteiro um byte para cima na string nova
	
	j loop_strcpy # pula de volta para o começo do loop

fim_strcpy: # ponto de saída da função strcpy
	jr $ra # retorna para o código na seção que invocou a função strcpy


# função que cópia uma número de bytes (num) de um bloco para outro na memória
.globl memcpy
memcpy: # entrada da função memcpy
	move $v0, $a0 # retorna o endereço de destino para o registrador $v0
	add $t1, $zero, $a2 # cria em $t1 um contador com o valor de num ($a2)

# loop principal que faz a cópia
loop_memcpy: # label de loop da função memcpy
	beqz $t1, fim_memcpy # verifica se é o fim do número de repetições do loop
	lb $t0, 0($a1) # carrega o byte do endereço de origem para o $t0
	sb $t0, 0($a0) # salva o byte de $t0 para o endereço de destino $a0
	addi $a1, $a1, 1 # move o ponteiro um byte para cima na string de origem
	addi $a0, $a0, 1 # move o ponteiro um byte para cima na string nova
	addi $t1, $t1, -1 # subtrai um do contador de repetições em $t1

	j loop_memcpy # pula de volta para o começo do loop
	
	
fim_memcpy: # ponto de saída da função memcpy
	jr $ra # retorna para o código na seção que invocou a função memcpy


# função que comapara duas strings com diferentes retornos dependendo do resultado da comparação, podendo ser negativo, positivo ou zero
.globl strcmp
strcmp: # ponto de entrada da função strcmp

# loop principal da comparação	
loop_strcmp: # label de loop da função strcmp
	lb $t0, 0($a0) # carrega o byte do endereço de origem em str1
	lb $t1, 0($a1) # carrega o byte do endereço de origem em str2
	
	blt  $t0, $t1, strcmp_inteiro_negativo # verifica se o caráctere em str1 é menor que o de str2 e caso sim, pula para o resultado apropropriado
	bgt $t0, $t1, strcmp_inteiro_positivo # verifica se o caráctere em str1 é maior que o de str2 e caso sim, pula para o resultado apropropriado
	beqz $t0, strcmp_zero # verifica o fim da string str1, que caso chegue aqui significa que é completamente igual a str2 e pula para o resultado apropriado
	
	addi $a0, $a0, 1 # move o ponteiro em str1 para o proximo caractere
	addi $a1, $a1, 1 # move o ponteiro em str2 para o proximo caractere		
	j loop_strcmp # pula de volta para o começo do loop
	
strcmp_zero: # resultado caso as strings sejam iguais
	add $v0, $zero, $zero # retorna zero
	jr $ra # retorna para o código na seção que invocou a função strcmp
	

strcmp_inteiro_negativo: # resultado caso o primeiro caractere diferente seja menor em str1 que em str2
	addi $v0, $zero, -1 # retorna -1
	jr $ra # retorna para o código na seção que invocou a função strcmp

strcmp_inteiro_positivo: # resultado caso o primeiro caractere diferente seja maior em str1 que em str2
	addi $v0, $zero, 1 # retorna 1
	jr $ra # retorna para o código na seção que invocou a função strcmp
 
# função que compara duas strings até no máximo um número (num) de bytes
.globl strncmp
strncmp: # ponto de entrada da função strncmp
	add $t0, $zero, $a3 # cria o contador de num ($a3) em $t0

# loop principal que faz a comparação entre as strings
loop_strncmp: # label de loop da função strncmp
	beqz $t0, strncmp_zero # verifica se é o fim do número de repetições do loop
	lb $t1, 0($a0) # carrega o byte do endereço de origem em str1
	lb $t2, 0($a1) # carrega o byte do endereço de origem em str2
	
	blt  $t1, $t2, strncmp_inteiro_negativo # verifica se o caráctere em str1 é menor que o de str2 e caso sim, pula para o resultado apropropriado
	bgt $t1, $t2, strncmp_inteiro_positivo # verifica se o caráctere em str1 é maior que o de str2 e caso sim, pula para o resultado apropropriado
	beqz $t1, strncmp_zero # verifica o fim da string str1, que caso chegue aqui significa que é completamente igual a str2 e pula para o resultado apropriado
	
	addi $t0, $t0, -1 # subtrai um do contador de repetições em $t0
	
	addi $a0, $a0, 1 # move o ponteiro em str1 para o proximo caractere
	addi $a1, $a1, 1 # move o ponteiro em str2 para o proximo caractere	
	j loop_strncmp # pula de volta para o começo do loop
	
strncmp_zero: # resultado caso as strings sejam iguais (pelo menos até num repetições)
	add $v0, $zero, $zero # retorna zero
	jr $ra # retorna para o código na seção que invocou a função strcmp
	


strncmp_inteiro_negativo: # resultado caso o primeiro caractere diferente seja menor em str1 que em str2
	addi $v0, $zero, -1 # retorna -1
	jr $ra # retorna para o código na seção que invocou a função strcmp	

strncmp_inteiro_positivo:
	addi $v0, $zero, 1 # resultado caso o primeiro caractere diferente seja maior em str1 que em str2
	jr $ra # retorna para o código na seção que invocou a função strcmp


# função que concatena duas strings
.globl strcat
strcat: # ponto de entrada da função strcat
	move $v0, $a0 # retorna o endereço de destino para o registrador $v0
	add $t0, $a0, $zero # cria um iterador para chegar até a parada da string destino

# loop inicial que busca o endereço do fim da string de destino
loop_strcat_iterate: # label do loop de iteração inicial
	lb $t1, 0($t0) # carrega o valor da string destino na posição apontada pelo iterador $t0
	beqz $t1, strcat_concat # pula para o a função de concatenação se encontrar a parada
	addi $t0, $t0, 1 # move o ponteiro do iterador para o próximo caractere
	j loop_strcat_iterate # volta para o começo do loop

strcat_concat: # ponto de entrada para o loop de concatenção da função strcat
	add $t2, $a1, $zero # cria um segundo iterador para copiar os conteúdos da string source para a destino

# loop que faz a concatenação em si, copiando os caracteres da string source para a string destino
loop_strcat_concat: # label do loop de concatenação
	lb $t1, 0($t2) # carrega o valor da string source apontada pelo iterador $t2
	sb $t1, 0($t0) # salva o valor salvo em $t1 para o endereço apontado pelo iterador $t0
	
	beqz $t1, fim_strcat
	
	addi $t0, $t0, 1 # move o ponteiro do iterador $t0 para o próximo caractere
	addi $t2, $t2, 1 # move o ponteiro do iterador $t2 para o próximo caractere
	 
	j loop_strcat_concat # volta para o começo do loop
	
	
fim_strcat: # ponto de saída da função strcat
	jr $ra # retorna para o código que invocou a função strcmp

print_linebreak:
    li $v0, 4 # carrega o código 4 (print string) em $v0
    la $a0, newline # carrega o endereço da string newline em $a0
    syscall # executa a chamada de sistema (imprime)
    jr $ra # retorna para o código que invocou a função

print_string:
    li $v0, 4 # carrega o código 4 (print string) em $v0
    # (syscall assume que $a0 já tem o endereço da string)
    syscall # executa a chamada de sistema (imprime string em $a0)
    jr $ra # retorna para o código que invocou a função

print_integer:
    li $v0, 1 # carrega o código 1 (print integer) em $v0
    # (syscall assume que $a0 já tem o inteiro)
    syscall # executa a chamada de sistema (imprime inteiro em $a0)
    jr $ra # retorna para o código que invocou a função

# seção de dados criados para os testes abaixo
.data    
    source_string:    .asciiz "Santa Cruz"    # define a string de origem 1
    destination_string: .asciiz "Sport"       # define a string de origem 2
    newline:          .asciiz "\n"            # define o caractere de pular linha
    string_livre:     .space 100            # reserva 100 bytes de espaço para o destino 1
    string_livre2:    .space 100            # reserva 100 bytes de espaço para o destino 2


# seção de testes/execução do programa
.text
main2: # ponto de entrada principal do programa
    #teste função strcpy
    la $a0, string_livre # carrega o endereço do destino (string_livre) em $a0
    la $a1, source_string # carrega o endereço da origem (source_string) em $a1
    jal strcpy # invoca a função strcpy
    
    move $a0, $v0 # move o resultado (ponteiro do destino) para $a0 para impressão
    jal print_string # invoca a função de imprimir string
    jal print_linebreak # invoca a função de pular linha

    # teste função memcpy
    la $a0, string_livre2 # carrega o endereço do destino (string_livre2) em $a0
    la $a1, destination_string # carrega o endereço da origem (destination_string) em $a1
    li $a2, 5 # carrega o número 5 (num) em $a2
    jal memcpy # invoca a função memcpy
    
    move $a0, $v0 # move o resultado (ponteiro do destino) para $a0 para impressão
    jal print_string # invoca a função de imprimir string
    jal print_linebreak # invoca a função de pular linha
    
    # teste da função strcmp
    la $a1, destination_string # carrega a origem 2 (str2) em $a1
    la $a0, source_string # carrega a origem 1 (str1) em $a0
    
    jal strcmp # invoca a função strcmp
        
    move $a0, $v0 # move o resultado (inteiro -1, 0 ou 1) para $a0
    jal print_integer # invoca a função de imprimir inteiro
    jal print_linebreak # invoca a função de pular linha
    
    # teste da função strncmp
    la $a1, destination_string # carrega a origem 2 (str2) em $a1
    la $a0, source_string # carrega a origem 1 (str1) em $a0
    li $a3, 5 # carrega o número 5 (num) em $a3
    
    jal strncmp # invoca a função strncmp
    
    move $a0, $v0 # move o resultado (inteiro) para $a0
    jal print_integer # invoca a função de imprimir inteiro
    jal print_linebreak # invoca a função de pular linha
    
    # teste da função strcat
    la $a1, destination_string # carrega a origem (source) em $a1
    la $a0, source_string # carrega o destino (destination) em $a0
    
    jal strcat # invoca a função strcat
    
    move $a0, $v0 # move o resultado (ponteiro do destino) para $a0
    jal print_string # invoca a função de imprimir string

    # Fim do Programa
    li $v0, 10 # carrega o código 10 (exit) em $v0
    syscall # executa a chamada de sistema (termina o programa)
	
	
	
	
	
	
	
	
