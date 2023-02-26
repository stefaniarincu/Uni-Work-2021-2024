.data
	lines: .long 3
	columns: .long 4
	lineIndex: .space 4
	columnIndex: .space 4
	matrix: .long 10, 20, 30, 40
		.long 50, 60, 70, 80
		.long 90, 15, 25, 35
       formatInt: .asciz "%d "
       newLine: .asciz "\n"
.text
.global main
main:
	lea matrix, %edi
	movl $0, lineIndex
for_lines:
	movl lineIndex, %ecx
	cmp %ecx, lines
	je exit
	movl $0, columnIndex
	for_columns:
		movl columnIndex, %ecx
		cmp %ecx, columns
		je cont_for_lines
		movl lineIndex, %eax
		mull columns
		addl columnIndex, %eax
		movl (%edi, %eax, 4), %ebx
		pushl %ebx
		pushl $formatInt
		call printf
		popl %ebx
		popl %ebx
		pushl $0
		call fflush
		popl %ebx
		addl $1, columnIndex
		jmp for_columns
cont_for_lines:
	mov $4, %eax
	mov $1, %ebx
	mov $newLine, %ecx
	mov $2, %edx
	int $0x80
	addl $1, lineIndex
	jmp for_lines	
exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
