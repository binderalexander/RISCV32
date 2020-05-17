.section .text
.global _start

_start:
	addi x1, x0, 2	# load 2
	addi x2, x0, 3	# load 3
	add  x3, x1, x2 # add x1 and x2, store in x3
	addi x4, x0, 5	# load 5
	beq x3, x4, pass

	addi x4, x0, -1
fail:
	j fail
pass:
	addi x4, x0, 1

# passed: x4 == 1, failed: x4  != 1
