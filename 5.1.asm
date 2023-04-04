STACK1        SEGMENT     PARA STACK
STACK_AREA    DW          100H DUP(?)
STACK_BOTTOM  EQU         $ - STACK_AREA
STACK1        ENDS

DATA1         SEGMENT     PARA
SCR_ARRAY     DB          25 * 80 DUP(?)
X             DB          ?
Y             DB          ?
I             DB          ?
DATA1         ENDS

CODE1         SEGMENT     PARA
              ASSUME      CS:CODE1, DS:DATA1, SS:STACK1
MAIN          PROC        FAR
              MOV         AX, STACK1
              MOV         SS, AX
              MOV         SP, STACK_BOTTOM
              MOV         AX, DATA1
              MOV         DS, AX

              MOV         AL, 80
              MUL         Y
              MOV         DL, X
              XOR         DH, DH
              ADD         AX, DX
              MOV         SI, OFFSET SCR_ARRAY
              ADD         SI, AX
              
              MOV         AL, 80H
              MOV         CL, I
              SHR         AL, CL
              OR          [SI], AL

EXIT:         MOV         AX, 4C00H
              INT         21H

MAIN          ENDP
CODE1         ENDS
              ENDP  MAIN

