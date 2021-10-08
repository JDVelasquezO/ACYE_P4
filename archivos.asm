;============= Abrir archivo===========================
OpenFile macro buffer,handler
    local erro,fini
    mov AX,@data
    mov DS,AX
    mov ah,3dh
    mov al,02h
    lea dx,buffer
    int 21h
    ;jc Erro ; db con mensaje que debe existir en doc maestro
    mov handler,ax
    mov ax,0
    ;jmp fini
    erro:
    ;Print TItuloErrorArchivo
    mov ax,1
    fini:
endm
;============== MACRO CERRAR ARCHIVO==============
CloseFile macro handler
    mov ah,3eh
    mov bx,handler
    int 21h
    ;jc Error2 ; db con mensaje que debe existir en doc maestro
endm

;=========== MACRO LEER ARCHIVO===========
; ReadFile macro handler,array,numbytes
;     mov AX,@data
;     mov DS,AX
;     mov ah,3fh
;     mov bx,handler
;     mov cx,numbytes ; numero maximo de bytes a leer(para proyectos hacerlo gigante) 
;     lea dx,array
;     int 21h
; ;jc Error4 ; db con mensaje que debe existir en doc maestro
; endm

; pendiente el de crear escribir
;======================== MACRO CREAR ARCHIVO (any extension) ===================
CreateFile macro buffer,handler
    mov AX,@data
    mov DS,AX
    mov ah,3ch
    mov cx,00h
    lea dx,buffer
    int 21h
    ;jc Error4
    mov bx,ax
    mov ah,3eh
    int 21h
endm
; ; ========================= MACRO ESCRIBIR EN ARCHIVO YA CREADO =================

WriteFile macro handler,buffer,numbytes
    mov AX,@data
    mov DS,AX
    mov ah,40h
    mov bx,handler
    mov cx,numbytes
    lea dx, buffer
    int 21h
endm

; NUEVOS METODOS
openFile macro name

    mov handle, 0000h

    mov ah, 3dh
    mov al, 000b
    lea dx, name
    int 21h

    mov handle, ax                      ;handle is a global variable

ENDM

readFile macro

    mov ah, 3fh
    mov bx, handle                      ;handle is a global variable
    mov cx, LENGTHOF bufferFile
    lea dx, bufferFile                  ;bufferFile is a global variable
    int 21h

ENDM

closeFile macro

    mov ah, 3eh
    mov bx, handle                      ;handle is a global variable
    int 21h

ENDM

createFile macro name
    mov ah, 3ch
    mov cx, 00h
    lea dx, name

    int 21h

    mov handle, ax                          ;handle is a global variable
ENDM

writeFile macro content
    mov ah, 40h
    mov bx, handle                          ;handle is a global variable
    mov cx, LENGTHOF content
    lea dx, content
    int 21h
ENDM