-------------------------------------------------------------------------------
-- Title      : Avalon Memory Mapped Input IP Core
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : Input.vhd
-- Author	  : Binder Alexander
-- Date		  : 05.05.2020
-- Revisions  : V1,05.05.2020 -ba
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AvalonMMInput is
    port (
        clk             	: in  std_logic;
        reset_n         	: in  std_logic;
        avs_i_address      	: in  std_logic_vector(0 downto 0);
		avs_i_read			: in  std_logic;
        avs_i_readdata     	: out std_logic_vector(7 downto 0);
		iConduit			: in  std_logic_vector(7 downto 0)
    );
end entity AvalonMMInput;

architecture Rtl of AvalonMMInput is
	signal reg : std_ulogic_vector(avs_i_readdata'range) := (others => '0');
begin

AvalonMMInterface: process(clk) is
begin
	if rising_edge(clk) then
		if reset_n = not('1') then
			avs_i_readdata <= (others => '0');
		else
			if avs_i_read = '1' then
				avs_i_readdata <= std_logic_vector(iConduit);
			end if;
		end if;
	end if;
end process;

end architecture;