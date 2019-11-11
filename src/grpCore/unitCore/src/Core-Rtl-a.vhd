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
    
Registers: process (iClk, inRstAsync)
begin
    if (inRstAsync = not('1')) then
        R <= cInitValRegSet;
        RegFile <= cInitValRegFile;
    elsif ( (iClk'event) and (iClk = '1') ) then
        R <= NxR;
        RegFile <= NxRegFile;
    end if;
end process;

Comb: process (R, RegFile, iWe, iWd, iRd)
begin
    NxR <= R;
    NxRegFile <= RegFile;

    -------------------------------------------------------------------------------
    -- Register File
    -------------------------------------------------------------------------------
    if (iWe = '1' and iRd /= "00000") then
        NxRegFile(to_integer(unsigned(iRd))) <= iWd;
    end if;

    -------------------------------------------------------------------------------
    -- Immediate Extension
    -------------------------------------------------------------------------------
    case R.curInstr(6 downto 0) is
        -- R-Type
        when "0110011" =>
            NxR.curImm <= (others => '0');
        -- I-Type
        when  "1100111" | "0000011" | "0010011" =>
            NxR.curImm(10 downto 0) <= R.curInstr(30 downto 20);
            NxR.curImm(cImmLen - 1 downto 11) <= (others => R.curInstr(31));
        -- S-Type
        when "0100011" =>
            NxR.curImm(10 downto 0) <= R.curInstr(30 downto 25) & R.curInstr(4 downto 0);
            NxR.curImm(cImmLen - 1 downto 11) <= (others => R.curInstr(31));
        -- B-Type
        when "1100011" =>
            NxR.curImm(cImmLen - 1 downto 12) <= (others => R.curInstr(31));
            NxR.curImm(11 downto 0) <= R.curInstr(7) & R.curInstr(30 downto 25) & R.curInstr(11 downto 8) & '0';
        -- U-Type
        when "0110111" | "0010111" =>
            NxR.curImm <= R.curInstr(31 downto 12) & "000000000000";
        -- J-Type
        when "1101111" =>
            NxR.curImm(cImmLen - 1 downto 20) <= (others => R.curInstr(31)); 
            NxR.curImm(19 downto 0) <= R.curInstr(19 downto 12) & R.curInstr(20) & R.curInstr(30 downto 21) & '0';
        when others => 
            NxR.curImm <= (others => '0'); -- TODO: handle illegal instruction
    end case;
    
        
end process;

-- asynchronous register read
oRd1 <= RegFile(to_integer(unsigned(iRs1)));
oRd2 <= RegFile(to_integer(unsigned(iRs2)));

end architecture rtl;