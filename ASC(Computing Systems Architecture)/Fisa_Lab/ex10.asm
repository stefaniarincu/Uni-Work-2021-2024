.data
	n: .long 49
	s1: .asciz "PRIM\n"
	s2: .asciz "COMPUS\n"
.text
.globl _start
_start:
	mov n, %eax
	mov $2, %ebx
	cmp %ebx, %eax
	je prim
	cmp %ebx, %eax
	jl compus
	mov $3, %ecx
	div %ebx
	mov %eax, %ebx
	cmp $0, %edx
	je compus
	cmp $0, %edx
	jmp for
for:
	cmp %ebx, %ecx
	jg prim
	mov n, %eax
	mov $0, %edx
	div %ecx
	cmp $0, %edx
	je compus
	inc %ecx
	jmp for
prim:
	mov $4, %eax
	mov $1, %ebx
	mov $s1, %ecx
	mov $5, %edx
	int $0x80
	jmp etexit
compus:
	mov $4, %eax
	mov $1, %ebx
	mov $s2, %ecx
	mov $7, %edx
	int $0x80
	jmp etexit
etexit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
