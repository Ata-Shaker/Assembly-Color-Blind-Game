Stack_Size      EQU     0x400;
	
				AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp

				AREA    RESET, DATA, READONLY
                EXPORT  __Vectors
                EXPORT  __Vectors_End

__Vectors       DCD     __initial_sp               ; Top of Stack
                DCD     Reset_Handler              ; Reset Handler
				DCD	0
				DCD	0
				DCD	0
				DCD	0
				DCD	0
				DCD	0
				DCD	0
				DCD	0
				DCD	0
				DCD	0
				DCD	0
				DCD	0
				DCD	0
				DCD	0
				DCD Button_Handler
			 
__Vectors_End    

				AREA    |.text|, CODE, READONLY
Reset_Handler   PROC
                EXPORT  Reset_Handler	
				ldr	 r0, =0xE000E100	;
				movs	 r1,#1			;
				str	 r1,[r0]			;			 
			    CPSIE	 i				;	 
                LDR     R0, =__main		;
                BX      R0				;
                ENDP

				AREA	 button, CODE, READONLY
Button_Handler	PROC
				EXPORT	 Button_Handler
				
				ldr	 r0, =0x40010010
				ldr	 r1,[r0]
				movs r3, r1
				movs r2,#0xFF
				ands r1,r1,r2
				cmp	 r1,#0
				beq	 release
				MOV r8, r1
				str	 r3,[r0]
				bx	lr
release			str	 r3,[r0]
				bx   lr	
	
                AREA    main, CODE, READONLY
                EXPORT	 __main			;make __main visible to linker	
				IMPORT arrow
				IMPORT title_screen
				IMPORT level_1
				IMPORT level_2
				IMPORT level_3
				IMPORT level_4
				IMPORT level_5
				IMPORT gameover_screen
				IMPORT zero_score
				IMPORT one_score
				IMPORT two_score
				IMPORT three_score
				IMPORT four_score
				IMPORT five_score
                ENTRY
__main          PROC
					
				MOVS r7, #0x0			;
				MOV r9, r7				;Score
				MOV r12, r7				;Level Number 
				
programStart	MOV r7, r12				;
				
				CMP r7, #0x0			;title_screen
				BEQ titleHandler					;
				
				CMP r7, #0x1			;Level_1
				BEQ lvl_1Handler		;
				
				CMP	r7, #0x2			;Level_2
				BEQ lvl_2Handler		;
				
				CMP r7, #0x3			;Level_3
				BEQ lvl_3Handler		;
				
				CMP r7, #0x4			;Level_4
				BEQ lvl_4Handler		;
				
				CMP r7, #0x5			;Level_5
				BEQ lvl_5Handler		;
				
				CMP r7, #0x6			;GameOver
				BEQ	gameover			;		
								
titleHandler 	LDR r0, =title_screen	;
				MOVS r7, #0x4			;The corret row in Level_1
				MOV r10, r7				;
				MOVS r7, #0x5			;The corret column in Level_1
				MOV r11, r7				;
				BAL printStart

lvl_1Handler 	LDR r0, =level_1		;
				MOVS r7, #0x1			;The corret row in Level_1
				MOV r10, r7				;
				MOVS r7, #0x2			;The corret column in Level_1
				MOV r11, r7				;
				BAL printStart

lvl_2Handler	LDR r0, =level_2		;
				MOVS r7, #0x0			;The corret row in Level_2
				MOV r10, r7				;
				MOVS r7, #0x1			;The corret column in Level_2
				MOV r11, r7				;
				BAL printStart			;
				
lvl_3Handler	LDR r0, =level_3		;
				MOVS r7, #0x2			;The corret row in Level_3
				MOV r10, r7				;
				MOVS r7, #0x2			;The corret column in Level_3
				MOV r11, r7				;
				BAL printStart			;
				
lvl_4Handler	LDR r0, =level_4		;
				MOVS r7, #0x2			;The corret row in Level_4
				MOV r10, r7				;
				MOVS r7, #0x0			;The corret column in Level_4
				MOV r11, r7				;
				BAL printStart			;
				
