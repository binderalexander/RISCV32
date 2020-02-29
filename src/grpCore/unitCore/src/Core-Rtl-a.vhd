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
    constant cInitValRegFile : aRegFile := (    1 => x"CF123456",
												2 => x"12345678",
                                                3 => x"CAFEBABE",
                                                others => (others => '0'));

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
    variable vRegReadData2      : aRegValue   := (others=>'0');
    variable vRegWriteData      : aRegValue   := (others=>'0');
	variable vAluRes            : aALUValue   := (others=>'0');
    variable vAluSrc            : aCtrlSignal := '0';
	variable vImm               : aImm	      := (others=>'0');
    variable vPCPlus4           : aPCValue    := (others=>'0');
    variable vNextPC            : aPCValue    := (others=>'0');
    variable vJumpAdr           : aPCValue    := (others=>'0');
    variable vDataMemReadData   : aWord       := (others=>'0');
    variable vDataMemByteEnable : std_logic_vector(3 downto 0) := (others=>'0');

begin
    NxR <= R;
    NxRegFile <= RegFile;

    -------------------------------------------------------------------------------
    -- Control Unit
    -------------------------------------------------------------------------------
    NxR.incPC       <= cNoIncPC;
    NxR.memRead     <= '0';
    NxR.memWrite    <= '0';
    NxR.memToReg    <= cMemToRegALU;
    NxR.jumpToAdr   <= cNoJump;

    if R.ctrlState = Fetch then
        NxR.ctrlState <= ReadReg;

    elsif R.ctrlState = ReadReg then

        NxR.incPC     <= cIncPC;
        NxR.ctrlState <= Calc;

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
                    vAluSrc := cALUSrcRegFile;
				elsif R.curInst(5) = '0' then
                    vAluSrc := cALUSrcImmGen;
				else
					null;
				end if;

            when cOpILoad | cOpSType =>
                NxR.aluOp       <= ALUOpAdd;
                vAluSrc         := cALUSrcImmGen;

            when cOpJType =>
                NxR.aluOp       <= ALUOpNOP;
                NxR.jumpToAdr   <= cJump;

            when cOpIJumpReg =>
                NxR.aluOp       <= ALUOpAdd;
                vAluSrc         := cALUSrcImmGen;
                NxR.jumpToAdr   <= cJump;

            when cOpBType =>
                NxR.ALUOp       <= ALUOpSub;
                vAluSrc         := cALUSrcRegFile;
                NxR.incPC       <= cNoIncPC;

            when others =>
                null; -- not implemented yet

        end case;


    elsif R.ctrlState = Calc then
        case R.curInst(6 downto 0) is   -- check opcode
            -- R-Type or I-Type Register Instruction
            when cOpRType | cOpIArith =>
            	NxR.regWriteEn  <= '1';
                NxR.memToReg    <= cMemToRegALU;
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
            when others =>
                null;
        end case;
        NxR.ctrlState <= WriteReg;

    elsif R.ctrlState = WriteReg then
        NxR.regWriteEn  <= '0';
        NxR.ctrlState <= Fetch;

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
    -- Data Memory
    -------------------------------------------------------------------------------
    avm_d_address       <= std_logic_vector(vAluRes);
    avm_d_byteenable    <= vDataMemByteEnable;
    avm_d_write         <= std_logic(R.memWrite);
    avm_d_writedata     <= std_logic_vector(vRegReadData2);
    avm_d_read          <= std_logic(R.memRead);

    case R.curInst(14 downto 12) is
        when cMemByte               => vDataMemReadData := std_ulogic_vector(resize(signed(
                                        avm_d_readdata(cByte-1 downto 0)), cBitWidth));
                                        vDataMemByteEnable := cEnableByte;

        when cMemHalfWord           => vDataMemReadData := std_ulogic_vector(resize(signed(
                                        avm_d_readdata(2*cByte-1 downto 0)), cBitWidth));
                                        vDataMemByteEnable := cEnableHalfWord;

        when cMemWord               => vDataMemReadData := std_ulogic_vector(resize(signed(
                                        avm_d_readdata(4*cByte-1 downto 0)), cBitWidth));
                                        vDataMemByteEnable := cEnableWord;

        when cMemUnsignedByte       => vDataMemReadData := std_ulogic_vector(resize(unsigned(
                                        avm_d_readdata(cByte-1 downto 0)), cBitWidth));
        when cMemUnsignedHalfWord   => vDataMemReadData := std_ulogic_vector(resize(unsigned(
                                        avm_d_readdata(2*cByte-1 downto 0)), cBitWidth));
    when others =>
        null;
    end case;

    -------------------------------------------------------------------------------
    -- Register File
    -------------------------------------------------------------------------------
    -- read registers
    NxR.regReadData1    <= RegFile(to_integer(unsigned(R.curInst(19 downto 15))));
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
            vAluRes := std_ulogic_vector(resize(
                unsigned(R.regReadData1) + (unsigned(R.aluData2)), cALUWidth));
        when ALUOpSub =>
            vAluRes := std_ulogic_vector(resize(
                unsigned(R.regReadData1) - unsigned(R.aluData2), cALUWidth));
        when ALUOpSLT =>
            if signed(R.regReadData1) < signed(R.aluData2) then
                vAluRes := (0 => '1', others => '0');
            else
                vAluRes := (others => '0');
            end if;
        when ALUOpSLTU =>
            if unsigned(R.regReadData1) < unsigned(R.aluData2) then
                vAluRes := (0 => '1', others => '0');
            else
                vAluRes := (others => '0');
            end if;
        when ALUOpAnd =>
            vAluRes := R.regReadData1 AND R.aluData2;
        when ALUOpOr =>
            vAluRes := R.regReadData1 OR R.aluData2;
        when ALUOpXor =>
            vAluRes := R.regReadData1 XOR R.aluData2;
        when ALUOpSLL =>
            vAluRes := std_ulogic_vector(
                shift_left(unsigned(R.regReadData1),
                to_integer(unsigned(R.aluData2(4 downto 0)))));
        when ALUOpSRL =>
            vAluRes := std_ulogic_vector(
                shift_right(unsigned(R.regReadData1),
                to_integer(unsigned(R.aluData2(4 downto 0)))));
        when ALUOpSRA =>
            vAluRes := std_ulogic_vector(
                shift_right(signed(R.regReadData1),
                to_integer(unsigned(R.aluData2(4 downto 0)))));
        when ALUOpNOP =>
            vAluRes := (others => '0');
        when others =>
            vAluRes := (others => '0');
    end case;

    -- Set Status Register
    if to_integer(unsigned(vAluRes)) = 0 then
        NxR.statusReg(cStatusZeroBit) <= '1';
    else
        NxR.statusReg(cStatusZeroBit) <= '0';
    end if;
    if to_integer(unsigned(vAluRes)) < 0 then
        NxR.statusReg(cStatusNegBit) <= '1';
    else
        NxR.statusReg(cStatusNegBit) <= '0';
    end if;

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
    -- Multiplexer
	-------------------------------------------------------------------------------

    -- MUX ALUSrc
    if vAluSrc = cALUSrcRegFile then
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


end process;

end architecture rtl;
