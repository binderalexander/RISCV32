-------------------------------------------------------------------------------
-- Title      : RISC-V Project Package
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : RegFile-Rtl-a.vhd
-- Author	    : Binder Alexander
-- Date		    : 06.09.2019
-- Revisions  : V1, 06.09.2019 -ba
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Global.all;

package RISCV is
  
-------------------------------------------------------------------------------
-- Common
-------------------------------------------------------------------------------
constant cBitWidth		: natural := 32;
constant cInstrWidth	: natural := 32;

subtype aInstr      	is std_ulogic_vector(cInstrWidth-1 downto 0);

-------------------------------------------------------------------------------
-- Program Counter
-------------------------------------------------------------------------------
constant cPCWidth		: natural := cBitWidth;
constant cPCIncrement	: natural := 4; -- Default Instruction Length is 4 Byte

subtype aPCValue		is std_ulogic_vector(cBitWidth-1 downto 0);

-------------------------------------------------------------------------------
-- Register File
-------------------------------------------------------------------------------
constant cRegWidth		: natural := cBitWidth;
constant cRegCount		: natural := 32;
constant cRegAdrWidth	: natural := LogDualis(cRegCount);

subtype aRegValue   	is std_ulogic_vector(cRegWidth-1 downto 0);
subtype aRegAdr     	is std_ulogic_vector(cRegAdrWidth-1 downto 0);
type aRegFile			is array (0 to cRegCount-1) of aRegValue;

-------------------------------------------------------------------------------
-- Immediate Extension
-------------------------------------------------------------------------------
constant cImmLen		: natural := cBitWidth;

subtype aImm			is std_ulogic_vector(cImmLen-1 downto 0);

-------------------------------------------------------------------------------
-- ALU
-------------------------------------------------------------------------------
constant cALUWidth		: natural := cBitWidth;
constant cALUOpLength	: natural := 4;
constant cALUOpAND		: std_ulogic_vector(cALUOpLength-1 downto 0) := "0000";
constant cALUOpOR		: std_ulogic_vector(cALUOpLength-1 downto 0) := "0001";
constant cALUOpADD		: std_ulogic_vector(cALUOpLength-1 downto 0) := "0010";
constant cALUOpSUB		: std_ulogic_vector(cALUOpLength-1 downto 0) := "0110";

subtype aALUOp			is std_ulogic_vector(cALUOpLength-1 downto 0);
subtype aALUValue		is std_ulogic_vector(cALUWidth-1 downto 0);

-------------------------------------------------------------------------------
-- RegSet
-------------------------------------------------------------------------------

  type aRegSet is record
	-- common signals
	curInstr					: aInstr;
	-- signals for program counter
	curPC						: aPCValue;
	-- signals for reading register file
	regReadAdr1, regReadAdr2 	: aRegAdr;
	regReadData1, regReadData2	: aRegValue;
	-- signals for writing register file
	regWriteAdr					: aRegAdr;
	regWriteEn					: std_ulogic;
	regWriteData				: aRegValue;
	-- signals for immediate extension
	curImm						: aImm;
	-- signals for ALU
	aluOp						: aALUOp;
	aluDataB					: aALUValue;
	aluRes						: aALUValue;
  end record aRegSet;

  constant cInitValRegSet : aRegSet := (
	  curInstr 		=> (others => '0'),

	  curPC			=> (others => '0'),

	  regReadAdr1 	=> (others => '0'),
	  regReadAdr2	=> (others => '0'),
	  regReadData1	=> (others => '0'),
	  regReadData2	=> (others => '0'),

	  regWriteAdr	=> (others => '0'),
	  regWriteEn	=> '0',
	  regWriteData	=> (others => '0'),

	  curImm		=> (others => '0'),

	  aluOp			=> (others => '0'),
	  aluDataB		=> (others => '0'),
	  aluRes		=> (others => '0')
  );


end RISCV;

