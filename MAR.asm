; ----------------- COAL Final Semester Project -----------------

; ----------------- Group Members -----------------
; ----------------- Kunwar Ahsan Murad --- 19I - 0694 -----------------
; ----------------- Rizwan Habib --- 19I - 0603 -----------------
; ----------------- Talha --- 19I - 2049 -----------------

; ----------------- Section:  CS - G -----------------

; ----------------- Submitted to: Sir Rohail Gulbaz -----------------


; ----------------- SUPER MARIO BROS. -----------------
; Assembly 8086 using Masm 615

.model small
.data
x dw 0
y dw 25
z dw 25

macroX dw ?
tempmacroX dw ?
macroY dw ?

color db 2

tempX dw ?
tempY dw ?

life db 5
level db 1
score db 0

savingAH db ?
gravityDontWork db 0
mario_X dw 17
mario_Y dw 90
mario_Color db 3

goomba_X dw 35
goomba_Y dw 90
goomba_Color db 3

ground_Y dw 35
ground_X dw 0
ground_Color db 4

crusader_X dw 40
crusader_Y dw 18
crusader_Color db 3

crusaderSword_X dw 50
crusaderSword_Y dw 25
crusaderSword_Color db 6

castle_X dw 127
castle_Y dw 95
castle_Color db 14



saveDx dw ?
saveBx dw ?

tempMx dw 17        ; Giving the Initial Co-Ordinates of Mario
tempMy dw 90

tempGx dw 35		; Giving the Initial Co-Ordinates of Goomba (Enemy)
tempGy dw 90

tempCx dw 40		; Giving the Initial Co-Ordinates of Crusader (Monster)
tempCy dw 18

tempCSx dw 50		; Giving the Initial Co-Ordinates of Crusader Fire Ball
tempCSy dw 25

tempLx dw 127		; Giving the Initial Co-Ordinates of Castle
tempLy dw 89

savingDown db 101
savingUp db ?


goomba1_Direction db 1	; Check whether the Goomba1 should move left or right
goomba2_Direction db 1	; Check whether the Goomba2 should move left or right
crusader_Direction db 1 ; Check whether the Crusader should move left or right

posGoomba1_X dw 33		; X - Coordinates for Goomba 1
posGoomba1_Y dw 90		; Y - Coordinates for Goomba 1

posGoomba2_X dw 90		; X - Coordinates for Goomba 2
posGoomba2_Y dw 90		; Y - Coordinates for Goomba 2


menuStatus db 1		;to call menu proc initially


; Declaring all the string, which will be used in displaying different messages

newGameString db "START GAME$"
ExitGameString db "EXIT$"
MadeByGameString db "MADE BY:$"
ahsan db "KUNWAR AHSAN MURAD$" 
talha db "TALHA$"
rizwan db "RIZWAN HABIB$"
theEndString db "THE END$"

winString db "YOU WIN$"
loseString db "YOU LOSE$"

pressEnterString db "PRESS ENTER$"
toStartNewGameString db "TO START NEW GAME$"
pressEscapeString db "PRESS ESCAPE$"
toExitString db "TO EXIT$"

GameName db "Super Mario Bros.$" 
enteruser db "Enter User Name:$"
userstring db "username$"
lifestring db "Lives: $"
scorestring db "Score: $"
levelstring db "Level: $"

columnNo db 0

.code
jmp jmpMain

;Dividing the Grid of 640 * 480 into 128 * 96
; This Macro will get x and y pos and will make a pixel of size 5*5
; Pixel making Macro

drawPixel MACRO x_axis, y_axis, userColour

; Saving all the Registers
push ax
push bx
push cx
push dx

mov dx, x_axis
mov tempX, dx

mov dx, y_axis
mov tempY, dx

mov ax, 5
mov bx, x_axis

mul bx
mov x_axis, ax

mov ax, 5
mov bx, y_axis

mul bx
mov y_axis, ax

mov bx, x_axis
mov macroX, bx
mov bx, y_axis
mov macroY, bx
mov bx, x_axis
mov tempmacroX, bx

add macroX, 5		; macroX will contain the x_axis+5 Value
add macroY, 5		; macroY will contain the y_axis+5 Value

mov dx, macroX
mov bx, macroY


.WHILE y_axis < bx ; rows
push bx
.WHILE x_axis < dx ; coumns
push dx
mov bx,0
mov ah, 0CH
mov al, userColour
mov cx, x_axis
mov dx, y_axis
int 10h
inc x_axis
pop dx
.ENDW
inc y_axis
mov bx, tempmacroX
mov x_axis, bx
pop bx
.ENDW

mov dx, tempX
mov x_axis, dx

mov dx, tempY
mov y_axis, dx

pop dx
pop cx
pop bx
pop ax

ENDM


jmpMain:
main proc

;Enabling Data Segment
mov ax, @data
mov ds, ax

mov ah, 0
mov al, 12h
int 10h
.IF menuStatus==1
call menu

B:
mov ah, 00h
int 16h


cmp ah, 01h ; ESC key
je ignore




cmp ah, 1ch ; Enter key
je startGame
jmp B
startGame::
	mov menuStatus,0
	mov life,5
	mov level,1
	mov score,0
	call username
	jmp A
.ELSE
jmp A
.ENDIF


A:
	
