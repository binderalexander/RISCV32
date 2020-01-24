.section .text
.global _start

_start:
	addi x1, x0, 0
	addi x1, x1, 1
	addi x1, x1, -1
	addi x1, x1, -1
	addi x1, x1, 1
	addi x1, x0, 5

loop:
	addi x1, x1, -1
	bnez x1, loop

	addi x1, x0, 711
