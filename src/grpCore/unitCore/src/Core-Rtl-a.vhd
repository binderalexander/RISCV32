-------------------------------------------------------------------------------
-- Title      : RISC-V 32-Bit FSMD Core
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : Core-Rtl-a.vhd
-- Author     : Binder Alexander
-- Date		  : 11.11.2019
-- Revisions  : V1, 11.11.2019 -ba
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------

architecture rtl of Core is

	-- common registers
	signal R, NxR : aRegSet;

	-- Register File
	signal RegFile, NxRegFile : aRegFile;
	constant cInitValRegFile : aRegFile := (others => (others => '0'));

	-- bussignals for remapping
	signal i_readdata_remapped 		: std_logic_vector(cBitWidth-1 downto 0);
	signal d_readdata_remapped 		: std_logic_vector(cBitWidth-1 downto 0);
	signal d_writedata_remapped		: std_logic_vector(cBitWidth-1 downto 0);


	function validAddrCSR(addr : aCsrAddr) return boolean is
	begin
		case addr is
			when 	cCsrMVendorId | cCsrMArchId | cCsrMImpId | cCsrMHartId |
					cCsrMStatus | cCsrMIsa | cCsrMEdeleg | cCsrMIdeleg |
					cCsrMIe | cCsrMTvec | cCsrMCounteren |
					cCsrMScratch | cCsrMEpc | cCsrMCause | cCsrMTval | cCsrMIp |
					cCsrPmpcfg0 | cCsrPmpcfg1 | cCsrPmpcfg2 | cCsrPmpcfg3 |
					cCsrPmpaddr0 | cCsrPmpaddr1 | cCsrPmpaddr2 | cCsrPmpaddr3 |
					cCsrPmpaddr4 | cCsrPmpaddr5 | cCsrPmpaddr6 | cCsrPmpaddr7 |
					cCsrPmpaddr8 | cCsrPmpaddr9 | cCsrPmpaddr10 | cCsrPmpaddr11 |
					cCsrPmpaddr12 | cCsrPmpaddr13 | cCsrPmpaddr14 | cCsrPmpaddr15 =>
				return true;
			when others =>
				return false;
		end case;
	end function;

begin

-- remap bus signals to internal representation
-- instruction bus
i_readdata_remapped(31 downto 24)      <= avm_i_readdata( 7 downto  0);
i_readdata_remapped(23 downto 16)      <= avm_i_readdata(15 downto  8);
i_readdata_remapped(15 downto  8)      <= avm_i_readdata(23 downto 16);
i_readdata_remapped(7  downto  0)      <= avm_i_readdata(31 downto 24);

-- data bus
d_readdata_remapped(31 downto 24)   <= avm_d_readdata( 7 downto  0);
d_readdata_remapped(23 downto 16)   <= avm_d_readdata(15 downto  8);
d_readdata_remapped(15 downto  8)   <= avm_d_readdata(23 downto 16);
d_readdata_remapped(7  downto  0)	<= avm_d_readdata(31 downto 24);
avm_d_writedata(31 downto 24)		<= d_writedata_remapped( 7 downto  0);
avm_d_writedata(23 downto 16)		<= d_writedata_remapped(15 downto  8);
avm_d_writedata(15 downto  8)		<= d_writedata_remapped(23 downto 16);
avm_d_writedata( 7 downto  0)		<= d_writedata_remapped(31 downto 24);	

