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
    theWord db "La palabra $"
    msgIsDipt db " si es diptongo $"
    msgIsTript db " si es triptongo $"
    msgIsHiato db " si es hiato $"
    msgIsNotDipt db " no es diptongo $"
    msgIsNotTript db " no es triptongo $"
    msgIsNotHiato db " no es hiato $"
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
            cmp bufferRoute[0], 'r'
            je fileUpload
            cmp bufferRoute[0], 'c'
            je countDipt
            cmp bufferRoute[0], 'd'
            je diptWord
            cmp bufferRoute[0], 't'
            je triptWord
            cmp bufferRoute[0], 'h'
            je hiatoWord
            jmp menu

    fileUpload:
        OpenFile bufferRoute, handle
        ReadFile handle, container, 500
        CloseFile handle
        print container
        jmp menu

    countDipt:
        descomposeWords 7d
        iterateWord

        xor bx, bx
        xor cx, cx
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

    diptWord:
        descomposeWords 9d
        iterateWord
        cmp counter, 0
        jne verifyDipt
        print theWord
        print newWord
        print msgIsNotDipt
        readUntilEnter bufferKey
        jmp menu

    verifyDipt:
        print theWord
        print newWord
        print msgIsDipt
        readUntilEnter bufferKey
        jmp menu

    triptWord:
        descomposeWords 10d
        iterateWord
        cmp counterTript, 0
        jne verifyTript
        print theWord
        print newWord
        print msgIsNotTript
        readUntilEnter bufferKey
        jmp menu

    verifyTript:
        print theWord
        print newWord
        print msgIsTript
        readUntilEnter bufferKey
        jmp menu

    hiatoWord:
        descomposeWords 6d
        iterateWord
        cmp counterHiato, 0
        jne verifyHiato
        print theWord
        print newWord
        print msgIsNotHiato
        readUntilEnter bufferKey
        jmp menu

    verifyHiato:
        print theWord
        print newWord
        print msgIsHiato
        readUntilEnter bufferKey
        jmp menu

    exitGame:
        mov ax, 4C00H
        INT 21H

    main ENDP
end