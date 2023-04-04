stack         segment   para stack
stack_area    dw        100h dup(?)
stack_bottom  equ       $ - stack_area
stack         ends

data          segment   para
table_len     dw        16
table         dw        9,0ah,0bh,0ch,0dh,0eh,0fh 
              dw        1,1,2,3,4,5,6,7,8
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

            ; show table before sort
            call show_table

            ; do bubble sort
            mov cx, table_len
            mov si, offset table
            call bubble_sort

            call show_table

            jmp exit

show_table  proc
            push cx
            push si
            push dx
            push ax

            mov   cx, table_len
            mov   si, offset table
            xor   dx, dx
            mov   dl, 20h
show_tablel1:   
            mov   ax, [si]
            call  disp_dec_value
            call  dispchar
            add   si, 2
            loop show_tablel1
            mov dx, offset new_line
            call dispstring
            pop ax
            pop dx
            pop si
            pop cx
            ret
show_table  endp

dispchar    proc  ; char should in dl
            push    ax
            mov     ah, 2
            int     21h
            pop     ax
            ret
dispchar    endp

dispstring  proc  ; string first address should in dx
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
  
exit:         mov       ax, 4c00h
              int       21h
main          endp
code          ends
              end main

