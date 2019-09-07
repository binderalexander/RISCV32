-------------------------------------------------------------------------------
-- Title      : Testbench for RISC-V 32-Bit Register File
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : tbRegFile-ea.vhd
-- Author	  : Binder Alexander
-- Date		  : 06.09.2019
-- Revisions  : V1, 06.09.2019 -ba
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity tbRegFile is
end entity tbRegFile;

architecture bhv of tbRegFile is
    signal clk              : std_ulogic := '0';
    signal reset            : std_ulogic := '1';
    signal rs1, rs2, rd     : std_ulogic := '0';

begin

-- Clock Gen
clk <= not(clk) after 10 ns;

UUT: entity work.RegFile(rtl)
    port map(
        iClk => clk,
        inRstAsync => reset
    )
    
end architecture bhv;