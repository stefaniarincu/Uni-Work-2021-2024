.data
	x: .long 3
	v: .long 1, 3, 7, 9, 15
	n: .long 5
	formatPrint: .asciz "%d\n"
.text
.global main
main:
	lea v, %edi
	movl n, %eax
	movl $0, %ecx
caut_bin:
	pushl %eax
	subl %ecx, %eax
	cmp $0, %eax
	jle et_interm
	movl $2, %ebx
	xorl %edx, %edx
	divl %ebx
	movl %eax, %edx
	popl %eax
	movl (%edi, %edx, 4), %ebx
	cmp x, %ebx
	je et_gas
	cmp x, %ebx
	jl et_mai_mare
	jmp et_mai_mic
   et_mai_mare:
   	incl %edx
   	movl %edx, %ecx
   	jmp caut_bin
   et_mai_mic:
   	decl %edx
   	movl %edx, %eax
   	jmp caut_bin
   et_interm:
   	cmp $0, %eax
	jl et_nu_exi
	movl (%edi, %ecx, 4), %ebx
	cmp x, %ebx
	je et_gas
	jmp et_nu_exi
   et_gas:
   	movl %edx, %eax
   	pushl %eax
   	pushl $formatPrint
   	call printf
   	popl %ebx
   	popl %ebx
   	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
   et_nu_exi:
   	movl $-1, %eax
   	pushl %eax
   	pushl $formatPrint
   	call printf
   	popl %ebx
   	popl %ebx
   	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
   	
