.data
	str: .space 100
	chDelim: .asciz " "
	formatPrintf: .asciz "%d\n"
	formatScanf: .asciz "%300[^\n]"
	temp: .space 4
	index: .long 0
	a: .long 0
	b: .long 0
	c: .long 0
	d: .long 0
	e: .long 0
	f: .long 0
	g: .long 0
	h: .long 0
	i: .long 0
	j: .long 0
	k: .long 0
	l: .long 0
	m: .long 0
	n: .long 0
	o: .long 0
	p: .long 0
	q: .long 0
	r: .long 0
	s: .long 0
	t: .long 0
	u: .long 0
	v: .long 0
	w: .long 0
	x: .long 0
	y: .long 0
	z: .long 0
.text
.global main
main:
	pushl $str
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	pushl $chDelim
	pushl $str
	call strtok
	popl %ebx
	popl %ebx
	movl %eax, temp
	pushl %eax
	call atoi
	popl %ebx
	cmp $0, %eax
	je et_dif
	pushl %eax
et_for:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	movl %eax, temp
	pushl %eax
	call atoi
	popl %ebx
	cmp $0, %eax
	je et_dif
	pushl %eax
cont:
	jmp et_for
et_dif:
	movl temp, %edi
	movl $0, %ecx
	movb (%edi, %ecx, 1), %al
	incl %ecx
	movb (%edi, %ecx, 1), %bl
	cmp $0, %bl
	je et_ver
	cmp $97, %al
	je et_add
	cmp $100, %al
	je et_div
	cmp $109, %al
	je et_mul
	cmp $115, %al
	je et_sub
et_ver:
	cmp $97, %al
	je et_a
	cmp $98, %al
	je et_b
	cmp $99, %al
	je et_c
	cmp $100, %al
	je et_d
	cmp $101, %al
	je et_e
	cmp $102, %al
	je et_f
	cmp $103, %al
	je et_g
	cmp $104, %al
	je et_h
	cmp $105, %al
	je et_i
	cmp $106, %al
	je et_j
	cmp $107, %al
	je et_k
	cmp $108, %al
	je et_l
	cmp $109, %al
	je et_m
	cmp $110, %al
	je et_n
	cmp $111, %al
	je et_o
	cmp $112, %al
	je et_p
	cmp $113, %al
	je et_q
	cmp $114, %al
	je et_r
	cmp $115, %al
	je et_s
	cmp $116, %al
	je et_t
	cmp $117, %al
	je et_u
	cmp $118, %al
	je et_v
	cmp $119, %al
	je et_w
	cmp $120, %al
	je et_x
	cmp $121, %al
	je et_y
	cmp $122, %al
	je et_z
et_a:
	movl a, %ebx
	cmp $0, %ebx
	je et_sc_a
	pushl %ebx
	jmp cont
et_sc_a:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, a
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_b:
	movl b, %ebx
	cmp $0, %ebx
	je et_sc_b
	pushl %ebx
	jmp cont
et_sc_b:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, b
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_c:
	movl c, %ebx
	cmp $0, %ebx
	je et_sc_c
	pushl %ebx
	jmp cont
et_sc_c:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, c
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_d:
	movl d, %ebx
	cmp $0, %ebx
	je et_sc_d
	pushl %ebx
	jmp cont
et_sc_d:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, d
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_e:
	movl e, %ebx
	cmp $0, %ebx
	je et_sc_e
	pushl %ebx
	jmp cont
et_sc_e:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, e
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_f:
	movl f, %ebx
	cmp $0, %ebx
	je et_sc_f
	pushl %ebx
	jmp cont
et_sc_f:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, f
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_g:
	movl g, %ebx
	cmp $0, %ebx
	je et_sc_g
	pushl %ebx
	jmp cont
et_sc_g:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, g
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_h:
	movl h, %ebx
	cmp $0, %ebx
	je et_sc_h
	pushl %ebx
	jmp cont
et_sc_h:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, h
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_i:
	movl i, %ebx
	cmp $0, %ebx
	je et_sc_i
	pushl %ebx
	jmp cont
et_sc_i:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, i
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_j:
	movl j, %ebx
	cmp $0, %ebx
	je et_sc_j
	pushl %ebx
	jmp cont
et_sc_j:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, j
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_k:
	movl k, %ebx
	cmp $0, %ebx
	je et_sc_k
	pushl %ebx
	jmp cont
et_sc_k:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, k
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_l:
	movl l, %ebx
	cmp $0, %ebx
	je et_sc_l
	pushl %ebx
	jmp cont
et_sc_l:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, l
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_m:
	movl m, %ebx
	cmp $0, %ebx
	je et_sc_m
	pushl %ebx
	jmp cont
et_sc_m:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, m
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_n:
	movl n, %ebx
	cmp $0, %ebx
	je et_sc_n
	pushl %ebx
	jmp cont
et_sc_n:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, n
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_o:
	movl o, %ebx
	cmp $0, %ebx
	je et_sc_o
	pushl %ebx
	jmp cont
et_sc_o:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, o
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_p:
	movl p, %ebx
	cmp $0, %ebx
	je et_sc_p
	pushl %ebx
	jmp cont
et_sc_p:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, p
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_q:
	movl q, %ebx
	cmp $0, %ebx
	je et_sc_q
	pushl %ebx
	jmp cont
et_sc_q:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, q
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_r:
	movl r, %ebx
	cmp $0, %ebx
	je et_sc_r
	pushl %ebx
	jmp cont
et_sc_r:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, r
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_s:
	movl s, %ebx
	cmp $0, %ebx
	je et_sc_s
	pushl %ebx
	jmp cont
et_sc_s:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, s
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_t:
	movl t, %ebx
	cmp $0, %ebx
	je et_sc_t
	pushl %ebx
	jmp cont
et_sc_t:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, t
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_u:
	movl u, %ebx
	cmp $0, %ebx
	je et_sc_u
	pushl %ebx
	jmp cont
et_sc_u:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, u
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_v:
	movl v, %ebx
	cmp $0, %ebx
	je et_sc_v
	pushl %ebx
	jmp cont
et_sc_v:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, v
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_w:
	movl w, %ebx
	cmp $0, %ebx
	je et_sc_w
	pushl %ebx
	jmp cont
et_sc_w:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, w
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_x:
	movl x, %ebx
	cmp $0, %ebx
	je et_sc_x
	pushl %ebx
	jmp cont
et_sc_x:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, x
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_y:
	movl y, %ebx
	cmp $0, %ebx
	je et_sc_y
	pushl %ebx
	jmp cont
et_sc_y:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, y
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_z:
	movl z, %ebx
	cmp $0, %ebx
	je et_sc_z
	pushl %ebx
	jmp cont
et_sc_z:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, z
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	cmp $0, %eax
	je exit
	jmp cont
et_add:
	popl %ebx
	popl %eax
	addl %ebx, %eax
	pushl %eax
	jmp cont
et_div:
	xorl %edx, %edx
	popl %ebx
	popl %eax
	divl %ebx
	pushl %eax
	jmp cont
et_mul:
	popl %ebx
	popl %eax
	mull %ebx
	pushl %eax
	jmp cont
et_sub:
	popl %ebx
	popl %eax
	subl %ebx, %eax
	pushl %eax
	jmp cont
exit:
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	pushl $0
	call fflush
	popl %ebx
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
