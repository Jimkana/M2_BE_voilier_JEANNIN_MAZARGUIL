library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_f7 is
end entity tb_f7;

architecture rtl of tb_f7 is
    signal clk          : std_logic := '0';
    signal raz          : std_logic := '0';
    signal btn_AUTO     : std_logic := '0';
    signal btn_Babord   : std_logic := '0';
    signal btn_Tribord  : std_logic := '0';

begin

    clk <= not clk after 10 ns;

    gestion_barre_inst : entity work.gestion_barre
    port map (
        clk_50M_i       => clk,
        raz_n_i         => raz,
        BP_STBY_i       => btn_AUTO,
        BP_Babord_i     => btn_Babord,
        BP_Tribord_i    => btn_Tribord,
        codeFonction_o  => open,
        ledBabord_o     => open,
        ledTribord_o    => open,
        ledSTBY_o       => open,
        out_bip_o       => open
    );

  
  

    --stimulus
    process 
    begin
        raz <= '0'; wait for 1 ms;
        raz <= '1'; wait for 1 ms;
        btn_Babord <= '1'; wait for 50 ms;
        btn_Babord <= '0'; wait for 10 ms;
        btn_Tribord <= '1'; wait for 50 ms;
        btn_Tribord <= '0'; wait for 50 ms;
        btn_AUTO <= '1'; wait for 10 ms;
        btn_AUTO <= '0'; wait for 10 ms;
        btn_Babord <= '1'; wait for 50 ms;
        btn_Babord <= '0'; wait for 20 ms;
        btn_Tribord <= '1'; wait for 10 ms;
        btn_Tribord <= '0'; wait;

    end process;

end architecture;