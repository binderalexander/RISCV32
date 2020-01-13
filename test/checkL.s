.section .text
.global _start

_start:
	# I Types

	add x1, x2, x3
	add x1, x1, x2
	addi x1, x0, 0
	addi x1, x0, 4

	sb x1, (x1)
	lb x2, (x0)
	sb x2, (x1)
	sh x2, (x1)
	sw x2, (x1)
	lh x3, (x1)
	lw x4, (x1)
	lbu x5, (x1)
	lhu x6, (x1)
