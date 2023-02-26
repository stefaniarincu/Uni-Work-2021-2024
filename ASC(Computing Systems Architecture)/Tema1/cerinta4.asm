.data
	n: .space 4
	m: .space 4
	lineIndex: .space 4
	columnIndex: .space 4
	index: .space 4
	s1: .space 100
	var: .space 4
	op: .space 4
	fScan: .asciz "%300[^\n]"
	chD: .asciz " "
	formatPrintf: .asciz "%d "
	NL: .asciz "\n"
.text
.global main
main:
	pushl $s1
	pushl $fScan
	call scanf
	popl %ebx
	popl %ebx
	pushl $chD
	pushl $s1
	call strtok
	popl %ebx
	popl %ebx
	pushl $chD
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, n
	pushl $chD
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, m
	movl $0, lineIndex
et_for_i:
	movl lineIndex, %ecx
	cmp n, %ecx
	je et_urm
	movl $0, columnIndex
	et_for_j:
		movl columnIndex, %ecx
		cmp m, %ecx
		je cont
		xorl %eax, %eax
		pushl $chD
		pushl $0
		call strtok
		popl %ebx
		popl %ebx
		pushl %eax
		call atoi
		popl %ebx
		movl %eax, %ebx
		movl lineIndex, %eax
		movl $0, %edx
		mull m
		add columnIndex, %eax
		movl %ebx, (%edi, %eax, 4) 
		incl columnIndex
		jmp et_for_j
cont:
	incl lineIndex
	jmp et_for_i
et_urm:
	pushl $chD
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	pushl $chD
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	movl %eax, var
	pushl %eax
	call atoi
	popl %ebx
	cmp $0, %eax
	jne et_op_a
	jmp et_dif
et_dif:
	movl var, %esi
	movl $1, %ecx
	movb (%esi, %ecx, 1), %bl
	cmp $111, %bl
	je et_u
	pushl $chD
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	pushl %eax
	call atoi
	popl %ebx
	cmp $0, %eax
	je et_u
	movl %eax, op
	pushl n
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	pushl m
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	pushl $chD
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	movl %eax, var
	jmp et_opp
et_op_a:
	movl %eax, op
	pushl n
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	pushl m
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	pushl $chD
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	movl %eax, var
et_opp:
	movl var, %esi
	movl $0, %ecx
	movb (%esi, %ecx, 1), %al
	cmp $97, %al
	je et_add
	cmp $100, %al
	je et_div
	cmp $109, %al
	je et_mul
	cmp $115, %al
	je et_sub
et_add:
	movl $0, lineIndex
	for_lines_add:
		movl lineIndex, %ecx
		cmp n, %ecx
		je exit
		movl $0, columnIndex
		for_columns_add:
			movl columnIndex, %ecx
			cmp m, %ecx
			je contin_add
			xorl %eax, %eax
			xorl %ebx, %ebx
			movl lineIndex,%eax
			movl $0, %edx
			mull m
			addl columnIndex, %eax
			movl (%edi, %eax, 4), %ebx
			movl op, %eax
			addl %eax, %ebx
			pushl %ebx
			pushl $formatPrintf
			call printf
			popl %ebx
			popl %ebx
			incl columnIndex
			jmp for_columns_add
	contin_add:
		incl lineIndex
		jmp for_lines_add
et_div:
	movl $0, lineIndex
	for_lines_div:
		movl lineIndex, %ecx
		cmp n, %ecx
		je exit
		movl $0, columnIndex
		for_columns_div:
			movl columnIndex, %ecx
			cmp m, %ecx
			je contin_div
			xorl %eax, %eax
			xorl %ebx, %ebx
			movl lineIndex,%eax
			movl $0, %edx
			mull m
			addl columnIndex, %eax
			movl (%edi, %eax, 4), %ebx
			cmp $0, %ebx
			jl et_sc
			movl %ebx, %eax
			movl op, %ebx
			xorl %edx, %edx
			idivl %ebx
		et_int:	
			pushl %eax
			pushl $formatPrintf
			call printf
			popl %ebx
			popl %ebx
			incl columnIndex
			jmp for_columns_div
	contin_div:
		incl lineIndex
		jmp for_lines_div
et_sc:
	negl %ebx
	movl %ebx, %eax
	movl op, %ebx
	xorl %edx, %edx
	idivl %ebx
	negl %eax
	jmp et_int
et_mul:
	movl $0, lineIndex
	for_lines_mul:
		movl lineIndex, %ecx
		cmp n, %ecx
		je exit
		movl $0, columnIndex
		for_columns_mul:
			movl columnIndex, %ecx
			cmp m, %ecx
			je contin_mul
			xorl %eax, %eax
			xorl %ebx, %ebx
			xorl %edx, %edx
			movl lineIndex,%eax
			movl $0, %edx
			mull m
			addl columnIndex, %eax
			movl (%edi, %eax, 4), %ebx
			xorl %edx, %edx
			movl %ebx, %eax
			movl op, %ebx
			imull %ebx
			pushl %eax
			pushl $formatPrintf
			call printf
			popl %ebx
			popl %ebx
			incl columnIndex
			jmp for_columns_mul
	contin_mul:
		incl lineIndex
		jmp for_lines_mul
et_sub:
	movl $0, lineIndex
	movl op, %eax
	cmp $0, %eax
	jl et_subn
	for_lines_sub:
		movl lineIndex, %ecx
		cmp n, %ecx
		je exit
		movl $0, columnIndex
		for_columns_sub:
			movl columnIndex, %ecx
			cmp m, %ecx
			je contin_sub
			xorl %eax, %eax
			xorl %ebx, %ebx
			movl lineIndex,%eax
			movl $0, %edx
			mull m
			addl columnIndex, %eax
			movl (%edi, %eax, 4), %ebx
			movl op, %eax
			subl %eax, %ebx
			pushl %ebx
			pushl $formatPrintf
			call printf
			popl %ebx
			popl %ebx
			incl columnIndex
			jmp for_columns_sub
	contin_sub:
		incl lineIndex
		jmp for_lines_sub
et_subn:
	negl %eax
	movl %eax, op
	jmp et_add
et_u:
	pushl m
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	pushl n
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	movl $0, lineIndex
	for_lines:
		movl lineIndex, %ecx
		cmp m, %ecx
		je exit
		movl n, %eax
		movl %eax, columnIndex
		decl columnIndex
		for_columns:
			movl columnIndex, %ecx
			cmp $0, %ecx
			jl contin
			movl columnIndex, %eax
			movl $0, %edx
			mull m
			addl lineIndex, %eax
			movl (%edi, %eax, 4), %ebx
			pushl %ebx
			pushl $formatPrintf
			call printf
			popl %ebx
			popl %ebx
			pushl $0
			call fflush
			popl %ebx
			decl columnIndex
			jmp for_columns
	contin:
		incl lineIndex
		jmp for_lines	
exit:
	pushl $0
	call fflush
	popl %ebx
	movl $4, %eax
	movl $1, %ebx
	movl $NL, %ecx
	movl $2, %edx
	int $0x80
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
