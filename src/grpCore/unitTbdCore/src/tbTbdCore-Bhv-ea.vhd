-------------------------------------------------------------------------------
-- Title      : Testbench for RISC-V 32-Bit FSMD Core Testbed
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : tbTbdCore-ea.vhd
-- Author	  : Binder Alexander
-- Date		  : 16.11.2019
-- Revisions  : V1, 16.11.2019 -ba
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISCV.all;

entity tbTbdCore is
end entity tbTbdCore;

architecture bhv of tbCore is
begin

-- Clock Gen
clk <= not(clk) after 10 ns;

end architecture bhv;