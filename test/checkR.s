.section .text
.global _start

_start:
	# R Types
	add x1, x2, x3
	add x1, x1, x2

	sub x1, x2, x3
	sub x1, x3, x2
	sub x1, x1, x2

	sll x1, x2, x3

	slt x1, x2, x3
	slt x1, x3, x2

	sltu x1, x2, x3
	sltu x1, x3, x2

	xor x1, x2, x3
	xor x1, x1, x2

	srl x1, x2, x3
	srl x1, x1, x2

	sra x1, x2, x3
	sra x1, x1, x2

	or x1, x2, x3
	or x1, x1, x2

	and x1, x1, x2
	and x1, x2, x3


	# I Types
	addi x1, x2, 0
	addi x1, x2, 1
	addi x1, x2, 444
	addi x1, x2, 2047

	slti x1, x2, 1
	slti x1, x2, 31
	slti x1, x2, 2047

	sltiu x1, x2, 1
	sltiu x1, x2, 31
	sltiu x1, x2, 2047

	xori x1, x2, 0
	xori x1, x2, 2047

	ori x1, x2, 0
	ori x1, x2, 2047

	andi x1, x2, 0
	andi x1, x2, 2047

	slli x1, x2, 0
	slli x1, x2, 1
	slli x1, x2, 31

	srli x1, x2, 0
	srli x1, x2, 1
	srli x1, x2, 31

	srai x1, x2, 0
	srai x1, x2, 1
	srai x1, x2, 31
