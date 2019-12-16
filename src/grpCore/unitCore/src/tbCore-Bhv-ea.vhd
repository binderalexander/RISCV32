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

    constant InstMemSize : natural := 8;
    type aInstMem is array (0 to InstMemSize-1) of std_logic_vector(cBitWidth-1 downto 0);
    signal InstMem : aInstMem := (
        0       => "00000000001000001000000110110011", -- add r3 = r1 + r2
        others  => (others=>'0')
    );

    signal clk              : std_ulogic := '0';
    signal reset            : std_ulogic := '0';

    signal instAddress      : std_logic_vector(cBitWidth-1 downto 0);
    signal instRead         : std_logic;
    signal instReadData     : std_logic_vector(cBitWidth-1 downto 0);

    signal dataAddress      : std_logic_vector(cBitWidth-1 downto 0);
    signal dataWrite        : std_logic;
    signal dataWriteData    : std_logic_vector(cBitWidth-1 downto 0);
    signal dataRead         : std_logic;
    signal dataReadData     : std_logic_vector(cBitWidth-1 downto 0);

begin

-- Clock Gen
clk <= not(clk) after 10 ns;

UUT: entity work.Core(rtl)
    port map(
        csi_clk             => clk,
        rsi_reset_n         => reset,

        avm_i_address       => instAddress,
        avm_i_read          => instRead,
        avm_i_readdata      => instReadData,

        avm_d_address       => dataAddress,
        avm_d_write         => dataWrite,
        avm_d_writedata     => dataWriteData,
        avm_d_read          => dataRead,
        avm_d_readdata      => dataReadData
    );
    
Stimuli: process is
begin
    reset <= '1' after 100 ns;
    
    wait;    

end process Stimuli;

InstructionMem: process(clk, reset) is

begin

    if reset = not('1') then
        instReadData <= (others => '0');

    elsif rising_edge(clk) then

        if (instRead = '1') and (to_integer(unsigned(instAddress)) < InstMemSize) then
            instReadData <= InstMem(to_integer(unsigned(instAddress)));
        end if;

    end if;

end process InstructionMem;


end architecture bhv;