mov ah,0CH
mov al,0
int 21h
	;##################
	;checking lives
	.IF life==0
		call loseGame
	.ENDIF
	.IF posGoomba1_X == 33			; Move it Right
		mov goomba1_Direction, 0
	.ENDIF
	.IF posGoomba1_X == 53			; Move it Left
		mov goomba1_Direction, 1
	.ENDIF

	.IF posGoomba2_X == 73			; Move it Right
		mov goomba2_Direction, 0
	.ENDIF
	.IF posGoomba2_X == 90			; Move it Left
		mov goomba2_Direction, 1
	.ENDIF

	.IF tempCx == 10
		mov crusader_Direction, 0
	.ENDIF

	.IF tempCx == 90
		mov crusader_Direction, 1
	.ENDIF


	.IF goomba1_Direction == 1 ; Left Direction
		dec posGoomba1_X
	.ENDIF
	.IF goomba1_Direction == 0 ; Right Direction
		inc posGoomba1_X
	.ENDIF

	.IF goomba2_Direction == 1 ; Left Direction
		dec posGoomba2_X
	.ENDIF
	.IF goomba2_Direction == 0 ; Right Direction
		inc posGoomba2_X
	.ENDIF

	; Giving Movemet to Crusader

	.IF crusader_Direction == 0 ; Right Direction
		inc tempCx
	.ENDIF

	.IF crusader_Direction == 1 ; Left Direction
		dec tempCx
	.ENDIF

	; Giving condition for Crusader Fire Ball

	add tempCSy, 2

	.IF tempCSy >= 80
		mov cx, crusader_X
		mov tempCSx, cx
		mov tempCSy, 25
	.ENDIF

		.IF tempMx<11
			mov tempMx,11
		.ENDIF
		.IF level==1
			mov score,0
		.ENDIF
		.IF level==2
			mov score,3
		.ENDIF
		.IF level==3
			mov score,6
		.ENDIF
		.IF level>3
			mov score,9
		.ENDIF
		.IF level>3
			call winGame
			mov tempMx,17
			mov tempMy,90
		.ENDIF
		
		;###################
		;conditions for flag
		.IF tempMx>124
			
			inc level
			mov life,5
			mov tempMx,17
			mov tempMy,90
		.ENDIF
		
		.IF tempMy>90
			mov tempMy,90
		.ENDIF
		;#######################
		;conditions for hurdle 1
		.IF tempMx<44
			.IF	tempMx>20
				.IF tempMy<80
					mov gravityDontWork,0
				.ENDIF
			.ENDIF
		.ENDIF
		
		.IF tempMx>20
			.IF tempMx<34	
			.IF tempMy>81
				mov tempMx,19
			.ENDIF
			.ENDIF	
		.ENDIF
		.IF tempMx<44
			.IF tempMx>34	
			.IF tempMy>81
				mov tempMx,44
			.ENDIF
			.ENDIF	
		.ENDIF
		
		.IF tempMx>20
			.IF	tempMx<44
				.IF	tempMy==80
					mov gravityDontWork,1
				.ENDIF
				
					
			.ENDIF
					
		.ENDIF
		.IF tempMx>0
			.IF	tempMx<20
				.IF	tempMy<=80
					mov savingUp,79
					mov savingDown,78
					mov gravityDontWork,0
				.ENDIF
				
			.ENDIF
					
		.ENDIF
		.IF tempMx>42
			.IF	tempMx<50
				.IF	tempMy==80
					mov savingUp,79
					mov savingDown,78
					mov gravityDontWork,0
				.ENDIF
				
			.ENDIF
					
		.ENDIF
	;#######################
	;conditions for brick 1
		
		.IF tempMx<62
			.IF	tempMx>45
				.IF tempMy<76
					mov gravityDontWork,0
				.ENDIF
			.ENDIF
		.ENDIF
		
		.IF tempMx>45
			.IF tempMx<=52	
			.IF tempMy>72
				mov tempMx,44
				
			.ENDIF
			.ENDIF	
		.ENDIF
		.IF tempMx<62
			.IF tempMx>52	
			.IF tempMy>72
				mov tempMx,62
				
			.ENDIF
			.ENDIF	
		.ENDIF
		
		.IF tempMx>45
			.IF	tempMx<62
				.IF	tempMy==72
					mov gravityDontWork,1
				.ENDIF
				
					
			.ENDIF
					
		.ENDIF
		.IF tempMx>42
			.IF	tempMx<45
				.IF	tempMy<=72
					mov savingUp,79
					mov savingDown,78
					mov gravityDontWork,0
				.ENDIF
				
			.ENDIF
					
		.ENDIF
		.IF tempMx>62
			.IF	tempMx<69
				.IF	tempMy==72
					mov savingUp,79
					mov savingDown,78
					mov gravityDontWork,0
				.ENDIF
				
			.ENDIF					
		.ENDIF
		
		;#######################
		;conditions for hurdle 2
		
		.IF tempMx<82
			.IF	tempMx>60
				.IF tempMy<82
					mov gravityDontWork,0
				.ENDIF
			.ENDIF
		.ENDIF
		
		.IF tempMx>60
			.IF tempMx<70	
			.IF tempMy>83
				mov tempMx,59
				
			.ENDIF
			.ENDIF	
		.ENDIF
		.IF tempMx<82
			.IF tempMx>75	
			.IF tempMy>83
				mov tempMx,79
				
			.ENDIF
			.ENDIF	
		.ENDIF
		
		.IF tempMx>60
			.IF	tempMx<82
				.IF	tempMy==82
					mov gravityDontWork,1
				.ENDIF
				
					
			.ENDIF
					
		.ENDIF
		
		.IF tempMx>56
			.IF	tempMx<60
				.IF	tempMy<=82
					mov savingUp,79
					mov savingDown,78
					mov gravityDontWork,0
				.ENDIF
				
			.ENDIF
					
		.ENDIF
		.IF tempMx>82
			.IF	tempMx<86
				.IF	tempMy<=82
					mov savingUp,79
					mov savingDown,78
					mov gravityDontWork,0
				.ENDIF				
			.ENDIF					
		.ENDIF
		;#######################
		;conditions for brick 2
		
		.IF tempMx<98
			.IF	tempMx>82
				.IF tempMy<74
					mov gravityDontWork,0
				.ENDIF
			.ENDIF
		.ENDIF
		
		.IF tempMx>82
			.IF tempMx<86	
			.IF tempMy>74
				mov tempMx,78
				
			.ENDIF
			.ENDIF	
		.ENDIF
		.IF tempMx<98
			.IF tempMx>=87	
			.IF tempMy>74
				mov tempMx,96
				
			.ENDIF
			.ENDIF	
		.ENDIF
		
		.IF tempMx>82
			.IF	tempMx<100
				.IF	tempMy==74
					mov gravityDontWork,1
				.ENDIF
				
					
			.ENDIF
					
		.ENDIF
		
		.IF tempMx>78
			.IF	tempMx<82
				.IF	tempMy<=84
					mov savingUp,79
					mov savingDown,78
					mov gravityDontWork,0
				.ENDIF
				
			.ENDIF
					
		.ENDIF
		.IF tempMx>=96
			.IF	tempMx<100
				.IF	tempMy<=82
					mov savingUp,79
					mov savingDown,78
					mov gravityDontWork,0
				.ENDIF
				
			.ENDIF					
		.ENDIF
		;#######################
		;conditions for hurdle 3
		
		.IF tempMx<122
			.IF	tempMx>98
				.IF tempMy<73
					mov gravityDontWork,0
				.ENDIF
			.ENDIF
		.ENDIF
		
		.IF tempMx>98
			.IF tempMx<110	
			.IF tempMy>73
				mov tempMx,98
				
			.ENDIF
			.ENDIF	
		.ENDIF
		.IF tempMx<122
			.IF tempMx>=110	
			.IF tempMy>73
				mov tempMx,122
				
			.ENDIF
			.ENDIF	
		.ENDIF
		
		.IF tempMx>98
			.IF	tempMx<122
				.IF	tempMy==73
					mov gravityDontWork,1
				.ENDIF
				
					
			.ENDIF
					
		.ENDIF
		
		.IF tempMx>94
			.IF	tempMx<98
				.IF	tempMy<=73
					mov savingUp,79
					mov savingDown,78
					mov gravityDontWork,0
				.ENDIF
				
			.ENDIF
					
		.ENDIF
		.IF tempMx>=122
			.IF	tempMx<126
				.IF	tempMy<=73
					mov savingUp,79
					mov savingDown,78
					mov gravityDontWork,0
				.ENDIF
				
			.ENDIF					
		.ENDIF
		.IF tempMy==83
			mov tempMy,90
		.ENDIF
mov ah, 0
mov al, 12h
int 10h


call drawScene
call displayData

;delay code
MOV CX, 0H
MOV DX, 0E240H ; CX:DX = interval in microseconds
MOV AH, 86H

INT 15H
cmp savingUp, 78
je upAgain
jmp ignoreUp
upAgain:
sub tempMy, 5
mov savingDown, 78
add savingUp, 1
jmp A


ignoreUp:
cmp savingDown, 88
jb gravityDown
jmp ignoreGravity
gravityDown:
cmp gravityDontWork,1
je ignoreGravity
mov ah,savingAH

cmp ah, 4dh ; Right Arrow Key
je jmpright

cmp ah, 4bh
je jmpleft

add tempMy, 1
add savingDown, 1
jmp A

ignoreGravity:
jmp llll
jmpleft:
mov savingAH,0
sub tempMx, 8
jmp A
jmp llll
jmpright:
mov savingAH,0
add tempMx, 8
jmp A
llll:

mov ah, 01h
int 16h
jz A
cmp ah, 4dh ; Right Arrow Key
je right

cmp ah, 4bh
je left

cmp ah, 48h
je up

cmp ah, 01H
je ignore
jmp A		; If any other button is pressed ignore it
right:
mov savingAH,0
add tempMx, 3
jmp A

left:
mov savingAH,0
sub tempMx, 3
jmp A

up:
mov ah,0CH ; Clearing KeyBoard Buffer
mov al,0
int 21h

;delay code
MOV CX, 01H

MOV DX, 0FFF1H ; CX:DX = interval in microseconds

MOV AH, 86H

INT 15H
mov ah, 01h
int 16h
jz A
mov savingAH,ah
sub tempMy, 5
mov savingUp, 78
jmp A
;.ENDIF

ignore::
mov ah, 0		; Clearing the Screen when Game is Closed / Ended
mov al, 12h
int 10h

mov ah, 4ch
int 21h

main endp


drawBigMario proc

mov cx, tempMx
mov mario_X, cx
mov cx, tempMy
mov mario_Y, cx

mov cx, mario_X ; Saving the Value of Initial X axis

mov mario_Color, 8 ; Light Grey
mov bx, 0
.WHILE bx < 4
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

sub mario_X, 4
mov bx, 0
.WHILE bx < 4
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW
; --------------- Last Line completed

;Again Initializing
mov mario_X, cx
dec mario_Y

dec mario_X

mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW
sub mario_X, 4
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW
; ----------- Second Last Line Completed
; ------------ Shoes Completed


;Again Initializing
mov mario_X, cx
dec mario_Y

mov mario_Color, 4 ; red Color

sub mario_X, 2
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

sub mario_X, 2

mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------ 3rd Last Line Completed

;Again Initializing
mov mario_X, cx
dec mario_Y

mov mario_Color, 4 ; red Color

sub mario_X, 2
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW


mov bx, 0
.WHILE bx < 5
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------ 4th Last Line Completed



;Again Initializing
mov mario_X, cx
dec mario_Y

mov mario_Color, 14 ; Yellow Color

mov bx, 0
.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 4 ; Red Color

mov bx, 0
.WHILE bx < 8
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 14 ; Yellow Color

mov bx, 0
.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------ 5th Last Line Completed



;Again Initializing
mov mario_X, cx
dec mario_Y

mov mario_Color, 14 ; Yellow Color

mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 4 ; Red Color

mov bx, 0
.WHILE bx < 6
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 14 ; Yellow Color

mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------ 6th Last Line Completed


;Again Initializing
mov mario_X, cx
dec mario_Y

mov mario_Color, 14 ; Yellow Color

mov bx, 0
.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 8 ; Color Dark Grey
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 4 ; Red Color
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 12 ; Orange Color
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 4 ; Red Color

mov bx, 0
.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 12 ; Orange Color
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 4 ; Red Color
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 8 ; Color Dark Grey
drawPixel mario_X, mario_Y, mario_Color
dec mario_X


mov mario_Color, 14 ; Yellow Color

mov bx, 0
.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------- 7th Last Line Completed -- The most complicated

;Again Initializing
mov mario_X, cx
dec mario_Y

mov mario_Color, 8 ; Dark Grey Color
mov bx, 0

.WHILE bx < 4
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 4 ; Red Color
mov bx, 0

.WHILE bx < 4
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 8 ; Dark Grey Color
mov bx, 0

