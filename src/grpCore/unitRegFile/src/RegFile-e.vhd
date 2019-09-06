-------------------------------------------------------------------------------
-- Title      : RISC-V 32-Bit Register File
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : RegFile-e.vhd
-- Author	  : Binder Alexander
-- Date		  : 06.09.2019
-- Revisions  : V1, 06.09.2019 -ba
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.RISCV.all;

entity RegFile is
    port (
        iClk                : in  std_ulogic;
        iWE1, iWEPC         : in  std_ulogic;
        iWD1, iWDPC         : in  aRegValue;
        iRS1, iRS2, iRD1    : in  aRegAdr;
        oRD1, oRD2 , oPC    : out aRegValue;
    );
end entity RegFile;