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

library work;
use work.RISCV.all;

entity tbRegFile is
end entity tbRegFile;

architecture bhv of tbRegFile is
    signal clk              : std_ulogic := '0';
    signal reset            : std_ulogic := '0';
    signal rs1, rs2, rd     : aRegAdr := (others => '0');
    signal we               : std_ulogic := '0';
    signal wd               : aRegValue := (others => '0');
    signal rd1, rd2         : aRegValue := (others => '0');
begin

-- Clock Gen
clk <= not(clk) after 10 ns;

UUT: entity work.RegFile(rtl)
    port map(
        iClk        => clk,
        inRstAsync  => reset,
        iRs1        => rs1,
        iRs2        => rs2,
        iRd         => rd,
        iWe         => we,
        iWd         => wd,
        oRd1        => rd1,
        oRd2        => rd2
    );
    
Stimuli: process is
begin
    reset <= '1' after 100 ns;
    wait;
    

end process Stimuli;


end architecture bhv;