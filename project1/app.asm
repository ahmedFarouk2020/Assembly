$NOMOD51	 ;to suppress the pre-defined addresses by keil
$include (C8051F020.INC)		; to declare the device peripherals	with it's addresses

ORG 0H					   ; to start writing the code from the base 0 in flash
DB 0FFH,3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH;,40,50,60;
;addresses from 1 -> 10  (7-segment 1) adresses from 11 -> 13 for max value on 7-seg

COUNTER EQU 14H
MOV COUNTER, #10

MAX EQU 18H 
MOV MAX, #4
VAR EQU 30H
MOV VAR, #20


;diable the watch dog
MOV WDTCN,#11011110B ;0DEH
MOV WDTCN,#10101101B ;0ADH

; config of clock
MOV OSCICN , #14H ; 2MH clock
;config cross bar
MOV XBR0 , #00H
;MOV XBR1 , #00H
MOV XBR2 , #040H  ; Cross bar enabled , weak Pull-up enabled 
MOV XBR1, #00000100        ; enable interrupt0 as input pin  INT0E

;SETB EA      ; global interrupt enable
;SETB EX0     ; enable interrupt0
;SETB IT0     ; Edge-triggered   

MOV P1MDOUT,#0FFh ; port1 -> output
MOV P2MDOUT,#0FFh ; port2 -> output
MOV P3MDOUT,#0f0h  ; port3 ->4 output , 4 input
MOV P3, #00H  

SWTCH BIT P3.0
DELAY_BUTTON BIT P3.1
RESET_BUTTON BIT P3.2

LED_RED BIT P3.4
SETB LED_RED
LED_GREEN BIT P3.5
CLR LED_GREEN
FLAG BIT 22H      ; 20H to 2FH 
CLR FLAG
DELAY_FLAG BIT 23H      ; 20H to 2FH 
RESET_DELAY_FLAG BIT 24H
CLR DELAY_FLAG


RED_LED_FLAG BIT 24H      ; 20H to 2FH 
GREEN_LED_FLAG BIT 26H      ; 20H to 2FH 
SETB RED_LED_FLAG
SETB GREEN_LED_FLAG
MOV R0, #50

;TAKE CARE!!!!!!! R1,R2,R3 is used by the seven segment function
MAIN: 
	ACALL INIT
    ACALL SEVEN_SEG2
    ACALL SEVEN_SEG1
    ACALL DELAY 
    INF_LOOP:
        ACALL INCREMENT         ; update variables
        ;ACALL TOG_LED
        ACALL SEVEN_SEG1
        ;ACALL LED
        ; subtract p1,p2 if result=0 then run led(xor the 2 led pins)
        MOV COUNTER, #10
        LOOP_TEN_TIMES:
            ACALL TOG_LED_CHECK
            ACALL SWITCH
            ACALL SEVEN_SEG2
            ACALL LED
            ACALL DELAY
            DJNZ COUNTER, LOOP_TEN_TIMES
    JMP	INF_LOOP		;#!return and start the program on

TOG_LED_CHECK:
    MOV A, P1 ; 
    ANL A, P2
    SUBB A, #2FH
    ;SUBB A, P2  ; tog at ONE 6FH
    JZ TOG
    RET
TOG:
    CPL LED_GREEN
    CPL LED_RED 
    RET

INIT:           ; set the initial values for 7-seg1 and 2
    MOV R1, #05H    ; start value (4) for 7-seg1 
    MOV R2, #01H    ; start value (0) for 7-seg2 
    MOV DPTR, #00H	
    RET
INCREMENT:
    JB FLAG, GET_MAX
    JB DELAY_FLAG, INC_DELAY_VAR
    ;JB RESET_DELAY_FLAG, DEFLT
    RET

INC_DELAY_VAR:
    MOV A, VAR
    ADD A, #50
    MOV VAR, A
    CLR DELAY_FLAG
    RET
DEFLT:
MOV VAR, #20
RET

SWITCH:
    JB SWTCH, SET_FLAG
    JB DELAY_BUTTON, SET_FLAG_BUTTON
    JB  RESET_BUTTON, DEFLT 
    RET
SET_RESET_FLAG:
    SETB RESET_DELAY_FLAG
    RET
SET_FLAG_BUTTON:
    SETB DELAY_FLAG
    RET
SET_FLAG:
    SETB FLAG
    RET
GET_MAX:
    INC MAX
    MOV A, MAX
    ANL A, #11110111b
    JZ DEFUALT
    CLR FLAG
    RET

LED:
    MOV A, #RED_LED_FLAG
    ADD A, #GREEN_LED_FLAG
    ;MOV A, R0
    ;ADD A, R3
    ;SUBB A, #3
    ;CJNE 
    ;CPL A
    ;ANL A,R2
    JZ TOG_LED
    RET
    
TOG_LED:
    ;MOV A,R1
    ;MOV R0, #50
    ;MOV R3, #50
    SETB RED_LED_FLAG
    SETB GREEN_LED_FLAG
    ;JNZ TOGGLE
 ;   RET
;TOGGLE:
    ;CPL LED_GREEN
    ;CPL LED_RED 
    RET

DEFUALT:
    MOV MAX, #3
    RET


SEVEN_SEG1:
    ACALL UPDATE_DPTR1
    ACALL GET_PTR1_VAL  ; get saved value of A
    MOVC A,@A+DPTR
    MOV P1,A
    ACALL GET_PTR1_VAL
    DEC A
    ACALL SAV_PTR1_VAL
	JZ RELOAD
    RET

RELOAD:
    MOV R1, MAX;#04H    ; start value for 7-seg1 pointer 3
    CLR GREEN_LED_FLAG
    CPL LED_RED
    CPL LED_GREEN
    ;INC R0
    ;MOV R3, #1
    RET

SAV_PTR1_VAL:
    MOV R1, A
    RET

GET_PTR1_VAL:
    MOV A, R1
    RET


UPDATE_DPTR1:        
    MOV DPTR, #00
    RET

SEVEN_SEG2:
    ACALL UPDATE_DPTR2
    ACALL GET_PTR2_VAL
    MOVC A,@A+DPTR
    MOV P2,A
    ACALL GET_PTR2_VAL
    DEC A
    ACALL SAV_PTR2_VAL
    jz RESET
    RET

SAV_PTR2_VAL:
    MOV R2, A
    RET
GET_PTR2_VAL:
    MOV A, R2
    RET
UPDATE_DPTR2:
    MOV DPTR, #00H
    RET

RESET:
    MOV R2, #10
    ;MOV A, R2
    ;DEC A
    ;JZ LAB
    CLR RED_LED_FLAG
    ;MOV R0, #2
    RET 

DELAY :
	MOV R4, VAR
	LOOP3:MOV R5,#255
	LOOP2:MOV R7,#10
	LOOP1:DJNZ R7,LOOP1
	DJNZ R5,LOOP2
	DJNZ R4,LOOP3
	RET

END