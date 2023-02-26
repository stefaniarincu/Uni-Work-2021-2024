.data
	v: .long 5, 6, 7
	w: .long 10, 20, 30, 40
	r: .space 400
	n: .long 3
	m: .long 4
.text
.globl _start
_start:
	lea v, %edi
	lea w, %esi
	mov $0, %ecx
	mov n, %edx
	cmp %edx, m
	jg e_1	
	cmp %edx, m
	jle e_2
e_1:
	cmp n, %ecx
	je e_1_2
	mov (%edi, %ecx, 4), %edx
	add %edx, (%esi, %ecx, 4)
	inc %ecx
	jmp e_1
e_1_2:
	mov %esi, r
	jmp etexit
e_2:
	cmp m, %ecx
	je e_2_2
	mov (%esi, %ecx, 4), %edx
	add %edx, (%edi, %ecx, 4)
	inc %ecx
	jmp e_2
e_2_2:
	mov %edi, r
	jmp etexit
etexit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
