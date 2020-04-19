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
constant cCsrAddrWidth	: natural := 12;

subtype aInst	      	is std_ulogic_vector(cInstWidth - 1		downto 0);
subtype aWord           is std_ulogic_vector(cBitWidth - 1 		downto 0);
subtype aCsrAddr		is std_ulogic_vector(cCsrAddrWidth - 1 	downto 0);
subtype aCtrlSignal		is std_ulogic;
subtype aCtrl2Signal	is std_ulogic_vector(1 downto 0);

constant cStatusZeroBit 	: natural := 0;
constant cStatusNegBit		: natural := 1;
constant cStatusCarryBit 	: natural := 2;

-------------------------------------------------------------------------------
-- OpCodes
-------------------------------------------------------------------------------
subtype aOpCode 		is std_ulogic_vector(6 downto 0);
subtype aFunct3			is std_ulogic_vector(2 downto 0);
subtype aFunct12		is std_ulogic_vector(11 downto 0);

constant cOpRType		: aOpCode := "0110011";
constant cOpIArith		: aOpCode := "0010011";
constant cOpILoad		: aOpCode := "0000011";
constant cOpIJumpReg	: aOpCode := "1100111";
constant cOpSType		: aOpCode := "0100011";
constant cOpBType		: aOpCode := "1100011";
constant cOpJType		: aOpCode := "1101111";
constant cOpLUI			: aOpCode := "0110111";
constant cOpAUIPC		: aOpCode := "0010111";
constant cOpFence		: aOpCode := "0001111";
constant cOpSys			: aOpCode := "1110011";

-- Memory Funct3
constant cMemByte				: aFunct3 := "000";
constant cMemHalfWord			: aFunct3 := "001";
constant cMemWord				: aFunct3 := "010";
constant cMemUnsignedByte 		: aFunct3 := "100";
constant cMemUnsignedHalfWord 	: aFunct3 := "101";

constant cEnableByte		: std_logic_vector(3 downto 0) := "0001";
constant cEnableHalfWord 	: std_logic_vector(3 downto 0) := "0011";
constant cEnableWord		: std_logic_vector(3 downto 0) := "1111";

-- Branch Funct3
constant cCondEq		: aFunct3 := "000";
constant cCondNe		: aFunct3 := "001";
constant cCondLt		: aFunct3 := "100";
constant cCondGe		: aFunct3 := "101";
constant cCondLtu		: aFunct3 := "110";
constant cCondGeu		: aFunct3 := "111";

-- System Funct3
constant cSysEnv		: aFunct3 := "000";
constant cSysRW			: aFunct3 := "001";
constant cSysRS			: aFunct3 := "010";
constant cSysRC			: aFunct3 := "011";
constant cSysRWI		: aFunct3 := "101";
constant cSysRSI		: aFunct3 := "110";
constant cSysRCI		: aFunct3 := "111";

-- Trap Return Funct12
constant cMTrapRet		: aFunct12 := "001100000010";

-------------------------------------------------------------------------------
-- Control Unit
-------------------------------------------------------------------------------
type aControlUnitState is (	Fetch, ReadReg, Calc, DataAccess, CheckJump, 
							WriteReg, Wait0, Wait1, Trap);

constant cMemToRegALU		: aCtrlSignal := '0';
constant cMemToRegMem		: aCtrlSignal := '1';

constant cNoJump			: aCtrlSignal := '0';
constant cJump				: aCtrlSignal := '1';
constant cNoIncPC			: aCtrlSignal := '0';
constant cIncPC				: aCtrlSignal := '1';

constant cALUSrc1RegFile 	: aCtrl2Signal := "00";
constant cALUSrc1Zero		: aCtrl2Signal := "01";
constant cALUSrc1PC			: aCtrl2Signal := "10";

constant cALUSrc2RegFile 	: aCtrlSignal := '0';
constant cALUSrc2ImmGen  	: aCtrlSignal := '1';

constant cCsrDataReg		: aCtrlSignal := '0';
constant cCsrDataImm		: aCtrlSignal := '1';
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
subtype aRawALUValue	is std_ulogic_vector(cALUWidth downto 0);	-- incl. overflow bit
subtype aALUValue		is std_ulogic_vector(cALUWidth-1 downto 0);

-------------------------------------------------------------------------------
-- CSR
-------------------------------------------------------------------------------
constant cModeNoWrite	: aCtrl2Signal := "00";
constant cModeClear		: aCtrl2Signal := "01";
constant cModeSet		: aCtrl2Signal := "10";
constant cModeWrite		: aCtrl2Signal := "11";

