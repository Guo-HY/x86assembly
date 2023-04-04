stack       segment     para stack
            dw          100 dup(?)
stack       ends

data        segment     para
buff        db          'Test line1: Good morning!',0DH,0AH
            db          'test line2:1234.',0DH,0AH
            db          'Test line3:5678.',0DH,0AH
            db          0DH,0AH
            db          '$'
buff_len    equ         $ - buff
buff_end    dw          $
data        ends

code        segment     para
            assume      cs:code, ds:data, es:data, ss:stack

main        proc        far
            mov         ax, data
            mov         ds, ax
            mov         es, ax

            mov         dx, offset buff
            mov         ah, 9
            int         21h

            mov         di, offset buff
lp1:
            mov         bx, buff_end
            sub         bx, 2
            cmp         di, bx
            jz          del_end

            cmp  word ptr [di], 0a0dH
            jnz         continue

            push        di
            mov         si, di
            inc         si
            inc         si
            mov         cx, buff_end
            sub         cx, di
            cld
            rep         movsb
            sub         buff_end, 2
            pop         di

continue:   inc         di
            jmp         lp1

del_end:    mov         ah, 9
            mov         dx, offset buff
            int         21h

exit:       mov         ax, 4c00h
            int         21h
main        endp
code        ends
            end main