lvl_5Handler	LDR r0, =level_5		;
				MOVS r7, #0x2			;The corret row in Level_5
				MOV r10, r7				;
				MOVS r7, #0x1			;The corret column in Level_5
				MOV r11, r7				;
				BAL printStart			;								

gameover		LDR r0, =gameover_screen		;
                MOVS r7, #0x4			;The corret row in Level_5
                MOV r10, r7				;
				MOVS r7, #0x4			;The corret column in Level_5
				MOV r11, r7				;
				BAL printStart			;								
				
printStart		MOVS r2, #0x0			;Row Counter
				LDR r1, =0x40010000		;LCD Register
				
rowLoop			CMP r2, #120			;
				BEQ arStart				;
				MOVS r3, #0x0			;Col Counter
				
colLoop			CMP r3, #180			;
				BEQ colLoopDone			;
				STR r2, [r1]			;Assign LCD row
				
				STR r3, [r1, #0x4]		;Assign LCD col
				
				LDR r4, [r0]			;Pixel Register
				REV r4, r4				;
				MOVS r7, #8				;
				RORS r4, r4, r7			;
				STR r4, [r1, #0x8]		;
				
				
				ADDS r3, r3, #0x1		;Update Column Counter
				ADDS r0, r0, #0x4		;Shift the Pixel Register
				BAL colLoop

colLoopDone		ADDS r2, r2, #0x1		;
				BAL rowLoop			
;########################################
bridge_1		BAL  programStart		;Dummy Branch No.1
;########################################

arStart			MOV r7, r12				;
				CMP r7, #0x0			;Check if the program is on title_screen
				BEQ refreshScreen		;
				CMP r7, #0x6			;Check if program is on gameover screen
				BEQ printScore			;
				MOVS r2, #0x0			;
				LDR r0, =arrow			;
				
arRowLoop		CMP r2, #10				;
				BEQ refreshScreen		;
				MOVS r3, #0x0			;

arColLoop		CMP r3, #10		
                BEQ arColLoopDone		;
										
				MOVS r7, r2				;Handle Row_offset
				PUSH {r7}				;
				MOVS r7, r5				;
				PUSH {r5}				;
				MOVS r5, #24			;
				MULS r7, r5, r7			;
				ADDS r2, r2, r7			;
				POP {r5}				;
				POP {r7}				;
                ADDS r2, r2, #33		;
				STR r2, [r1]			;
				MOVS r2, r7				;
                
				MOVS r7, r3				;Handle Col_offset
				PUSH {r7}				;
				MOVS r7, r6				;
				PUSH {r6}				;
				MOVS r6, #36			;
				MULS r7, r6, r7			;
				ADDS r3, r3, r7			;
				POP {r6}				;
				POP {r7}				;
				ADDS r3, r3, #16		;
                STR r3, [r1, #0x4]		;
				MOVS r3, r7				;	
				
                LDR r4, [r0]			;
                REV r4, r4				;
                MOVS r7, #8				;
                RORS r4, r4, r7			;
                STR r4, [r1, #0x8]		;
                
                ADDS r3, r3, #0x1		;
                ADDS r0, r0, #0x4		;
                BAL arColLoop
                
arColLoopDone  	ADDS r2, r2, #0x1		;
				BAL arRowLoop			;
;########################################
printScore 		MOVS r2, #0x0			;
				MOV r7, r9				;
				
				CMP	r7, #0x0			;Checks if score is zero
				BEQ zeroHandler			;
				
				CMP	r7, #0x1			;Checks if score is one
				BEQ oneHandler			;
				
				CMP	r7, #0x2			;Checks if score is two
				BEQ twoHandler			;
				
				CMP	r7, #0x3			;Checks if score is three
				BEQ threeHandler		;
				
				CMP	r7, #0x4			;Checks if score is four
				BEQ fourHandler			;
				
				CMP	r7, #0x5			;Checks if score is five
				BEQ fiveHandler			;
				
zeroHandler		LDR r0, =zero_score		;
				BAL scRowLoop			;

oneHandler		LDR r0, =one_score		;
				BAL scRowLoop			;
					
twoHandler		LDR r0, =two_score		;
				BAL scRowLoop			;

threeHandler	LDR r0, =three_score	;
				BAL scRowLoop			;
				
fourHandler		LDR r0, =four_score		;
				BAL scRowLoop			;
				
fiveHandler		LDR r0, =five_score		;
				BAL scRowLoop			;
				
scRowLoop		CMP r2, #8				;
				BEQ refreshScreen		;
				MOVS r3, #0x0			;
				
scColLoop		CMP r3, #8		
                BEQ scColLoopDone		;
										
				MOVS r7, r2				;Handle Row_offset
                ADDS r2, r2, #83		;
				STR r2, [r1]			;
				MOVS r2, r7				;
                
				MOVS r7, r3				;Handle Col_offset
				ADDS r3, r3, #80		;
                STR r3, [r1, #0x4]		;
				MOVS r3, r7				;	
				
                LDR r4, [r0]			;
                REV r4, r4				;
                MOVS r7, #8				;
                RORS r4, r4, r7			;
                STR r4, [r1, #0x8]		;
                
                ADDS r3, r3, #0x1		;
                ADDS r0, r0, #0x4		;
                BAL scColLoop
                
scColLoopDone  	ADDS r2, r2, #0x1		;
				BAL scRowLoop			;				 
				
refreshScreen	MOVS r7, #0x1			;
				STR r7, [r1, #0xC]		;Set the Screen
				MOVS r7, #0x2			;
				STR r7, [r1, #0xC]		;Clear the Buffer & Screen
				
				MOV r7, r12				;
				CMP r7, #0x6			;
				BEQ gameFinished		;
				BAL	keyHandler
;########################################
bridge_2 		BAL bridge_1			;Dummy Branch No.2
;########################################
				
keyHandler		MOV r7, r8				;
				
				CMP r7, #0x4			;A Button Comparison 
				BEQ rowCheck			;
				
				CMP r7, #0x8			;B Button Comparison
				BEQ rowCheck			;
				
				CMP r7, #16				;Up Comparison 
				BEQ upHandler			;
				
				CMP r7, #32				;Down Comparison
				BEQ	downHandler
				
				CMP	r7, #64				;Left Handler
				BEQ leftHandler			;
				
				CMP r7, #128			;Right Handler
				BEQ rightHandler
				
				BAL bridge_2
				
upHandler		CMP r5, #0x0			;
				BEQ bridge_2			;
				SUBS r5, r5, #0x1		;
				MOVS r7, #0x0			;
				MOV r8, r7				;
				BAL bridge_2			;
				
downHandler		CMP r5, #0x2			;
				BEQ bridge_2			;
				ADDS r5, r5, #0x1		;
				MOVS r7, #0x0			;
				MOV r8, r7				;
				BAL bridge_2			;

leftHandler		CMP r6, #0x0			;
				BEQ bridge_2			;
				SUBS r6, r6, #0x1		;
				MOVS r7, #0x0			;
				MOV r8, r7				;
				BAL bridge_2			;

rightHandler	CMP r6, #0x3			;
				BEQ bridge_2			;
				ADDS r6, r6, #0x1		;
				MOVS r7, #0x0			;
				MOV r8, r7				;
				BAL bridge_2			;
				
rowCheck		MOV r7, r10				;Row Equality Comparison
				CMP r5, r7				;
				BEQ colCheck
				BAL nextLevel
				;BAL deductFromScore

colCheck		MOV r7, r11				;Col Equality Comparison
				CMP r6, r7				;
				BEQ addToScore			;
				BAL nextLevel
				;BAL deductFromScore

deductFromScore	MOV r7, r9				;Score Reduction
				CMP r7, #0x0			;Score cannot be negative
				BEQ nextLevel			;
				SUBS r7, r7, #0x1		;
				MOV r9, r7				;
				BAL nextLevel

addToScore		MOV r7, r9				;Score addition
				ADDS r7, r7, #0x1		;
				MOV r9, r7				;
				BAL nextLevel
				
nextLevel		MOVS r5, #0x0			;
				MOVS r6, #0x0			;
				MOV r7, r12				;
				ADDS r7, r7, #0x1		;
				MOV r12, r7				;
				MOVS r7, #0x0			;
				MOV r8, r7				;
				BAL bridge_2			;
				
gameFinished	BAL gameFinished		;

				ENDP
                END