.WHILE bx < 4
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------------ 8th Last Line Completed -------

;Again Initializing
mov mario_X, cx
dec mario_Y

dec mario_X

mov mario_Color, 8 ; Dark Grey Color
mov bx, 0

.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 4 ; Red Color
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 8 ; Dark Grey Color
mov bx, 0

.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 4 ; Red Color
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 8 ; Dark Grey
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ---------------- 9th Last Line ---- Completed

;Again Initializing
mov mario_X, cx
dec mario_Y

sub mario_X, 4

mov mario_Color, 8 ; Dark Grey
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 4 ; Red Color
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 8 ; Dark Grey
mov bx, 0
.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; --------------- 10th last line Completed


;Again Initializing
mov mario_X, cx
dec mario_Y

sub mario_X, 2

mov mario_Color, 14 ; Yello Color  
mov bx, 0
.WHILE bx < 7
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------------ 11th Last Line Completed

;Again Initializing
mov mario_X, cx
dec mario_Y

dec mario_X

mov mario_Color, 8 ; Dark Grey
mov bx, 0
.WHILE bx < 4
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 14 ; Yellow Color
mov bx, 0
.WHILE bx < 4
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 8 ; Dark Grey
mov bx, 0
.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW


; ---------- 12th Last Line Completed -----------

;Again Initializing
mov mario_X, cx
dec mario_Y

mov mario_Color, 14 ; Yellow Color
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 8 ; Dark Grey
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 14 ; Yellow Color
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 8 ; Dark  Grey Color
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 14 ; Yellow Colour
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 8 ; Dark Grey
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

; ----------- 13th Last Line Completed -----------

;Again Initializing
mov mario_X, cx
dec mario_Y

dec mario_X

mov mario_Color, 14 ; Yellow Color
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 8 ; Dark Grey
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 14 ; Yellow Color
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 8 ; Dark Grey
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 14 ; Yellow Color
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 8 ; Dark Grey
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

; ----------- 14th Last Line Completed --------

;Again Initializing
mov mario_X, cx
dec mario_Y

sub mario_X, 3

mov mario_Color, 14 ; Yellow Color
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 8 ; Dark Grey
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 14 ; Yellow Color
mov bx, 0
.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 8 ; Dark Grey
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------- 15th Last Line Completed

;Again Initializing
mov mario_X, cx
dec mario_Y

dec mario_X

mov mario_Color, 4 ; Red Color
mov bx, 0
.WHILE bx < 9
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------- 16th Last Line Completed

;Again Initializing
mov mario_X, cx
dec mario_Y

sub mario_X, 4
mov mario_Color, 4 ; Red Color
mov bx, 0
.WHILE bx < 5
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------------ 1st Line Completed ---------------


; Mario Completed


ret
drawBigMario endp



; Drawing Smaller Mario, which will be used in the Game for movement and playing

drawMario proc

mov cx, tempMx
mov mario_X, cx
mov cx, tempMy
mov mario_Y, cx

mov cx, mario_X ; Saving the Value of Initial X axis



mov mario_Color, 8 ; Light Grey
mov bx, 0
.WHILE bx < 4
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

sub mario_X, 4
mov bx, 0
.WHILE bx < 4
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW
; --------------- Last Line completed
; ------------ Shoes Completed


;Again Initializing
mov mario_X, cx
dec mario_Y

mov mario_Color, 4 ; red Color

sub mario_X, 2
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

sub mario_X, 2

mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------ 3rd Last Line Completed


;Again Initializing
mov mario_X, cx
dec mario_Y

mov mario_Color, 14 ; Yellow Color

mov bx, 0
.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 4 ; Red Color

mov bx, 0
.WHILE bx < 8
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 14 ; Yellow Color

mov bx, 0
.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------ 5th Last Line Completed


;Again Initializing
mov mario_X, cx
dec mario_Y

mov mario_Color, 14 ; Yellow Color

mov bx, 0
.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 8 ; Color Dark Grey
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 4 ; Red Color
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 12 ; Orange Color
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 4 ; Red Color

mov bx, 0
.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 12 ; Orange Color
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 4 ; Red Color
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 8 ; Color Dark Grey
drawPixel mario_X, mario_Y, mario_Color
dec mario_X


mov mario_Color, 14 ; Yellow Color

mov bx, 0
.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------- 7th Last Line Completed -- The most complicated

;Again Initializing
mov mario_X, cx
dec mario_Y

mov mario_Color, 8 ; Dark Grey Color
mov bx, 0

.WHILE bx < 4
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 4 ; Red Color
mov bx, 0

.WHILE bx < 4
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 8 ; Dark Grey Color
mov bx, 0

.WHILE bx < 4
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------------ 8th Last Line Completed -------

;Again Initializing
mov mario_X, cx
dec mario_Y

dec mario_X

mov mario_Color, 8 ; Dark Grey Color
mov bx, 0

.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 4 ; Red Color
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 8 ; Dark Grey Color
mov bx, 0

.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 4 ; Red Color
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 8 ; Dark Grey
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ---------------- 9th Last Line ---- Completed


;Again Initializing
mov mario_X, cx
dec mario_Y

sub mario_X, 2

mov mario_Color, 14 ; Yello Color  
mov bx, 0
.WHILE bx < 7
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------------ 11th Last Line Completed

;Again Initializing
mov mario_X, cx
dec mario_Y

dec mario_X

mov mario_Color, 8 ; Dark Grey
mov bx, 0
.WHILE bx < 4
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 14 ; Yellow Color
mov bx, 0
.WHILE bx < 4
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 8 ; Dark Grey
mov bx, 0
.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW


; ---------- 12th Last Line Completed -----------

;Again Initializing
mov mario_X, cx
dec mario_Y

mov mario_Color, 14 ; Yellow Color
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 8 ; Dark Grey
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 14 ; Yellow Color
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 8 ; Dark  Grey Color
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 14 ; Yellow Colour
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 8 ; Dark Grey
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

; ----------- 13th Last Line Completed -----------

;Again Initializing
mov mario_X, cx
dec mario_Y

sub mario_X, 3

mov mario_Color, 14 ; Yellow Color
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 8 ; Dark Grey
drawPixel mario_X, mario_Y, mario_Color
dec mario_X

mov mario_Color, 14 ; Yellow Color
mov bx, 0
.WHILE bx < 2
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

mov mario_Color, 8 ; Dark Grey
mov bx, 0
.WHILE bx < 3
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------- 15th Last Line Completed

;Again Initializing
mov mario_X, cx
dec mario_Y

dec mario_X

mov mario_Color, 4 ; Red Color
mov bx, 0
.WHILE bx < 9
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------- 16th Last Line Completed

;Again Initializing
mov mario_X, cx
dec mario_Y

sub mario_X, 4
mov mario_Color, 4 ; Red Color
mov bx, 0
.WHILE bx < 5
drawPixel mario_X, mario_Y, mario_Color
dec mario_X
inc bx
.ENDW

; ------------------ 1st Line Completed ---------------


; Mario Completed


ret
drawMario endp


drawScene proc 

MOV AH, 06h
MOV AL, 0
MOV CX, 0
MOV DH, 240
MOV DL, 240
MOV BH, 9
INT 10h


call groundBase
call drawMario
call drawHurdel_1
call drawHurdel_2
call drawHurdel_3
.IF level==1
	call drawFlag
.ENDIF
.IF level==2
	call drawFlag
.ENDIF
.IF level==3
	call drawCastle
.ENDIF
.IF level>1
	mov cx, posGoomba1_X
	mov tempGx, cx
	mov cx, posGoomba1_Y
	mov tempGy, cx
	call drawGoomba

	push ax
	push bx
	push cx
	push dx
	mov ax,POSGOOMBA1_X
	mov bx,tempMx
	mov cx,ax
	add cx,10
	mov dx,bx
	sub dx,11
	.IF bx>ax
		.IF bx<cx
			.IF tempMy>83
				mov tempMx,19
				mov tempMy,90
				dec life
			.ENDIF
		.ENDIF
	.ENDIF
	.IF dx>ax
		.IF dx<cx
			.IF tempMy>83
				mov tempMx,19
				mov tempMy,90
				dec life
			.ENDIF
		.ENDIF
	.ENDIF	
	pop dx
	pop cx
	pop bx
	pop ax




	mov cx, posGoomba2_X
	mov tempGx, cx
	mov cx, posGoomba2_Y
	mov tempGy, cx
	call drawGoomba


	push ax
	push bx
	push cx
	push dx
	mov ax,POSGOOMBA2_X
	mov bx,tempMx
	mov cx,ax
	add cx,10
	mov dx,bx
	sub dx,11
	.IF bx>ax
		.IF bx<cx
			.IF tempMy>83
				dec life
				mov tempMx,19
				mov tempMy,90
			.ENDIF
		.ENDIF
	.ENDIF
	.IF dx>ax
		.IF dx<cx
			.IF tempMy>83
				dec life
				mov tempMx,19
				mov tempMy,90
			.ENDIF
		.ENDIF
	.ENDIF	
	pop dx
	pop cx
	pop bx
	pop ax
