	component riscv_simulation is
		port (
			leds_export : out std_logic_vector(7 downto 0)   -- export
		);
	end component riscv_simulation;

	u0 : component riscv_simulation
		port map (
			leds_export => CONNECTED_TO_leds_export  -- leds.export
		);

