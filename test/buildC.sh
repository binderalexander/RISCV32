file=$1
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -o $file.o -c $file.c
riscv64-unknown-elf-objcopy -O binary $file.o $file.bin
riscv64-unknown-elf-objcopy -I binary $file.bin -O ihex $file.hex
xxd $file.bin
cat $file.hex
riscv64-unknown-elf-objdump -D $file.o
rm $file.o
