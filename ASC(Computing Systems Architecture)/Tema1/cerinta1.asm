.data
	sirb16: .space 100
	sir: .space 200
	formatScanf: .asciz "%s"
	formatPrintf: .asciz "%s\n"
	index: .long 0
.text
.global main
main:
	pushl $sirb16
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	movl $sirb16, %edi
	movl $sir, %esi
	xorl %ecx, %ecx
et_for:
	movb (%edi, %ecx, 1), %al
	cmp $0, %al
	je exit
	cmp $56, %al
	je cif8
	cmp $57, %al
	je cif9
	cmp $65, %al
	je litA
	cmp $67, %al
	je litC
cont:
	incl %ecx
	jmp et_for
cif8:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $48, %al
	je nr_0_15
	cmp $49, %al
	je nr_16_31
	cmp $50, %al
	je nr_32_47
	cmp $51, %al
	je nr_48_63
	cmp $52, %al
	je nr_64_79
	cmp $53, %al
	je nr_80_95
	cmp $54, %al
	je nr_96_111
	cmp $55, %al
	je nr_112_127
	cmp $56, %al
	je nr_128_143
	cmp $57, %al
	je nr_144_159
	cmp $65, %al
	je nr_160_175
	cmp $66, %al
	je nr_176_191
	cmp $67, %al
	je nr_192_207
	cmp $68, %al
	je nr_208_223
	cmp $69, %al
	je nr_224_239
	cmp $70, %al
	je nr_240_255
nr_0_15:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $65, %al
	jl n0_15_0
	pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	addl $1, index
	popl %ecx
	subb $17, %al
	jmp n0_15_0
n0_15_0:
	pushl %ecx
	movl index, %ecx
	movb %al, (%esi, %ecx, 1)
	inc %ecx
	movb $32, (%esi, %ecx,1)
	inc %ecx
	addl $2, index
	popl %ecx
	jmp cont
nr_16_31:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $52, %al
	jl n16_31_1
	cmp $69, %al
	jl n16_31_2
	pushl %ecx
	movl index, %ecx
	movl $51, (%esi, %ecx, 1)
	inc %ecx
	addl $1, index
	popl %ecx
	subb $21, %al
	jmp n0_15_0
n16_31_1:
	pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	addl $1, index
	popl %ecx
	addb $6, %al
	jmp n0_15_0
n16_31_2:
	pushl %ecx
	movl index, %ecx
	movl $50, (%esi, %ecx, 1)
	inc %ecx
	addl $1, index
	popl %ecx
	cmp $57, %al
	jle n16_31_2_2
	subb $11, %al
	jmp n0_15_0
n16_31_2_2:
	subb $4, %al
	jmp n0_15_0
nr_32_47:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $56, %al
	jl n32_47_3
	pushl %ecx
	movl index, %ecx
	movl $52, (%esi, %ecx, 1)
	inc %ecx
	addl $1, index
	popl %ecx
	cmp $57, %al
	jle n32_47_4
	subb $15, %al
	jmp n0_15_0
n32_47_3:
	pushl %ecx
	movl index, %ecx
	movl $51, (%esi, %ecx, 1)
	inc %ecx
	addl $1, index
	popl %ecx
	addb $2, %al
	jmp n0_15_0
n32_47_4:
	subb $8, %al
	jmp n0_15_0
nr_48_63:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $50, %al
	jl n48_63_4
	cmp $67, %al
	jl n48_63_5
	pushl %ecx
	movl index, %ecx
	movl $54, (%esi, %ecx, 1)
	inc %ecx
	addl $1, index
	popl %ecx
	subb $19, %al
	jmp n0_15_0
n48_63_4:
	pushl %ecx
	movl index, %ecx
	movl $52, (%esi, %ecx, 1)
	inc %ecx
	addl $1, index
	popl %ecx
	addb $8, %al
	jmp n0_15_0
