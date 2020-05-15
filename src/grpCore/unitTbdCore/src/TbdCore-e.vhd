-------------------------------------------------------------------------------
-- Title      : RISC-V 32-Bit FSMD Core Testbed
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : TbdCore-e.vhd
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

entity TbdCore is
	port (
		CLOCK_50			: in  std_logic;
		KEY_0				: in  std_logic;
		SW					: in  std_logic_vector(9 downto 0);
		LEDR				: out std_logic_vector(9 downto 0)	
	);
end entity TbdCore;