# remove file list

rm rv32tests.txt 

for file in rv32*
do 
	riscv64-unknown-elf-objcopy -O binary $file $file.bin
	echo $file.bin >> rv32tests.txt
done