n48_63_5:
	pushl %ecx
	movl index, %ecx
	movl $53, (%esi, %ecx, 1)
	inc %ecx
	addl $1, index
	popl %ecx
	cmp $57, %al
	jle n48_63_5_2
	subb $9, %al
	jmp n0_15_0
n48_63_5_2:
	subb $2, %al
	jmp n0_15_0
nr_64_79:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $54, %al
	jl n64_79_6
	pushl %ecx
	movl index, %ecx
	movl $55, (%esi, %ecx, 1)
	inc %ecx
	addl $1, index
	popl %ecx
	cmp $57, %al
	jle n64_79_7_2
        subb $13, %al
        jmp n0_15_0
n64_79_6:
	pushl %ecx
	movl index, %ecx
	movl $54, (%esi, %ecx, 1)
	inc %ecx
	addl $1, index
	popl %ecx
	addb $4, %al
	jmp n0_15_0
n64_79_7_2:
	subb $6, %al
	jmp n0_15_0
nr_80_95:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $65, %al
	jl n80_95_8
	pushl %ecx
	movl index, %ecx
	movl $57, (%esi, %ecx, 1)
	inc %ecx
	addl $1, index
	popl %ecx
	subb $17, %al
	jmp n0_15_0
n80_95_8:
	pushl %ecx
	movl index, %ecx
	movl $56, (%esi, %ecx, 1)
	inc %ecx
	addl $1, index
	popl %ecx
	jmp n0_15_0
nr_96_111:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $52, %al
	jl n96_111_9
	cmp $69, %al
	jl n96_111_10
	pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	subb $21, %al
	jmp n0_15_0
n96_111_9:
	pushl %ecx
	movl index, %ecx
	movl $57, (%esi, %ecx, 1)
	inc %ecx
	addl $1, index
	popl %ecx
	addb $6, %al
	jmp n0_15_0
n96_111_10:
        pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	movl $48, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	cmp $57, %al
	jle n96_111_10_2
	subb $11, %al
	jmp n0_15_0
n96_111_10_2:
	subb $4, %al
	jmp n0_15_0
nr_112_127:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $56, %al
	jl n112_127_11
	pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	movl $50, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	cmp $57, %al 
	jle nr112_127_12_2
        subb $15, %al
        jmp n0_15_0
n112_127_11:
	pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	addb $2, %al
	jmp n0_15_0
nr112_127_12_2:
	subb $8, %al
	jmp n0_15_0
nr_128_143:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $50, %al
	jl n128_143_12
	cmp $67, %al
	jl n128_143_13
	pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	movl $52, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	subb $19, %al
	jmp n0_15_0
n128_143_12:
	pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	movl $50, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	addb $8, %al
	jmp n0_15_0
n128_143_13:
	pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	movl $51, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	cmp $57, %al
	jle n128_143_13_2
	subb $9, %al
	jmp n0_15_0
n128_143_13_2:
	subb $2, %al
	jmp n0_15_0
nr_144_159:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $54, %al
	jl n144_159_14
	pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	movl $53, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	cmp $57, %al
	jle n144_159_15_2
	subb $13, %al
	jmp n0_15_0
n144_159_14:
	pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	movl $52, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	addb $4, %al
	jmp n0_15_0
n144_159_15_2:
	subb $6, %al
	jmp n0_15_0
nr_160_175:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $65, %al
	jl n160_175_16
	pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	movl $55, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	subb $17, %al
	jmp n0_15_0
n160_175_16:
	pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	movl $54, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	jmp n0_15_0
nr_176_191:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $52, %al
	jl n176_191_17
	cmp $69, %al
	jl n176_191_18
	pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	movl $57, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	subb $21, %al
	jmp n0_15_0
n176_191_17:
	pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	movl $55, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	addb $6, %al
	jmp n0_15_0
n176_191_18:
	pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	movl $56, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	cmp $57, %al
	jle n176_191_18_2
	subb $11, %al
	jmp n0_15_0
