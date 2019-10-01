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

    inst <= "01010101010101010101000001101111" after 200 ns;    
    
    wait;    

end process Stimuli;
end architecture bhv;