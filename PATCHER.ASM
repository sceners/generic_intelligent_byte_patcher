;***************************************************************
;*              Generic Intelligent Byte Patcher               *
;*                   Coded by Aesculapius                      *
;*   Instructions: Compile this file as a .COM executable      *
;*            This program was prepared to crack               *
;*                    UltraEdit v. 4.40c                       *
;*                                                             *
;*                                                             *
;***************************************************************

.MODEL SMALL
.CODE
ORG     100H
START:          JMP     BEGIN

;******************************************************************************
;                  MODIFY THESE DATA ACCORDING TO THE CRACK
;******************************************************************************

LOB     EQU     0000H                   ;FIRST HALF OF THE OFFSET TO PATCH    
HOB     EQU     4ACCH                   ;SECOND HALF OF THE OFFSET TO PATCH  
LENGHT  EQU     01H                     ;NUMBER OF BYTES TO BE PATCHED
PATCH_DATA      DB 0C0H,0               ;THE PATCHING SEQUENCE            
PREV_DATA       DB 080H,0               ;PREVIOS CONTENTS OF THE LOCATION
                                        ;TO BE PATCHED
FILE_NAME       DB 'uedit32.exe',0      ;FILENAME TO BE PATCHED          

LOGO            DB '≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤ ',0AH,0DH
                DB '≤≤…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª≤≤ ',0AH,0DH
                DB '≤≤∫    Cracked by Aesculapius    ∫≤≤ ',0AH,0DH
                DB '≤≤∫             -.-              ∫≤≤ ',0AH,0DH
                DB '≤≤∫ Software: UltraEdit 4.40c    ∫≤≤ ',0AH,0DH
                DB '≤≤∫    aesculapius.home.ml.org   ∫≤≤ ',0AH,0DH
                DB '≤≤∫ aesculapius@cyberjunkie.com  ∫≤≤ ',0AH,0DH
                DB '≤≤∫     -= Aesculapius 97 =-     ∫≤≤ ',0AH,0DH
                DB '≤≤»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº≤≤ ',0AH,0DH
                DB '≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤ ',0AH,0DH
                DB '$'

ERROR1          DB 'THE FILE TO BE CRACKED WAS NOT FOUND!!!      ',0AH,0DH
                DB 'Be sure to execute the crack from the same   ',0AH,0DH
                DB 'directory where UEDIT32.EXE is located.      ',0AH,0DH,07H
		DB '$'
		
ERROR2          DB 'UNKNOWN ERROR            ',0AH,0DH
                DB 'THE CRACK WAS NOT APPLIED',0AH,0DH,07H
		DB '$'
		
ERROR3          DB 'The file UEDIT32.EXE is write-protected.   ',0AH,0DH
                DB 'Change the file attributes and apply the   ',0AH,0DH
                DB 'crack again.                               ',0AH,0DH,07H
		DB '$'
		
ERROR4          DB 'The location to be patched was not found!      ',0AH,0DH
                DB 'This could happen if:                          ',0AH,0DH
                DB '- The program has been already cracked.        ',0AH,0DH
                DB '- This is a different version of the program.  ',0AH,0DH
                DB 'Please, contact the author of this crack at    ',0AH,0DH
                DB 'aesculapius@cryogen.com to get an update.      ',0AH,0DH,07H
                DB '$'

HANDLE          DW 0

;******************************************************************************
;                      OPEN FILE TO BE CRACKED         
;******************************************************************************

OPEN_FILE       PROC    NEAR

                MOV     DX, OFFSET FILE_NAME ; FILENAME TO BE CRACKED
                MOV     AX, 3D02H            ; PREPARE TO EXECUTE INTERRUPT
		INT     21H
                JNC     DONE                 ; IF NO ERROR OCCURED JUMP DONE
                                             ; 
                CMP     AX, 05H              ; ERROR RELATED TO READ_ONLY ATTRIBUTE
                JZ      READ_ONLY

                MOV     AH, 09H
                MOV     DX, OFFSET ERROR1    ; FILE NOT FOUND ERROR DISPLAYED
		INT     21H
                JMP     EXIT

READ_ONLY:      MOV     AH, 09H              ; READ_ONLY ERROR DISPLAYED
                MOV     DX, OFFSET ERROR3
                INT     21H
                JMP     EXIT
		
DONE:           MOV     HANDLE, AX           ; SAVE FILE HANDLE FOR LATER USE
                RET                          ; PROCEDURE ENDS           

OPEN_FILE       ENDP

;******************************************************************************
;                  MOVE FILE POINTER TO THE PATCHING LOCATION      
;******************************************************************************

MOVE_POINTER    PROC    NEAR

                MOV     AX, 4200H
                MOV     BX, HANDLE                                     
                MOV     CX, LOB                                              
                MOV     DX, HOB                                      
                INT     21H                                            
                JNC     OK                                               

                MOV     AH, 09H
                MOV     DX, OFFSET ERROR2
                INT     21H                                                  
                JMP     EXIT                           

OK:             RET

MOVE_POINTER    ENDP

;******************************************************************************
;                       CHECKING PROGRAM AUTHENTICITY                   
;******************************************************************************

COMPARE_FILE    PROC    MAIN

                MOV     AH, 3FH
                MOV     BX, HANDLE
                MOV     CX, LENGHT
                INT     21H
                MOV     SI, DX
                MOV     DI, OFFSET PREV_DATA
                MOV     CX, LENGHT
                REP     CMPSB
                JNZ     ERROR_COMP

                JMP     FINAL  

ERROR_COMP:     MOV     AH, 09H
                MOV     DX, OFFSET ERROR4
                INT     21H
                JMP     EXIT

FINAL:          RET

COMPARE_FILE    ENDP

;******************************************************************************
;                          EXECUTE THE PATCH                          
;******************************************************************************

PATCH_FILE      PROC    NEAR

                MOV     AH, 40H
                MOV     BX, HANDLE                                   
                MOV     CX, LENGHT                                               
                MOV     DX, OFFSET PATCH_DATA                             
                INT     21H                                       
                JNC     CLOSE_FILE                                        

                MOV     AH, 3EH
		INT     21H
                MOV     AH, 09H                                        
                MOV     DX, OFFSET ERROR2                                     
                INT     21H                                                    
                JMP     EXIT                                         
	    
CLOSE_FILE:     MOV     AH,3EH                                         
                INT     21H                                             

		RET

PATCH_FILE      ENDP

;******************************************************************************
;                              MAIN ENGINE
;******************************************************************************

BEGIN           PROC    NEAR

                CALL    OPEN_FILE               ;OPEN FILE
                CALL    MOVE_POINTER            ;SET POINTER LOCATION        
                CALL    COMPARE_FILE            ;CHECKS FILE AUTHENCITY
                CALL    MOVE_POINTER            ;RELOCATE POINTER AGAIN
                CALL    PATCH_FILE              ;EXECUTES PATCH

                MOV     AH, 09H
                MOV     DX, OFFSET LOGO                           
		INT     21H

EXIT:           MOV     AX, 4C00H                          
		INT     21H

BEGIN           ENDP

		END     START                
