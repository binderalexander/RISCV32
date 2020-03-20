file=$1
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -o $file.o -c $file.s
riscv64-unknown-elf-objcopy -O binary $file.o $file.bin
xxd $file.bin
riscv64-unknown-elf-objdump --disassemble $file.o
rm $file.o
