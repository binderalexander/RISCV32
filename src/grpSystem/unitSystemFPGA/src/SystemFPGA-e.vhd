-------------------------------------------------------------------------------
-- Title      : RISC-V 32-Bit System
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : SystemFPGA-e.vhd
-- Author	  : Binder Alexander
-- Date		  : 20.04.2020
-- Revisions  : V1, 20.04.2020 -ba
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.Global.all;
use work.RISCV.all;

entity SystemFPGA is
	port (
		CLOCK_50			: in  std_logic;
		KEY_0				: in  std_logic;
		SW					: in  std_logic_vector(9 downto 0);
		LEDR				: out std_logic_vector(9 downto 0)	
	);
end entity SystemFPGA;