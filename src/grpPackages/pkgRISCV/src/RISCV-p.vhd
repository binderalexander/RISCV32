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
-- OpCodes
-------------------------------------------------------------------------------
subtype aOpCode 		is std_ulogic_vector(6 downto 0);
subtype aFunct3			is std_ulogic_vector(2 downto 0);

constant cOpRType		: aOpCode := "0110011";
constant cOpIArith		: aOpCode := "0010011";
constant cOpILoad		: aOpCode := "0000011";
constant cOpSType		: aOpCode := "0100011";
constant cOpBType		: aOpCode := "1100011";
constant cOpJType		: aOpCode := "1101111";

constant cMemByte				: aFunct3 := "000";
constant cMemHalfWord			: aFunct3 := "001";
constant cMemWord				: aFunct3 := "010";
constant cMemUnsignedByte 		: aFunct3 := "100";
constant cMemUnsignedHalfWord 	: aFunct3 := "101";

constant cEnableByte		: std_logic_vector(3 downto 0) := "0001";
constant cEnableHalfWord 	: std_logic_vector(3 downto 0) := "0011";
constant cEnableWord		: std_logic_vector(3 downto 0) := "1111";

-------------------------------------------------------------------------------
-- Control Unit
-------------------------------------------------------------------------------
type aControlUnitState is (Fetch, ReadReg, Calc, DataAccess, WriteReg);

constant cALUSrcRegFile : aCtrlSignal := '0';
constant cALUSrcImmGen  : aCtrlSignal := '1';
constant cMemToRegALU	: aCtrlSignal := '0';
constant cMemToRegMem	: aCtrlSignal := '1';

constant cNoJump		: aCtrlSignal := '0';
constant cJump			: aCtrlSignal := '1';
constant cNoIncPC		: aCtrlSignal := '0';
constant cIncPC			: aCtrlSignal := '1';

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
    memWrite                    : aCtrlSignal;
    memRead                     : aCtrlSignal;
    memToReg                    : aCtrlSignal;
	jumpToAdr					: aCtrlSignal;

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
      memWrite      => '0',
      memRead       => '0',
      memToReg      => '0',
	  jumpToAdr		=> '0',

	  curPC			=> (others => '0'),
	  incPC			=> '0',

	  regReadData1	=> (others => '0'),

	  regWriteEn	=> '0',
	  regWriteData	=> (others => '0'),

	  aluOp			=> ALUOpNOP,
	  aluData2		=> (others => '0')
  );


end RISCV;
