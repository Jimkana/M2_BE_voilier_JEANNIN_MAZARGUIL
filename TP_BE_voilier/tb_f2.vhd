library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_f2 is
end entity tb_f2;

architecture rtl of tb_f2 is
    signal clk_i 			: std_logic := '0';
    signal arst_i 		: std_logic := '0';
    signal freq 			: std_logic := '0';
    signal continu_i 	: std_logic := '0';
    signal start_stop_i : std_logic := '0';
begin

    clk_i <= not clk_i after 10 ns;
	 freq <= not freq after 100 ns;

    --UUT
    ConversionVitesseVent_inst : entity work.ConversionVitesseVent
    port map (
        clk_50M_i				=> clk_i,
        raz_n_i				=> arst_i,
        in_freq_anemometre_i => freq,
		  continu_i 			=> continu_i,
		  start_stop_i 		=> start_stop_i,
        
		  data_valid_o 		=> open,
        data_anemometre_o 	=> open
    );


    --stimulus
    process 
    begin
        arst_i <= '0'; wait for 10ms;
        arst_i <= '1'; continu_i <= '1'; start_stop_i <= '0';
        wait for 100 ms;
        continu_i <= '0'; 

		  wait for 100 ms;
        start_stop_i <= '1';
        wait for 100 ms;

        start_stop_i <= '0';
        wait for 100ms;

        continu_i <= '1'; start_stop_i <= '1';
        
        wait;
        
    end process;

end architecture;