Registers: process (csi_clk, rsi_reset_n)
begin
	if (rsi_reset_n = not('1')) then
		R <= cInitValRegSet;
		RegFile <= cInitValRegFile;
	elsif ( (csi_clk'event) and (csi_clk = '1') ) then
		R <= NxR;
		RegFile <= NxRegFile;
	end if;
end process;

Comb: process (R, RegFile, i_readdata_remapped, d_readdata_remapped)
	variable vRegReadData1      : aRegValue     				:= (others=>'0');
	variable vRegReadData2      : aRegValue     				:= (others=>'0');
	variable vRegWriteData      : aRegValue     				:= (others=>'0');
	variable vRawAluRes         : aRawALUValue  				:= (others=>'0');
	variable vAluRes            : aALUValue     				:= (others=>'0');
	variable vAluSrc1           : aCtrl2Signal  				:= (others=>'0');
	variable vAluSrc2			: aCtrlSignal   				:= '0';
	variable vImm               : aImm	        				:= (others=>'0');
	variable vPCPlus4 			: aPCValue      				:= (others=>'0');
	variable vNextPC            : aPCValue      				:= (others=>'0');
	variable vJumpAdr           : aPCValue      				:= (others=>'0');
	variable vDataMemReadData   : aWord         				:= (others=>'0');
	variable vDataMemWriteData	: aWord							:= (others=>'0');
	variable vDataMemByteEnable : std_logic_vector(3 downto 0) 	:= (others=>'0');

begin

	-- default signal values
	NxR <= R;
	NxRegFile <= RegFile;

	-- default variable values
	vRegReadData1       := (others=>'0');   -- register file read data 1
	vRegReadData2       := (others=>'0');   -- register file read data 2
	vRegWriteData       := (others=>'0');   -- register file write data
	vRawAluRes          := (others=>'0');   -- alu result including overflow bit
	vAluRes				:= (others=>'0');	-- alu result truncated
	vAluSrc1            := (others=>'0');   -- alu input 1 mux
	vAluSrc2            := '0';             -- alu input 2 mux
	vImm				:= (others=>'0');	-- extended Immediate
	vPCPlus4			:= (others=>'0');	-- current program counter plus 4
	vNextPC				:= (others=>'0');	-- next program counter value
	vJumpAdr			:= (others=>'0');	-- calculated jump address from instruction
	vDataMemReadData	:= (others=>'0');	-- data memory read data
	vDataMemWriteData	:= (others=>'0');	-- data memory write data
	vDataMemByteEnable	:= (others=>'0');	-- data memory byte enable

	-------------------------------------------------------------------------------
	-- Control Unit
	-------------------------------------------------------------------------------
	NxR.incPC           <= cNoIncPC;
	NxR.aluCalc			<= '0';
	NxR.memRead         <= '0';
	NxR.memWrite        <= '0';
	NxR.memToReg        <= cMemToRegALU;
	NxR.jumpToAdr       <= cNoJump;
	NxR.csrRead         <= '0';
	NxR.csrWriteMode    <= cModeNoWrite;

	if R.ctrlState = Fetch then
		NxR.ctrlState <= ReadReg;

	elsif R.ctrlState = ReadReg then

		NxR.incPC     <= cIncPC;
		NxR.aluCalc	  <= '1';
		NxR.ctrlState <= Calc;
		vALUSrc1      := cALUSrc1RegFile;

		case R.curInst(6 downto 0) is

			when cOpRType | cOpIArith =>
				-- ALU OpCode
				case R.curInst(14 downto 12) is
					when "000" => -- add/sub
						if R.curInst(6 downto 0) = cOpRType and R.curInst(30) = '1' then
							NxR.aluOp <= ALUOpSub;
						else
							NxR.aluOp <= ALUOpAdd;
						end if;
					when "001" => NxR.aluOp <= ALUOpSLL; 	-- shift left logical
					when "010" => NxR.aluOp <= ALUOpSLT;	-- signed less than
					when "011" => NxR.aluOp <= ALUOpSLTU;	-- unsigned less than
					when "100" => NxR.aluOp <= ALUOpXor; 	-- xor
					when "101" => 							-- shift rigth logical/arithmetical
						case R.curInst(30) is
							when '0' => NxR.aluOp <= ALUOpSRL;
							when '1' => NxR.aluOp <= ALUOpSRA;
							when others => null;
						end case;
					when "110" => NxR.aluOp <= ALUOpOr; 	-- or
					when "111" => NxR.aluOp <= ALUOpAnd;	-- and
					when others => null;
				end case;

				-- Immediate or Register Instruction
				if R.curInst(5) = '1' then
					vAluSrc2 := cALUSrc2RegFile;
				else
					vAluSrc2 := cALUSrc2ImmGen;
				end if;

			when cOpILoad =>
				NxR.aluOp       <= ALUOpAdd;
				NxR.incPC		<= cNoIncPC;
				vAluSrc2        := cALUSrc2ImmGen;

			when cOpSType =>
				NxR.aluOp       <= ALUOpAdd;
				vAluSrc2        := cALUSrc2ImmGen;

			when cOpJType =>
				NxR.aluOp       <= ALUOpNOP;
				NxR.jumpToAdr   <= cJump;

			when cOpIJumpReg =>
				NxR.aluOp       <= ALUOpAdd;
				vAluSrc2        := cALUSrc2ImmGen;
				NxR.jumpToAdr   <= cJump;

			when cOpBType =>
				NxR.ALUOp       <= ALUOpSub;
				vAluSrc2        := cALUSrc2RegFile;
				NxR.incPC       <= cNoIncPC;

			when cOpLUI =>
				NxR.ALUOp       <= ALUOpAdd;
				vAluSrc1        := cALUSrc1Zero;
				vAluSrc2        := cALUSrc2ImmGen;

			when cOpAUIPC =>
				NxR.ALUOp       <= ALUOpAdd;
				vAluSrc1        := cALUSrc1PC;
				vAluSrc2        := cALUSrc2ImmGen;

			when cOpFence =>    -- implemented as NOP
				NxR.aluCalc		<= '0';
				NxR.ctrlState   <= Wait0;

			when cOpSys =>
				case R.curInst(14 downto 12) is
					when cSysEnv =>
						NxR.ctrlState   <= Trap;
					when others =>
						NxR.incPC       <= cNoIncPC;
						NxR.ctrlState   <= Calc;
				end case;

			when others =>
				null; -- not implemented

		end case;

	elsif R.ctrlState = Calc then
		case R.curInst(6 downto 0) is   -- check opcode
			-- R-Type or I-Type Register Instruction
			when cOpRType | cOpIArith =>
				NxR.regWriteEn  <= '1';
				NxR.ctrlState   <= WriteReg;
			-- I-Type Load Instruction
			when cOpILoad =>
				NxR.memRead     <= '1';
				NxR.incPC		<= cIncPC;
				--NxR.memToReg    <= cMemToRegMem;
				NxR.ctrlState   <= DataAccess0;
			-- S-Type Store Instruction
			when cOpSType =>
				NxR.memWrite    <= '1';
				NxR.ctrlState   <= DataAccess0;
			-- J-Type Jump Instruction
			when cOpJType | cOpIJumpReg =>
				NxR.regWriteEn  <= '1';
				NxR.ctrlState   <= WriteReg;
				null;
			-- B-Type Conditional Branch
			when cOpBType =>
				NxR.ctrlState   <= CheckJump;
			-- U-Type Load Immediate
			when cOpLUI | cOpAUIPC =>
				NxR.regWriteEn  <= '1';
				NxR.ctrlState   <= WriteReg;
			-- CSR Instruction
			when cOpSys =>
				case R.curInst(14 downto 12) is
					when cSysRW | cSysRWI =>
						if R.curInst(11 downto 7) = "00000" then    NxR.csrRead <= '0';
						else                                        NxR.csrRead <= '1';
						end if;
						NxR.csrWriteMode <= cModeWrite;
					when cSysRS | cSysRSI =>
						NxR.csrRead <= '1';
						if R.curInst(19 downto 15) = "00000" then   NxR.csrWriteMode <= cModeNoWrite;
						else                                        NxR.csrWriteMode <= cModeSet;
						end if;
					when cSysRC | cSysRCI =>
						NxR.csrRead <= '1';
						if R.curInst(19 downto 15) = "00000" then   NxR.csrWriteMode <= cModeNoWrite;
						else                                        NxR.csrWriteMode <= cModeClear;
						end if;
					when others => null;
				end case;
				NxR.incPC     <= cIncPC;
				NxR.ctrlState <= DataAccess0;
			when others =>
				null;

		end case;

	elsif R.ctrlState = DataAccess0 then
		case R.curInst(6 downto 0) is
			when cOpILoad =>
				NxR.memToReg    <= cMemToRegMem;
				NxR.ctrlState   <= DataAccess1;
			when cOpSType =>
				NxR.ctrlState   <= Wait1;
			when cOpSys =>
				NxR.regWriteEn  <= R.csrRead;
				NxR.ctrlState   <= WriteReg;
			when others =>
				null;
		end case;

	elsif R.ctrlState = DataAccess1 then
		NxR.regWriteEn  <= '1';
		NxR.ctrlState 	<= WriteReg;

	elsif R.ctrlState = CheckJump then
		NxR.incPC       <= cIncPC;
		case R.curInst(14 downto 12) is
			when cCondEq =>
				if R.statusReg(cStatusZeroBit) = '1' then
					NxR.jumpToAdr   <= cJump;
				end if;
			when cCondNe =>
				if R.statusReg(cStatusZeroBit) = '0' then
					NxR.jumpToAdr   <= cJump;
				end if;
			when cCondLt =>
				if R.statusReg(cStatusNegBit) = '1' then
					NxR.jumpToAdr   <= cJump;
				end if;
			when cCondGe =>
				if R.statusReg(cStatusNegBit) = '0' then
					NxR.jumpToAdr   <= cJump;
				end if;
			when cCondLtu =>
				if R.statusReg(cStatusCarryBit) = '1' then
					NxR.jumpToAdr   <= cJump;
				end if;
			when cCondGeu =>
				if R.statusReg(cStatusCarryBit) = '0' then
					NxR.jumpToAdr   <= cJump;
				end if;
			when others =>
				null;
		end case;
		NxR.ctrlState <= Wait0;

	elsif R.ctrlState = WriteReg then
		NxR.regWriteEn  <= '0';
		NxR.ctrlState <= Fetch;

	elsif R.ctrlState = Wait0 then
		NxR.ctrlState <= Wait1;

	elsif R.ctrlState = Wait1 then
		NxR.ctrlState <= Fetch;

	elsif R.ctrlState = Trap then
		if R.curInst(31 downto 20) = cMTrapRet then
			NxR.ctrlState <= Wait1;
		else
			NxR.ctrlState <= Trap;
		end if;
	else
		null;
	end if;

	-------------------------------------------------------------------------------
	-- Program Counter
	-------------------------------------------------------------------------------
	vPCPlus4 := std_ulogic_vector(to_unsigned(
		to_integer(unsigned(R.curPC)) + cPCIncrement, cPCWidth));

	-------------------------------------------------------------------------------
	-- Instruction Memory
	-------------------------------------------------------------------------------
	if R.ctrlState = WriteReg or R.ctrlState = Wait1 then
		avm_i_read <= '1';
	else
		avm_i_read <= '0';
	end if;

	avm_i_address   <= std_logic_vector(R.curPC);
	NxR.curInst     <= std_ulogic_vector(i_readdata_remapped);

	-------------------------------------------------------------------------------
	-- Register File
	-------------------------------------------------------------------------------
	-- read registers
	vRegReadData1       := RegFile(to_integer(unsigned(R.curInst(19 downto 15))));
	vRegReadData2       := RegFile(to_integer(unsigned(R.curInst(24 downto 20))));

	-- write register
	if R.regWriteEn = '1' and R.curInst(11 downto 7) /= "00000" then
		NxRegFile(to_integer(unsigned(R.curInst(11 downto 7)))) <= R.regWriteData;
	end if;

	-------------------------------------------------------------------------------
	-- Immediate Extension
	-------------------------------------------------------------------------------
	case R.curInst(6 downto 0) is
		when cOpRType =>
			vImm := (others => '0');
		when  cOpIJumpReg | cOpILoad | cOpIArith =>
			vImm(10 downto 0) := R.curInst(30 downto 20);
			vImm(cImmLen - 1 downto 11) := (others => R.curInst(31));
		when cOpSType =>
			vImm(10 downto 0) := R.curInst(30 downto 25) & R.curInst(11 downto 7);
			vImm(cImmLen - 1 downto 11) := (others => R.curInst(31));
		when cOpBType =>
			vImm(cImmLen - 1 downto 12) := (others => R.curInst(31));
			vImm(11 downto 0) := R.curInst(7) & R.curInst(30 downto 25) & R.curInst(11 downto 8) & '0';
		when cOpLUI | cOpAUIPC =>
			vImm := R.curInst(31 downto 12) & "000000000000";
		when cOpJType =>
			vImm(cImmLen - 1 downto 20) := (others => R.curInst(31));
			vImm(19 downto 0) := R.curInst(19 downto 12) & R.curInst(20) & R.curInst(30 downto 21) & '0';
		when others =>
			vImm := (others => '0');
	end case;

	-------------------------------------------------------------------------------
	-- ALU
	-------------------------------------------------------------------------------
	case R.aluOp is
		when ALUOpAdd =>
			vRawAluRes := std_ulogic_vector(resize(
				resize(unsigned(R.aluData1), cALUWidth+1) +
				resize(unsigned(R.aluData2), cALUWidth+1), cALUWidth+1));
		when ALUOpSub =>
			vRawAluRes := std_ulogic_vector(resize(
				resize(unsigned(R.aluData1), cALUWidth+1) -
				resize(unsigned(R.aluData2), cALUWidth+1), cALUWidth+1));
		when ALUOpSLT =>
			if signed(R.aluData1) < signed(R.aluData2) then
				vRawAluRes := (0 => '1', others => '0');
			else
				vRawAluRes := (others => '0');
			end if;
		when ALUOpSLTU =>
			if unsigned(R.aluData1) < unsigned(R.aluData2) then
				vRawAluRes := (0 => '1', others => '0');
			else
				vRawAluRes := (others => '0');
			end if;
		when ALUOpAnd =>
			vRawAluRes := '0' & (R.aluData1 AND R.aluData2);
		when ALUOpOr =>
			vRawAluRes := '0' & (R.aluData1 OR R.aluData2);
		when ALUOpXor =>
			vRawAluRes := '0' & (R.aluData1 XOR R.aluData2);
		when ALUOpSLL =>
			vRawAluRes := std_ulogic_vector(
				shift_left(unsigned('0' & R.aluData1),
				to_integer(unsigned(R.aluData2(4 downto 0)))));
		when ALUOpSRL =>
			vRawAluRes := std_ulogic_vector(
				shift_right(unsigned('0' & R.aluData1),
				to_integer(unsigned(R.aluData2(4 downto 0)))));
		when ALUOpSRA =>
			vRawAluRes := std_ulogic_vector(
				shift_right(signed(R.aluData1(cALUWidth-1) & R.aluData1),
				to_integer(unsigned(R.aluData2(4 downto 0)))));
		when ALUOpNOP =>
			vRawAluRes := (others => '0');
		when others =>
			vRawAluRes := (others => '0');
	end case;

	-- Remove Carry Bit and Store New Value
	if(R.aluCalc = '1') then
		vAluRes := std_ulogic_vector(resize(unsigned(vRawAluRes), cALUWidth));
		NxR.aluRes <= vAluRes;
	else
		vAluRes := R.aluRes;
	end if;

	-- Set Status Register
	if to_integer(signed(vAluRes)) = 0 then
		NxR.statusReg(cStatusZeroBit) <= '1';
	else
		NxR.statusReg(cStatusZeroBit) <= '0';
	end if;
	if to_integer(signed(vAluRes)) < 0 then
		NxR.statusReg(cStatusNegBit) <= '1';
	else
		NxR.statusReg(cStatusNegBit) <= '0';
	end if;
	NxR.statusReg(cStatusCarryBit) <= vRawAluRes(vRawAluRes'high);

	-------------------------------------------------------------------------------
	-- Jump Adress Calculation
	-------------------------------------------------------------------------------
	if R.curInst(6 downto 0) = cOpIJumpReg then  -- JAL or JALR
		vJumpAdr := vAluRes;
	else
		vJumpAdr := std_ulogic_vector(resize(unsigned(vImm) + unsigned(R.curPC), cImmLen));
	end if;

	-------------------------------------------------------------------------------
	-- CSR Unit
	-------------------------------------------------------------------------------
	if R.csrRead = '1' then
		if validAddrCSR(R.curInst(31 downto 20)) then
			NxR.csrReadData <= R.csrReg(to_integer(unsigned(R.curInst(31 downto 20))));
		else
			NxR.csrReadData <= (others => '0');
		end if;
	end if;

	if R.csrWriteMode /= cModeNoWrite then
		if validAddrCSR(R.curInst(31 downto 20)) then
			case R.csrWriteMode is
				when cModeWrite =>
					NxR.csrReg(to_integer(unsigned(R.curInst(31 downto 20)))) <= R.csrWriteData;
				when cModeSet =>
					NxR.csrReg(to_integer(unsigned(R.curInst(31 downto 20)))) <= R.csrWriteData or R.csrReadData;
				when cModeClear =>
					NxR.csrReg(to_integer(unsigned(R.curInst(31 downto 20)))) <= (not R.csrWriteData) and R.csrReadData;
				when others =>
					null;
			end case;
		end if;
	end if;

	-------------------------------------------------------------------------------
	-- Data Memory
	-------------------------------------------------------------------------------	
	case R.curInst(14 downto 12) is
		when cMemByte => 				
			vDataMemReadData := std_ulogic_vector(
				resize(signed(d_readdata_remapped(cByte-1 downto 0)), cBitWidth));
			vDataMemWriteData(4*cByte-1 downto 3*cByte) := vRegReadData2(cByte-1 downto 0);
			vDataMemByteEnable := cEnableByte;

		when cMemHalfWord => 
			vDataMemReadData := std_ulogic_vector(
				resize(signed(d_readdata_remapped(2*cByte-1 downto 0)), cBitWidth));
			vDataMemWriteData(4*cByte-1 downto 2*cByte) := vRegReadData2(2*cByte-1 downto 0);
			vDataMemByteEnable := cEnableHalfWord;

		when cMemWord => 
			vDataMemReadData := std_ulogic_vector(
				resize(signed(d_readdata_remapped(4*cByte-1 downto 0)), cBitWidth));
			vDataMemWriteData := vRegReadData2;
			vDataMemByteEnable := cEnableWord;

		when cMemUnsignedByte => 
			vDataMemReadData := std_ulogic_vector(resize(unsigned(
				d_readdata_remapped(cByte-1 downto 0)), cBitWidth));
			vDataMemWriteData(4*cByte-1 downto 3*cByte) := vRegReadData2(cByte-1 downto 0);
			vDataMemByteEnable := cEnableByte;

		when cMemUnsignedHalfWord => 
			vDataMemReadData := std_ulogic_vector(resize(unsigned(
				d_readdata_remapped(2*cByte-1 downto 0)), cBitWidth));
			vDataMemWriteData(4*cByte-1 downto 2*cByte) := vRegReadData2(2*cByte-1 downto 0);
			vDataMemByteEnable := cEnableHalfWord;

		when others =>
			vDataMemReadData 	:= (others=>'0');
			vDataMemWriteData 	:= (others=>'0');
			vDataMemByteEnable 	:= (others=>'0');
	end case;

	avm_d_address       	<= std_logic_vector(vAluRes);
	avm_d_byteenable 		<= vDataMemByteEnable;
	avm_d_write         	<= std_logic(R.memWrite);
	d_writedata_remapped    <= std_logic_vector(vDataMemWriteData);
	avm_d_read          	<= std_logic(R.memRead);

	-------------------------------------------------------------------------------
	-- Multiplexer
	-------------------------------------------------------------------------------

	-- MUX ALUSrc
	if vAluSrc2 = cALUSrc2RegFile then
		NxR.aluData2 <= vRegReadData2;
	else
		NxR.aluData2 <= vImm;
	end if;

	-- Mux WriteRegSrc0
	if R.memToReg = cMemToRegALU then
		vRegWriteData := vAluRes;
	else
		vRegWriteData := vDataMemReadData;
	end if;
	-- Mux WriteRegSrc1
	if R.jumpToAdr = cNoJump then
		NxR.regWriteData <= vRegWriteData;
	else
		NxR.regWriteData <= vPCPlus4;
	end if;

	-- Mux PCInc
	if R.incPC = cNoIncPC then
		vNextPC := R.curPC;
	else
		vNextPC := vPCPlus4;
	end if;
	-- Mux PCJump
	if R.jumpToAdr = cNoJump then
		NxR.curPC <= vNextPC;
	else
		NxR.curPC <= vJumpAdr;
	end if;

	-- Mux ALU1Src
	case vAluSrc1 is
		when cALUSrc1RegFile        => NxR.aluData1 <= vRegReadData1;
		when cALUSrc1Zero           => NxR.aluData1 <= (others => '0');
		when cALUSrc1PC             => NxR.aluData1 <= R.curPC;
		when others                 => null;
	end case;

	-- Mux CsrWriteData
	if R.curInst(14) = cCsrDataReg then
		NxR.csrWriteData <= vRegReadData1;
	else
		NxR.csrWriteData <= std_ulogic_vector(resize(unsigned(R.curInst(19 downto 15)), cBitWidth));
	end if;

end process;

end architecture rtl;
