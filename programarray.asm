.data 
	array:
		.align 2
		.space 16 # Aloca 4 espaços no array
	space:
		.asciiz " " # String contendo um espaço
.text
	move $t0, $zero #Define indice do array como zero
	li $t2, 16 # Define Tamanho do array (16/4) elementos

	loopCriarArray:
	   beq $t0, $t2, loopImprimir #Se o indice for maior que a lista sai do loop
	   li $a1, 100 # Limite superior do intervalo de aleatorios
	   li $v0, 42 # Código para gerar inteiro aleatorio
	   syscall 
	   sw $a0, array($t0) # Salva o valor aleatorio gerado na posicao do array
	   addi $t0, $t0, 4 #incrementa indice do loop
	   j loopCriarArray
	
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
	# Fim do programa
	li $v0, 10                  # Chamada de syscall para terminar o programa
	syscall
	
	   
	   	
	   	
		   