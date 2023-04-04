stack         segment   para stack
stack_area    dw        100h dup(?)
stack_bottom  equ       $ - stack_area
stack         ends

data          segment   para
value         dw        0fffeh
result        db        5 dup(?),'$'
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
              mov       bx, 10
              mov       di, offset result + 4
            
lp1:          xor       dx, dx
              div       bx
              or        dl, 30h
              mov       byte ptr [di], dl
              dec       di
              loop      lp1

              mov       dx, offset result
              mov       ah, 9
              int       21h
  
exit:         mov       ax, 4c00h
              int       21h
main          endp
code          ends
              end main

