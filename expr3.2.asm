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
            mov         di, offset in_buf + 2
            mov         si, offset string1
            call        strcmp

            mov         dx, offset string1
            add         dx, string1_len
            dec         dx 
            mov         si, dx
            mov  byte ptr [si], '$'
            mov         dx, offset string1
            call        dispstring
            call        showcompare
            mov   cl,   in_buf + 1
            xor   ch, ch
            mov   si, offset in_buf + 2
            add   si, cx
            mov  byte ptr [si], '$'
            mov   dx, offset in_buf + 2
            call        dispstring
            
            jmp exit



input       proc
            mov   dx, offset in_buf
            mov   ah, 0ah
            int   21h
            mov   cl,   in_buf + 1
            xor   ch, ch
            mov   si, offset in_buf + 2
            add   si, cx
            mov  byte ptr [si], 0
            ret
input       endp

showcompare proc
            push dx
            cmp   ax, 1h
            jz    showcompare_al
            cmp   ax, 0h
            jz    showcompare_el
            jmp   showcompare_bl

showcompare_al:
            mov  dl, '>'
            jmp   showcompare_r

showcompare_el:
            mov  dl, '='
            jmp   showcompare_r

showcompare_bl:
            mov  dl, '<'
            jmp   showcompare_r

showcompare_r:
            call dispchar
            pop dx
            ret
showcompare endp

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
            jz    strcmp_el
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



exit:       mov         ax, 4c00h
            int         21h
main        endp
code        ends
            end main