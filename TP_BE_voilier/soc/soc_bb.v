
module soc (
	bus_avalon_0_conduit_end_export,
	bus_avalon_f2_0_conduit_end_export,
	bus_avalon_f7_0_conduit_end_bp_stby_i,
	bus_avalon_f7_0_conduit_end_bp_babord_i,
	bus_avalon_f7_0_conduit_end_bp_tribord_i,
	bus_avalon_f7_0_conduit_end_ledbabord_o,
	bus_avalon_f7_0_conduit_end_ledstby_o,
	bus_avalon_f7_0_conduit_end_ledtribord_o,
	bus_avalon_f7_0_conduit_end_writeresponsevalid_n,
	buttons_export,
	clk_clk,
	leds_export,
	reset_reset_n);	

	input		bus_avalon_0_conduit_end_export;
	input		bus_avalon_f2_0_conduit_end_export;
	input		bus_avalon_f7_0_conduit_end_bp_stby_i;
	input		bus_avalon_f7_0_conduit_end_bp_babord_i;
	input		bus_avalon_f7_0_conduit_end_bp_tribord_i;
	output		bus_avalon_f7_0_conduit_end_ledbabord_o;
	output		bus_avalon_f7_0_conduit_end_ledstby_o;
	output		bus_avalon_f7_0_conduit_end_ledtribord_o;
	output		bus_avalon_f7_0_conduit_end_writeresponsevalid_n;
	input		buttons_export;
	input		clk_clk;
	output	[7:0]	leds_export;
	input		reset_reset_n;
endmodule
