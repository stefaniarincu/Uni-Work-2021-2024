.data
	v: .long 10, 15, 11, 15, 10
	n: .long 5
	s: .space 4
.text
.globl _start
_start:
	lea v, %edi
	mov $0, %eax
	mov $0, %ecx
e_xor:
	cmp n, %ecx
	je e_f
	mov (%edi, %ecx, 4), %edx
	xor %edx, %eax
	inc %ecx
	jmp e_xor
e_f:
	mov %eax, s
etexit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
