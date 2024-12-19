.data
	array: 
		.align 2 # Alinha palavra na posicao correta
		.space 16
	space:
		.asciiz " " #String contendo espaço em branco
	newline:
		.asciiz "\n" #Imprime quebra de linha

.text
	.global main

main:
	jal criarArray
	jal ImprimirDesordenado
	
	li $v0, 10 # Código de saída
	syscall

	
criarArray:
	move $t0, $zero # Define indice do array como zero
	li $t2, 16 #Define tamanho do array (16/4) elementos
	loopCriarArray:
		beq $t0, $t2, fimCriarArray #Se o indice for maior que a lista sai do loop
		li $a1, 100 # Limite superior do intervalo de aleatorios
		li $v0, 42 # C�digo para gerar inteiro aleatorio
		syscall 
		sw $a0, array($t0) # Salva o valor aleatorio gerado na posicao do array
		addi $t0, $t0, 4 #incrementa indice do loop
		j loopCriarArray
	fimCriarArray:
		jr $ra

ImprimirDesordenado:
	loopImprimirDesordenado:
		move $t0, $zero #indice do array 
	imprimeDesordenado:
		beq $t0, $t2, fimImprimeDesordenado #Se o indice for maior que a lista sai do loop
		li $v0, 1 # Codigo para imprimir inteiro carregado
		lw $a0, array($t0) # Argumento sendo valor do array na posicao
		syscall
		li $v0, 4 # Codigo para imprimir string
		la $a0, space # String espa�o em branco sendo carregada como argumento
		syscall
		addi $t0, $t0, 4 # Incrementa indice do loop
		j imprimeDesordenado
	fimImprimeDesordenado:
		li $v0, 4 #Imprime quebra de linha no final
		la $a0, newline #Imprimir o \n
		syscall
		jr $ra #Retorna ao chamador
		
		
		
	
