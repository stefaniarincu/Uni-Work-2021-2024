.data
	s: .space 1000
	n: .long 0
	m: .long 0
	chD: .asciz " "
	formatScanf: .asciz "%300[^\n]"
	formatPrintf: .asciz "%d "
	nL: .asciz "\n"
.text
.global main
main:
	pushl $s
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	pushl $chD
	pushl $s
	call strtok
	popl %ebx
	popl %ebx
	pushl %eax
	call atoi
	popl %ebx
	xorl %ecx, %ecx
	movl %eax, (%edi, %ecx, 4)
	incl %ecx	
et_cit:
	pushl %ecx
	pushl $chD
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je et_interm
	pushl %eax
	call atoi
	popl %ebx
	popl %ecx
	movl %eax, (%edi, %ecx, 4) 
	incl %ecx
	jmp et_cit
et_interm:
	movl %ecx, n
	movl n, %ebx
	decl %ebx
	movl %ebx, m
	xorl %ecx, %ecx
et_for:
	cmp m, %ecx
	je et_i
	movl (%edi, %ecx, 4), %eax
	incl %ecx
	movl %ecx, %edx
	jmp et_fori
et_fori:
	cmp n, %edx
	je et_for
	movl (%edi, %edx, 4), %ebx
	incl %edx
	cmp %eax, %ebx
	jl et_s
	jmp et_fori
et_s:
	decl %ecx
	decl %edx
	movl %eax, (%edi, %edx, 4)
	movl %ebx, (%edi, %ecx, 4)
	movl %ebx, %eax
	movl (%edi, %edx, 4), %ebx
	incl %ecx
	incl %edx
	jmp et_fori
et_i:
	xorl %ecx, %ecx
et_ff:
	cmp n, %ecx
	je et_exit
	movl (%edi, %ecx, 4), %eax
	pushl %ecx
	pushl %eax
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	pushl $0
	call fflush
	popl %ebx
	popl %ecx
	incl %ecx
	jmp et_ff
et_exit:
	movl $4, %eax
	movl $1, %ebx
	movl $nL, %ecx
	movl $2, %edx
	int $0x80
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
