stack         segment   para stack
stack_area    dw        100h dup(?)
stack_bottom  equ       $ - stack_area
stack         ends

data          segment   para
s             dw        5678h, 1234h, 1232h, 4545h ; 12345678h * 45451232h
t             dw        20h dup(?)
r             dw        20h dup(0)
; r             dw        5678h, 1234h, 1232h, 4545h
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

              mov bp, 0
              ; mul : dx : ax <- ax * src
              mov   si,  offset s
              mov   di,  offset r
              mov   ax, [si]
              mul   word ptr [si + 4] ; s0 * s2

              mov   [di], ax  ; r0 = t0
              mov  cx, dx  ; store t1 in cx

              mov   ax, [si + 2]
              mul   word ptr [si + 4] ; s1 * s2

              add  cx, ax ; t1 = t1 + t2
              mov  [di + 2], cx ; r1 = t1
  
              adc [di + 4], dx ; r2 = t3 + adc

              mov ax, [si]
              mul word ptr [si + 6]    ; s0 * s3

              add [di + 2], ax ; r1 = r1 + t4, has adc
              adc [di + 4], bp ; r2 add adc

              mov cx, dx  
              mov ax, [si + 2]
              mul word ptr [si + 6]
              add [di + 4], ax ; r2 + t6
              adc [di + 6], dx
              add [di + 4], cx
              adc [di + 6], bp

              ; display
              mov si, offset r
              add si, 8
              mov cx, 4
lp1:          dec si
              dec si
              mov bx, [si]
              call disp_hex_vaule
              loop lp1
              jmp exit


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



exit:         mov       ax, 4c00h
              int       21h
main          endp
code          ends
              end main

