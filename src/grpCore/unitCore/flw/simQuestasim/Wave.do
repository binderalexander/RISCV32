onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tbcore/InstMem
add wave -noupdate -radix hexadecimal /tbcore/DataMem
add wave -noupdate /tbcore/clk
add wave -noupdate /tbcore/reset
add wave -noupdate -radix hexadecimal /tbcore/instAddress
add wave -noupdate /tbcore/instRead
add wave -noupdate -radix hexadecimal /tbcore/instReadData
add wave -noupdate -radix hexadecimal /tbcore/dataAddress
add wave -noupdate /tbcore/dataByteEnable
add wave -noupdate /tbcore/dataWrite
add wave -noupdate -radix hexadecimal /tbcore/dataWriteData
add wave -noupdate /tbcore/dataRead
add wave -noupdate -radix hexadecimal /tbcore/dataReadData
add wave -noupdate /tbcore/UUT/csi_clk
add wave -noupdate /tbcore/UUT/rsi_reset_n
add wave -noupdate -radix hexadecimal /tbcore/UUT/avm_i_address
add wave -noupdate /tbcore/UUT/avm_i_read
add wave -noupdate -radix hexadecimal /tbcore/UUT/avm_i_readdata
add wave -noupdate -radix hexadecimal /tbcore/UUT/avm_d_address
add wave -noupdate /tbcore/UUT/avm_d_write
add wave -noupdate -radix hexadecimal /tbcore/UUT/avm_d_writedata
add wave -noupdate /tbcore/UUT/avm_d_read
add wave -noupdate -radix hexadecimal /tbcore/UUT/avm_d_readdata
add wave -noupdate -radix hexadecimal -childformat {{/tbcore/UUT/R.curInst -radix hexadecimal} {/tbcore/UUT/R.statusReg -radix hexadecimal} {/tbcore/UUT/R.ctrlState -radix hexadecimal} {/tbcore/UUT/R.memWrite -radix hexadecimal} {/tbcore/UUT/R.memRead -radix hexadecimal} {/tbcore/UUT/R.memToReg -radix hexadecimal} {/tbcore/UUT/R.jumpToAdr -radix hexadecimal} {/tbcore/UUT/R.curPC -radix hexadecimal} {/tbcore/UUT/R.incPC -radix hexadecimal} {/tbcore/UUT/R.regReadData1 -radix hexadecimal} {/tbcore/UUT/R.regWriteEn -radix hexadecimal} {/tbcore/UUT/R.regWriteData -radix hexadecimal} {/tbcore/UUT/R.aluOp -radix hexadecimal} {/tbcore/UUT/R.aluData2 -radix hexadecimal}} -subitemconfig {/tbcore/UUT/R.curInst {-height 16 -radix hexadecimal} /tbcore/UUT/R.statusReg {-radix hexadecimal} /tbcore/UUT/R.ctrlState {-height 16 -radix hexadecimal} /tbcore/UUT/R.memWrite {-height 16 -radix hexadecimal} /tbcore/UUT/R.memRead {-height 16 -radix hexadecimal} /tbcore/UUT/R.memToReg {-height 16 -radix hexadecimal} /tbcore/UUT/R.jumpToAdr {-height 16 -radix hexadecimal} /tbcore/UUT/R.curPC {-height 16 -radix hexadecimal} /tbcore/UUT/R.incPC {-height 16 -radix hexadecimal} /tbcore/UUT/R.regReadData1 {-height 16 -radix hexadecimal} /tbcore/UUT/R.regWriteEn {-height 16 -radix hexadecimal} /tbcore/UUT/R.regWriteData {-height 16 -radix hexadecimal} /tbcore/UUT/R.aluOp {-height 16 -radix hexadecimal} /tbcore/UUT/R.aluData2 {-height 16 -radix hexadecimal}} /tbcore/UUT/R
add wave -noupdate -radix hexadecimal /tbcore/UUT/NxR
add wave -noupdate -radix hexadecimal -childformat {{/tbcore/UUT/RegFile(0) -radix hexadecimal} {/tbcore/UUT/RegFile(1) -radix hexadecimal} {/tbcore/UUT/RegFile(2) -radix hexadecimal} {/tbcore/UUT/RegFile(3) -radix hexadecimal} {/tbcore/UUT/RegFile(4) -radix hexadecimal} {/tbcore/UUT/RegFile(5) -radix hexadecimal} {/tbcore/UUT/RegFile(6) -radix hexadecimal} {/tbcore/UUT/RegFile(7) -radix hexadecimal} {/tbcore/UUT/RegFile(8) -radix hexadecimal} {/tbcore/UUT/RegFile(9) -radix hexadecimal} {/tbcore/UUT/RegFile(10) -radix hexadecimal} {/tbcore/UUT/RegFile(11) -radix hexadecimal} {/tbcore/UUT/RegFile(12) -radix hexadecimal} {/tbcore/UUT/RegFile(13) -radix hexadecimal} {/tbcore/UUT/RegFile(14) -radix hexadecimal} {/tbcore/UUT/RegFile(15) -radix hexadecimal} {/tbcore/UUT/RegFile(16) -radix hexadecimal} {/tbcore/UUT/RegFile(17) -radix hexadecimal} {/tbcore/UUT/RegFile(18) -radix hexadecimal} {/tbcore/UUT/RegFile(19) -radix hexadecimal} {/tbcore/UUT/RegFile(20) -radix hexadecimal} {/tbcore/UUT/RegFile(21) -radix hexadecimal} {/tbcore/UUT/RegFile(22) -radix hexadecimal} {/tbcore/UUT/RegFile(23) -radix hexadecimal} {/tbcore/UUT/RegFile(24) -radix hexadecimal} {/tbcore/UUT/RegFile(25) -radix hexadecimal} {/tbcore/UUT/RegFile(26) -radix hexadecimal} {/tbcore/UUT/RegFile(27) -radix hexadecimal} {/tbcore/UUT/RegFile(28) -radix hexadecimal} {/tbcore/UUT/RegFile(29) -radix hexadecimal} {/tbcore/UUT/RegFile(30) -radix hexadecimal} {/tbcore/UUT/RegFile(31) -radix hexadecimal}} -subitemconfig {/tbcore/UUT/RegFile(0) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(1) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(2) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(3) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(4) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(5) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(6) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(7) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(8) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(9) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(10) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(11) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(12) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(13) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(14) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(15) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(16) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(17) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(18) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(19) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(20) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(21) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(22) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(23) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(24) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(25) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(26) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(27) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(28) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(29) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(30) {-height 16 -radix hexadecimal} /tbcore/UUT/RegFile(31) {-height 16 -radix hexadecimal}} /tbcore/UUT/RegFile
add wave -noupdate -radix hexadecimal /tbcore/UUT/NxRegFile
add wave -noupdate -divider -height 36 {Comb Variables}
add wave -noupdate -radix hexadecimal /tbcore/UUT/Comb/vRegReadData2
add wave -noupdate -radix hexadecimal /tbcore/UUT/Comb/vRegWriteData
add wave -noupdate -radix hexadecimal /tbcore/UUT/Comb/vAluRes
add wave -noupdate -radix hexadecimal /tbcore/UUT/Comb/vImm
add wave -noupdate -radix hexadecimal /tbcore/UUT/Comb/vPCPlus4
add wave -noupdate -radix hexadecimal /tbcore/UUT/Comb/vNextPC
add wave -noupdate -radix hexadecimal /tbcore/UUT/Comb/vJumpAdr
add wave -noupdate -radix hexadecimal /tbcore/UUT/Comb/vDataMemReadData
add wave -noupdate /tbcore/UUT/Comb/vDataMemByteEnable
add wave -noupdate -divider Multiplexer
add wave -noupdate /tbcore/UUT/Comb/vAluSrc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {219285 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 307
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
WaveRestoreZoom {4435092 ps} {5029732 ps}
