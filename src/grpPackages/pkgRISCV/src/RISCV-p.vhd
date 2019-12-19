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
constant cByteWidth     : natural := cBitWidth/cByte;
constant cInstWidth		: natural := 32;

subtype aInst	      	is std_ulogic_vector(cInstWidth-1 downto 0);
subtype aWord           is std_ulogic_vector(cBitWidth-1 downto 0);
subtype aCtrlSignal		is std_ulogic;

-------------------------------------------------------------------------------
-- Control Unit
-------------------------------------------------------------------------------
type aControlUnitState is (Fetch, ReadReg, Calc, DataAccess, WriteReg);

constant cALUSrcRegFile : aCtrlSignal := '0';
constant cALUSrcImmGen  : aCtrlSignal := '1';

-------------------------------------------------------------------------------
-- Program Counter
-------------------------------------------------------------------------------
constant cPCWidth		: natural := cBitWidth;
constant cPCIncrement	: natural := cInstWidth/cByte;

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

type aALUOp is (
	ALUOpAdd, ALUOpSub,
	ALUOpSLT, ALUOpSLTU,			-- less than (unsigned)
	ALUOpAnd, ALUOpOr, ALUOpXor,
	ALUOpSLL, ALUOpSRL, ALUOpSRA,	-- shift left/right logical/arithmetic
	ALUOpNOP
);
subtype aALUValue		is std_ulogic_vector(cALUWidth-1 downto 0);

-------------------------------------------------------------------------------
-- RegSet
-------------------------------------------------------------------------------

  type aRegSet is record
	-- common signals
	curInst						: aInst;
	-- control signals
	ctrlState					: aControlUnitState;
	aluSrc						: aCtrlSignal;
    memWrite                    : aCtrlSignal;
    memRead                     : aCtrlSignal;
    memToReg                    : aCtrlSignal;

	-- signals for program counter
	curPC						: aPCValue;
	incPC						: aCtrlSignal;

	-- signals for reading register file
	regReadData1				: aRegValue;
	-- signals for writing register file
	regWriteEn					: aCtrlSignal;
	regWriteData				: aRegValue;

	-- signals for ALU
	aluOp						: aALUOp;
	aluData2					: aALUValue;
  end record aRegSet;

  constant cInitValRegSet : aRegSet := (
	  curInst 		=> (others => '0'),

	  ctrlState		=> Fetch,
  	  aluSrc		=> '0',
      memWrite      => '0',
      memRead       => '0',
      memToReg      => '0',

	  curPC			=> (others => '0'),
	  incPC			=> '0',

	  regReadData1	=> (others => '0'),

	  regWriteEn	=> '0',
	  regWriteData	=> (others => '0'),

	  aluOp			=> ALUOpNOP,
	  aluData2		=> (others => '0')
  );


end RISCV;
