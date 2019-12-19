file=$1
riscv32-unknown-linux-gnu-gcc -march=rv32i -o $file.o -c $file.s
riscv32-unknown-linux-gnu-objcopy -O binary $file.o $file.bin
xxd $file.bin
