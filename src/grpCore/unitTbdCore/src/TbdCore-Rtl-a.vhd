-------------------------------------------------------------------------------
-- Title      : RISC-V 32-Bit FSMD Core Testbed
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : TbdCore-Rtl-a.vhd
-- Author	  : Binder Alexander
-- Date		  : 16.11.2019
-- Revisions  : V1, 16.11.2019 -ba
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------

architecture rtl of TbdCore is
	component riscv_system is
		port (
			clk_clk         : in  std_logic;
			reset_reset_n   : in  std_logic;
			switches_export : in  std_logic_vector(9 downto 0);
			leds_export     : out std_logic_vector(9 downto 0)
		);
	end component riscv_system;

begin
	u0 : component riscv_system
		port map (
			clk_clk         => CLOCK_50,
			reset_reset_n   => KEY_0,
			switches_export => SW(9 downto 0),
			leds_export     => LEDR(9 downto 0)
		);
	
end architecture rtl;
