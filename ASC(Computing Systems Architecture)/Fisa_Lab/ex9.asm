.data
	x: .long 27
	formatPrint: .asciz "%d "
	Nl: .asciz "\n"
.text

.global main
main:
	movl x, %eax
	movl $1, %ecx
et_div:
    	cmp %eax, %ecx
    	jg et_ret
    	xorl %edx, %edx
    	pushl %eax
    	divl %ecx
    	popl %eax
    	cmp $0, %edx
    	je et_scrie
et_interm:
    	incl %ecx
    	jmp et_div
et_scrie:
    	pushl %ecx
    	pushl %eax
    	pushl %ecx
	pushl $formatPrint
	call printf
	popl %ebx
	popl %ecx
	pushl $0
	call fflush
	popl %ebx
	popl %eax
	popl %ecx
    	jmp et_interm
et_ret:
	movl $4, %eax
	movl $1, %ebx
	movl $Nl, %ecx
	movl $2, %edx
	int $0x80
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80