n176_191_18_2:
	subb $4, %al
	jmp n0_15_0
nr_192_207:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $56, %al
	jl n192_207_19
	pushl %ecx
	movl index, %ecx
	movl $50, (%esi, %ecx, 1)
	inc %ecx
	movl $48, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	cmp $57, %al
	jle n192_207_20_2
	subb $15, %al
	jmp n0_15_0
n192_207_19:
	pushl %ecx
	movl index, %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	movl $57, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	addb $2, %al
	jmp n0_15_0
n192_207_20_2:
	subb $8, %al
	jmp n0_15_0
nr_208_223:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $50, %al
	jl n208_223_20
	cmp $67, %al
	jl n208_223_21
	pushl %ecx
	movl index, %ecx
	movl $50, (%esi, %ecx, 1)
	inc %ecx
	movl $50, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	subb $19, %al
	jmp n0_15_0
n208_223_20:
        pushl %ecx
	movl index, %ecx
	movl $50, (%esi, %ecx, 1)
	inc %ecx
	movl $48, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	addb $8, %al
	jmp n0_15_0
n208_223_21:
        pushl %ecx
	movl index, %ecx
	movl $50, (%esi, %ecx, 1)
	inc %ecx
	movl $49, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	cmp $57, %al
	jle n208_223_21_2
	subb $9, %al
	jmp n0_15_0
n208_223_21_2:
        subb $2, %al
        jmp n0_15_0
nr_224_239:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $54, %al
	jl n224_239_22
	pushl %ecx
	movl index, %ecx
	movl $50, (%esi, %ecx, 1)
	inc %ecx
	movl $51, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	cmp $57, %al
	jle n224_239_23_2
	subb $13, %al
	jmp n0_15_0
n224_239_22:
	pushl %ecx
	movl index, %ecx
	movl $50, (%esi, %ecx, 1)
	inc %ecx
	movl $50, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	addb $4, %al
	jmp n0_15_0
n224_239_23_2:
	subb $6, %al
	jmp n0_15_0
nr_240_255:
	inc %ecx
	movb (%edi, %ecx, 1), %al
	cmp $65, %al
	jl n240_255_24
	pushl %ecx
	movl index, %ecx
	movl $50, (%esi, %ecx, 1)
	inc %ecx
	movl $53, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	subb $17, %al
	jmp n0_15_0
n240_255_24:
	pushl %ecx
	movl index, %ecx
	movl $50, (%esi, %ecx, 1)
	inc %ecx
	movl $52, (%esi, %ecx, 1)
	inc %ecx
	addl $2, index
	popl %ecx
	jmp n0_15_0
cif9:
	pushl %ecx
	movl index, %ecx
	movb $45, (%esi, %ecx, 1)
	incl %ecx
	addl $1, index
	popl %ecx
	jmp cif8
litA:
	incl %ecx
	movb (%edi, %ecx, 1), %al
	cmp $54, %al
	je et_a_o
	jmp et_p_z
et_a_o:
	incl %ecx
	movb (%edi, %ecx, 1), %al
	cmp $49, %al
	je et_a
	cmp $50, %al
	je et_b
	cmp $51, %al
	je et_c
	cmp $52, %al
	je et_d
	cmp $53, %al
	je et_e
	cmp $54, %al
	je et_f
	cmp $55, %al
	je et_g
	cmp $56, %al
	je et_h
	cmp $57, %al
	je et_i
	cmp $65, %al
	je et_j
	cmp $66, %al
	je et_k
	cmp $67, %al
	je et_l
	cmp $68, %al
	je et_m
	cmp $69, %al
	je et_n
	cmp $70, %al
	je et_o
