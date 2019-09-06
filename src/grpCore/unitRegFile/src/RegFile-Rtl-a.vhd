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
    
    type aRegFile is array (0 to cRegCount - 1) of aRegValue;

    -- register File storage
    signal regFile : aRegFile := (others => (others => '0'));

    -- program counter
    signal progCnt : aRegValue := (others => '0');

begin
    



oPC <= progCnt;
    
end architecture rtl;