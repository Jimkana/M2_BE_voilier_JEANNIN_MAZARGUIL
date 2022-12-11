library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity gestion_temps_appui_bouton is
    port (
        clk_i    : in std_logic;
        raz_n_i  : in std_logic;
        btn_i    : in std_logic; 

        appui_btn_o : out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of gestion_temps_appui_bouton is
    signal tps_appuis_bt_m      : std_logic_vector(26 downto 0);    --26 nombre de coup d'horloge pendant l'appuie l'appuie sur le bouton 
    signal rst_comp             : std_logic;    -- reset synchrone
    signal fe_btn               : std_logic;    -- font descendant
    signal valid_cpt            : std_logic;    -- si on reste appuyer plus de 134 217 727 coup d'horloge -> le compteur ce remet à zero -> on doit valider qu'on a un appuie long
    signal raz                  : std_logic;    -- reset asynchrone    
    signal tempo_appui_btn      : std_logic_vector(1 downto 0);
begin

    raz <= not(raz_n_i);
    
    counter_inst : entity work.counter
    generic map (
        N => 27 --  on veux compter jusqu'a 2s (--> 100 000 000 coups d'horloge) donc on a besoin de 27 bits
    )
    port map (
        clk_i   => clk_i,
        arst_i  => raz,
        srst_i  => rst_comp,
        en_i    => valid_cpt,   
        qn_o    => tps_appuis_bt_m
    );

    edge_detector_inst : entity work.edge_detector
    port map (
        clk_i => clk_i,
        en_i => '1',
        E_i => btn_i,
        re_o => open,
        fe_o => fe_btn
    );

    process(tps_appuis_bt_m, fe_btn, raz_n_i, clk_i)
    begin
        if (raz_n_i = '0') then
            tempo_appui_btn <= "00";       

		  elsif(rising_edge(clk_i)) then
			  if(tps_appuis_bt_m = "111111111111111111111111111") then -- arrêter de compter 
					valid_cpt <= '0';
			  else 
					valid_cpt <= btn_i;
			  end if;
			  if(fe_btn = '1') then
					if(unsigned(tps_appuis_bt_m) >= 99999999/100) then -- 2sec 
						 tempo_appui_btn <= "10";
					elsif (unsigned(tps_appuis_bt_m) < 99999999/100 and unsigned(tps_appuis_bt_m) /= 0) then 
						 tempo_appui_btn <= "01";
					else
						 tempo_appui_btn <= "00";
					end if;
					rst_comp <= '1';
			  end if;
			  if(tps_appuis_bt_m = "000000000000000000000000000") then
					rst_comp <= '0';
			  end if;
			  if(tempo_appui_btn = "01" or tempo_appui_btn = "10") then
					tempo_appui_btn <= "00";
			  end if;
        end if;
    end process;

    appui_btn_o <= tempo_appui_btn;

end architecture;