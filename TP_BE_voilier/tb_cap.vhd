library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_cap is
end entity tb_cap;

architecture rtl of tb_cap is
    signal clk_i 			: std_logic := '0';
    signal arst_i 		: std_logic := '0';
    signal pwm_i 			: std_logic := '0';
    signal continu_i 	: std_logic := '0';
    signal start_stop_i : std_logic := '0';
begin

    clk_i <= not clk_i after 10 ns;

    --UUT
    Conversion_Adaptation_inst : entity work.Conversion_Adaptation
    port map (
        clk_50M_i           => clk_i,
        raz_n_i             => arst_i,
        in_pwm_compas_i     => pwm_i,
        continu_i           => continu_i,
        start_stop_i        => start_stop_i,
        data_valid_o        => open,
        out_1s_o            => open,
        data_compas_o	    => open
    );


    --stimulus
    process 
    begin
        arst_i <= '0'; wait for 10ms;
        arst_i <= '1'; continu_i <= '1'; start_stop_i <= '0';
        pwm_i <= '1'; wait for 1 ms;
        pwm_i <= '0'; wait for 65 ms;
        pwm_i <= '1'; wait for 10 ms;
        pwm_i <= '0'; wait for 65 ms;
        pwm_i <= '1'; wait for 19 ms;
        pwm_i <= '0'; wait for 65 ms;
        pwm_i <= '1'; wait for 28 ms;
        pwm_i <= '0'; wait for 65 ms;
        continu_i <= '0'; 

        pwm_i <= '1'; wait for 1 ms;
        pwm_i <= '0'; wait for 65 ms;
        pwm_i <= '1'; wait for 10 ms;
        pwm_i <= '0'; wait for 65 ms;
        start_stop_i <= '1';
        pwm_i <= '1'; wait for 19 ms;
        pwm_i <= '0'; wait for 65 ms;
        pwm_i <= '1'; wait for 28 ms;
        pwm_i <= '0'; wait for 65 ms;
        
        pwm_i <= '1'; wait for 1 ms;
        pwm_i <= '0'; wait for 65 ms;
        pwm_i <= '1'; wait for 10 ms;
        pwm_i <= '0'; wait for 65 ms;

        start_stop_i <= '0';
        pwm_i <= '1'; wait for 28 ms;
        pwm_i <= '0'; wait for 65 ms;
        pwm_i <= '1'; wait for 19 ms;
        pwm_i <= '0'; wait for 65 ms;

        continu_i <= '1'; start_stop_i <= '1';
        pwm_i <= '1'; wait for 1 ms;
        pwm_i <= '0'; wait for 65 ms;
        pwm_i <= '1'; wait for 10 ms;
        pwm_i <= '0'; wait for 65 ms;
        pwm_i <= '1'; wait for 19 ms;
        pwm_i <= '0'; wait for 65 ms;
        pwm_i <= '1'; wait for 28 ms;
        pwm_i <= '0'; wait for 65 ms;
        wait;
        
    end process;

end architecture;