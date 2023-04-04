stack         segment   para stack
stack_area    dw        100h dup(?)
stack_bottom  equ       $ - stack_area
stack         ends

data          segment   para
value         dw        0fffeh
divisor       dw        10000, 1000, 100, 10, 1
data          ends

code          segment   para
              assume    cs:code, ds:data, ss:stack
main          proc      far
              mov       ax, stack
              mov       ss, ax
              mov       sp, stack_bottom
              mov       ax, data
              mov       ds, ax

              mov       cx, 5
              mov       ax, value
              mov       si, offset divisor

lp1:          xor       dx, dx
              div       word ptr [si]

              push      dx
              or        al, 30h
              mov       dl, al
              mov       ah, 2
              int       21h
              inc       si
              inc       si
              pop       ax
              loop      lp1
  
exit:         mov       ax, 4c00h
              int       21h
main          endp
code          ends
              end main

