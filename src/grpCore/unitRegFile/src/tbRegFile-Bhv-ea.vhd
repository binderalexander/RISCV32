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
use ieee.numeric_std.all;

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

    wd <= std_ulogic_vector(to_unsigned(16#1234FEDC#, aRegValue'length));
    we <=   '1' after 20 ns,
            '0' after 60 ns,
            '1' after 200 ns;

    rs1 <= "01011";
    rs2 <= "00100";

    for i in 0 to 31 loop
        rd <= transport std_ulogic_vector(to_unsigned(i, aRegAdr'length)) after ((10 + i) * (30 ns));
    end loop;
    
    wait;    

end process Stimuli;


end architecture bhv;