.ENDIF
.IF level==3
	mov tempCy, 18 ; Giving Crusader Y axis Value
	call drawCrusader
	call drawcrusaderSword

	push ax
	push bx
	push cx
	push dx

	mov ax, tempMx	; Storing the x axis of Mario : Right Foot
	mov bx, tempMx
	sub bx, 12		; Storing the x axis of Mario : Left Foot
	mov cx, tempMy
	sub cx, 12

	; Condition So that Mario die After interacting with the FireBall of Crusader
	.IF tempCSx > bx
		.IF tempCSx < ax
			.IF tempCSy > cx
				dec life
				mov tempMx,19
				mov tempMy,90
			.ENDIF
		.ENDIF
	.ENDIF

	pop ax
	pop bx
	pop cx
	pop dx

.ENDIF

ret

drawScene endp

groundBase proc 

; ------ Base Brown Colored

MOV AH, 06h
MOV AL, 0
MOV ch, 28
MOV cl, 0
MOV DH, 29
MOV DL, 79	
MOV BH, 6
INT 10h


mov x,0
mov y,448
mov color, 0
.WHILE x < 640
    mov bx,0
	mov ah, 0CH
	mov al, color
	mov cx, x
	mov dx, y
	int 10h
    inc x 
.ENDW

mov x,0
mov y,449
mov color, 0
.WHILE x < 640
    mov bx,0
	mov ah, 0CH
	mov al, color
	mov cx, x
	mov dx, y
	int 10h
    inc x 
.ENDW

mov x,0
mov y,450
mov color, 0
.WHILE x < 640
    mov bx,0
	mov ah, 0CH
	mov al, color
	mov cx, x
	mov dx, y
	int 10h
    inc x 
.ENDW


mov x,0
mov y,465
mov color, 0
.WHILE x < 640
    mov bx,0
	mov ah, 0CH
	mov al, color
	mov cx, x
	mov dx, y
	int 10h
    inc x 
.ENDW




; Vertical Lines
mov x,0
mov y,450
mov z,450
mov color, 0
.WHILE x<640
mov ax,z
mov y,ax
    .WHILE y < 480
    mov bx,0
	mov ah, 0CH
	mov al, color
	mov cx, x
	mov dx, y
	int 10h
    inc y 
    .ENDW
    add x,30
.ENDW

ret

groundBase endp

drawFlag proc

mov x,510
mov y,70
mov z,510
mov color, 15
.WHILE y<170
mov ax,z
mov x,ax
    .WHILE x < 610
    mov bx,0
	mov ah, 0CH
	mov al, color
	mov cx, x
	mov dx, y
	int 10h
        inc x 
    .ENDW
    inc y
    inc z
.ENDW


mov x,620 ;124 * 5
mov y,70 ;14 * 5
mov z,620 ;124 * 5


mov color, 10
.WHILE y<450 ;90 * 5
mov ax,z
mov x,ax
    .WHILE x < 630 ;126 * 5
    mov bx,0
	mov ah, 0CH
	mov al, color
	mov cx, x
	mov dx, y
	int 10h
    inc x 
    .ENDW
    inc y
.ENDW

mov color, 10

mov x, 124
mov y, 12
drawPixel x, y, color
inc x
drawPixel x, y, color

inc x
dec y
drawPixel x, y, color
dec y
drawPixel x, y, color

dec X
dec y
drawPixel x, y, color
dec X
drawPixel x, y, color

dec X
inc y
drawPixel x, y, color
inc y
drawPixel x, y, color

ret
drawFlag endp


drawHurdel_1 proc;starting 21,79 and ending 32,79
	

; Drawing Brick, where Mario Will Stand

;Drawing the Black Line on the Brick
mov x, 215
mov y, 364
mov color, 0
.WHILE x < 265
	mov bx,0
	mov ah, 0CH
	mov al, color
	mov cx, x
	mov dx, y
	int 10h
    inc x 
.ENDW


mov x,43
mov y,73
mov z,43
mov color, 6
.WHILE y<76
mov ax,z
mov x,ax
    .WHILE x < 53
        drawPixel x, y, color
        inc x 
    .ENDW
    inc y
.ENDW


;Drawing the Black Line on the Brick

mov x, 395
mov y, 369
mov color, 0
.WHILE x < 445
	mov bx,0
	mov ah, 0CH
	mov al, color
	mov cx, x
	mov dx, y
	int 10h
    inc x 
.ENDW


mov x,79
mov y,74
mov z,79
mov color, 6
.WHILE y<77
mov ax,z
mov x,ax
    .WHILE x < 89
        drawPixel x, y, color
        inc x 
    .ENDW
    inc y
.ENDW


;********************************printing top (box like shape) of hurdel***********************************
mov x,21;26					;starting x-pos
mov y,79					;starting y-pos
mov color,2

	.WHILE x <= 32
	drawPixel  x, y, color
	add x,1 
	.ENDW
	
	


mov x,21					;starting x-pos
mov y,80					;starting y-pos
mov color,2

	.WHILE x <= 32
	drawPixel  x, y, color
	add x,11 
	.ENDW	

mov x,21					;starting x-pos
mov y,81					;starting y-pos
mov color,2

	.WHILE x <= 32
	drawPixel  x, y, color
	add x,11 
	.ENDW	

mov x,22					;starting x-pos
mov y,80					;starting y-pos
mov color,10

	.WHILE x <= 31
	drawPixel  x, y, color
	add x,1 
	.ENDW	
	
mov x,22					;starting x-pos
mov y,81					;starting y-pos
mov color,10

	.WHILE x <= 31
	drawPixel  x, y, color
	add x,1 
	.ENDW	
	
	
	

mov x,21					;starting x-pos
mov y,82					;starting y-pos
mov color,2

	.WHILE x <= 32
	drawPixel  x, y, color
	add x,11 
	.ENDW
	
mov x,22					;starting x-pos
mov y,82					;starting y-pos
mov color,10

	.WHILE x <= 31
	drawPixel  x, y, color
	add x,1 
	.ENDW	

	
mov x,21					;starting x-pos
mov y,83					;starting y-pos
mov color,2

	.WHILE x <= 32
	drawPixel  x, y, color
	add x,1 
	.ENDW


	

;********************************printing bottom of hurdel***********************************
mov x,24					;starting x-pos
mov tempX,16
mov y,84					;starting y-pos
mov color,2

.WHILE y <=90
	push x 
	.WHILE x <= 30
	drawPixel  x, y, color
	add x,5 
	.ENDW
	pop x	
inc y
.ENDW	
	

mov x,25					;starting x-pos
mov tempX,16
mov y,84					;starting y-pos
mov color,10

.WHILE y <=90
	push x 
	.WHILE x <= 28
	drawPixel  x, y, color
	add x,1 
	.ENDW
	pop x	
inc y
.ENDW

	

ret
drawHurdel_1 endp



;21,32

drawHurdel_2 proc	;starting 61,82 and ending 70,82
	
;********************************printing top (box like shape) of hurdel***********************************
mov x,61					;starting x-pos
mov y,82					;starting y-pos
mov color,2

	.WHILE x <= 70
	drawPixel  x, y, color
	add x,1 
	.ENDW


mov x,61					;starting x-pos
mov y,83					;starting y-pos
mov color,2

	.WHILE x <= 70
	drawPixel  x, y, color
	add x,9 
	.ENDW
	
mov x,62					;starting x-pos
mov y,83					;starting y-pos
mov color,10

	.WHILE x <= 69
	drawPixel  x, y, color
	add x,1 
	.ENDW	
	

mov x,61					;starting x-pos
mov y,84					;starting y-pos
mov color,2

	.WHILE x <= 70
	drawPixel  x, y, color
	add x,9 
	.ENDW
	
mov x,62					;starting x-pos
mov y,84					;starting y-pos
mov color,10

	.WHILE x <= 69
	drawPixel  x, y, color
	add x,1 
	.ENDW	
	

mov x,61					;starting x-pos
mov y,85					;starting y-pos
mov color,2

	.WHILE x <= 70
	drawPixel  x, y, color
	add x,9 
	.ENDW
	
	
mov x,62					;starting x-pos
mov y,85					;starting y-pos
mov color,10

	.WHILE x <= 69
	drawPixel  x, y, color
	add x,1 
	.ENDW	

	
mov x,61					;starting x-pos
mov y,86					;starting y-pos
mov color,2

	.WHILE x <= 70
	drawPixel  x, y, color
	add x,1 
	.ENDW	

;********************************printing bottom of hurdel***********************************
mov x,63					;starting x-pos
mov y,87					;starting y-pos
mov color,2

.WHILE y <=90
	push x 
	.WHILE x <= 69
	drawPixel  x, y, color
	add x,5 
	.ENDW
	pop x	
inc y
.ENDW	
	
mov x,64					;starting x-pos
mov y,87					;starting y-pos
mov color,10

.WHILE y <=90
	push x 
	.WHILE x < 68
	drawPixel  x, y, color
	add x,1 
	.ENDW
	pop x	
inc y
.ENDW	


ret
drawHurdel_2 endp





