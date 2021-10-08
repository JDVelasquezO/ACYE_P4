include macros.asm
include archivos.asm

.model small
.stack 100h
.data
    headers db 	0ah,0dh,'Universidad de San Carlos de Guatemala',
                0ah,0dh,'Arquitectura de Computadores y Ensambladores 1',
                0ah,0dh,'Jose Daniel Velasquez Orozco',
                0ah,0dh,'Practica 3',
                0ah,0dh,'Ingrese x si desea cerrar el programa',
                0ah,0dh,'$'

    bufferRoute db 50 dup("$"), 0
    bufferKey db 50 dup("$"), "$"
    bufferFile db 1000 dup("$"), "$"            ; Guardar lectura
    wordIndividual db 50 dup("$"), "$"
    totalDipt db "El total de diptongos es: $"
    totalHiato db "El total de hiatos es: $"
    totalTript db "El total de triptongos es: $"
    totalWords db "El total de palabras es: $"
    theWord db "La palabra $"
    msgIsDiptCrec db " es diptongo tipo creciente $"
    msgIsDiptDec db " es diptongo tipo decreciente $"
    msgIsDiptHomo db " es diptongo tipo homogeneo $"
    msgIsTript db " si es triptongo $"
    msgIsHiato db " si es hiato $"
    msgIsNotDipt db " no es diptongo $"
    msgIsNotTript db " no es triptongo $"
    msgIsNotHiato db " no es hiato $"
    msgPropDipt db " La proporcion de diptongo es $"
    msgPropTript db " La proporcion de triptongo es $"
    msgPropHiato db " La proporcion de hiato es $"
    msgPer db " % $"
    cantPropDipt db 0
    ; msgNumPropDipt db 3 dup ("$"), "$"
    blankSpace db " $"
    test_info db "Test aqui $"
    newWord db 50 dup("$"), "$"
    counter db 0
    counterHiato db 0
    counterTript db 0
    counterDipt db 0
    counterChar db 0
    counterTotalWords db 0
    handle dw ?, 0
    isDiptCrec db 0
    isDiptDec db 0
    isDiptHomo db 0
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
            je count
            cmp bufferRoute[0], 'd'
            je diptWord
            cmp bufferRoute[0], 't'
            je triptWord
            cmp bufferRoute[0], 'h'
            je hiatoWord
            cmp bufferRoute[0], "p"
            je prop
            jmp menu

    fileUpload:
        descomposeWords 6d
        openFile newWord
        readFile
        closeFile
        jmp menu

    prop:
        descomposeWords 5d
        cmp newWord[0], "d"
        je prop_dip
        cmp newWord[0], "t"
        je prop_tript
        cmp newWord[0], "h"
        je prop_hiato

    prop_dip:
        xor bx, bx
        xor ax, ax
        xor cx, cx

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

        print msgPropDipt       
        Imprimir8bits dl        ; 20
        print msgPer
        readUntilEnter bufferKey
        jmp menu

    prop_tript:
        xor bx, bx
        xor ax, ax
        xor cx, cx

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

        print msgPropTript      
        Imprimir8bits dl        ; 10
        print msgPer
        readUntilEnter bufferKey
        jmp menu

    prop_hiato:
        xor bx, bx
        xor ax, ax
        xor cx, cx

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

        print msgPropHiato       
        Imprimir8bits dl        ; 5
        print msgPer
        readUntilEnter bufferKey
        jmp menu

    count:
        descomposeWords 7d

        cmp bufferRoute[2], "l"
        je color
        cmp newWord[0], "d"
        je countDipt
        cmp newWord[0], "t"
        je countTript
        cmp newWord[0], "h"
        je countHiato
        cmp newWord[0], "p"
        je countTotalWords

    countDipt:
        countWords counter, totalDipt
        readUntilEnter bufferKey
        jmp menu

    countTript:
        countWords counterTript, totalTript
        readUntilEnter bufferKey
        jmp menu

    countHiato:
        countWords counterHiato, totalHiato
        readUntilEnter bufferKey
        jmp menu

    countTotalWords:
        countWords counterTotalWords, totalWords
        readUntilEnter bufferKey
        jmp menu

    color:
        colorWords
        readUntilEnter bufferKey
        jmp menu

    diptWord:
        descomposeWords 9d
        iterateWord newWord
        
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
        
        cmp isDiptCrec, 1
        je verifyIsDiptCrec
        cmp isDiptDec, 1
        je verifyIsDiptDec
        cmp isDiptHomo, 1
        je verifyIsDiptHomo
        print msgIsNotDipt

        returnVerifyDipt:
        readUntilEnter bufferKey
        jmp menu

    verifyIsDiptCrec:
        print msgIsDiptCrec
        jmp returnVerifyDipt

    verifyIsDiptDec:
        print msgIsDiptDec
        jmp returnVerifyDipt

    verifyIsDiptHomo:
        print msgIsDiptHomo
        jmp returnVerifyDipt

    triptWord:
        descomposeWords 10d
        iterateWord newWord
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
        iterateWord newWord
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