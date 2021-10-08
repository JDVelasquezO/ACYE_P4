print macro string

    push ax
    push dx

    mov dx, offset string		; mover donde empieza el mensaje
	mov ah, 09h 				; Para imprimir un caracter en pantalla
	INT 21H

    pop dx
    pop ax
endm

printRegister macro register
	push ax
	push dx
	
	mov dl,register
	add dl,48 		; Se le suma 48 por el codigo ascii
	mov ah,02h
	int 21h
	
	pop dx
	pop ax
endm

ImprimirEspacio macro registro
	push ax
	push dx
	
	mov registro, 13
	CrearEspacio al
	mov registro, 10
	CrearEspacio al
	
	pop dx
	pop ax
endm

CrearEspacio macro registro
	push ax
	push dx
	
	mov dl,registro
	mov ah,02h
	int 21h
	
	pop dx
	pop ax
endm

readUntilEnter macro entrada
    local salto, fin

    xor bx, bx ;Limpiando el registro
    salto:
        mov ah, 01h
        int 21h
        cmp al, 0dh ;Verificar si es un salto de linea lo que se esta leyendo
        je fin
        mov entrada[bx], al
        inc bx
        jmp salto

    fin:
        mov al, 24h ;Agregando un signo de dolar para eliminar el salto de linea
        mov entrada[bx], al
endm

clearTerminal macro   ; clear o cls
    mov ax, 03h 
    int 10h
endm

getIn macro
    mov ah, 01h
    int 21h
endm

CadenaColor MACRO cadena, cantidad, inicio, fin
    push ax
    push bx
    push cx
    push dx

    mov bx, 0
    lea bp, cadena[bx]  ; Imprimir cadena. bp debe saber donde inicia el string
    mov al, 1       ; Escribir con colores
    mov bh, 0       ; Número de página siempre 0 por defecto
    mov bl, 2h      ; Atributos, color específico
    mov cx, cantidad       ; Cantidad de caracteres
    mov dl, inicio      ; Columna donde va a empezar
    mov dh, fin      ; Fila donde va a empezar
    mov ah, 13h     ; Funcionalidad escribir STRING
    int 10h

    pop dx
    pop cx
    pop bx
    pop ax
ENDM

CharColor MACRO char, color

    push ax
    push bx
    push cx
    push dx

    mov al, char     ; Imprimir un caracter en específico
    mov ah, 09h     ; Imprimir un char
    mov bh, 0       ; Página
    mov bl, color   ; Color: el primer bit indica si parpadea o no, los otros 3 el color de fondo y los otros 4 el color
    mov cx, 1       ; 1 Caracter
    int 10h

    ; DESPLAZAR EL CURSOR PARA IMPRIMIR LA W DESPUES DE LA @
    mov ah, 03h     ; Obtiene la posicion actual
    int 10h
    inc dl
    mov ah, 02h     ; Desplazar el cursor
    int 10h
    ; --------------------------------------------------------

    pop dx
    pop cx
    pop bx
    pop ax 
ENDM

convertir8bits macro param
    local cualquiera,noz
    xor ax,ax
    mov al,param
    mov cx,10
    mov bx,3
    cualquiera:
    xor dx,dx
    div cx
    push dx
    dec bx
    jnz cualquiera
    mov bx,3
    noz:
    pop dx

    push ax
    push bx
    push cx
    push dx

    add dl, 48
    mov param, dl
    writeFile param
    
    pop dx
    pop cx
    pop bx
    pop ax
    
    dec bx
    jnz noz
endm

printRegister macro register
	push ax
	push dx
	
	mov dl,register
	add dl,48 		; Se le suma 48 por el codigo ascii
	mov ah,02h
	int 21h
	
	pop dx
	pop ax
endm

ImprimirNumero macro registro
    push ax
    push dx


    mov dl,registro
    ;ah = 2
    add dl,48
    mov ah,02h
    int 21h


    pop dx
    pop ax
endm

Imprimir8bits macro registro
    local cualquiera,noz
    xor ax,ax
    mov al,registro
    mov cx,10
    mov bx,3
    cualquiera:
    xor dx,dx
    div cx
    push dx
    dec bx
    jnz cualquiera
    mov bx,3
    noz:
    pop dx
    ImprimirNumero dl
    dec bx
    jnz noz
endm

Imprimir16bits macro registro
    local cualquiera,noz
    xor ax,ax
    mov ax,registro
    mov cx,10
    mov bx,5
    cualquiera:
    xor dx,dx
    div cx
    push dx
    dec bx
    jnz cualquiera
    mov bx,5
    noz:
    pop dx
    ImprimirNumero dl
    dec bx
    jnz noz
endm

ImprimirCadena macro cadena
	mov dx, offset cadena		; mover donde empieza el mensaje
	mov ah, 09h 				; Para imprimir un caracter en pantalla
	INT 21H
endm

