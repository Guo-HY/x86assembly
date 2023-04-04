stack         segment   para stack
stack_area    dw        100h dup(?)
stack_bottom  equ       $ - stack_area
stack         ends

data          segment   para
table         dw        100h dup(?)
new_line      db        0DH, 0AH, '$'
data          ends

code          segment   para
              assume    cs:code, ds:data, ss:stack
main          proc      far
              mov       ax, stack
              mov       ss, ax
              mov       sp, stack_bottom
              mov       ax, data
              mov       ds, ax

              mov   si, offset table
              mov   cx, 2
              call getnum
              mov   [si], ax
              mov   cx, 3
              call  getnum
              
              mul  word ptr [si]   ; DX:AX <- AX * src

              call disp_dec_value

              jmp exit
              

dispstring  proc  ; string first offset address should in dx
                  ; string should term with '$'
            push  ax
            mov   ah, 9
            int   21h
            pop   ax
            ret
dispstring  endp

getnum          proc    ; in : cx = The number of digits of the entered decimal number
                        ; out : ax = entered number
                push si
                push dx
                push bx

                mov  si, 0    ; init num = 0
                mov  bx, 10   ; mult 10 in every iter

getnuml1:       mov  ah, 1
                int  21h      ; result in al
                cmp  al, 0dh  ; is enter?
                je   getnumreturn
                cmp  al, 30h
                jb   getnuml1 ; if < '0' , ignore
                cmp  al, 39h
                ja   getnuml1 ; if > '9', ignore
                sub  al, 30h
                xor  ah, ah
                push ax
                mov  ax, si
                mul  bx
                mov  si, ax
                pop  ax
                add  si, ax
                loop getnuml1

getnumreturn:   mov   ax, si
                pop bx
                pop dx
                pop si
                ret
getnum          endp

disp_dec_value  proc    ; ax = value that want to show in dec
                        ; without leading zero
                push  dx
                push  cx
                push  bx
                push  ax

                mov   cx, 5
                mov   bx, 10

ddvl1:          xor   dx, dx
                div   bx
                push  dx
                loop  ddvl1

                mov   bx, 0
                mov   cx, 5
ddvl2:          pop   dx
                cmp   dl, 0
                jnz   ddvl2_1           
                cmp   bx, 0
                jz    ddvl2_2

ddvl2_1:        mov   bx, 1
                or    dl, 30h
                mov   ah, 2
                int   21h

ddvl2_2:        loop  ddvl2

                pop  ax
                pop  bx
                pop  cx
                pop  dx
                ret
disp_dec_value  endp

exit:         mov       ax, 4c00h
              int       21h
main          endp
code          ends
              end main

