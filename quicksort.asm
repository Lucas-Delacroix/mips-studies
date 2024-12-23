.data 
	array:
		.align 2 # Alinha palavra na posicao correta, array de inteiros
		.word 0:16 # Aloca 4 espa?os no array
	space:
		.asciiz " " # String contendo um espa?o
		
	newline: 
		.asciiz "\n" #Imprime quebra de linha
.text
main:
	jal criarArray
	jal imprimirArray
	la $t0, array # Move o endereço do array
	addi $a0, $t0, 0 # Define o primeiro elemento do array
	addi $a1, $zero, 0 # Define a esquerda para ser passado como parametro
	addi $a2, $zero, 3 # Define a posicao do ultimo elemento do array
	jal quicksort
	jal imprimirArray	
	li $v0, 10 # Código de saída
	syscall

	


criarArray:
	move $t0, $zero #Define indice do array como zero
	li $t2, 16 # Define Tamanho do array (16/4) elementos
	loopCriarArray:
		beq $t0, $t2, frimCriarArray #Se o indice for maior que a lista sai do loop
		li $a1, 100 # Limite superior do intervalo de aleatorios
		li $v0, 42 # C?digo para gerar inteiro aleatorio
		syscall 
		sw $a0, array($t0) # Salva o valor aleatorio gerado na posicao do array
		addi $t0, $t0, 4 #incrementa indice do loop
		j loopCriarArray
	frimCriarArray:
		jr $ra





imprimirArray:
	loopImprimirDesordenado:
		move $t0, $zero #indice do array  
		li $t2, 16
	imprimeDesordenado:
		beq $t0, $t2, fimImprimirDesordenado #Se o indice for maior que a lista sai do loop
		li $v0, 1 # Codigo para imprimir inteiro carregado
		lw $a0, array($t0) # Argumento sendo valor do array na posicao
		syscall
		li $v0, 4 # Codigo para imprimir string
		la $a0, space # String espa?o em branco sendo carregada como argumento
		syscall
		addi $t0, $t0, 4 # Incrementa indice do loop
		j imprimeDesordenado
	fimImprimirDesordenado:
		li, $v0, 4
		la $a0, newline #Imprimir o \n
		syscall
		jr $ra #Retorna ao chamador
		
		
		

troca:				
	addi $sp, $sp, -12#Prepara a pilha para 3 elementos

	sw $a0, 0($sp)# Guarda a0 na pilha
	sw $a1, 4($sp)# Guarda a1 na pilha
	sw $a2, 8($sp)# Guarda a2 na pilha

	sll $t1, $a1, 2 #t1 = 4a
	add $t1, $a0, $t1#t1 = arr + 4a
	lw $s3, 0($t1)#s3  t = array[a]

	sll $t2, $a2, 2#t2 = 4b
	add $t2, $a0, $t2#t2 = arr + 4b
	lw $s4, 0($t2)#s4 = arr[b]

	sw $s4, 0($t1)#arr[a] = arr[b]
	sw $s3, 0($t2)#arr[b] = t 


	addi $sp, $sp, 12#Libera a pilha
	jr $ra
	


dividir: 			
	addi $sp, $sp, -16#Prepara a pilha para 5 elementos
	sw $a0, 0($sp)#Guarda a0
	sw $a1, 4($sp)#Guarda a1
	sw $a2, 8($sp)#Guarda a2
	sw $ra, 12($sp)#Armazena o endereço de retorno
	
	move $s1, $a1	#s1 = esquerda
	move $s2, $a2#s2 = direita

	sll $t1, $s2, 2 # t1 = 4*direita
	add $t1, $a0, $t1# t1 = arr + 4*direita
	lw $t2, 0($t1)# t2 = arr[direita] //pivo

	addi $t3, $s1, -1#t3, i=esquerda -1
	move $t4, $s1#t4, j=esquerda
	addi $t5, $s2, -1#t5 = direita - 1

	loopFor: 
		slt $t6, $t5, $t4 #t6=1 if j>direita-1, t7=0 if j<=direita-1
		bne $t6, $zero, endFor 

		sll $t1, $t4, 2 #t1 = j*4
		add $t1, $t1, $a0 #t1 = arr + 4j
		lw $t7, 0($t1) #t7 = arr[j]

		slt $t8, $t2, $t7 #t8 = 1 if pivo < arr[j], 0 if arr[j]<=pivo
		bne $t8, $zero, endfIf #if t8=1 termina
		addi $t3, $t3, 1 #i=i+1

		move $a1, $t3 #a1 = i
		move $a2, $t4 #a2 = j
		jal troca #troca(arr, i, j)
		
		addi $t4, $t4, 1 #j++
		j loopFor

	    endfIf:
		addi $t4, $t4, 1 #j++
		j loopFor #Retorna ao forloop

	endFor:
		addi $a1, $t3, 1 #a1 = i+1
		move $a2, $s2 #a2 = direita
		add $v0, $zero, $a1 #v0 = i+1 return (i + 1);
		jal troca #troca(arr, i + 1, direita);

		lw $ra, 12($sp)
		addi $sp, $sp, 16		
		jr $ra				

quicksort:				
	addi $sp, $sp, -16# Prepara a pilha para 4

	sw $a0, 0($sp)# a0
	sw $a1, 4($sp)# esquerda
	sw $a2, 8($sp)# direita
	sw $ra, 12($sp)# retorna o endereço da chamada

	move $t0, $a2 #salva direita em t0

	slt $t1, $a1, $t0 #t1=1 se esquerda < direita, senão 0
	beq $t1, $zero, endIf # se esquerda >= direita, termina

	jal dividir #chama a funcao de divisao
	move $s0, $v0 # pivo, s0= v0

	lw $a1, 4($sp) #a1 = esquerda
	addi $a2, $s0, -1 #a2 = pivo -1
	jal quicksort	#chamada para a funcao do quicksort

	addi $a1, $s0, 1#a1 = pivo + 1
	lw $a2, 8($sp) #a2 = direita
	jal quicksort #retorna ao quicksort

 endIf:
 	lw $a0, 0($sp) #carrega a0
 	lw $a1, 4($sp)#carrega a1
 	lw $a2, 8($sp)#carrega a2
 	lw $ra, 12($sp)#carega o endereço de retorno
 	addi $sp, $sp, 16#restaura a pilha
 	jr $ra	#retorna ao chamador
	   	
		   
