.data
   	v: .long 100,10, 5, 8, 10, 1000
   	n: .long 6
   	max: .space 4
   	ap: .space 4
.text
.globl _start
_start:
	lea v, %edi
	mov $0, %ecx
	mov (%edi, %ecx, 4), %eax
	mov %eax, %edx
	inc %ecx
	mov $1, %ebx
et_for:
	cmp n, %ecx
	je et_i
	mov (%edi, %ecx, 4), %eax
	inc %ecx
	cmp %eax, %edx
	jle et_me
	jmp et_for
et_me:
	cmp %eax, %edx
	je et_a
	mov $1, %ebx
	mov %eax, %edx
	
	jmp et_for
et_a:
	inc %ebx
	jmp et_for
et_i:
	mov %edx, max
	mov %ebx, ap
et_exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
