; skeleton.asm
; my required comments

USE32         ; tell nasm to assemble 32 bit code

global _start ; export the start symbol for our program
_start:       ; tell the linker where our program begins
    ; beginning of program
							; set up stack frame
    mov  ebp, esp           ; set up a new stack frame

	; my code here
							; ebx for i, ecx for is_prime
    call read_integer		; read integer and save to eax
	push eax				; save input in the bottom of the stack, mark as #1

.main_loop:

    cmp eax, 0				; compare input integer and 0
    je .done_main			; exit program if value is 0

							; begin calculating
	mov edx, ebp			; get stack base
	sub edx, 4				; get address of input vale
    cmp dword [edx], 1		; compare input value with 1
    jne .not_1				; jump to other cases if not 1
    jmp .not_prime			; goto not prime is it'1

.not_1:

    mov eax, 1				; assign is_prime = true
	push eax				; save is_prime in stack, mark as #2
    mov eax, 2				; assign i = 2
	push eax				; save i in stack, mark as #3

.loop:

	mul eax					; get value of i*i and save in edx(higher) and eax(lower)
	mov ebx, ebp			; get stack base
	sub ebx, 4				; get address of input value save in ebx
	test edx, edx			; test the value of edx
	jnz .break_loop			; if higher 32 bits of i*i is not 0, break loop
	cmp [ebx], eax			; compare lower 32 bits of i*i with input value
	pop ebx					; clear i which is not needed anymore
    jb .break_loop			; resault found if the input is lower than i*i, break loop
							; start iteration
	mov ebx, ebp			; get stack base
	sub ebx, 4				; get address of input save in ebx
	mov ecx, ebx			; copy address of input into ecx
	sub ecx, 8				; get address of i
	mov eax, [ebx]			; save input value in eax
	xor edx, edx			; clear edx
	div dword [ecx]				; divide input by i
	test edx, edx			; test the value of remainder
    jnz .not_div			; jump if remainder is not 0
	pop ebx					; pop i out of stack and save in ebx
	pop ecx					; pop is_prime out and save in ecx
	mov ecx, 0				; make is_prime false
	push ecx				; save is_prime, mark as #2
	jmp .break_loop			; result found and break out of loop

.not_div:

	pop eax					; pop i out into eax
	inc eax					; increase eax by 1
	push eax				; save into stack, mark as #3
    jmp .loop				; jump back to calculate again

.break_loop:

	pop ebx					; get result from stack
    jz .not_prime			; if result is false, go to not prime block
    call print_prime		; print prime is result is true
    jmp .done_prime			; finish with current input

.not_prime:

	call print_not_prime;

.done_prime:

	mov esp, ebp			; clear the stack
    call read_integer		; read integer and save to eax
	push eax				; save input in the bottom of the stack, mark as #1

	jmp .main_loop			; run program again

.done_main:
  
	; exit
	mov ebx, 0
	mov eax, 1
	int 80h

; functions here
print_not_prime:
                             ; set up stack frame
    push ebp                 ; save the current stack frame
    mov  ebp, esp            ; set up a new stack frame

                             ; save modified registers
    push eax                 ; save eax
    push ebx                 ; save ebx
    push ecx                 ; save ecx
    push edx                 ; save edx

                             ; write not prime to stdout
    mov  eax, 4              ; syscall 4 (write)
    mov  ebx, 1              ; file descriptor (stdout)
    mov  ecx, .not_prime     ; pointer to data to load 
    mov  edx, .not_prime.l   ; byte count
    int  0x80                ; issue system call

                             ; cleanup
    pop  edx                 ; restore edx
    pop  ecx                 ; restore ecx
    pop  ebx                 ; restore ebx
    pop  eax                 ; restore eax
    pop  ebp                 ; restore ebp
    ret                      ; return to caller

.not_prime: db "not prime", 10
.not_prime.l equ $-.not_prime

print_prime:
                             ; set up stack frame
    push ebp                 ; save the current stack frame
    mov  ebp, esp            ; set up a new stack frame

                             ; save modified registers
    push eax                 ; save eax
    push ebx                 ; save ebx
    push ecx                 ; save ecx
    push edx                 ; save edx

                             ; write prime to stdout
    mov  eax, 4              ; syscall 4 (write)
    mov  ebx, 1              ; file descriptor (stdout)
    mov  ecx, .prime         ; pointer to data to load 
    mov  edx, .prime.l       ; byte count
    int  0x80                ; issue system call

                             ; cleanup
    pop  edx                 ; restore edx
    pop  ecx                 ; restore ecx
    pop  ebx                 ; restore ebx
    pop  eax                 ; restore eax
    pop  ebp                 ; restore ebp
    ret                      ; return to caller

.prime: db "prime", 10
.prime.l equ $-.prime

read_integer:
                             ; set up stack frame
    push ebp                 ; save the current stack frame
    mov  ebp, esp            ; set up a new stack frame

                             ; set up local variables
    sub  esp, 8              ; allocate space for two local ints
    mov  dword [ebp-4], '0'  ; digit: initialize to '0' 
    mov  dword [ebp-8], 0    ; value: initialize to 0

                             ; save modified registers
    push ebx                 ; save ebx
    push ecx                 ; save ecx
    push edx                 ; save edx

.read_loop:
                             ; update number calculation
    mov  eax, 10             ; load multiplier
    mul  dword [ebp-8]       ; multiply current value by 10, store in eax
    add  eax, [ebp-4]        ; add new digit to current value
    sub  eax, '0'            ; convert digit character to numerical equivalent
    mov  [ebp-8], eax        ; save new value

                             ; read in digit from user
    mov  eax, 3              ; syscall 3 (read)
    mov  ebx, 0              ; file descriptor (stdin)
    lea  ecx, [ebp-4]        ; pointer to data to save to
    mov  edx, 1              ; byte count
    int  0x80                ; issue system call

                             ; loop until enter is pressed
    cmp  dword [ebp-4], 10   ; check if end of line reached
    jne  .read_loop          ; if not, continue reading digits

                             ; cleanup
    mov  eax, [ebp-8]        ; save final value in eax
    pop  edx                 ; restore edx
    pop  ecx                 ; restore ecx
    pop  ebx                 ; restore ebx
    add  esp, 8              ; free local variables
    pop  ebp                 ; restore ebp
    ret                      ; return to caller
