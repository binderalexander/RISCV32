-------------------------------------------------------------------------------
-- Title      : RISC-V 32-Bit Immediate Extender
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : ImmGen-e.vhd
-- Author	  : Binder Alexander
-- Date		  : 01.10.2019
-- Revisions  : V1, 01.10.2019 -ba
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISCV.all;

entity ImmGen is
    port (
        iClk            : in  std_ulogic;
        inRstAsync      : in  std_ulogic;

        -- instruction from instruction memory
        iInst           : in  aInstr;
        -- extendend immediate
        oImm            : out aImm
    );
end entity ImmGen;