drawHurdel_3 proc
	
	;********************************printing top (box like shape) of hurdel***********************************
mov x,98;84					;starting x-pos
mov y,73					;starting y-pos
mov color,2

	.WHILE x < 112;94
	drawPixel  x, y, color
	add x,1 
	.ENDW


mov x,98;84					;starting x-pos
mov y,74					;starting y-pos
mov color,2

	.WHILE x < 112;94
	drawPixel  x, y, color
	add x,13 
	.ENDW

mov x,98;84					;starting x-pos
mov y,75					;starting y-pos
mov color,2

	.WHILE x < 112;94
	drawPixel  x, y, color
	add x,13 
	.ENDW

mov x,99;85					;starting x-pos
mov y,74					;starting y-pos
mov color,10

	.WHILE x < 111;93
	drawPixel  x, y, color
	add x,1 
	.ENDW	


mov x,99;85					;starting x-pos
mov y,75					;starting y-pos
mov color,10

	.WHILE x < 111;93
	drawPixel  x, y, color
	add x,1 
	.ENDW	

	
mov x, 98;84					;starting x-pos
mov y,76					;starting y-pos
mov color,2

	.WHILE x < 112;94
	drawPixel  x, y, color
	add x,13 
	.ENDW

mov x, 99;85					;starting x-pos
mov y,76					;starting y-pos
mov color,10

	.WHILE x < 111;93
	drawPixel  x, y, color
	add x,1 
	.ENDW	

mov x, 98;84					;starting x-pos
mov y,77					;starting y-pos
mov color,2

	.WHILE x < 112;94
	drawPixel  x, y, color
	add x,1 
	.ENDW	

;********************************printing bottom of hurdel***********************************
mov x,101;86					;starting x-pos
mov y,78					;starting y-pos
mov color,2

.WHILE y <=90
	push x 
	.WHILE x <= 108;92
	drawPixel  x, y, color
	add x,7
	.ENDW
	pop x	
inc y
.ENDW

mov x,102;87					;starting x-pos
mov y,78					;starting y-pos
mov color,10

.WHILE y <=90
	push x 
	.WHILE x <= 107;90
	drawPixel  x, y, color
	add x,1 
	.ENDW
	pop x	
inc y
.ENDW	
	
	

ret
drawHurdel_3 endp
backgroundForMenu proc

mov x,0
mov y,0
mov z,0
mov color, 9
.WHILE y<96
mov ax,z
mov x,ax
   .WHILE x < 128
       drawPixel x, y, color
       inc x 
   .ENDW
   inc y
.ENDW

ret
backgroundForMenu endp



username proc
call backgroundForMenu
call groundBase

mov tempMx,40
mov tempMy,54
call drawMario

mov tempMx,225
mov tempMy,54
call drawMario

call menuBox
mov tempGx,10
mov tempGy,90
call drawGoomba
mov tempGx,40
mov tempGy,90
call drawGoomba
mov tempGx,210
mov tempGy,90
call drawGoomba
mov tempGx,240
mov tempGy,90
call drawGoomba

mov tempCx,195
mov tempCy,90
call drawCrusader

call usernameEnter
mov tempMx,17
mov tempMy,90
			
ret 
username endp

usernameEnter proc
	mov columnNo ,30
	mov si,0
	.WHILE  si<16
	mov ah,02 ;interrupt function number
	mov bh,0 ;page number 0
	mov dh,7 ;Row number
	mov dl,columnNo ;column number
	int 10h
	mov ah, 09h ;interrupt function number

	mov al, [enteruser+si] ;Character to be printed
	mov cx,1 ;Number of times
	mov bh,0 ;page number
	mov bl,6 ;colour
	int 10h
	inc di
	inc si
	inc columnNo
	.ENDW
	mov columnNo ,30
	mov si,0
	mov ah,02 ;interrupt function number
	mov bh,0 ;page number 0
	mov dh,10 ;Row number
	mov dl,columnNo ;column number
	int 10h
	
	mov ah,0Ah	
	mov dx,OFFSET userstring
	int 21h
ret
usernameEnter endp


menu proc
call backgroundForMenu
call groundBase

mov tempMx,40
mov tempMy,54
call drawBigMario

mov tempMx,225
mov tempMy,54
call drawBigMario

call menuBox
call menuText
mov tempGx,10
mov tempGy,90
call drawGoomba
mov tempGx,40
mov tempGy,90
call drawGoomba
mov tempGx,210
mov tempGy,90
call drawGoomba
mov tempGx,240
mov tempGy,90
call drawGoomba

mov tempCx,195
mov tempCy,90
call drawCrusader
ret 
menu endp


;****************************************to display wining message at the end ************************************
winGame proc ;call this to show the window after wining or completing the game 

call backgroundForMenu
call groundBase
dec level
mov tempMx,40
mov tempMy,54
call drawBigMario

mov tempMx,225
mov tempMy,54
call drawBigMario

call menuBox
call winText

mov tempGx,10
mov tempGy,90
call drawGoomba
mov tempGx,40
mov tempGy,90
call drawGoomba
mov tempGx,210
mov tempGy,90
call drawGoomba
mov tempGx,240
mov tempGy,90
call drawGoomba

mov tempCx,195
mov tempCy,90
call drawCrusader
winn:
	mov ah, 00h
	int 16h  ;keyboard interupt


	cmp ah, 01h ; ESC key   (scan code)
	je ignore




	cmp ah, 1ch ; Enter key
	je startGame
	jmp winn
	
ret 
winGame endp

;***********************************************to display the losing message at the end******************************
loseGame proc ; call this to show the window after losing  the game 

call backgroundForMenu
call groundBase

mov tempMx,40
mov tempMy,54
call drawBigMario

mov tempMx,225
mov tempMy,54
call drawBigMario

call menuBox
call loseText

mov tempGx,10
mov tempGy,90
call drawGoomba
mov tempGx,40
mov tempGy,90
call drawGoomba
mov tempGx,210
mov tempGy,90
call drawGoomba
mov tempGx,240
mov tempGy,90
call drawGoomba

mov tempCx,195
mov tempCy,90
call drawCrusader
loose:
	mov ah, 00h
	int 16h

	cmp ah, 01h ; ESC key
	je ignore


	cmp ah, 1ch ; Enter key
	je startGame
	jmp loose

ret 
loseGame endp


;******************************to display 'Y','O','U',' '.'W','I','N'**************************************
winText proc 
mov columnNo ,36
mov si,0
.WHILE  si<7
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,7 ;Row number
mov dl,columnNo ;column number
int 10h

