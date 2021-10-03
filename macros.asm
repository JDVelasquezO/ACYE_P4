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

ClearConsole MACRO
    mov ah, 0 ; ACTIVAR CAMBIO DE VIDEO
    mov al, 3h ; TIPO DE VIDEO
    int 10h
ENDM