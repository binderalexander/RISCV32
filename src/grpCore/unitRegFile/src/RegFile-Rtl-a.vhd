-------------------------------------------------------------------------------
-- Title      : RISC-V 32-Bit Register File
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : RegFile-Rtl-a.vhd
-- Author     : Binder Alexander
-- Date		  : 06.09.2019
-- Revisions  : V1, 06.09.2019 -ba
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------

architecture rtl of RegFile is

    signal R, NxR : aRegFile;
    constant cInitValR : aRegFile := (others => (others => '0'));

begin
    
Registers: process (iClk, inRstAsync)
begin
    if (inRstAsync = not('1')) then
        R <= cInitValR;
    elsif ( (iClk'event) and (iClk = '1') ) then
        R <= NxR;
    end if;
end process;

Comb: process (R, iWe, iWd, iRd)
begin
    NxR <= R;
    -- write to register
    if (iWe = '1' and iRd /= "00000") then
        NxR(to_integer(unsigned(iRd))) <= iWd;
    end if;
end process;

-- asynchronous register read
oRd1 <= R(to_integer(unsigned(iRs1)));
oRd2 <= R(to_integer(unsigned(iRs2)));

end architecture rtl;