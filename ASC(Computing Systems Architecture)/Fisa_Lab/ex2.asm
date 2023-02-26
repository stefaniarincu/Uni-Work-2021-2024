.data
	x: .long -2
	s1: .asciz "egal cu 0\n"
	s2: .asciz "negativ\n"
	s3: .asciz "pozitiv\n"
.text
.global main
main:
	mov x, %eax
	cmp $0, %eax
	je et_egal
	cmp $0, %eax
	jl et_neg
	mov $4, %eax 
	mov $1, %ebx
	mov $s3, %ecx
	mov $8, %edx
	int $0x80
	jmp et_exit
et_egal:
	mov $4, %eax 
	mov $1, %ebx
	mov $s1, %ecx
	mov $10, %edx
	int $0x80
	jmp et_exit
et_neg:
	mov $4, %eax 
	mov $1, %ebx
	mov $s2, %ecx
	mov $8, %edx
	int $0x80
	jmp et_exit
et_exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80

