include macros.asm
include archivos.asm

.model small
.stack 64h
.data
    headers db 	0ah,0dh,'Universidad de San Carlos de Guatemala',
                0ah,0dh,'Arquitectura de Computadores y Ensambladores 1',
                0ah,0dh,'Jose Daniel Velasquez Orozco',
                0ah,0dh,'Practica 3',
                0ah,0dh,'Ingrese x si desea cerrar el programa',
                0ah,0dh,'$'

    bufferRoute db 50 dup("$"), "$"
    bufferKey db 50 dup("$"), "$"
    container db 500 dup("$"), "$"            ; Guardar lectura
    totalDipt db "El total de diptongos es: $"
    newWord db 50 dup("$"), "$"
    counter db 0
    handle dw ?
.code
    ;description
    main PROC
        mov ax, @data
        mov ds, ax
        mov es, ax  ; Le mandamos al segmento data extra el inicio del segmento de datos


        menu:
            clearTerminal
            print headers
            readUntilEnter bufferRoute

            cmp bufferRoute[0], 'x'
            je exitGame
            cmp bufferRoute[0], 'a'
            je fileUpload
            cmp bufferRoute[0], 'c'
            je countDipt
            jmp menu

    fileUpload:
        OpenFile bufferRoute, handle
        ReadFile handle, container, 500
        CloseFile handle
        print container
        jmp menu

    countDipt:
        xor di, di
        xor si, si
        mov di, 7d
        mov counter, 0
        ciclo:
            xor ax, ax
            mov al, bufferRoute[di]
            mov newWord[si], al
            inc di
            inc si
            cmp bufferRoute[di], "$"
            jne ciclo

        xor si, si
        ciclo2:
            xor ax, ax
            mov al, newWord[si]
            mov ah, newWord[si+1]
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
        print totalDipt
        mov bl, counter
        printRegister bl
        readUntilEnter bufferKey
        jmp menu

    diptCresc:
        cmp ah, "a"
        je isDipt
        cmp ah, "e"
        je isDipt
        cmp ah, "o"
        je isDipt
        jmp returnDiptCresc

    diptDec:
        cmp ah, "i"
        je isDipt
        cmp ah, "u"
        je isDipt
        jmp returnDiptCresc

    isDipt:
        add counter, 1
        jmp returnDiptCresc

    exitGame:
        mov ax, 4C00H
        INT 21H

    main ENDP
end