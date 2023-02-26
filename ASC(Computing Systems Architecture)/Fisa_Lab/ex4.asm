.data
	x: .long 16
.text
.globl _start
_start:
	mov x, %eax
	mov %eax, %ebx
	mov $2, %eax
	mov $2, %ecx
et_for:
 	cmp %eax, %ebx
 	jle et_exit
        mul %ecx
        jmp et_for
et_exit:
       mov $1, %eax
       mov $0, %ebx
       int $0x80