et_a:
	push %ecx
	movl index, %ecx
	movb $97, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_b:
	push %ecx
	movl index, %ecx
	movb $98, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_c:
	push %ecx
	movl index, %ecx
	movb $99, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_d:
	push %ecx
	movl index, %ecx
	movb $100, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_e:
	push %ecx
	movl index, %ecx
	movb $101, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_f:
	push %ecx
	movl index, %ecx
	movb $102, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_g:
	push %ecx
	movl index, %ecx
	movb $103, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_h:
	push %ecx
	movl index, %ecx
	movb $104, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_i:
	push %ecx
	movl index, %ecx
	movb $105, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_j:
	push %ecx
	movl index, %ecx
	movb $106, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_k:
	push %ecx
	movl index, %ecx
	movb $107, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_l:
	push %ecx
	movl index, %ecx
	movb $108, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_m:
	push %ecx
	movl index, %ecx
	movb $109, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_n:
	push %ecx
	movl index, %ecx
	movb $110, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_o:
	push %ecx
	movl index, %ecx
	movb $111, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_p_z:
	incl %ecx
	movb (%edi, %ecx, 1), %al
	cmp $48, %al
	je et_p
	cmp $49, %al
	je et_q
	cmp $50, %al
	je et_r
	cmp $51, %al
	je et_s
	cmp $52, %al
	je et_t
	cmp $53, %al
	je et_u
	cmp $54, %al
	je et_v
	cmp $55, %al
	je et_w
	cmp $56, %al
	je et_x
	cmp $57, %al
	je et_y
	cmp $65, %al
	je et_z
et_p:
	push %ecx
	movl index, %ecx
	movb $112, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_q:
	push %ecx
	movl index, %ecx
	movb $113, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_r:
	push %ecx
	movl index, %ecx
	movb $114, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_s:
	push %ecx
	movl index, %ecx
	movb $115, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_t:
	push %ecx
	movl index, %ecx
	movb $116, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_u:
	push %ecx
	movl index, %ecx
	movb $117, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_v:
	push %ecx
	movl index, %ecx
	movb $118, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_w:
	push %ecx
	movl index, %ecx
	movb $119, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_x:
	push %ecx
	movl index, %ecx
	movb $120, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_y:
	push %ecx
	movl index, %ecx
	movb $121, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
et_z:
	push %ecx
	movl index, %ecx
	movb $122, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $2, index
	popl %ecx
	jmp cont
litC:
	inc %ecx
        inc %ecx
        movb (%edi, %ecx, 1), %al
        cmp $48, %al
        je et_let
        cmp $49, %al
        je et_add
        cmp $50, %al
        je et_sub
        cmp $51, %al
        je et_mul
        cmp $52, %al
        je et_div
et_let:
	pushl %ecx
	movl index, %ecx
	movb $108, (%esi, %ecx, 1)
	incl %ecx
	movb $101, (%esi, %ecx, 1)
	incl %ecx
	movb $116, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $4, index
	popl %ecx
	jmp cont
et_add:
	pushl %ecx
	movl index, %ecx
	movb $97, (%esi, %ecx, 1)
	incl %ecx
	movb $100, (%esi, %ecx, 1)
	incl %ecx
	movb $100, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $4, index
	popl %ecx
	jmp cont
et_sub:
	pushl %ecx
	movl index, %ecx
	movb $115, (%esi, %ecx, 1)
	incl %ecx
	movb $117, (%esi, %ecx, 1)
	incl %ecx
	movb $98, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $4, index
	popl %ecx
	jmp cont
et_mul:
	pushl %ecx
	movl index, %ecx
	movb $109, (%esi, %ecx, 1)
	incl %ecx
	movb $117, (%esi, %ecx, 1)
	incl %ecx
	movb $108, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $4, index
	popl %ecx
	jmp cont
et_div:
	pushl %ecx
	movl index, %ecx
	movb $100, (%esi, %ecx, 1)
	incl %ecx
	movb $105, (%esi, %ecx, 1)
	incl %ecx
	movb $118, (%esi, %ecx, 1)
	incl %ecx
	movb $32, (%esi, %ecx, 1)
	incl %ecx
	addl $4, index
	popl %ecx
	jmp cont
exit:
        pushl $sir
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
