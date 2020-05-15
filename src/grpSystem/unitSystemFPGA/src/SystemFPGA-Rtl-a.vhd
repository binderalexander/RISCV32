-------------------------------------------------------------------------------
-- Title      : RISC-V 32-Bit System
-- Project    : RISC-V 32-Bit Core
-------------------------------------------------------------------------------
-- File       : SystemFPGA-Rtl-a.vhd
-- Author	  : Binder Alexander
-- Date		  : 20.04.2020
-- Revisions  : V1, 20.04.2020 -ba
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------

architecture rtl of SystemFPGA is
	component riscv_system is
		port (
			clk_clk         : in  std_logic;
			reset_reset_n   : in  std_logic;
			switches_export : in  std_logic_vector(7 downto 0);
			leds_export     : out std_logic_vector(7 downto 0)
			-- debug			: out std_logic_vector(9 downto 0);
			-- debug0			: out std_logic_vector(7 downto 0);
			-- debug1			: out std_logic_vector(7 downto 0);
			-- debug2			: out std_logic_vector(7 downto 0);
			-- debug3			: out std_logic_vector(7 downto 0);
			-- debug4			: out std_logic_vector(7 downto 0);
			-- debug5			: out std_logic_vector(7 downto 0);
			-- debug6			: out std_logic_vector(7 downto 0);
			-- debug7			: out std_logic_vector(7 downto 0)
		);
	end component riscv_system;

	constant scaler 	: integer 		:= 100000;
	signal slow_clk 	: std_logic		:= '0';
	signal sink			: std_logic_vector(7 downto 0);
	signal sink2		: std_logic_vector(9 downto 0);
	signal sink_0		: std_logic_vector(7 downto 0);
	signal sink_1		: std_logic_vector(7 downto 0);
	signal sink_2		: std_logic_vector(7 downto 0);	
	signal sink_3		: std_logic_vector(7 downto 0);
	signal sink_4		: std_logic_vector(7 downto 0);
	signal sink_5		: std_logic_vector(7 downto 0);
	signal sink_6		: std_logic_vector(7 downto 0);	
	signal sink_7		: std_logic_vector(7 downto 0);
			
begin

	scale_clk : process(CLOCK_50) is
	begin
		if rising_edge(CLOCK_50) then
			if SW(5) = '0' then
				LEDR(7 downto 0) <= sink;
			end if;
		end if;
	end process;

	u0 : component riscv_system
		port map (
			clk_clk         => CLOCK_50, --slow_clk,
			reset_reset_n   => SW(9),
			switches_export => SW(7 downto 0),
			leds_export     => sink
			-- debug			=> sink2,
			-- debug0			=> sink_0,
			-- debug1			=> sink_1,
			-- debug2			=> sink_2,
			-- debug3			=> sink_3,
			-- debug4			=> sink_4,
			-- debug5			=> sink_5,
			-- debug6			=> sink_6,
			-- debug7			=> sink_7			
		);

	
end architecture rtl;
