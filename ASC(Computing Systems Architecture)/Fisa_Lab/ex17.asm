.data
	v: .long 1092, 209, 25, 1092, 209
	n: .long 5
	a: .space 4
.text
.globl _start
_start:
	lea v, %edi
	mov $0, %ecx
	mov $0, %eax
et_for:
	cmp n, %ecx
	je e_i
	mov (%edi, %ecx, 4), %edx
	xor %edx, %eax
	inc %ecx
	jmp et_for
e_i:
	mov %eax, a
et_exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