descomposeWords MACRO index
    local ciclo, cleanWord

    xor di, di
    xor si, si
    mov di, index
    mov counter, 0
    mov counterHiato, 0
    mov counterTript, 0
    cleanWord:
        mov newWord[si], "$"
        inc si
        cmp si, 50
        jne cleanWord

    xor si, si
    ciclo:
        xor ax, ax
        mov al, bufferRoute[di]
        mov newWord[si], al
        inc di
        inc si
        cmp bufferRoute[di], "$"
        jne ciclo
ENDM

iterateWord MACRO wordInd
    local ciclo2, returnDiptCresc, returnIsTript, diptCresc, diptDec, dipHomo, verifyThirdLetter, isTript, isDipt, isHiato, isHomo, fin, addCounterDiptCrec

    mov isDiptCrec, 0
    mov isDiptDec, 0
    mov isDiptHomo, 0

    xor si, si
    ciclo2:
        xor ax, ax
        xor bx, bx

        mov al, wordInd[si]
        mov ah, wordInd[si+1]
        mov bl, wordInd[si+2]

        cmp ah, 24h
        je fin

        cmp al, "i"
        je diptCresc
        cmp al, "u"
        je diptCresc
        cmp al, "a"
        je diptDec
        cmp al, "e"
        je diptDec
        cmp al, "o"
        je diptDec
        
        returnDiptCresc:
            inc si
            cmp ah, 24h
            jne ciclo2
            jmp fin
        returnIsTript:
            add si, 2d
            cmp wordInd[si+1], 24h
            jne ciclo2
            jmp fin

    diptCresc:
        cmp wordInd[si-1], "q"
        je returnDiptCresc
        cmp ah, "a"
        je verifyThirdLetter
        cmp ah, "e"
        je verifyThirdLetter
        cmp ah, "o"
        je verifyThirdLetter
        cmp ah, "i"
        je dipHomo
        cmp ah, "u"
        je dipHomo
        jmp returnDiptCresc

    diptDec:
        mov isDiptDec, 1
        cmp ah, "i"
        je isDipt
        cmp ah, "u"
        je isDipt
        cmp ah, "e"
        je isHiato
        cmp ah, "o"
        je isHiato
        cmp ah, "a"
        je isHiato
        jmp returnDiptCresc

    dipHomo:
        mov isDiptHomo, 1
        cmp ah, "u"
        je isDipt
        cmp ah, "i"
        je isDipt

    verifyThirdLetter:
        cmp bl, "i"
        je isTript
        cmp bl, "u"
        je isTript
        jmp addCounterDiptCrec

    isTript:
        add counterTript, 1
        jmp returnIsTript

    isHiato:
        add counterHiato, 1
        jmp returnDiptCresc

    addCounterDiptCrec:
        mov isDiptCrec, 1
        jmp isDipt

    isDipt:
        add counter, 1
        jmp returnDiptCresc

    isHomo:
        add counter, 1
        jmp returnDiptCresc

    fin:
ENDM

clearBuffer macro buffer

    push di
    push cx
    push ax

    xor ax, ax
    xor di, di
    xor cx, cx
   
    MOV al, 24h

    LEA di, buffer
    MOV cx, LENGTHOF buffer
    CLD
    REP stosb

    pop ax
    pop cx
    pop di

ENDM

countWords MACRO contador, msgOutput
    local ciclo, ciclo2, exit

    mov counterTotalWords, 0
    mov cantPropDipt, 0
    xor di, di
    ciclo:
        xor si, si
        xor ax, ax
        clearBuffer wordIndividual
        ciclo2:
            mov ah, bufferFile[di]
            mov wordIndividual[si], ah
            inc di
            inc si
            cmp bufferFile[di], 24h     ; Compara el "$"
            je exit
            cmp bufferFile[di], 20h     ; Compara el " "
            jne ciclo2
        iterateWord wordIndividual
        add counterTotalWords, 1

        inc di
        cmp bufferFile[di], 24h
        jne ciclo
    exit:
        xor bx, bx
        iterateWord wordIndividual
        add counterTotalWords, 1

        print msgOutput
        mov bl, contador
        mov cantPropDipt, bl
        Imprimir8bits bl
ENDM

