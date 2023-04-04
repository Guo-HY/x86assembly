stack       segment     para  stack
            dw          100 dup(?)
stack       ends

data        segment     para
string1     db          'guohongyu',0h
string1_len equ         $ - string1
len         equ         121
in_buf      db          len - 1
            db          ?
            db          len dup(?)
tmp2        db          30 dup(?)

data        ends

code        segment     para
            assume      cs:code, ds:data, es:data, ss:stack

main        proc        far
            mov         ax, data
            mov         ds, ax
            mov         es, ax
            

            call        input
            call        dispenter
            xor         ax, ax
            mov         al, in_buf + 1
            push        ax    ; len
            mov         ax, offset in_buf + 2   ; begin addr
            push        ax 
            mov         al, 'a'
            call        FIND
            call        disp_dec_value
            
            jmp exit


FIND        proc
            pop  dx
            pop   si
            pop   cx
            push dx
            mov   bl, al
            xor   ax, ax
FIND_lp1:   
            mov   dl, [si]
            cmp   dl, bl
            jnz   FIND_continue
            inc   ax
FIND_continue:
            inc   si
            loop  FIND_lp1
            ret
FIND        endp

input       proc
            mov   dx, offset in_buf
            mov   ah, 0ah
            int   21h
            ret
input       endp




dispstring  proc  ; string first offset address should in dx
                  ; string should term with '$'
            push  ax
            mov   ah, 9
            int   21h
            pop   ax
            ret
dispstring  endp

dispspace   proc  ; char should in dl
            push    ax
            push    dx
            mov     dl, 20h
            mov     ah, 2
            int     21h
            pop     dx
            pop     ax
            ret
dispspace    endp

dispenter   proc  ; char should in dl
            push    ax
            push    dx
            mov     dl, 0ah
            mov     ah, 2
            int     21h
            pop     dx
            pop     ax
            ret
dispenter   endp

dispchar    proc  ; char should in dl
            push    ax
            mov     ah, 2
            int     21h
            pop     ax
            ret
dispchar    endp

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



exit:       mov         ax, 4c00h
            int         21h
main        endp
code        ends
            end main