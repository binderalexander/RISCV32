.section .text
.global _start

.equ CONSTANT, 		0x100000
.equ PERIPH_OUT,   	0x00008000

_start:

	# reserve space for data
	li sp, 0
	li a0, 0x2000
	add sp, sp, a0

	# clear register
	li a0, 0

	# load peripheral address
	li a2, PERIPH_OUT

	# load compare value
	li a1, CONSTANT
loop:
	# increment
	addi a0, a0, 1

	# check loopcounter
	bge a0, a1, blink

	j loop

blink:
	# reset loop counter
	li a0, 0

	# increment peripheral value
	addi a3, a3, 1

	# write to peripheral
	sb a3, 0(a2)

	j loop


