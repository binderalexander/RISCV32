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
        inRstAsync          : in  std_ulogic;

        -- register addresses
        iRs1, iRs2, iRd     : in  aRegAdr;
        -- write enable
        iWe                 : in  std_ulogic;
        -- write data
        iWd                 : in  aRegValue;
        -- read data
        oRd1, oRd2          : out aRegValue;
    );
end entity RegFile;