mov ah, 09h ;interrupt function number
mov al, [winString+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo

.ENDW

;******************************to display 'P','R','E','S','S',' ','E','N','T','E','R'**************************************


mov columnNo ,30
mov si,0
.WHILE  si<11
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,9 ;Row number
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [pressEnterString+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW

;******************************to display 'T','O',' ','S','T','A','R','T',' ','N','E','W',' ','G','A','M','E'**************************************

mov columnNo ,30 ;starting x-position
mov si,0
.WHILE  si<17
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,10 ;Row number ;;starting y-position
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [toStartNewGameString+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW

;******************************to display PRESS ESCAPE*************************


mov columnNo ,30 ;starting x-position
mov si,0
.WHILE  si<12
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,11 ;Row number ;;starting y-position
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [pressEscapeString+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW

;******************************to display TO EXIT *************************

mov columnNo ,30 ;starting x-position
mov si,0
.WHILE  si<7
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,12 ;Row number ;;starting y-position
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [toExitString+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW

mov columnNo ,36
mov si,0
.WHILE  si<7
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,14 ;Row number
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [levelstring+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW

mov al, level ;Character to be printed
add al,48
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h

mov columnNo ,36
mov si,0
.WHILE  si<7
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,15 ;Row number
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [scorestring+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW

mov al, score ;Character to be printed
add al,48
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h

ret 
winText endp

displayData proc
	mov columnNo ,3 ;starting x-position
	mov si,0
	.WHILE  si<7
	mov ah,02 ;interrupt function number
	mov bh,0 ;page number 0
	mov dh,1 ;Row number ;;starting y-position
	mov dl,columnNo ;column number
	int 10h
	mov ah, 09h ;interrupt function number

	mov al, [lifestring+si] ;Character to be printed
	mov cx,1 ;Number of times
	mov bh,0 ;page number
	mov bl,2 ;colour
	int 10h
	inc di
	inc si
	inc columnNo
	.ENDW
	
	mov ah, 09h ;interrupt function number
	mov al, life ;Character to be printed
	add al,48
	mov cx,1 ;Number of times
	mov bh,0 ;page number
	mov bl,2 ;colour
	int 10h

	;for score
	mov columnNo ,34 ;starting x-position
	mov si,0
	.WHILE  si<7
	mov ah,02 ;interrupt function number
	mov bh,0 ;page number 0
	mov dh,1 ;Row number ;;starting y-position
	mov dl,columnNo ;column number
	int 10h
	mov ah, 09h ;interrupt function number

	mov al, [scorestring+si] ;Character to be printed
	mov cx,1 ;Number of times
	mov bh,0 ;page number
	mov bl,2 ;colour
	int 10h
	inc di
	inc si
	inc columnNo
	.ENDW
	
	mov ah, 09h ;interrupt function number
	mov al, score ;Character to be printed
	add al,48
	mov cx,1 ;Number of times
	mov bh,0 ;page number
	mov bl,2 ;colour
	int 10h
	
	
	;for level
	mov columnNo ,64 ;starting x-position
	mov si,0
	.WHILE  si<7
	mov ah,02 ;interrupt function number
	mov bh,0 ;page number 0
	mov dh,1 ;Row number ;;starting y-position
	mov dl,columnNo ;column number
	int 10h
	mov ah, 09h ;interrupt function number

	mov al, [levelstring+si] ;Character to be printed
	mov cx,1 ;Number of times
	mov bh,0 ;page number
	mov bl,2 ;colour
	int 10h
	inc di
	inc si
	inc columnNo
	.ENDW
	
	mov ah, 09h ;interrupt function number
	mov al, level ;Character to be printed
	add al,48
	mov cx,1 ;Number of times
	mov bh,0 ;page number
	mov bl,2 ;colour
	int 10h
ret
displayData endp


;******************************to display YOU LOSE**************************************
loseText proc 

mov columnNo ,36
mov si,0
.WHILE  si<8
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,7 ;Row number
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [loseString+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW

;******************************to display 'P','R','E','S','S',' ','E','N','T','E','R'**************************************


mov columnNo ,30
mov si,0
.WHILE  si<11
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,9 ;Row number
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [pressEnterString+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW

;******************************to display 'T','O',' ','S','T','A','R','T',' ','N','E','W',' ','G','A','M','E'**************************************

mov columnNo ,30 ;starting x-position
mov si,0
.WHILE  si<17
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,10 ;Row number ;;starting y-position
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [toStartNewGameString+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW

;******************************to display PRESS ESCAPE*************************


mov columnNo ,30 ;starting x-position
mov si,0
.WHILE  si<12
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,11 ;Row number ;;starting y-position
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [pressEscapeString+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW

;******************************to display TO EXIT *************************

mov columnNo ,30 ;starting x-position
mov si,0
.WHILE  si<7
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,12 ;Row number ;;starting y-position
mov dl,columnNo ;column number
int 10h

mov ah, 09h ;interrupt function number
mov al, [toExitString+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW
mov columnNo ,36
mov si,0
.WHILE  si<7
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,14 ;Row number
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [levelstring+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW

mov al, level ;Character to be printed
add al,48
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h

mov columnNo ,36
mov si,0
.WHILE  si<7
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,15 ;Row number
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [scorestring+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW

mov al, score ;Character to be printed
add al,48
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h

ret 
loseText endp












menuText proc


mov columnNo ,30
mov si,0
.WHILE  si<8
mov ah,02 ;interrupt function number  (set cursor)
mov bh,0 ;page number 0
mov dh,12 ;Row number
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number (to write char)

mov al, [MadeByGameString+si] ;Character to be printed  
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h  
inc di
inc si
inc columnNo
.ENDW

;************************Kunwar Ahsan Murad************************
mov columnNo ,30
mov si,0
.WHILE  si<18
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,13 ;Row number
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [ahsan+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW



;************************Rizwan Habib*****************************
mov columnNo ,30
mov si,0
.WHILE  si<12
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,14 ;Row number
mov dl,columnNo ;column number
int 10h

mov ah, 09h ;interrupt function number
mov al, [rizwan+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW
;*************************TALHA*****************************************

mov columnNo ,30
;mov di,OFFSET newGameString ; DI = address of newGameString
mov si,0
.WHILE  si<5
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,15 ;Row number
mov dl,columnNo ;column number
int 10h


mov ah, 09h ;interrupt function number
mov al, [talha+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW


;******************************to display Game NAME DISPLAY **************************************


mov columnNo ,30
mov si,0
.WHILE  si<17
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,4 ;Row number
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [GameName+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW

;******************************to display 'P','R','E','S','S',' ','E','N','T','E','R'**************************************


mov columnNo ,30
mov si,0
.WHILE  si<11
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,7 ;Row number
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [pressEnterString+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW

;******************************to display 'T','O',' ','S','T','A','R','T',' ','N','E','W',' ','G','A','M','E'**************************************

mov columnNo ,30 ;starting x-position
mov si,0
.WHILE  si<17
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,8 ;Row number ;;starting y-position
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [toStartNewGameString+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW

;******************************to display PRESS ESCAPE*************************


mov columnNo ,30 ;starting x-position
mov si,0
.WHILE  si<12
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,9 ;Row number ;;starting y-position
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [pressEscapeString+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW

;******************************to display TO EXIT *************************

mov columnNo ,30 ;starting x-position
mov si,0
.WHILE  si<7
mov ah,02 ;interrupt function number
mov bh,0 ;page number 0
mov dh,10 ;Row number ;;starting y-position
mov dl,columnNo ;column number
int 10h
mov ah, 09h ;interrupt function number

mov al, [toExitString+si] ;Character to be printed
mov cx,1 ;Number of times
mov bh,0 ;page number
mov bl,6 ;colour
int 10h
inc di
inc si
inc columnNo
.ENDW


ret 
menuText endp




menuBox proc

mov x,43;84					;starting x-pos
mov y,19					;starting y-pos
mov color,6
	.WHILE y<21
		.WHILE x < 83;94
		 drawPixel  x, y, color
		 add x,1 
		.ENDW
		mov x,43

	add y,1	
	.ENDW
	


mov x,43;84					;starting x-pos
mov y,21					;starting y-pos
mov color,6

	.WHILE y<52
		.WHILE x < 83;94
		drawPixel  x, y, color
		add x,1
		drawPixel  x, y, color
		add x,37 
		.ENDW
		mov x,43

	add y,1
	.ENDW

mov x,45;84					;starting x-pos
mov y,21					;starting y-pos
mov color,2
	.WHILE y<52
		.WHILE x < 81;94
		drawPixel  x, y, color
		add x,1 
		.ENDW
		mov x,45

	add y,1
	.ENDW


mov x,43;84					;starting x-pos
mov y,52					;starting y-pos
mov color,6
	.WHILE y<54
		.WHILE x < 83;94
		 drawPixel  x, y, color
		 add x,1 
		.ENDW
		mov x,43
		
	add y,1	
	.ENDW








ret 
menuBox endp



drawGoomba proc

mov cx, tempGx
mov goomba_X, cx
mov cx, tempGy
mov goomba_Y, cx


; INitialization
mov goomba_Color, 0 ; Black Color
mov cx, goomba_X

mov bx, 0
.WHILE bx < 3
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW

add goomba_X, 2
mov bx, 0
.WHILE bx < 3
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW

; ------------------- Last Line Comple -----------------

; Initializing Again
mov goomba_X, cx
dec goomba_Y

dec goomba_X

mov bx, 0
.WHILE bx < 4
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW

add goomba_X, 2
mov bx, 0
.WHILE bx < 4
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW

; ----------------- 2nd Last Complete ----------------- 

; Initializing Again
mov goomba_X, cx
dec goomba_Y

drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X

mov goomba_Color, 15 ; White

mov bx, 0

.WHILE bx < 6
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW


mov goomba_Color, 0 ; Black
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X

; ----------------- 3rd Last Complete ----------------- 

; Initializing Again
mov goomba_X, cx
dec goomba_Y

inc goomba_X

mov goomba_Color, 15 ; White

mov bx, 0

.WHILE bx < 6
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW


; ----------------- 4th Last Complete ----------------- 

; Initializing Again
mov goomba_X, cx
dec goomba_Y

sub goomba_X, 2

mov goomba_Color, 6 ; Brown

mov bx, 0

.WHILE bx < 12
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW   


; ----------------- 5th Last Complete ----------------- 
; Initializing Again
mov goomba_X, cx
dec goomba_Y

sub goomba_X, 2


mov goomba_Color, 6 ; Brown

mov bx, 0

.WHILE bx < 3
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW  

mov goomba_Color, 15 ; White

mov bx, 0

.WHILE bx < 2
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW 

mov goomba_Color, 6 ; Brown

mov bx, 0

.WHILE bx < 2
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW  

mov goomba_Color, 15 ; White

mov bx, 0

.WHILE bx < 2
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW 

mov goomba_Color, 6 ; Brown

mov bx, 0

.WHILE bx < 3
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW  



; ----------------- 6th Last Complete ----------------- 

; Initializing Again
mov goomba_X, cx
dec goomba_Y

sub goomba_X, 1

mov goomba_Color, 6 ; Brown

mov bx, 0

.WHILE bx < 2
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW 

mov goomba_Color, 15 ; White
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X

mov goomba_Color, 0; Black
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X

mov goomba_Color, 6 ; Brown

mov bx, 0

.WHILE bx < 2
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW 

mov goomba_Color, 0; Black
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X

mov goomba_Color, 15 ; White
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X

mov goomba_Color, 6 ; Brown

mov bx, 0

.WHILE bx < 2
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW 


; ----------------- 7th Last Complete -----------------

; Initializing Again
mov goomba_X, cx
dec goomba_Y

mov goomba_Color, 0 ; Black

mov bx, 0

.WHILE bx < 2
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW 

mov goomba_Color, 6 ; Brown

mov bx, 0

.WHILE bx < 4
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW 

mov goomba_Color, 0 ; Black

mov bx, 0

.WHILE bx < 2
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW 


; ----------------- 8th Last Complete ----------------- 

; Initializing Again
mov goomba_X, cx
dec goomba_Y

inc goomba_X

mov goomba_Color, 6 ; Brown

mov bx, 0

.WHILE bx < 6
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW 

; ----------------- 9th Last Complete ----------------- 


; Initializing Again
mov goomba_X, cx
dec goomba_Y

inc goomba_X
inc goomba_X

mov goomba_Color, 6 ; Brown

mov bx, 0

.WHILE bx < 4
drawPixel goomba_X, goomba_Y, goomba_Color
inc goomba_X
inc bx
.ENDW 

; -------------------- Last LLine Completed ----------------------


ret
drawGoomba endp


drawCrusader proc

; Giving Initial Values
mov cx, tempCx
mov crusader_X, cx
mov cx, tempCy
mov crusader_Y, cx

mov cx, crusader_X ; Saving the Value of Initial X axis


; ----------------- Last Line -------------------
mov crusader_Color, 7 ; Light Grey
drawPixel crusader_X, crusader_Y, crusader_Color
sub crusader_X, 4
drawPixel crusader_X, crusader_Y, crusader_Color
; ----------------- Second Last Line -------------------
; Initializig Again
mov crusader_X, cx
dec crusader_Y
mov bx, 0
.WHILE bx < 5
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
; ----------------- Third Last Line -------------------
; Initializig Again
mov crusader_X, cx
dec crusader_Y
mov crusader_Color, 4 ; Red
mov bx, 0
.WHILE bx < 5
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
; ----------------- Fourth Last Line -------------------
; Initializig Again
mov crusader_X, cx
dec crusader_Y
add crusader_X, 3
mov crusader_Color, 7 ; Light Grey
drawPixel crusader_X, crusader_Y, crusader_Color
sub crusader_X, 2
mov crusader_Color, 4 ; Red
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color, 7 ; Light Grey
mov bx, 0
.WHILE bx < 5
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
sub crusader_X, 4
drawPixel crusader_X, crusader_Y, crusader_Color
; ----------------- Fifth Last Line -------------------
; Initializig Again
mov crusader_X, cx
dec crusader_Y
add crusader_X, 3
mov crusader_Color, 4; Red
mov bx, 0
.WHILE bx < 3
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
mov crusader_Color, 7 ; Light Grey
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color, 8 ; Dark Grey
mov bx, 0
.WHILE bx < 3
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
mov crusader_Color, 7 ; Light Grey
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color, 4 ; Red
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color, 7 ; Light Grey
sub crusader_X, 3
drawPixel crusader_X, crusader_Y, crusader_Color
; ----------------- Sixth Last Line -------------------
; Initializig Again
mov crusader_X, cx
dec crusader_Y
add crusader_X, 3
mov crusader_Color, 7 ; Light Grey
mov bx, 0
.WHILE bx < 2
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
mov crusader_Color, 4 ; Red
mov bx, 0
.WHILE bx < 7
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
mov crusader_Color, 7 ; Light Grey
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color, 4 ; Red
mov bx, 0
.WHILE bx < 4
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW

; ----------------- Seventh Last Line -------------------
; Initializig Again
mov crusader_X, cx
dec crusader_Y
add crusader_X, 2
mov crusader_Color, 7 ; Light Grey
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color, 4 ; Red
mov bx, 0
.WHILE bx < 2
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
mov crusader_Color, 7 ; Light Grey
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color, 14 ; Yellow
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color, 7 ; Light Grey
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color, 4 ; Red
mov bx, 0
.WHILE bx < 2
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
mov crusader_Color, 7 ; Light Grey
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color, 4 ; Red
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color,	7 ; Light Grey
mov bx, 0
.WHILE bx < 3
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
; ----------------- Eighth Last Line -------------------
; Initializig Again
mov crusader_X, cx
dec crusader_Y
add crusader_X, 2
mov crusader_Color,	4 ; Red
mov bx, 0
.WHILE bx < 2
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
mov crusader_Color,	7 ; Light Grey
mov bx, 0
.WHILE bx < 2
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
mov crusader_Color, 14 ; Yellow
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color,	7 ; Light Grey
mov bx, 0
.WHILE bx < 2
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
mov crusader_Color,	4 ; Red
mov bx, 0
.WHILE bx < 2
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
sub crusader_X, 2
mov crusader_Color, 7 ; Light Grey
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
; ----------------- Ninth Last Line -------------------
; Initializig Again
mov crusader_X, cx
dec crusader_Y
inc crusader_X
mov crusader_Color,	7 ; Light Grey
mov bx, 0
.WHILE bx < 3
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
mov crusader_Color, 14 ; Yellow
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color,	7 ; Light Grey
mov bx, 0
.WHILE bx < 3
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
sub crusader_X, 3
mov crusader_Color, 7 ; Light Grey
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
; ----------------- Tenth Last Line -------------------
; Initializig Again
mov crusader_X, cx
dec crusader_Y
inc crusader_X
mov crusader_Color, 7 ; Light Grey
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color,	0 ; Black
mov bx, 0
.WHILE bx < 2
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
mov crusader_Color, 14 ; Yellow
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color,	0 ; Black
mov bx, 0
.WHILE bx < 2
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
mov crusader_Color, 7 ; Light Grey
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
sub crusader_X, 3
mov crusader_Color, 7 ; Light Grey
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
; ----------------- Eleventh Last Line -------------------
; Initializig Again
mov crusader_X, cx
dec crusader_Y
inc crusader_X
mov crusader_Color,	7 ; Light Grey
mov bx, 0
.WHILE bx < 3
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
mov crusader_Color, 14 ; Yellow
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color,	7 ; Light Grey
mov bx, 0
.WHILE bx < 3
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
sub crusader_X, 3
mov crusader_Color, 7 ; Light Grey
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
; ----------------- Twelveth Last Line -------------------
; Initializig Again
mov crusader_X, cx
dec crusader_Y
inc crusader_X
mov crusader_Color,	7 ; Light Grey
mov bx, 0
.WHILE bx < 3
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
mov crusader_Color, 14 ; Yellow
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
mov crusader_Color,	7 ; Light Grey
mov bx, 0
.WHILE bx < 3
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
sub crusader_X, 3
mov crusader_Color, 7 ; Light Grey
drawPixel crusader_X, crusader_Y, crusader_Color
dec crusader_X
; ----------------- First Line -------------------
; Initializig Again
mov crusader_X, cx
dec crusader_Y
mov crusader_Color,	7 ; Light Grey
mov bx, 0
.WHILE bx < 5
	drawPixel crusader_X, crusader_Y, crusader_Color
	dec crusader_X
	inc bx
.ENDW
; --------------------- Little Crusader Completed ---------------

ret
drawCrusader endp




drawcrusaderSword proc

mov cx, tempCSx
mov crusaderSword_X, cx
mov cx, tempCSy
mov crusaderSword_Y, cx

mov cx, crusaderSword_X


inc crusaderSword_X
mov crusaderSword_Color, 4; Red
mov bx, 0
.WHILE bx < 3
	drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
	dec crusaderSword_X
	inc bx
.ENDW

; --------------
mov crusaderSword_X, cx
dec crusaderSword_Y
; --------------

add crusaderSword_X, 3
mov crusaderSword_Color, 4; Red
mov bx, 0
.WHILE bx < 3
	drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
	dec crusaderSword_X
	inc bx
.ENDW

mov crusaderSword_Color, 12 ; Orange
	drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
	dec crusaderSword_X
mov crusaderSword_Color, 4 ; Red
	drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
	dec crusaderSword_X
mov crusaderSword_Color, 12 ; Orange
	drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
	dec crusaderSword_X


; -------------------------------------------------

; --------------
mov crusaderSword_X, cx
dec crusaderSword_Y
; --------------

add crusaderSword_X, 3
mov crusaderSword_Color, 4; Red
mov bx, 0
.WHILE bx < 2
	drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
	dec crusaderSword_X
	inc bx
.ENDW

mov crusaderSword_Color, 12  ; Orange
mov bx, 0
.WHILE bx < 2
	drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
	dec crusaderSword_X
	inc bx
.ENDW

mov crusaderSword_Color, 14 ; Yellow
drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
dec crusaderSword_X

mov crusaderSword_Color, 12 ; Orange
drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
dec crusaderSword_X

mov crusaderSword_Color, 4 ; Red
drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
dec crusaderSword_X



; -------------------------------------------------

; --------------
mov crusaderSword_X, cx
dec crusaderSword_Y
; --------------

add crusaderSword_X, 3
mov crusaderSword_Color, 4; Red
mov bx, 0
.WHILE bx < 1
	drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
	dec crusaderSword_X
	inc bx
.ENDW

mov crusaderSword_Color, 12  ; Orange
mov bx, 0
.WHILE bx < 3
	drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
	dec crusaderSword_X
	inc bx
.ENDW

mov crusaderSword_Color, 14 ; Yellow
drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
dec crusaderSword_X

mov crusaderSword_Color, 12 ; Orange
drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
dec crusaderSword_X

mov crusaderSword_Color, 4 ; Red
drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
dec crusaderSword_X





; -------------------------------------------------

; --------------
mov crusaderSword_X, cx
dec crusaderSword_Y
; --------------

add crusaderSword_X, 2

mov crusaderSword_Color, 4; Red
mov bx, 0
.WHILE bx < 2
	drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
	dec crusaderSword_X
	inc bx
.ENDW

mov crusaderSword_Color, 12 ; Orange
mov bx, 0
.WHILE bx < 2
	drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
	dec crusaderSword_X
	inc bx
.ENDW

mov crusaderSword_Color, 4; Red
drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
dec crusaderSword_X


; -------------------------------------------

; --------------
mov crusaderSword_X, cx
dec crusaderSword_Y
; --------------

add crusaderSword_X, 4

mov crusaderSword_Color, 4; Red
mov bx, 0
.WHILE bx < 2
	drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
	dec crusaderSword_X
	inc bx
.ENDW

sub crusaderSword_X, 2

mov crusaderSword_Color, 4; Red
mov bx, 0
.WHILE bx < 2
	drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
	dec crusaderSword_X
	inc bx
.ENDW




; -------------------------------------------

; --------------
mov crusaderSword_X, cx
dec crusaderSword_Y
dec crusaderSword_Y
; --------------

add crusaderSword_X, 3

mov crusaderSword_Color, 4; Red
drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
dec crusaderSword_X
dec crusaderSword_X
drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color



; -------------------------------------------

; --------------
mov crusaderSword_X, cx
dec crusaderSword_Y
; --------------

add crusaderSword_X, 5

mov crusaderSword_Color, 4; Red
drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color
dec crusaderSword_X
dec crusaderSword_X
drawPixel crusaderSword_X, crusaderSword_Y, crusaderSword_Color



ret
drawcrusaderSword endp



drawCastle proc

mov cx, tempLx
mov castle_X, cx
mov cx, tempLy
mov castle_Y, cx
mov castle_Color, 13 	;Light Magenta


mov bx, 0
.WHILE bx < 18
drawPixel castle_X, castle_Y, castle_Color
dec castle_X
inc bx
.ENDW
inc castle_X

mov bx, 0
.WHILE bx < 11	;Second left Line Vertical
drawPixel castle_X, castle_Y, castle_Color
dec castle_Y
inc bx
.ENDW
inc castle_Y

mov bx, 0
.WHILE bx < 4
drawPixel castle_X, castle_Y, castle_Color
inc castle_X
inc bx
.ENDW
dec castle_X

mov bx, 0
.WHILE bx < 12
drawPixel castle_X, castle_Y, castle_Color
dec castle_Y
inc bx
.ENDW
inc castle_Y

mov bx, 0
.WHILE bx < 15
drawPixel castle_X, castle_Y, castle_Color
inc castle_X
inc bx
.ENDW
dec castle_X

mov bx, 0
.WHILE bx < 21
drawPixel castle_X, castle_Y, castle_Color
inc castle_Y
inc bx
.ENDW
dec castle_Y
dec castle_X

mov castle_Color, 13 	;Light Magenta

mov dx, castle_X

mov castle_Color, 13 	;Light Magenta
mov castle_Y, 67
mov castle_x, 125
mov bx, 0
.WHILE bx < 10
	drawPixel castle_X, castle_Y, castle_Color
	dec castle_Y
	inc bx
.ENDW

mov castle_Color, 13 	;Light Magenta
mov castle_Y, 67
mov castle_x, 122
mov bx, 0
.WHILE bx < 10
	drawPixel castle_X, castle_Y, castle_Color
	dec castle_Y
	inc bx
.ENDW

mov castle_Color, 13 	;Light Magenta
mov castle_Y, 67
mov castle_x, 118
mov bx, 0
.WHILE bx < 10
	drawPixel castle_X, castle_Y, castle_Color
	dec castle_Y
	inc bx
.ENDW

mov castle_Color, 13 	;Light Magenta
mov castle_Y, 67
mov castle_x, 115
mov bx, 0
.WHILE bx < 10
	drawPixel castle_X, castle_Y, castle_Color
	dec castle_Y
	inc bx
.ENDW


mov castle_Color, 10

mov castle_X, 123
mov castle_Y, 57
drawPixel castle_X, castle_Y, castle_Color
inc castle_X
drawPixel castle_X, castle_Y, castle_Color

inc castle_X
dec castle_Y
drawPixel castle_X, castle_Y, castle_Color
dec castle_Y
drawPixel castle_X, castle_Y, castle_Color

dec castle_X
dec castle_Y
drawPixel castle_X, castle_Y, castle_Color
dec castle_X
drawPixel castle_X, castle_Y, castle_Color

dec castle_X
inc castle_Y
drawPixel castle_X, castle_Y, castle_Color
inc castle_Y
drawPixel castle_X, castle_Y, castle_Color

mov castle_Color, 10

mov castle_X, 116
mov castle_Y, 57
drawPixel castle_X, castle_Y, castle_Color
inc castle_X
drawPixel castle_X, castle_Y, castle_Color

inc castle_X
dec castle_Y
drawPixel castle_X, castle_Y, castle_Color
dec castle_Y
drawPixel castle_X, castle_Y, castle_Color

dec castle_X
dec castle_Y
drawPixel castle_X, castle_Y, castle_Color
dec castle_X
drawPixel castle_X, castle_Y, castle_Color

dec castle_X
inc castle_Y
drawPixel castle_X, castle_Y, castle_Color
inc castle_Y
drawPixel castle_X, castle_Y, castle_Color


mov castle_Color, 0
mov castle_Y, 64
mov castle_x, 114
mov bx, 0
.WHILE bx < 8
	dec castle_X
	inc bx
.ENDW
;dec castle_X
inc castle_Y
mov bx, 0
.WHILE bx < 7
	inc castle_X
	inc castle_Y
	inc bx
.ENDW

add castle_x, 7
add castle_Y, 7
mov cx, castle_X
drawPixel castle_X, castle_Y, castle_Color

mov castle_X, cx
dec castle_Y
inc castle_x
drawPixel castle_X, castle_Y, castle_Color

dec castle_x
mov castle_Color, 4 ; Red
drawPixel castle_X, castle_Y, castle_Color

dec castle_x
mov castle_Color, 0 ; Black
drawPixel castle_X, castle_Y, castle_Color

dec castle_Y
mov castle_X, cx
add castle_X, 2
mov castle_Color, 0 ; Black
drawPixel castle_X, castle_Y, castle_Color
dec castle_X
mov castle_Color, 4 ; Red
mov bx, 0
.WHILE bx < 3
drawPixel castle_X, castle_Y, castle_Color
	dec castle_X
	inc bx
.ENDW

mov castle_Color, 0 ; Black
drawPixel castle_X, castle_Y, castle_Color


dec castle_Y
mov castle_X, cx
add castle_X, 3
mov castle_Color, 0 ; Black
drawPixel castle_X, castle_Y, castle_Color
dec castle_X
mov castle_Color, 4 ; Red
mov bx, 0
.WHILE bx < 5
drawPixel castle_X, castle_Y, castle_Color
	dec castle_X
	inc bx
.ENDW

mov castle_Color, 0 ; Black
drawPixel castle_X, castle_Y, castle_Color

dec castle_Y
mov castle_X, cx
add castle_X, 3
mov castle_Color, 0 ; Black
drawPixel castle_X, castle_Y, castle_Color
dec castle_X
mov castle_Color, 4 ; Red
mov bx, 0
.WHILE bx < 5
drawPixel castle_X, castle_Y, castle_Color
	dec castle_X
	inc bx
.ENDW

mov castle_Color, 0 ; Black
drawPixel castle_X, castle_Y, castle_Color


; ----------------

dec castle_Y
mov castle_X, cx
add castle_X, 3
mov castle_Color, 0 ; Black
drawPixel castle_X, castle_Y, castle_Color
dec castle_X
mov castle_Color, 4 ; Red
mov bx, 0
.WHILE bx < 5
drawPixel castle_X, castle_Y, castle_Color
	dec castle_X
	inc bx
.ENDW

mov castle_Color, 0 ; Black
drawPixel castle_X, castle_Y, castle_Color

mov castle_X, cx
drawPixel castle_X, castle_Y, castle_Color

; ----------------------


dec castle_Y
mov castle_X, cx
add castle_X, 2
mov castle_Color, 0 ; Black
mov bx, 0
.WHILE bx < 2
drawPixel castle_X, castle_Y, castle_Color
	dec castle_X
	inc bx
.ENDW

dec castle_X

mov bx, 0
.WHILE bx < 2
drawPixel castle_X, castle_Y, castle_Color
	dec castle_X
	inc bx
.ENDW

ret
drawCastle endp


end main		; The Game finally ends Here !