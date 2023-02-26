.data
	str: .space 100
	chDelim: .asciz " "
	formatPrintf: .asciz "%d\n"
	formatScanf: .asciz "%300[^\n]"
	res: .long 0
	op: .space 4
.text
.global main
main:
	pushl $str
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	pushl $chDelim
	pushl $str
	call strtok
	popl %ebx
	popl %ebx
	pushl %eax
	call atoi
	popl %ebx
	pushl %eax
et_for:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	movl %eax, op
	pushl %eax
	call atoi
	popl %ebx
	cmp $0, %eax
	je et_op
	pushl %eax
cont:
	jmp et_for
et_op:
	movl op, %edi
	xorl %ecx, %ecx
	movb (%edi, %ecx, 1), %al
	cmp $97, %al
	je et_add
	cmp $100, %al
	je et_div
	cmp $109, %al
	je et_mul
	cmp $115, %al
	je et_sub
et_add:
	popl %ebx
	popl %eax
	addl %ebx, %eax
	pushl %eax
	jmp cont
et_div:
	xorl %edx, %edx
	popl %ebx
	cmp $0, %ebx
	je nu_ex
	popl %eax
	cmp $0, %eax
	je nu_ex_2
	divl %ebx
	pushl %eax
	jmp cont
et_mul:
	popl %ebx
	popl %eax
	mull %ebx
	pushl %eax
	jmp cont
et_sub:
	popl %ebx
	popl %eax
	subl %ebx, %eax
	pushl %eax
	jmp cont
nu_ex:
	popl %eax
	pushl %ebx
	jmp cont
nu_ex_2:
	pushl %eax
	jmp cont
exit:
	popl %eax
	movl %eax, res
	pushl res
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	pushl $0
	call fflush
	popl %ebx
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
