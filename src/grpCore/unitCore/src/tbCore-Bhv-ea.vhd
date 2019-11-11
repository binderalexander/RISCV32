-------------------------------------------------------------------------------
-- Title      : Testbench for RISC-V 32-Bit FSMD Core
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : tbCore-ea.vhd
-- Author	  : Binder Alexander
-- Date		  : 11.11.2019
-- Revisions  : V1, 11.11.2019 -ba
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISCV.all;

entity tbCore is
end entity tbCore;

architecture bhv of tbCore is
    signal clk              : std_ulogic := '0';
    signal reset            : std_ulogic := '0';
    signal rs1, rs2, rd     : aRegAdr := (others => '0');
    signal we               : std_ulogic := '0';
    signal wd               : aRegValue := (others => '0');
    signal rd1, rd2         : aRegValue := (others => '0');
begin

-- Clock Gen
clk <= not(clk) after 10 ns;

UUT: entity work.Core(rtl)
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

    rs1 <=  "01011" after 400 ns,
            "00000" after 2000 ns;
    rs2 <=  "00100" after 400 ns,
            "00000" after 2000 ns;

    for i in 0 to 31 loop
        rd <= transport std_ulogic_vector(to_unsigned(i, aRegAdr'length)) after ((10 + i) * (30 ns));
    end loop;
    
    wait;    

end process Stimuli;


end architecture bhv;