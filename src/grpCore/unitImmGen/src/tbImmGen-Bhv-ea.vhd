-------------------------------------------------------------------------------
-- Title      : Testbench for RISC-V 32-Bit Immediate Extender
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : tbImmGen-Bhv-ea.vhd
-- Author	  : Binder Alexander
-- Date		  : 01.10.2019
-- Revisions  : V1, 01.10.2019 -ba
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISCV.all;

entity tbImmGen is
end entity tbImmGen;

architecture bhv of tbImmGen is
    signal clk              : std_ulogic := '0';
    signal reset            : std_ulogic := '0';
    signal inst             : aInstr := (others => '0');
    signal imm              : aImm := (others => '0');
begin

-- Clock Gen
clk <= not(clk) after 10 ns;
    
UUT: entity work.ImmGen(rtl)
    port map(
        iClk        => clk,
        inRstAsync  => reset,
        iInst       => inst,
        oImm        => imm
    );
    
Stimuli: process is
begin
    reset <= '1' after 100 ns;




    inst <= 
            -- Test R-Type 
            "00000000001000001000000010110011" after 1000 ns,   -- add r1, r1, r2
            "01000000001000001000000010110011" after 1100 ns,   -- sub r1, r1, r2

            -- Test I-Type
            "00111111111100001000000011100111" after 2000 ns,   -- jalr r1, 0x7FF(r1)
            "00111111111100001000000010000011" after 2100 ns,   -- lb r1, 0x7FF(r1)
            "11111111111100001000000010010011" after 2200 ns,   -- addi r1, 0x7FF(r1)
            "00000000001100001001000010010011" after 2300 ns,   -- slli r1, 3(r1)

            -- Test S-Type
            "00111111000100000100011110100011" after 3000 ns,   -- sb r2, 0x7FF(r1)

            -- Test B-Type
            "00000000001000001000000101100011" after 4000 ns,   -- beq r2, 2(r1)

            -- Test U-Type
            "00000000000000000001000010110111" after 5000 ns,   -- lui 1(r1)

            -- Test J-Type  
            "00110100010000010010000011101111" after 6000 ns;   -- jal r1, 0x012344 

    
    wait;    

end process Stimuli;
end architecture bhv;