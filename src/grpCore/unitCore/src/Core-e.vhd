-------------------------------------------------------------------------------
-- Title      : RISC-V 32-Bit FSMD Core
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : Core-e.vhd
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
use work.Global.all;

entity Core is
    port (
        csi_clk             : in  std_logic;
        rsi_reset_n         : in  std_logic;

        -- Instruction Memory Avalon Master Interface
        avm_i_address      : out std_logic_vector(cBitWidth-1 downto 0);
        avm_i_read         : out std_logic;
        avm_i_readdata     : in  std_logic_vector(cBitWidth-1 downto 0);

        -- Data Memory Avalon Master Interface
        avm_d_address      : out std_logic_vector(cBitWidth-1 downto 0);
        avm_d_byteenable   : out std_logic_vector(cBitWidth/cByte-1 downto 0);
        avm_d_write        : out std_logic;
        avm_d_writedata    : out std_logic_vector(cBitWidth-1 downto 0);
        avm_d_read         : out std_logic;
        avm_d_readdata     : in  std_logic_vector(cBitWidth-1 downto 0)

    );
end entity Core;
