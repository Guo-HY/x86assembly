stack       segment     para  stack
            dw          100 dup(?)
stack       ends

data        segment     para
tmp1        db          30 dup(?)
string1_1     db          'guohongyu'
string1_1_len equ         $ - string1_1
tmp2        db          60 dup(?)

tmp3        db          30 dup(?)
string1_2     db          'guohongyu'
string1_2_len equ         $ - string1_2
tmp4        db          30 dup(?)

tmp5        db          30 dup(?)
string1_3     db          'guohongyu'
string1_3_len equ         $ - string1_3
tmp6        db          30 dup(?)

data        ends

code        segment     para
            assume      cs:code, ds:data, es:data, ss:stack

main        proc        far
            mov         ax, data
            mov         ds, ax
            mov         es, ax
            
            ; not overlay
            mov         si, offset string1_1
            mov         cx, string1_1_len
            mov         di, offset tmp2
            add         di, 30h
            mov         dx, offset string1_1
            call        show

            ; string2 before string1
            mov         si, offset string1_2
            mov         cx, string1_2_len
            mov         di, offset string1_2
            sub         di, 5
            mov         dx, offset string1_2
            call        show

            ; string2 after string1
            mov         si, offset string1_3
            mov         cx, string1_3_len
            mov       di, offset string1_3
            add       di, 2
            mov         dx, offset string1_3
            call      show


            jmp exit


show        proc
            push        dx
            call        dispnumchar
            call        dispspace
            call        Memmove
            pop         dx
            call        dispnumchar
            call        dispspace
            mov         dx, di
            call        dispnumchar
            call        dispspace
            call        dispenter            
            ret
show        endp

Memmove     proc  ; in : si=src, di = dst, cx = len
            push si
            push di
            push cx
            cld
Memmove_l1:  lodsb
            stosb
            loop Memmove_l1
            pop cx
            pop  di
            pop  si
            ret
Memmove      endp

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

dispnumchar proc  ; string first offset address should in dx
                  ; string len should in cx
            push cx
            push ax
            push dx
            push si

            mov  si, dx
            mov  ah, 2
dispnumchar_l1:
            mov  dl, [si]
            int  21h
            inc  si
            loop dispnumchar_l1
            pop si
            pop dx
            pop ax
            pop cx
            ret
dispnumchar endp

exit:       mov         ax, 4c00h
            int         21h
main        endp
code        ends
            end main