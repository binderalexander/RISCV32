onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbcore/InstMem
add wave -noupdate /tbcore/clk
add wave -noupdate /tbcore/reset
add wave -noupdate /tbcore/instAddress
add wave -noupdate /tbcore/instRead
add wave -noupdate /tbcore/instReadData
add wave -noupdate /tbcore/dataAddress
add wave -noupdate /tbcore/dataWrite
add wave -noupdate /tbcore/dataWriteData
add wave -noupdate /tbcore/dataRead
add wave -noupdate /tbcore/dataReadData
add wave -noupdate /tbcore/UUT/csi_clk
add wave -noupdate /tbcore/UUT/rsi_reset_n
add wave -noupdate /tbcore/UUT/avm_i_address
add wave -noupdate /tbcore/UUT/avm_i_read
add wave -noupdate /tbcore/UUT/avm_i_readdata
add wave -noupdate /tbcore/UUT/avm_d_address
add wave -noupdate /tbcore/UUT/avm_d_write
add wave -noupdate /tbcore/UUT/avm_d_writedata
add wave -noupdate /tbcore/UUT/avm_d_read
add wave -noupdate /tbcore/UUT/avm_d_readdata
add wave -noupdate -childformat {{/tbcore/UUT/R.curInst -radix hexadecimal} {/tbcore/UUT/R.curPC -radix hexadecimal} {/tbcore/UUT/R.regReadData1 -radix hexadecimal} {/tbcore/UUT/R.regReadData2 -radix hexadecimal} {/tbcore/UUT/R.regWriteData -radix hexadecimal} {/tbcore/UUT/R.curImm -radix hexadecimal} {/tbcore/UUT/R.aluData2 -radix hexadecimal}} -expand -subitemconfig {/tbcore/UUT/R.curInst {-height 15 -radix hexadecimal} /tbcore/UUT/R.curPC {-height 15 -radix hexadecimal} /tbcore/UUT/R.regReadData1 {-height 15 -radix hexadecimal} /tbcore/UUT/R.regReadData2 {-height 15 -radix hexadecimal} /tbcore/UUT/R.regWriteData {-height 15 -radix hexadecimal} /tbcore/UUT/R.curImm {-height 15 -radix hexadecimal} /tbcore/UUT/R.aluData2 {-height 15 -radix hexadecimal}} /tbcore/UUT/R
add wave -noupdate /tbcore/UUT/NxR
add wave -noupdate -childformat {{/tbcore/UUT/RegFile(1) -radix hexadecimal} {/tbcore/UUT/RegFile(2) -radix hexadecimal} {/tbcore/UUT/RegFile(3) -radix hexadecimal}} -expand -subitemconfig {/tbcore/UUT/RegFile(1) {-radix hexadecimal} /tbcore/UUT/RegFile(2) {-radix hexadecimal} /tbcore/UUT/RegFile(3) {-height 15 -radix hexadecimal}} /tbcore/UUT/RegFile
add wave -noupdate /tbcore/UUT/NxRegFile
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {219285 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 217
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
WaveRestoreZoom {0 ps} {574623 ps}
