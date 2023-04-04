stack       segment     para  stack
            dw          100 dup(?)
stack       ends

data        segment     para
tmp1        db          30 dup(?)
string1     db          'guohongyu$'
string1_len equ         $ - string1
tmp2        db          60 dup(?)

data        ends

code        segment     para
            assume      cs:code, ds:data, es:data, ss:stack

main        proc        far
            mov         ax, data
            mov         ds, ax
            mov         es, ax

            mov         si, offset string1
            mov         cx, string1_len
            
            ; not overlay
            mov         di, offset tmp2
            add         di, 30h
            call        show

            ; string2 before string1
            mov         di, offset string1
            sub         di, 5
            call        show

            mov       di, offset string1
            add       di, 2
            call      show


            jmp exit


show        proc
            mov         dx, offset string1
            call        dispstring
            call        dispspace
            call        Memmove
            mov         dx, offset string1
            call        dispstring
            call        dispspace
            mov         dx, di
            call        dispstring
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

exit:       mov         ax, 4c00h
            int         21h
main        endp
code        ends
            end main