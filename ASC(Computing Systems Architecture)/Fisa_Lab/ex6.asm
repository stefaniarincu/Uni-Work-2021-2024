.data
	x: .long 1
.text
.globl _start
_start:
	mov x, %eax
	mov $2, %ebx
	mov $0, %ecx
et_for:
	cmp $1, %eax
	jle et_exit
	mov $0, %edx
	inc %ecx
	div %ebx
	jmp et_for
et_exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
