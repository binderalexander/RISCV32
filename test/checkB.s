.section .text
.global _start

_start:
	addi x1, x0, 3
loop0:				# execute 3 times
	addi x1, x1, -1
	bnez x1, loop0

	addi x1, x0, 1
	beqz x1, err
	addi x1, x0, 0
	beqz x1, part2

err:
	j err

part2:
	addi x1, x0, 0
	addi x2, x0, 3
loop1:
	addi x1, x1, 1
	ble x1, x2, loop1

loop2:
	addi x1, x1, -1
	bgt x1, x0, loop2

finished:
	j finished
