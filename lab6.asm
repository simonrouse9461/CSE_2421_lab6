; skeleton.asm
; my required comments

USE32         ; tell nasm to assemble 32 bit code

global _start ; export the start symbol for our program
_start:       ; tell the linker where our program begins
    ; beginning of program

	; my code here

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
