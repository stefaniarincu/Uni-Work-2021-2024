.data
	a: .long 6
.text
.globl _start
_start:
	mov a, %eax
	mov a, %ecx
	dec %ecx
et_for:
	cmp $0, %ecx
	je et_i
	mul %ecx
	dec %ecx
	jmp et_for
et_i:
	mov %eax, a
et_exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
