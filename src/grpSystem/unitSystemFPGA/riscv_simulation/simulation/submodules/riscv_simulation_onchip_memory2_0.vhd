--Legal Notice: (C)2020 Altera Corporation. All rights reserved.  Your
--use of Altera Corporation's design tools, logic functions and other
--software and tools, and its AMPP partner logic functions, and any
--output files any of the foregoing (including device programming or
--simulation files), and any associated documentation or information are
--expressly subject to the terms and conditions of the Altera Program
--License Subscription Agreement or other applicable license agreement,
--including, without limitation, that your use is for the sole purpose
--of programming logic devices manufactured by Altera and sold by Altera
--or its authorized distributors.  Please refer to the applicable
--agreement for further details.


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity riscv_simulation_onchip_memory2_0 is 
        generic (
                 INIT_FILE : STRING := "C:/Daten/Studium/Bachelor_Semester_5/Bachelorarbeit/RISCV32/src/grpSystem/unitSystemFPGA/checkMinimalSystem.hex"
                 );
        port (
              -- inputs:
                 signal address : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
                 signal address2 : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
                 signal byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal byteenable2 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal chipselect : IN STD_LOGIC;
                 signal chipselect2 : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal clken : IN STD_LOGIC;
                 signal clken2 : IN STD_LOGIC;
                 signal freeze : IN STD_LOGIC;
                 signal reset : IN STD_LOGIC;
                 signal reset_req : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;
                 signal write2 : IN STD_LOGIC;
                 signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal writedata2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal readdata2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity riscv_simulation_onchip_memory2_0;


architecture europa of riscv_simulation_onchip_memory2_0 is
  component altsyncram is
GENERIC (
      address_reg_b : STRING;
        byte_size : NATURAL;
        byteena_reg_b : STRING;
        indata_reg_b : STRING;
        init_file : STRING;
        lpm_type : STRING;
        maximum_depth : NATURAL;
        numwords_a : NATURAL;
        numwords_b : NATURAL;
        operation_mode : STRING;
        outdata_reg_a : STRING;
        outdata_reg_b : STRING;
        ram_block_type : STRING;
        read_during_write_mode_mixed_ports : STRING;
        width_a : NATURAL;
        width_b : NATURAL;
        width_byteena_a : NATURAL;
        width_byteena_b : NATURAL;
        widthad_a : NATURAL;
        widthad_b : NATURAL;
        wrcontrol_wraddress_reg_b : STRING
      );
    PORT (
    signal q_b : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal q_a : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal wren_a : IN STD_LOGIC;
        signal clock0 : IN STD_LOGIC;
        signal data_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        signal clocken0 : IN STD_LOGIC;
        signal addressstall_a : IN STD_LOGIC;
        signal addressstall_b : IN STD_LOGIC;
        signal byteena_a : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        signal wren_b : IN STD_LOGIC;
        signal address_a : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
        signal address_b : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
        signal byteena_b : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        signal data_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0)
      );
  end component altsyncram;
                signal clocken0 :  STD_LOGIC;
                signal internal_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_readdata2 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal not_clken :  STD_LOGIC;
                signal not_clken2 :  STD_LOGIC;
                signal wren :  STD_LOGIC;
                signal wren2 :  STD_LOGIC;

begin

  wren <= (chipselect AND write) AND clken;
  not_clken <= NOT clken;
  not_clken2 <= NOT clken2;
  clocken0 <= NOT reset_req;
  wren2 <= (chipselect2 AND write2) AND clken2;
  the_altsyncram : altsyncram
    generic map(
      address_reg_b => "CLOCK0",
      byte_size => 8,
      byteena_reg_b => "CLOCK0",
      indata_reg_b => "CLOCK0",
      init_file => INIT_FILE,
      lpm_type => "altsyncram",
      maximum_depth => 8192,
      numwords_a => 8192,
      numwords_b => 8192,
      operation_mode => "BIDIR_DUAL_PORT",
      outdata_reg_a => "UNREGISTERED",
      outdata_reg_b => "UNREGISTERED",
      ram_block_type => "AUTO",
      read_during_write_mode_mixed_ports => "OLD_DATA",
      width_a => 32,
      width_b => 32,
      width_byteena_a => 4,
      width_byteena_b => 4,
      widthad_a => 13,
      widthad_b => 13,
      wrcontrol_wraddress_reg_b => "CLOCK0"
    )
    port map(
            address_a => address,
            address_b => address2,
            addressstall_a => not_clken,
            addressstall_b => not_clken2,
            byteena_a => byteenable,
            byteena_b => byteenable2,
            clock0 => clk,
            clocken0 => clocken0,
            data_a => writedata,
            data_b => writedata2,
            q_a => internal_readdata,
            q_b => internal_readdata2,
            wren_a => wren,
            wren_b => wren2
    );

  --s1, which is an e_avalon_slave
  --s2, which is an e_avalon_slave
  --vhdl renameroo for output signals
  readdata <= internal_readdata;
  --vhdl renameroo for output signals
  readdata2 <= internal_readdata2;

end europa;

