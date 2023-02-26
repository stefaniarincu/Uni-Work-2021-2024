.data
	v: .long 10, 20, 35
	n: .long 3
	s: .space 4
	c: .space 4
	r: .space 4
.text
.globl _start
_start:
	lea v, %edi
	mov $0, %ecx
	mov $0, %eax
et_for:
	cmp n, %ecx
	je et_int
	mov (%edi, %ecx, 4), %edx
	add %edx, %eax
	inc %ecx
	jmp et_for
et_int:
	mov %eax, s
	mov $0, %edx
	div %ecx
	mov %eax, c
	mov %edx, r
et_exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
