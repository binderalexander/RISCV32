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
use work.Global.all;

entity tbCore is
end entity tbCore;

architecture bhv of tbCore is

    constant InstMemSize : natural := 256;
    type aInstMem is array (0 to InstMemSize-1) of std_logic_vector(cByte-1 downto 0);
    signal InstMem : aInstMem := (
        others  => (others=>'0')
    );

    constant DataMemSize : natural := 16;
    type aDataMem is array (0 to DataMemSize-1) of std_logic_vector(cByte-1 downto 0);
    signal DataMem: aDataMem := (
        0 => x"81",
        1 => x"02",
        2 => x"03",
        3 => x"04",
        4 => x"FF",
        5 => x"FE",
        6 => x"FD",
        7 => x"FC",
        others=>(others=>'0')
    );

    signal clk              : std_ulogic := '0';
    signal reset            : std_ulogic := '0';

    signal instAddress      : std_logic_vector(cBitWidth-1 downto 0);
    signal instRead         : std_logic;
    signal instReadData     : std_logic_vector(cBitWidth-1 downto 0) := (others => '0');

    signal dataAddress      : std_logic_vector(cBitWidth-1 downto 0);
    signal dataByteEnable   : std_logic_vector(cBitWidth/cByte-1 downto 0);
    signal dataWrite        : std_logic;
    signal dataWriteData    : std_logic_vector(cBitWidth-1 downto 0);
    signal dataRead         : std_logic := '1';
    signal dataReadData     : std_logic_vector(cBitWidth-1 downto 0) := (others => '0');

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
        avm_d_byteenable    => dataByteEnable,
        avm_d_write         => dataWrite,
        avm_d_writedata     => dataWriteData,
        avm_d_read          => dataRead,
        avm_d_readdata      => dataReadData
    );

ReadROM: process is
    type char_file_t is file of character;
    file char_file : char_file_t;
    variable char_v : character;
    variable i : natural := 0;
begin
    file_open(char_file, "../../../../../test/checkU.bin");
    while not endfile(char_file) and (i < InstMemSize) loop
        read(char_file, char_v);
        InstMem(i) <= std_logic_vector(to_unsigned(character'pos(char_v), cByte));
        i := i+1;
    end loop;
    report integer'image(i) & " Bytes written into ROM!";
    file_close(char_file);
    wait;
end process ReadROM;

Stimuli: process is
begin
    reset <= '1' after 100 ns;
    wait;

end process Stimuli;

InstructionMemory: process(clk) is
begin
    if rising_edge(clk) then
        if (instRead = '1') and (to_integer(unsigned(instAddress))+cByteWidth-1) < InstMemSize then
            readInstructionMemory : for i in 0 to cByteWidth-1 loop
                instReadData(((i+1)*cByte)-1 downto i*cByte) <= InstMem(to_integer(unsigned(instAddress))+i);
            end loop;
        end if;
    end if;
end process InstructionMemory;

DataMemory: process(clk) is
begin

    if falling_edge(clk) then
        if (dataRead = '1') and (to_integer(unsigned(dataAddress))+cByteWidth-1) < DataMemSize then
            readDataMemory : for i in 0 to cByteWidth-1 loop
                dataReadData(((i+1)*cByte)-1 downto i*cByte) <= DataMem(to_integer(unsigned(dataAddress))+i);
            end loop;
        end if;

        if (dataWrite = '1') and (to_integer(unsigned(dataAddress))+cByteWidth-1) < DataMemSize then
            writeDataMemory : for i in 0 to cByteWidth-1 loop
                if dataByteEnable(i) = '1' then
                    DataMem(to_integer(unsigned(dataAddress))+i) <= dataWriteData(((i+1)*cByte)-1 downto i*cByte);
                end if;
            end loop;
        end if;
    end if;
end process DataMemory;

end architecture bhv;