colorWord MACRO wordInd
    local ciclo2, returnDiptCresc, returnIsTript, diptCresc, diptDec, dipHomo, verifyThirdLetter, colorHomo, colorHiato, colorTript, fin, fin24h, paintLetter

    ; print test_info
    mov isDiptCrec, 0
    mov isDiptDec, 0
    mov isDiptHomo, 0

    xor si, si
    ciclo2:
        xor ax, ax
        xor bx, bx

        mov al, wordInd[si]
        mov ah, wordInd[si+1]
        mov bl, wordInd[si+2]

        cmp ah, 24h
        je fin

        cmp al, "i"
        je diptCresc
        cmp al, "u"
        je diptCresc
        cmp al, "a"
        je diptDec
        cmp al, "e"
        je diptDec
        cmp al, "o"
        je diptDec
        
        CharColor wordInd[si], 0111b
        returnDiptCresc:
            ; printRegister al
            inc si
            cmp wordInd[si], 24h
            jne ciclo2
            jmp fin24h
        returnIsTript:
            add si, 2d
            cmp wordInd[si+1], 24h
            jne ciclo2
            jmp fin

    diptCresc:
        cmp wordInd[si-1], "q"
        je paintLetter
        cmp ah, "a"
        je verifyThirdLetter
        cmp ah, "e"
        je verifyThirdLetter
        cmp ah, "o"
        je verifyThirdLetter
        cmp ah, "i"
        je colorHomo
        cmp ah, "u"
        je colorHomo
        paintLetter:
        CharColor wordInd[si], 0111b
        jmp returnDiptCresc

    diptDec:
        mov isDiptDec, 1
        cmp ah, "i"
        je colorHomo
        cmp ah, "u"
        je colorHomo
        cmp ah, "e"
        je colorHiato
        cmp ah, "o"
        je colorHiato
        cmp ah, "a"
        je colorHiato
        CharColor wordInd[si], 0111b
        jmp returnDiptCresc

    verifyThirdLetter:
        cmp bl, "i"
        je colorTript
        cmp bl, "u"
        je colorTript
        jmp colorHomo

    colorHomo:
        CharColor wordInd[si], 0010b
        CharColor wordInd[si+1], 0010b
        inc si
        jmp returnDiptCresc

    colorTript:
        CharColor wordInd[si], 1110b
        CharColor wordInd[si+1], 1110b
        CharColor wordInd[si+2], 1110b
        add si, 2
        jmp returnDiptCresc

    colorHiato:
        CharColor wordInd[si], 0100b
        CharColor wordInd[si+1], 0100b
        inc si
        jmp returnDiptCresc

    fin:
        cmp wordInd[si], 24h
        je fin24h
        CharColor wordInd[si], 0111b
    
    fin24h:
ENDM

colorWords MACRO
    local ciclo, ciclo2, exit

    xor di, di
    ciclo:
        xor si, si
        xor ax, ax
        clearBuffer wordIndividual
        ciclo2:
            mov ah, bufferFile[di]
            mov wordIndividual[si], ah
            inc di
            inc si
            cmp bufferFile[di], 24h     ; Compara el "$"
            je exit
            cmp bufferFile[di], 20h     ; Compara el " "
            jne ciclo2
        colorWord wordIndividual
        ; print wordIndividual
        print blankSpace

        inc di
        cmp bufferFile[di], 24h
        jne ciclo
    exit:
        ; print wordIndividual
        colorWord wordIndividual
ENDM

prop_dip MACRO
    xor bx, bx
    xor ax, ax
    xor cx, cx

    mov propGeneral, 0
    mov counter, 0
    countWords counter, totalDipt
    mov al, cantPropDipt      ; 018
    mov bl, 100                 ; 100
    mul bl                    ; ax = 1800
    ; mov dx, ax
    ImprimirEspacio al
    xor dx, dx
    mov cl, counterTotalWords    ; 089
    div cl                    ; al = 20
    mov dx, ax

    mov propGeneral, dl       
    print msgPropDipt
    Imprimir8bits dl        ; 20
    print msgPer
ENDM

prop_tript MACRO 
    xor bx, bx
    xor ax, ax
    xor cx, cx

    mov propGeneral, 0
    mov counterTript, 0
    countWords counterTript, totalTript
    mov al, cantPropDipt      ; 009
    mov bl, 100                 ; 100
    mul bl                    ; ax = 900
    ; mov dx, ax
    ImprimirEspacio al
    xor dx, dx
    mov cl, counterTotalWords    ; 089
    div cl                    ; al = 10
    mov dx, ax

    mov propGeneral, dl
    print msgPropTript      
    Imprimir8bits dl        ; 10
    print msgPer
ENDM

prop_hiato MACRO
    xor bx, bx
    xor ax, ax
    xor cx, cx

    mov propGeneral, 0
    mov counterHiato, 0
    countWords counterHiato, totalHiato
    mov al, cantPropDipt      ; 005
    mov bl, 100                 ; 100
    mul bl                    ; ax = 500
    ; mov dx, ax
    ImprimirEspacio al
    xor dx, dx
    mov cl, counterTotalWords    ; 089
    div cl                    ; al = 5
    mov dx, ax

    mov propGeneral, dl
    print msgPropHiato       
    Imprimir8bits dl        ; 5
    print msgPer
ENDM

generateReport MACRO

    createFile input
    writeFile titleReport
    
    prop_dip
    writeFile totalDipt
    convertir8bits counter
    writeFile lineBreak
    writeFile msgPropDipt
    convertir8bits propGeneral
    convertir8bits msgPer
    writeFile lineBreak

    prop_tript
    writeFile totalTript
    convertir8bits counterTript
    writeFile lineBreak
    writeFile msgPropTript
    convertir8bits propGeneral
    convertir8bits msgPer
    writeFile lineBreak
    
    prop_hiato
    writeFile totalHiato
    convertir8bits counterHiato
    writeFile lineBreak
    writeFile msgPropHiato
    convertir8bits propGeneral
    writeFile lineBreak

    closeFile

    readUntilEnter bufferKey
    jmp menu
ENDM