for file in rv32*
do riscv64-unknown-elf-objcopy -O binary $file $file.bin
done
