stack       segment     para  stack
            dw          100 dup(?)
stack       ends

data        segment     para
buff        db          'Test line1: Good morning!',0AH
            db          'test line2:1234.',0AH
            db          'Test line3:5678.',0AH
            db          0AH
            db          '$'
buff_len    equ         $ - buff
addi_buf    db          30 dup(?)
buff_end    dw          addi_buf
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

            mov         dl, 0DH
            mov         ah, 2
            int         21h
            mov         dl, 0aH
            mov         ah, 2
            int         21h

            mov         di, offset buff

lp1:        cmp         di, buff_end
            jae         ins_end

            mov         cx, buff_end
            sub         cx, di
            mov         al, 0aH
            cld
            repnz       scasb
            jnz         ins_end

            dec         di
            push        di
            mov         cx, buff_end
            sub         cx, di
            mov         di, buff_end
            mov         si, di
            dec         si
            std
            rep         movsb

            pop         di
            cld
            mov         al, 0DH
            stosb
            inc         buff_end


ins_end:    mov         ah, 9
            mov         dx, offset buff
            int         21h


exit:       mov         ax, 4c00h
            int         21h
main        endp
code        ends
            end main