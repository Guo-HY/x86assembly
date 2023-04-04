stack1        segment     para  stack
              dw          100h  dup(?)
stack1        ends

data1         segment     para
asc_table     db          30h,31h,32h,33h,34h,35h,36h,37h
              db          38h,39h,41h,42h,43h,44h,45h,46h
hex           db          ?
asc           db          ?
data1         ends

code1         segment     para
              assume      cs:code1,ds:data1,ss:stack1
main          proc        far
              push        ds
              xor         ax, ax
              push        ax

              mov         ax, data1
              mov         ds, ax

              mov         si, offset asc_table
              xor         ah, ah
              mov         al, hex
              add         si, ax
              mov         al, [si]
              mov         asc, al

              mov         ah, 2
              mov         dl, al
              int         21h
              ret
main          endp
code1         ends
              end main