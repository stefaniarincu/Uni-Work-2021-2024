.data
	v: .long 10, 3, 2, 5, 2
	n: .long 5
	m1: .space 4
	m2: .space 4
.text
.globl _start
_start:
	lea v, %edi
	mov $0, %ecx
	mov (%edi, %ecx, 4), %eax
	inc %ecx
	mov (%edi, %ecx, 4), %ebx
	inc %ecx
	cmp %ebx, %eax
	jg e_s
e_s: 
	mov %eax, %edx
	mov %ebx, %eax
	mov %edx, %ebx
et_for:
	cmp n, %ecx
	je e_i
	mov (%edi, %ecx, 4), %edx
	inc %ecx
	cmp %eax, %edx
	jl e_1
	cmp %ebx, %edx
	jl e_2
	jmp et_for
e_1:
	mov %eax, %ebx
	mov %edx, %eax
	jmp et_for
e_2:
	mov %edx, %ebx
	jmp et_for
e_i:
 	mov %eax, m1
 	mov %ebx, m2
et_exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80