-- user trap setup
constant cCsrUStatus	: aCsrAddr := x"000";
constant cCsrUIe		: aCsrAddr := x"004";
constant cCsrUTvec		: aCsrAddr := x"005";
-- user trap handling
constant cCsrUScratch	: aCsrAddr := x"040";
constant cCsrUEpc		: aCsrAddr := x"041";
constant cCsrUCause		: aCsrAddr := x"042";
constant cCsrUTval		: aCsrAddr := x"043";
constant cCsrUIp		: aCsrAddr := x"044";
-- machine information registers
constant cCsrMVendorId	: aCsrAddr := x"F11";
constant cCsrMArchId	: aCsrAddr := x"F12";
constant cCsrMImpId		: aCsrAddr := x"F13";
constant cCsrMHartId	: aCsrAddr := x"F14";
-- machine trap setup
constant cCsrMStatus	: aCsrAddr := x"300";
constant cCsrMIsa		: aCsrAddr := x"301";
constant cCsrMEdeleg	: aCsrAddr := x"302";
constant cCsrMIdeleg	: aCsrAddr := x"303";
constant cCsrMIe		: aCsrAddr := x"304";
constant cCsrMTvec		: aCsrAddr := x"305";
constant cCsrMCounteren	: aCsrAddr := x"306";
-- machine trap handling
constant cCsrMScratch	: aCsrAddr := x"340";
constant cCsrMEpc		: aCsrAddr := x"341";
constant cCsrMCause		: aCsrAddr := x"342";
constant cCsrMTval		: aCsrAddr := x"343";
constant cCsrMIp		: aCsrAddr := x"344";
-- machine memory protection
constant cCsrPmpcfg0	: aCsrAddr := x"3A0";
constant cCsrPmpcfg1	: aCsrAddr := x"3A1";
constant cCsrPmpcfg2	: aCsrAddr := x"3A2";
constant cCsrPmpcfg3	: aCsrAddr := x"3A3";
constant cCsrPmpaddr0	: aCsrAddr := x"3B0";
constant cCsrPmpaddr1	: aCsrAddr := x"3B1";
constant cCsrPmpaddr2	: aCsrAddr := x"3B2";
constant cCsrPmpaddr3	: aCsrAddr := x"3B3";
constant cCsrPmpaddr4	: aCsrAddr := x"3B4";
constant cCsrPmpaddr5	: aCsrAddr := x"3B5";
constant cCsrPmpaddr6	: aCsrAddr := x"3B6";
constant cCsrPmpaddr7	: aCsrAddr := x"3B7";
constant cCsrPmpaddr8	: aCsrAddr := x"3B8";
constant cCsrPmpaddr9	: aCsrAddr := x"3B9";
constant cCsrPmpaddr10	: aCsrAddr := x"3BA";
constant cCsrPmpaddr11	: aCsrAddr := x"3BB";
constant cCsrPmpaddr12	: aCsrAddr := x"3BC";
constant cCsrPmpaddr13	: aCsrAddr := x"3BD";
constant cCsrPmpaddr14	: aCsrAddr := x"3BE";
constant cCsrPmpaddr15	: aCsrAddr := x"3BF";


type aCsrSet is record
	-- user trap setup
	ustatus				: aRegValue;
	uie					: aRegValue;
	utvec				: aRegValue;
	-- user trap handling
	uscratch			: aRegValue;
	uepc				: aRegValue;
	ucause				: aRegValue;
	utval				: aRegValue;
	uip					: aRegValue;
	-- machine information registers
	mvendorid			: aRegValue;
	marchid				: aRegValue;
	mimpid				: aRegValue;
	mhartid				: aRegValue;
	--machine trap setup
	mstatus				: aRegValue;
	misa				: aRegValue;
	medeleg				: aRegValue;
	mideleg				: aRegValue;
	mie					: aRegValue;
	mtvec				: aRegValue;
	mcounteren			: aRegValue;
	-- machine trap handling
	mscratch			: aRegValue;
	mepc				: aRegValue;
	mcause				: aRegValue;
	mtval				: aRegValue;
	mip					: aRegValue;
	-- machine memory protection
	pmpcfg0				: aRegValue;
	pmpcfg1				: aRegValue;
	pmpcfg2				: aRegValue;
	pmpcfg3				: aRegValue;
	pmpaddr0			: aRegValue;
	pmpaddr1			: aRegValue;
	pmpaddr2			: aRegValue;
	pmpaddr3			: aRegValue;
	pmpaddr4			: aRegValue;
	pmpaddr5			: aRegValue;
	pmpaddr6			: aRegValue;
	pmpaddr7			: aRegValue;
	pmpaddr8			: aRegValue;
	pmpaddr9			: aRegValue;
	pmpaddr10			: aRegValue;
	pmpaddr11			: aRegValue;
	pmpaddr12			: aRegValue;
	pmpaddr13			: aRegValue;
	pmpaddr14			: aRegValue;
	pmpaddr15			: aRegValue;
end record;

-------------------------------------------------------------------------------
-- RegSet
-------------------------------------------------------------------------------

type aRegSet is record
	-- common signals
	curInst						: aInst;
	statusReg					: aRegValue;

	-- control signals
	ctrlState					: aControlUnitState;
	memWrite                    : aCtrlSignal;
	memRead                     : aCtrlSignal;
	memToReg                    : aCtrlSignal;
	jumpToAdr					: aCtrlSignal;

	-- signals for program counter
	curPC						: aPCValue;
	incPC						: aCtrlSignal;

	-- signals for writing register file
	regWriteEn					: aCtrlSignal;
	regWriteData				: aRegValue;

	-- signals for ALU
	aluCalc						: aCtrlSignal;
	aluOp						: aALUOp;
	aluData1					: aALUValue;
	aluData2					: aALUValue;
	aluRes						: aALUValue;

	-- signals for CSR
	csrReg						: aCsrSet;
	csrRead						: aCtrlSignal;
	csrReadData					: aRegValue;
	csrWriteMode				: aCtrl2Signal;
	csrWriteData				: aRegValue;
end record aRegSet;

constant cInitValRegSet : aRegSet := (
	curInst 		=> (others => '0'),
	statusReg		=> (others => '0'),

	ctrlState		=> Fetch,
	memWrite      	=> '0',
	memRead       	=> '0',
	memToReg      	=> '0',
	jumpToAdr		=> '0',

	curPC			=> (others => '0'),
	incPC			=> '0',

	regWriteEn		=> '0',
	regWriteData	=> (others => '0'),

	aluCalc			=> '0',
	aluOp			=> ALUOpNOP,
	aluData1		=> (others => '0'),
	aluData2		=> (others => '0'),
	aluRes			=> (others => '0'),

	csrReg			=> (others => (others => '0')),
	csrRead			=> '0',
	csrReadData		=> (others => '0'),
	csrWriteMode	=> (others => '0'),
	csrWriteData	=> (others => '0')
);


end RISCV;
