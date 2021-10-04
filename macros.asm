print macro string

    mov dx, offset string		; mover donde empieza el mensaje
	mov ah, 09h 				; Para imprimir un caracter en pantalla
	INT 21H
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

CharColor MACRO char
    push ax
    push bx
    push cx
    push dx

    mov al, char     ; Imprimir un caracter en específico
    mov ah, 09h     ; Imprimir un char
    mov bh, 0       ; Página
    mov bl, 11110011b   ; Color: el primer bit indica si parpadea o no, los otros 3 el color de fondo y los otros 4 el color
    mov cx, 1       ; 1 Caracter
    int 10h

    ; DESPLAZAR EL CURSOR PARA IMPRIMIR LA W DESPUES DE LA @
    mov ah, 03h     ; Obtiene la posicion actual
    int 10h
    inc dl
    mov ah, 02h     ; Desplazar el cursor
    int 10h   

    pop dx
    pop cx
    pop bx
    pop ax 
ENDM

; convertir8bits macro registro
;     local cualquiera,noz
;     xor ax,ax
;     mov al,registro
;     mov cx,10
;     mov bx,3
;     cualquiera:
;     xor dx,dx
;     div cx
;     push dx
;     dec bx
;     jnz cualquiera
;     mov bx,3
;     noz:
;     pop dx

;     push ax
;     push bx
;     push cx
;     push dx

;     add dl, 48
;     mov param, dl
;     WriteFile handle, param, 1
    
;     pop dx
;     pop cx
;     pop bx
;     pop ax
    
;     dec bx
;     jnz noz
; endm

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

iterateWord MACRO
    local ciclo2, returnDiptCresc, returnIsTript, diptCresc, diptDec, dipHomo, verifyThirdLetter, isTript, isDipt, isHiato, isHomo, fin

    xor si, si
    ciclo2:
        xor ax, ax
        xor bx, bx

        mov al, newWord[si]
        mov ah, newWord[si+1]
        mov bl, newWord[si+2]
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
            cmp ah, "$"
            jne ciclo2
        returnIsTript:
            add si, 2d
            cmp newWord[si+1], "$"
            jne ciclo2
            jmp fin

    diptCresc:
        cmp ah, "a"
        je verifyThirdLetter
        cmp ah, "e"
        je verifyThirdLetter
        cmp ah, "o"
        je verifyThirdLetter
        cmp ah, "i"
        je isDipt
        cmp ah, "u"
        je isDipt
        jmp returnDiptCresc

    diptDec:
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
        cmp ah, "u"
        je isDipt
        cmp ah, "i"
        je isDipt

    verifyThirdLetter:
        cmp bl, "i"
        je isTript
        cmp bl, "u"
        je isTript
        jmp isDipt

    isTript:
        add counterTript, 1
        jmp returnIsTript

    isHiato:
        add counterHiato, 1
        jmp returnDiptCresc

    isDipt:
        add counter, 1
        jmp returnDiptCresc

    isHomo:
        add counter, 1
        jmp returnDiptCresc

    fin:
ENDM