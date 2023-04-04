stack         segment   para stack
stack_area    dw        100h dup(?)
stack_bottom  equ       $ - stack_area
stack         ends

data          segment   para
value         dw        0d9e6h
data          ends

code          segment   para
              assume    cs:code, ds:data, ss:stack
main          proc      far
              mov       ax, stack
              mov       ss, ax
              mov       sp, stack_bottom
              mov       ax, data
              mov       ds, ax

              mov       bx, value
              mov       cx, 4

lp1:          push      cx
              mov       cl, 4
              rol       bx, cl
              mov       al, bl
              and       al, 0fh
              add       al, 30h
              cmp       al, 39h
              jbe       disp
              add       al, 'A'-'9'-1

disp:         mov       dl, al
              mov       ah, 2
              int       21h
              pop       cx
              loop      lp1
  
exit:         mov       ax, 4c00h
              int       21h
main          endp
code          ends
              end main
