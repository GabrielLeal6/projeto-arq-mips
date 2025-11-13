# Grupo composto pelos alunos Gabriel Leal de Queiroz e Caio Vinicius Marinho
# Atividade da primeira VA de 2025.2 de Arquitetura e Organização de Computadores
# Arquivo referente a definição dos tamanhos dos dados usados

.data
	# atributos do cliente:
	.eqv SIZE_NOME 64
	.eqv SIZE_CPF 12
	.eqv SIZE_CONTA 9
	.eqv SIZE_SALDO 4
	.eqv SIZE_LIMITE 4
	.eqv SIZE_DIVIDA 4
	
	.eqv SIZE_INDEX_DEBITO 4 # index de ultima transação no debito
	.eqv SIZE_INDEX_CREDITO 4 # index de ultima transação no credito
	
	.eqv SIZE_FIXOS 105 # SIZE_NOME + SIZE_CPF + SIZE_CONTA + SIZE_SALDO + SIZE_LIMITE + SIZE_DIVIDA
	
	.eqv SIZE_TRANS 32	
	.eqv SIZE_TRANS_TOTAL 3200 # SIZE_TRANS * 100
	
	.eqv SIZE_CLIENTE SIZE_FIXOS + SIZE_TRANS_TOTAL #  105 + 3200 = 3305
	
	banco_clientes:    .space 165250 # 50 * SIZE_CLIENTE
	contador_clientes: .word 00 # Número atual de clientes cadastrados