.data
	n: .space 4
	lineIndex: .space 4
	columnIndex: .space 4
	matrix: .space 1600
	nrMuchii: .space 4
	index: .space 4
	left: .space 4
	right: .space 4
	formatScanf: .asciz "%d"
	formatPrintf: .asciz "%d "
	newLine: .asciz "\n"
.text
.global main
main:
	pushl $n
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	pushl $nrMuchii
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	movl $0, index
et_for:
	movl index, %ecx
	cmp %ecx, nrMuchii
	je af_mat
	pushl $left
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	pushl $right
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	movl left, %eax
	mull n
	addl right, %eax
	lea matrix, %edi
	movl $1, (%edi, %eax, 4)
	incl index
	jmp et_for
af_mat:
	movl $0, lineIndex
	for_lines:
		movl lineIndex, %ecx
		cmp %ecx, n
		je exit
		movl $0, columnIndex
		for_columns:
			movl columnIndex, %ecx
			cmp %ecx, n
			je cont
			movl lineIndex,%eax
			movl $0, %edx
			mull n
			add columnIndex, %eax
			lea matrix, %edi
			movl (%edi, %eax, 4), %ebx
			pushl %ebx
			pushl $formatPrintf
			call printf
			popl %ebx
			popl %ebx
			pushl $0
			call fflush
			popl %ebx
			incl columnIndex
			jmp for_columns
	cont:
		movl $4, %eax
		movl $1, %ebx
		movl $newLine, %ecx
		movl $2, %edx
		int $0x80
		incl lineIndex
		jmp for_lines
exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
