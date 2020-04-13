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

begin

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

Comb: process (R, RegFile, avm_i_readdata, avm_d_readdata)
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
	variable vDataMemByteEnable : std_logic_vector(3 downto 0) 	:= (others=>'0');

begin

	-- default signal values
	NxR <= R;
	NxRegFile <= RegFile;

	-- default variable values
	if(R.ctrlState = Fetch) then
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
		vDataMemByteEnable	:= (others=>'0');	-- data memory byte enable
	end if;

	-------------------------------------------------------------------------------
	-- Control Unit
	-------------------------------------------------------------------------------
	NxR.incPC           <= cNoIncPC;
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
				elsif R.curInst(5) = '0' then
					vAluSrc2 := cALUSrc2ImmGen;
				else
					null;
				end if;

			when cOpILoad | cOpSType =>
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
				null; -- not implemented yet

		end case;

	elsif R.ctrlState = Calc then
		case R.curInst(6 downto 0) is   -- check opcode
			-- R-Type or I-Type Register Instruction
			when cOpRType | cOpIArith =>
				NxR.regWriteEn  <= '1';
				NxR.memToReg    <= cMemToRegALU;    --TODO: ist schon default wert ?!?
				NxR.ctrlState   <= WriteReg;
			-- I-Type Load Instruction
			when cOpILoad =>
				NxR.memRead     <= '1';
				NxR.memToReg    <= cMemToRegMem;
				NxR.ctrlState   <= DataAccess;
			-- S-Type Store Instruction
			when cOpSType =>
				NxR.memWrite    <= '1';
				NxR.ctrlState   <= DataAccess;
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
				NxR.ctrlState <= DataAccess;
			when others =>
				null; -- not implemented yet

		end case;

	elsif R.ctrlState = DataAccess then
		case R.curInst(6 downto 0) is
			when cOpILoad =>
				NxR.regWriteEn  <= '1';
				NxR.ctrlState   <= WriteReg;
			when cOpSType =>
				NxR.ctrlState   <= Fetch;
			when cOpSys =>
				NxR.regWriteEn  <= R.csrRead;
				NxR.ctrlState   <= WriteReg;
			when others =>
				null;
		end case;

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
	avm_i_read      <= '1';
	avm_i_address   <= std_logic_vector(R.curPC);
	NxR.curInst     <= std_ulogic_vector(avm_i_readdata);

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
		-- R-Type
		when "0110011" =>
			vImm := (others => '0');
		-- I-Type
		when  "1100111" | "0000011" | "0010011" =>
			vImm(10 downto 0) := R.curInst(30 downto 20);
			vImm(cImmLen - 1 downto 11) := (others => R.curInst(31));
		-- S-Type
		when "0100011" =>
			vImm(10 downto 0) := R.curInst(30 downto 25) & R.curInst(11 downto 7);
			vImm(cImmLen - 1 downto 11) := (others => R.curInst(31));
		-- B-Type
		when "1100011" =>
			vImm(cImmLen - 1 downto 12) := (others => R.curInst(31));
			vImm(11 downto 0) := R.curInst(7) & R.curInst(30 downto 25) & R.curInst(11 downto 8) & '0';
		-- U-Type
		when "0110111" | "0010111" =>
			vImm := R.curInst(31 downto 12) & "000000000000";
		-- J-Type
		when "1101111" =>
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
				shift_right(signed('0' & R.aluData1),
				to_integer(unsigned(R.aluData2(4 downto 0)))));
		when ALUOpNOP =>
			vRawAluRes := (others => '0');
		when others =>
			vRawAluRes := (others => '0');
	end case;
	-- Remove Carry Bit
	vAluRes := std_ulogic_vector(resize(unsigned(vRawAluRes), cALUWidth));

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
	-- TODO: Exception if Adress is missaligned
	if R.curInst(6 downto 0) = cOpIJumpReg then  -- JAL or JALR
		vJumpAdr := vAluRes;
	else
		vJumpAdr := std_ulogic_vector(resize(unsigned(vImm) + unsigned(R.curPC), cImmLen));
	end if;

	-------------------------------------------------------------------------------
	-- CSR Unit
	-------------------------------------------------------------------------------
	if R.csrRead = '1' then
		case R.curInst(31 downto 20) is
			when cCsrUStatus    => NxR.csrReadData <= R.csrReg.ustatus;
			when cCsrUIe        => NxR.csrReadData <= R.csrReg.uie;
			when cCsrUTvec      => NxR.csrReadData <= R.csrReg.utvec;
			when cCsrUScratch   => NxR.csrReadData <= R.csrReg.uscratch;
			when cCsrUEpc       => NxR.csrReadData <= R.csrReg.uepc;
			when cCsrUCause     => NxR.csrReadData <= R.csrReg.ucause;
			when cCsrUTval      => NxR.csrReadData <= R.csrReg.utval;
			when cCsrUIp        => NxR.csrReadData <= R.csrReg.uip;
			when cCsrMVendorId  => NxR.csrReadData <= R.csrReg.mvendorid;
			when cCsrMArchId    => NxR.csrReadData <= R.csrReg.marchid;
			when cCsrMImpId     => NxR.csrReadData <= R.csrReg.mimpid;
			when cCsrMHartId    => NxR.csrReadData <= R.csrReg.mhartid;
			when cCsrMStatus    => NxR.csrReadData <= R.csrReg.mstatus;
			when cCsrMIsa       => NxR.csrReadData <= R.csrReg.misa;
			when cCsrMEdeleg    => NxR.csrReadData <= R.csrReg.medeleg;
			when cCsrMIdeleg    => NxR.csrReadData <= R.csrReg.mideleg;
			when cCsrMIe        => NxR.csrReadData <= R.csrReg.mie;
			when cCsrMTvec      => NxR.csrReadData <= R.csrReg.mtvec;
			when cCsrMCounteren => NxR.csrReadData <= R.csrReg.mcounteren;
			when cCsrMScratch   => NxR.csrReadData <= R.csrReg.mscratch;
			when cCsrMEpc       => NxR.csrReadData <= R.csrReg.mepc;
			when cCsrMCause     => NxR.csrReadData <= R.csrReg.mcause;
			when cCsrMTval      => NxR.csrReadData <= R.csrReg.mtval;
			when cCsrMIp        => NxR.csrReadData <= R.csrReg.mip;
			when cCsrPmpcfg0    => NxR.csrReadData <= R.csrReg.pmpcfg0;
			when cCsrPmpaddr0   => NxR.csrReadData <= R.csrReg.pmpaddr0;
			when others         => NxR.csrReadData <= (others => 'X');
		end case;
	end if;

	case R.csrWriteMode is
		when cModeWrite =>
			case R.curInst(31 downto 20) is
				when cCsrUStatus    => NxR.csrReg.ustatus   <= R.csrWriteData;
				when cCsrUIe        => NxR.csrReg.uie       <= R.csrWriteData;
				when cCsrUTvec      => NxR.csrReg.utvec     <= R.csrWriteData;
				when cCsrUScratch   => NxR.csrReg.uscratch  <= R.csrWriteData;
				when cCsrUEpc       => NxR.csrReg.uepc      <= R.csrWriteData;
				when cCsrUCause     => NxR.csrReg.ucause    <= R.csrWriteData;
				when cCsrUTval      => NxR.csrReg.utval     <= R.csrWriteData;
				when cCsrUIp        => NxR.csrReg.uip       <= R.csrWriteData;
				when cCsrMVendorId  => NxR.csrReg.mvendorid <= R.csrWriteData;
				when cCsrMArchId    => NxR.csrReg.marchid   <= R.csrWriteData;
				when cCsrMImpId     => NxR.csrReg.mimpid    <= R.csrWriteData;
				when cCsrMHartId    => NxR.csrReg.mhartid   <= R.csrWriteData;
				when cCsrMStatus    => NxR.csrReg.mstatus   <= R.csrWriteData;
				when cCsrMIsa       => NxR.csrReg.misa      <= R.csrWriteData;
				when cCsrMEdeleg    => NxR.csrReg.medeleg   <= R.csrWriteData;
				when cCsrMIdeleg    => NxR.csrReg.mideleg   <= R.csrWriteData;
				when cCsrMIe        => NxR.csrReg.mie       <= R.csrWriteData;
				when cCsrMTvec      => NxR.csrReg.mtvec     <= R.csrWriteData;
				when cCsrMCounteren => NxR.csrReg.mcounteren <= R.csrWriteData;
				when cCsrMScratch   => NxR.csrReg.mscratch  <= R.csrWriteData;
				when cCsrMEpc       => NxR.csrReg.mepc      <= R.csrWriteData;
				when cCsrMCause     => NxR.csrReg.mcause    <= R.csrWriteData;
				when cCsrMTval      => NxR.csrReg.mtval     <= R.csrWriteData;
				when cCsrMIp        => NxR.csrReg.mip       <= R.csrWriteData;
				when cCsrPmpcfg0    => NxR.csrReg.pmpcfg0   <= R.csrWriteData;
				when cCsrPmpaddr0   => NxR.csrReg.pmpaddr0  <= R.csrWriteData;
				when others         => null;
			end case;

		when cModeSet =>
			case R.curInst(31 downto 20) is
				when cCsrUStatus    => NxR.csrReg.ustatus   <= R.csrWriteData or R.csrReadData;
				when cCsrUIe        => NxR.csrReg.uie       <= R.csrWriteData or R.csrReadData;
				when cCsrUTvec      => NxR.csrReg.utvec     <= R.csrWriteData or R.csrReadData;
				when cCsrUScratch   => NxR.csrReg.uscratch  <= R.csrWriteData or R.csrReadData;
				when cCsrUEpc       => NxR.csrReg.uepc      <= R.csrWriteData or R.csrReadData;
				when cCsrUCause     => NxR.csrReg.ucause    <= R.csrWriteData or R.csrReadData;
				when cCsrUTval      => NxR.csrReg.utval     <= R.csrWriteData or R.csrReadData;
				when cCsrUIp        => NxR.csrReg.uip       <= R.csrWriteData or R.csrReadData;
				when cCsrMVendorId  => NxR.csrReg.mvendorid <= R.csrWriteData or R.csrReadData;
				when cCsrMArchId    => NxR.csrReg.marchid   <= R.csrWriteData or R.csrReadData;
				when cCsrMImpId     => NxR.csrReg.mimpid    <= R.csrWriteData or R.csrReadData;
				when cCsrMHartId    => NxR.csrReg.mhartid   <= R.csrWriteData or R.csrReadData;
				when cCsrMStatus    => NxR.csrReg.mstatus   <= R.csrWriteData or R.csrReadData;
				when cCsrMIsa       => NxR.csrReg.misa      <= R.csrWriteData or R.csrReadData;
				when cCsrMEdeleg    => NxR.csrReg.medeleg   <= R.csrWriteData or R.csrReadData;
				when cCsrMIdeleg    => NxR.csrReg.mideleg   <= R.csrWriteData or R.csrReadData;
				when cCsrMIe        => NxR.csrReg.mie       <= R.csrWriteData or R.csrReadData;
				when cCsrMTvec      => NxR.csrReg.mtvec     <= R.csrWriteData or R.csrReadData;
				when cCsrMCounteren => NxR.csrReg.mcounteren <= R.csrWriteData or R.csrReadData;
				when cCsrMScratch   => NxR.csrReg.mscratch  <= R.csrWriteData or R.csrReadData;
				when cCsrMEpc       => NxR.csrReg.mepc      <= R.csrWriteData or R.csrReadData;
				when cCsrMCause     => NxR.csrReg.mcause    <= R.csrWriteData or R.csrReadData;
				when cCsrMTval      => NxR.csrReg.mtval     <= R.csrWriteData or R.csrReadData;
				when cCsrMIp        => NxR.csrReg.mip       <= R.csrWriteData or R.csrReadData;
				when cCsrPmpcfg0    => NxR.csrReg.pmpcfg0   <= R.csrWriteData or R.csrReadData;
				when cCsrPmpaddr0   => NxR.csrReg.pmpaddr0  <= R.csrWriteData or R.csrReadData;
				when others         => null;
			end case;

		when cModeClear =>
			case R.curInst(31 downto 20) is
				when cCsrUStatus    => NxR.csrReg.ustatus   <= (not R.csrWriteData) and R.csrReadData;
				when cCsrUIe        => NxR.csrReg.uie       <= (not R.csrWriteData) and R.csrReadData;
				when cCsrUTvec      => NxR.csrReg.utvec     <= (not R.csrWriteData) and R.csrReadData;
				when cCsrUScratch   => NxR.csrReg.uscratch  <= (not R.csrWriteData) and R.csrReadData;
				when cCsrUEpc       => NxR.csrReg.uepc      <= (not R.csrWriteData) and R.csrReadData;
				when cCsrUCause     => NxR.csrReg.ucause    <= (not R.csrWriteData) and R.csrReadData;
				when cCsrUTval      => NxR.csrReg.utval     <= (not R.csrWriteData) and R.csrReadData;
				when cCsrUIp        => NxR.csrReg.uip       <= (not R.csrWriteData) and R.csrReadData;
				when cCsrMVendorId  => NxR.csrReg.mvendorid <= (not R.csrWriteData) and R.csrReadData;
				when cCsrMArchId    => NxR.csrReg.marchid   <= (not R.csrWriteData) and R.csrReadData;
				when cCsrMImpId     => NxR.csrReg.mimpid    <= (not R.csrWriteData) and R.csrReadData;
				when cCsrMHartId    => NxR.csrReg.mhartid   <= (not R.csrWriteData) and R.csrReadData;
				when cCsrMStatus    => NxR.csrReg.mstatus   <= (not R.csrWriteData) and R.csrReadData;
				when cCsrMIsa       => NxR.csrReg.misa      <= (not R.csrWriteData) and R.csrReadData;
				when cCsrMEdeleg    => NxR.csrReg.medeleg   <= (not R.csrWriteData) and R.csrReadData;
				when cCsrMIdeleg    => NxR.csrReg.mideleg   <= (not R.csrWriteData) and R.csrReadData;
				when cCsrMIe        => NxR.csrReg.mie       <= (not R.csrWriteData) and R.csrReadData;
				when cCsrMTvec      => NxR.csrReg.mtvec     <= (not R.csrWriteData) and R.csrReadData;
				when cCsrMCounteren => NxR.csrReg.mcounteren <= (not R.csrWriteData) and R.csrReadData;
				when cCsrMScratch   => NxR.csrReg.mscratch  <= (not R.csrWriteData) and R.csrReadData;
				when cCsrMEpc       => NxR.csrReg.mepc      <= (not R.csrWriteData) and R.csrReadData;
				when cCsrMCause     => NxR.csrReg.mcause    <= (not R.csrWriteData) and R.csrReadData;
				when cCsrMTval      => NxR.csrReg.mtval     <= (not R.csrWriteData) and R.csrReadData;
				when cCsrMIp        => NxR.csrReg.mip       <= (not R.csrWriteData) and R.csrReadData;
				when cCsrPmpcfg0    => NxR.csrReg.pmpcfg0   <= (not R.csrWriteData) and R.csrReadData;
				when cCsrPmpaddr0   => NxR.csrReg.pmpaddr0  <= (not R.csrWriteData) and R.csrReadData;
				when others         => null;
			end case;

		when others => null;
	end case;

	-------------------------------------------------------------------------------
	-- Data Memory
	-------------------------------------------------------------------------------	
	case R.curInst(14 downto 12) is
		when cMemByte => 				
			vDataMemReadData := std_ulogic_vector(
				resize(signed(avm_d_readdata(cByte-1 downto 0)), cBitWidth));
			vDataMemByteEnable := cEnableByte;

		when cMemHalfWord => 
			vDataMemReadData := std_ulogic_vector(
				resize(signed(avm_d_readdata(2*cByte-1 downto 0)), cBitWidth));
			vDataMemByteEnable := cEnableHalfWord;

		when cMemWord => 
			vDataMemReadData := std_ulogic_vector(
				resize(signed(avm_d_readdata(4*cByte-1 downto 0)), cBitWidth));
			vDataMemByteEnable := cEnableWord;

		when cMemUnsignedByte => 
			vDataMemReadData := std_ulogic_vector(resize(unsigned(
				avm_d_readdata(cByte-1 downto 0)), cBitWidth));

		when cMemUnsignedHalfWord => 
			vDataMemReadData := std_ulogic_vector(resize(unsigned(
				avm_d_readdata(2*cByte-1 downto 0)), cBitWidth));

		when others => null;
	end case;

	avm_d_address       <= std_logic_vector(vAluRes);
	avm_d_byteenable    <= vDataMemByteEnable;
	avm_d_write         <= std_logic(R.memWrite);
	avm_d_writedata     <= std_logic_vector(vRegReadData2);
	avm_d_read          <= std_logic(R.memRead);

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

	-- TODO: Change to single mux
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
