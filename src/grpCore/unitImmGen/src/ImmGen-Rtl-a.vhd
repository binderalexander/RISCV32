-------------------------------------------------------------------------------
-- Title      : RISC-V 32-Bit Immediate Extender
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : ImmGen-Rtl-a.vhd
-- Author	  : Binder Alexander
-- Date		  : 01.10.2019
-- Revisions  : V1, 01.10.2019 -ba
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------

architecture rtl of ImmGen is

    signal R, NxR : aImm;
    constant cInitValR: aImm := (others => '0');
    
begin
    
Registers: process (iClk, inRstAsync)
begin
    if (inRstAsync = not('1')) then
        R <= cInitValR;
    elsif ( (iClk'event) and (iClk = '1') ) then
        R <= NxR;
    end if;
end process;

Comb: process (R, iInst)
begin
    NxR <= R;

    -- check opcode
    case iInst(6 downto 0) is
        -- R-Type
        when "0110011" =>
            NxR <= (others => '0');
        -- I-Type
        when  "1100111" | "0000011" | "0010011" =>
            NxR(10 downto 0) <= iInst(30 downto 20);
            NxR(cImmLen - 1 downto 11) <= (others => iInst(31));
        -- S-Type
        when "0100011" =>
            NxR(10 downto 0) <= iInst(30 downto 25) & iInst(4 downto 0);
            NxR(cImmLen - 1 downto 11) <= (others => iInst(31));
        -- B-Type
        when "1100011" =>
            NxR(11 downto 0) <= iInst(7) & iInst(30 downto 25) & iInst(11 downto 8) & '0';
            NxR(cImmLen - 1 downto 12) <= (others => iInst(31));
        -- U-Type
        when "0110111" | "0010111" =>
            NxR <= iInst(31 downto 12) & "000000000000";
        -- J-Type
        when "1101111" =>
            NxR(19 downto 0) <= iInst(19 downto 12) & iInst(20) & iInst(30 downto 21) & '0';
            NxR(cImmLen - 1 downto 20) <= (others => iInst(31)); 
        when others => 
            NxR <= (others => 'X'); -- TODO: handle illegal instruction
            
    end case;
    
end process;

-- output current immediate
oImm <= R;
    
end architecture rtl;