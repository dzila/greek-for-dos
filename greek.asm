GREEK	SEGMENT

	ASSUME	CS:GREEK


; //----------------------------------------- ΑΡΧΙΚΕΣ ΡΥΘΜΙΣΕΙΣ ΚΑΙ ΕΞΟΔΟΣ --//

	CLI				; Αλλαγή Segment και Offset της
	XOR	AX	,AX		; διακοπής INT 10H ώστε να περνά
	MOV	DS	,AX		; και από το πρόγραμμα αυτό
	MOV	AX	,DS:[64]
	MOV	BX	,DS:[66]
	MOV	DS:[66]	,CS
	MOV	DS:[64]	,Offset A00+256
	MOV	Word Ptr CS:[A01+257],AX
	MOV	Word Ptr CS:[A01+259],BX

	MOV	AX	,3		; Ενεργοποίηση αλλαγής
	INT	16

	PUSH	CS			; Εμφάνιση string στην οθόνη
	POP	ES
	MOV	AX	,4865
	XOR	DX	,DX
	MOV	BX	,15
	MOV	CX	,149
	MOV	BP	,Offset Grf+256
	INT	16
	
	MOV	AX	,12544		; Δέσμευση μνήμης για TSR
	MOV	DX	,4000
	INT	39


; //------------------------------------------ ΚΑΛΕΣΤΗΚΕ Η ΔΙΑΚΟΠΗ INT 10H --//

   A00:	CMP	AH	,0		; Αν υφισταται αλλαγή ανάλυσης
	JNZ	A01			; αποθηκευση του pointer επιστροφής
	PUSHF
	PUSH	CS
	DB	104
	DW	Offset A02+256
   A01:	DB	234,0,0,0,0		; Επιστροφή στην κύρια διακοπή

   A02:	PUSH	BX			; Ευρεση της ανάλυσης τwν χαρακτήρwν
	CMP	AL	,4		; από τις διάφορες καταστάσεις οθόνης
	JB	A03			; που δίνονται
	CMP	AL	,7
	JZ	A03
	CMP	AL	,20
	JZ	A03
	CMP	AL	,84
	JZ	A03
	CMP	AL	,85
	JZ	A03
	POP	BX
	IRET

   A05:	MOV	BX	,2048		; Ανάλυση χαρακτήρα 8 x 8
	MOV	Word Ptr CS:[A07+257],Offset Grf+1300
	MOV	Word Ptr CS:[A06+257],Offset Grf+1400
	JMP	SHORT A04

   A03:	MOV	BX	,4096		; Ανάλυση χαρακτήρα 16 x 8

   A04:	PUSH	AX			; Αλλαγή του set χαρακτήρwν
	PUSH	CX
	PUSH	DX
	PUSH	BP
	PUSH	ES
	PUSH	CS
	POP	ES
	MOV	AX	,4352
	MOV	CX	,46
	MOV	DX	,128
   A07:	MOV	BP	,Offset Grf+405
	INT	16
	MOV	CX	,18
	MOV	DX	,224	
   A06:	MOV	BP	,Offset Grf+1173
	INT	16
	POP	ES
	POP	BP
	POP	DX
	POP	CX
	POP	AX
	POP	BX
	IRET

   Grf:

GREEK	ENDS

END