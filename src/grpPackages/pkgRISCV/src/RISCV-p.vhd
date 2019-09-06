-------------------------------------------------------------------------------
-- Title      : RISC-V Project Package
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : RegFile-Rtl-a.vhd
-- Author	    : Binder Alexander
-- Date		    : 06.09.2019
-- Revisions  : V1, 06.09.2019 -ba
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Global.all;

package RISCV is

-------------------------------------------------------------------------------
-- RegFile
-------------------------------------------------------------------------------
  constant cRegWidth    : natural : 32;
  constant cRegCount    : natural : 32;
  constant cRegAdrWidth : natural : LogDualis(cRegCount);

  subtype aRegValue   is std_ulogic_vector(cRegWidth - 1 downto 0);
  subtype aRegAdr     is std_ulogic_vector(cRegAdrWidth - 1 downto 0);

end RISCV;

