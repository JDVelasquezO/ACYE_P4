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
    totalHiato db "El total de hiatos es: $"
    totalTript db "El total de triptongos es: $"
    newWord db 50 dup("$"), "$"
    counter db 0
    counterHiato db 0
    counterTript db 0
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
        mov counterHiato, 0
        mov counterTript, 0
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

        xor bx, bx
        print totalDipt
        mov bl, counter
        printRegister bl
        ImprimirEspacio al
        print totalHiato
        mov bh, counterHiato
        printRegister bh
        ImprimirEspacio al
        print totalTript
        mov cl, counterTript
        printRegister cl
        
        readUntilEnter bufferKey
        jmp menu

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

    exitGame:
        mov ax, 4C00H
        INT 21H

    main ENDP
end