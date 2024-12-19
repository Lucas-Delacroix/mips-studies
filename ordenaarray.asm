.data 
	array:
		.align 2
		.space 16 # Aloca 4 espaços no array
	space:
		.asciiz " " # String contendo um espaço
.text
	move $t0, $zero #Define indice do array como zero
	move $t1, $zero
	li $t2, 16 # Define Tamanho do array (16/4) elementos

	loopCriarArray:
		beq $t0, $t2, loopOrdenar #Se o indice for maior que a lista sai do loop
		li $a1, 100 # Limite superior do intervalo de aleatorios
		li $v0, 42 # Código para gerar inteiro aleatorio
		syscall 
		sw $a0, array($t0) # Salva o valor aleatorio gerado na posicao do array
		addi $t0, $t0, 4 #incrementa indice do loop
		j loopCriarArray
			     
	loopOrdenar:
		move $t3, $zero #indice do array
	
	ordena:
		beq $t3, $t2, loopImprimir #Se o indice for maior que a lista sai do loop
		move $t4, $zero #Salva em t4 o indice do segundo loop
	
	ordenaIterno:
		addi $t5, $t4, 4 # Cria um indice com o valor +1 ao atual
		beq $t5, $t2, fimInterno  # Se $t5 atingir o final do array, sai do loop interno
		lw $t6, array($t4) #Valor do array na posicao 4
		lw $t7, array($t5) #Valor do array na posicao 5
		bgt $t6, $t7, troca #Se o atual for maior que o atual+1 vai para troca
		addi $t4, $t4, 4# Incrementa índice interno
		j ordenaIterno
	
	fimInterno:
		addi $t3, $t3, 4 # Incrementa o índice externo
		j ordena
	
	troca:
		xor $t6, $t6, $t7
		xor $t7, $t6, $t7
		xor $t6, $t6, $t7
		sw $t6, array($t4)# Salva o valor atualizado em $t4
		sw $t7, array($t5)# Salva o valor atualizado em $t5
		j ordenaIterno

	loopImprimir:
		move $t0, $zero #indice do array  
	   
	imprime:
		beq $t0, $t2, saiDaImpressao #Se o indice for maior que a lista sai do loop
		li $v0, 1 # Codigo para imprimir inteiro carregado
		lw $a0, array($t0) # Argumento sendo valor do array na posicao
		syscall
		li $v0, 4 # Codigo para imprimir string
		la $a0, space # String espaço em branco sendo carregada como argumento
		syscall
		addi $t0, $t0, 4 # Incrementa indice do loop
		j imprime
		
	saiDaImpressao:
		li $v0, 10# Chamada de syscall para terminar o programa
		syscall
	
	   
	   	
	   	
		   