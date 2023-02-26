.data
	v: .long 10, 15, 30
	n: .long 3
.text
.globl _start
_start:
	lea v, %edi
	mov $0, %ecx
	mov $0, %eax
et_for:
	cmp %ecx, n
	je etexit
	mov (%edi, %ecx, 4), %ebx
	add %ebx, %eax
	inc %ecx
	jmp et_for
etexit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
