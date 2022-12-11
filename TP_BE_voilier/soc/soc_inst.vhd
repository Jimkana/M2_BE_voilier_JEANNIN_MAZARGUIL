	component soc is
		port (
			bus_avalon_0_conduit_end_export                  : in  std_logic                    := 'X'; -- export
			bus_avalon_f2_0_conduit_end_export               : in  std_logic                    := 'X'; -- export
			bus_avalon_f7_0_conduit_end_bp_stby_i            : in  std_logic                    := 'X'; -- bp_stby_i
			bus_avalon_f7_0_conduit_end_bp_babord_i          : in  std_logic                    := 'X'; -- bp_babord_i
			bus_avalon_f7_0_conduit_end_bp_tribord_i         : in  std_logic                    := 'X'; -- bp_tribord_i
			bus_avalon_f7_0_conduit_end_ledbabord_o          : out std_logic;                           -- ledbabord_o
			bus_avalon_f7_0_conduit_end_ledstby_o            : out std_logic;                           -- ledstby_o
			bus_avalon_f7_0_conduit_end_ledtribord_o         : out std_logic;                           -- ledtribord_o
			bus_avalon_f7_0_conduit_end_writeresponsevalid_n : out std_logic;                           -- writeresponsevalid_n
			buttons_export                                   : in  std_logic                    := 'X'; -- export
			clk_clk                                          : in  std_logic                    := 'X'; -- clk
			leds_export                                      : out std_logic_vector(7 downto 0);        -- export
			reset_reset_n                                    : in  std_logic                    := 'X'  -- reset_n
		);
	end component soc;

	u0 : component soc
		port map (
			bus_avalon_0_conduit_end_export                  => CONNECTED_TO_bus_avalon_0_conduit_end_export,                  --    bus_avalon_0_conduit_end.export
			bus_avalon_f2_0_conduit_end_export               => CONNECTED_TO_bus_avalon_f2_0_conduit_end_export,               -- bus_avalon_f2_0_conduit_end.export
			bus_avalon_f7_0_conduit_end_bp_stby_i            => CONNECTED_TO_bus_avalon_f7_0_conduit_end_bp_stby_i,            -- bus_avalon_f7_0_conduit_end.bp_stby_i
			bus_avalon_f7_0_conduit_end_bp_babord_i          => CONNECTED_TO_bus_avalon_f7_0_conduit_end_bp_babord_i,          --                            .bp_babord_i
			bus_avalon_f7_0_conduit_end_bp_tribord_i         => CONNECTED_TO_bus_avalon_f7_0_conduit_end_bp_tribord_i,         --                            .bp_tribord_i
			bus_avalon_f7_0_conduit_end_ledbabord_o          => CONNECTED_TO_bus_avalon_f7_0_conduit_end_ledbabord_o,          --                            .ledbabord_o
			bus_avalon_f7_0_conduit_end_ledstby_o            => CONNECTED_TO_bus_avalon_f7_0_conduit_end_ledstby_o,            --                            .ledstby_o
			bus_avalon_f7_0_conduit_end_ledtribord_o         => CONNECTED_TO_bus_avalon_f7_0_conduit_end_ledtribord_o,         --                            .ledtribord_o
			bus_avalon_f7_0_conduit_end_writeresponsevalid_n => CONNECTED_TO_bus_avalon_f7_0_conduit_end_writeresponsevalid_n, --                            .writeresponsevalid_n
			buttons_export                                   => CONNECTED_TO_buttons_export,                                   --                     buttons.export
			clk_clk                                          => CONNECTED_TO_clk_clk,                                          --                         clk.clk
			leds_export                                      => CONNECTED_TO_leds_export,                                      --                        leds.export
			reset_reset_n                                    => CONNECTED_TO_reset_reset_n                                     --                       reset.reset_n
		);

