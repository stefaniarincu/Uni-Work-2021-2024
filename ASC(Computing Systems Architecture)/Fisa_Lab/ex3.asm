.data
	a: .long 4
	b: .long 5
.text
.globl _start
_start:
	mov a, %eax
	mov b, %ebx
	xor %eax, %ebx
	xor %ebx, %eax
	xor %eax, %ebx
	mov %eax, a
	mov %ebx, b
etexit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
