onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /riscv_simulation/clock_source_0_clk_clk
add wave -noupdate /riscv_simulation/rv32ui_fsmd_0/csi_clk
add wave -noupdate -divider LEDS
add wave -noupdate /riscv_simulation/pio_0/address
add wave -noupdate /riscv_simulation/pio_0/chipselect
add wave -noupdate /riscv_simulation/pio_0/clk
add wave -noupdate /riscv_simulation/pio_0/reset_n
add wave -noupdate /riscv_simulation/pio_0/write_n
add wave -noupdate -radix hexadecimal /riscv_simulation/pio_0/writedata
add wave -noupdate /riscv_simulation/pio_0/out_port
add wave -noupdate -radix hexadecimal /riscv_simulation/pio_0/readdata
add wave -noupdate -divider Memory
add wave -noupdate -radix hexadecimal /riscv_simulation/onchip_memory2_0/address
add wave -noupdate -radix hexadecimal /riscv_simulation/onchip_memory2_0/byteenable
add wave -noupdate -radix hexadecimal /riscv_simulation/onchip_memory2_0/chipselect
add wave -noupdate -radix hexadecimal /riscv_simulation/onchip_memory2_0/chipselect2
add wave -noupdate -radix hexadecimal /riscv_simulation/onchip_memory2_0/write
add wave -noupdate -radix hexadecimal /riscv_simulation/onchip_memory2_0/write2
add wave -noupdate -radix hexadecimal /riscv_simulation/onchip_memory2_0/writedata
add wave -noupdate -radix hexadecimal /riscv_simulation/onchip_memory2_0/writedata2
add wave -noupdate -radix hexadecimal /riscv_simulation/onchip_memory2_0/readdata
add wave -noupdate -radix hexadecimal /riscv_simulation/onchip_memory2_0/readdata2
add wave -noupdate -divider RISCV-Core
add wave -noupdate -radix hexadecimal /riscv_simulation/rv32ui_fsmd_0/avm_i_address
add wave -noupdate /riscv_simulation/rv32ui_fsmd_0/avm_i_read
add wave -noupdate -radix hexadecimal /riscv_simulation/rv32ui_fsmd_0/avm_i_readdata
add wave -noupdate /riscv_simulation/rv32ui_fsmd_0/avm_i_waitrequest
add wave -noupdate -radix hexadecimal /riscv_simulation/rv32ui_fsmd_0/avm_d_address
add wave -noupdate /riscv_simulation/rv32ui_fsmd_0/avm_d_byteenable
add wave -noupdate /riscv_simulation/rv32ui_fsmd_0/avm_d_write
add wave -noupdate -radix hexadecimal /riscv_simulation/rv32ui_fsmd_0/avm_d_writedata
add wave -noupdate /riscv_simulation/rv32ui_fsmd_0/avm_d_read
add wave -noupdate -radix hexadecimal /riscv_simulation/rv32ui_fsmd_0/avm_d_readdata
add wave -noupdate /riscv_simulation/rv32ui_fsmd_0/avm_d_waitrequest
add wave -noupdate -childformat {{/riscv_simulation/rv32ui_fsmd_0/R.curInst -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/R.statusReg -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/R.memAddr -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/R.memWriteData -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/R.memReadData -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/R.curPC -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/R.regWriteData -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/R.aluData1 -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/R.aluData2 -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/R.aluRes -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/R.csrReg -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/R.csrReadData -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/R.csrWriteData -radix hexadecimal}} -expand -subitemconfig {/riscv_simulation/rv32ui_fsmd_0/R.curInst {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/R.statusReg {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/R.memAddr {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/R.memWriteData {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/R.memReadData {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/R.curPC {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/R.regWriteData {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/R.aluData1 {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/R.aluData2 {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/R.aluRes {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/R.csrReg {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/R.csrReadData {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/R.csrWriteData {-height 15 -radix hexadecimal}} /riscv_simulation/rv32ui_fsmd_0/R
add wave -noupdate -radix hexadecimal -childformat {{/riscv_simulation/rv32ui_fsmd_0/RegFile(0) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(1) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(2) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(3) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(4) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(5) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(6) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(7) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(8) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(9) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(10) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(11) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(12) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(13) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(14) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(15) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(16) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(17) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(18) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(19) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(20) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(21) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(22) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(23) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(24) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(25) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(26) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(27) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(28) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(29) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(30) -radix hexadecimal} {/riscv_simulation/rv32ui_fsmd_0/RegFile(31) -radix hexadecimal}} -expand -subitemconfig {/riscv_simulation/rv32ui_fsmd_0/RegFile(0) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(1) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(2) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(3) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(4) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(5) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(6) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(7) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(8) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(9) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(10) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(11) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(12) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(13) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(14) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(15) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(16) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(17) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(18) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(19) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(20) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(21) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(22) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(23) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(24) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(25) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(26) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(27) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(28) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(29) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(30) {-height 15 -radix hexadecimal} /riscv_simulation/rv32ui_fsmd_0/RegFile(31) {-height 15 -radix hexadecimal}} /riscv_simulation/rv32ui_fsmd_0/RegFile
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {76831596 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 327
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {75665048 ps} {79333419 ps}