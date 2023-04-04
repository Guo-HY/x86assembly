dispchar    proc  ; char should in dl
            push    ax
            mov     ah, 2
            int     21h
            pop     ax
            ret
dispchar    endp

dispstring  proc  ; string first offset address should in dx
                  ; string should term with '$'
            push  ax
            mov   ah, 9
            int   21h
            pop   ax
            ret
dispstring  endp
            
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

disp_hex_vaule  proc      ; in : bx is the value want to show
                push ax
                push cx
                push dx

                mov   cx, 4
dhvl1:          push  cx
                mov   cl, 4
                rol   bx, cl
                mov   al, bl
                and   al, 0fh
                add   al, 30h
                cmp   al, 39h
                jbe   dhvldisp
                add   al, 'A'- '9' - 1
dhvldisp:       mov   dl, al
                mov   ah, 2
                int   21h
                pop   cx
                loop  dhvl1

                pop dx
                pop cx
                pop ax
                ret
disp_hex_vaule  endp




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


bubble_sort    proc  ; in : cx: table len(in byte)
                      ; in : si : start offset address of table in ds
                push bx
                push ax

                push si
                dec  cx
bsortl1:        mov  bx, 1
                pop  si
                push si
                push cx

bsortl1_1:      mov   ax, [si]
                cmp   ax, [si + 2]
                jbe   bsortcontinue
                xchg  ax, [si + 2]
                mov   [si], ax
                mov   bx, 0
bsortcontinue:
                add   si, 2
                loop  bsortl1_1

                pop   cx
                dec   cx
                cmp   bx, 1
                jz    bsortreturn
                jmp   bsortl1

bsortreturn:
                pop si
                pop ax
                pop bx
                ret
bubble_sort     endp


strcpy      proc  ; in : si=src, di = dst
            push si
            push di
            cld
strcpy_l1:  lodsb
            stosb
            cmp   al, 0
            jnz   strcpy_l1
            pop  di
            pop  si
            ret
strcpy      endp

strcmp      proc  ; in si=str1, di=str2
                  ; out ax = 1,0,-1: str1 >,=,< str2
            push si
            push di
            cld
strcmp_l1:  lodsb
            cmp   al, es:[di]
            ja    strcmp_al
            jb    strcmp_bl
            cmp   al, 0
            jz    strcmp_be
            inc   di
            jmp   strcmp_l1
strcmp_al:  mov   ax, 1
            jmp  strcmp_return
strcmp_bl:  mov   ax, 0fffh
            jmp strcmp_return
strcmp_el:  mov   ax, 0
strcmp_return:
            pop  di
            pop  si
            ret
strcmp      endp

