library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity gestion_bip is
    port (
        clk_i         : in std_logic;
        raz_n_i       : in std_logic;
        btn_AUTO_i    : in std_logic_vector(1 downto 0); 
        btn_Babord_i  : in std_logic_vector(1 downto 0); 
        btn_Tribord_i : in std_logic_vector(1 downto 0); 
		en_i		  : in std_logic;

        temps_choix_o : out std_logic;
        bip_o         : out std_logic
    );
end entity;



architecture rtl of gestion_bip is
    signal activation_bip      : std_logic;
    signal attente_bip         : std_logic;
	signal ONE_sec             : std_logic_vector(25 downto 0);
	signal ZERO_FIVE_sec       : std_logic_vector(20 downto 0);
    signal rst_1_sec           : std_logic;
    signal rst_05_sec          : std_logic;    -- reset synchrone
    signal RE_rst_1_sec        : std_logic;
    signal RE_rst_05_sec       : std_logic;

    signal raz                 : std_logic;
    signal temp_choix_btn      : std_logic := '0';

begin

    raz <= not (raz_n_i);

    counter_bip_inst : entity work.counter
    generic map (
        N => 26 -- on veux compter jusqu'a 1s (--> 50 000 000 coups d'horloge) donc on a besoin de 26 bits
    )
    port map (
        clk_i   => clk_i,
        arst_i  => raz,
        srst_i  => rst_1_sec,
        en_i    => activation_bip,
        qn_o    => ONE_sec
    );

    counter_attente_bip_inst : entity work.counter
    generic map (
        N => 21 -- on veux compter jusqu'a 0.5s (--> 25 000 000 coups d'horloge) donc on a besoin de 21 bits
    )
    port map (
        clk_i   => clk_i,
        arst_i  => raz,
        srst_i  => rst_05_sec,
        en_i    => attente_bip,
        qn_o    => ZERO_FIVE_sec
    );

    edge_detector_1_sec_inst : entity work.edge_detector
    port map (
        clk_i   => clk_i,
        en_i    => '1',
        E_i     => rst_1_sec,
        re_o    => RE_rst_1_sec,
        fe_o    => open
    );

    edge_detector_05_sec_inst : entity work.edge_detector
    port map (
        clk_i   => clk_i,
        en_i    => '1',
        E_i     => rst_05_sec,
        re_o    => RE_rst_05_sec,
        fe_o    => open
    );

    process(btn_AUTO_i, btn_Babord_i, btn_Tribord_i, RE_rst_05_sec, RE_rst_1_sec, raz)
    begin 
        if(raz = '1') then 
            activation_bip <= '0';
		elsif(en_i = '1') then
			if(btn_AUTO_i = "01" or btn_AUTO_i = "10" or btn_Babord_i = "01" or btn_Tribord_i = "01") then
				activation_bip <= '1'; 
			end if;        
			if(btn_Babord_i = "10" or btn_Tribord_i = "10") then
				activation_bip <= '1';
				temp_choix_btn <= '1';
			end if; 
			if(RE_rst_1_sec = '1') then
				activation_bip <= '0'; 
				if (temp_choix_btn = '1') then
					attente_bip <= '1';
				end if;
			end if;

			if(RE_rst_05_sec = '1') then
				attente_bip <= '0';
				activation_bip <= '1'; 
				temp_choix_btn <= '0';
			end if;
		end if;
    end process;

    rst_1_sec <= '1' when unsigned(ONE_sec) >= 49999999/100 else '0'; -- sur 26 bits, on veux s'arrêter à 1s soit à 50 000 000 - 1 = 49 999 999 (-1 car on commence à compter à 0) 
    rst_05_sec <= '1' when unsigned(ZERO_FIVE_sec) >= 24999999/100 else '0'; -- sur 21 bits,on veux s'arrêter à 1s soit à 25 000 000 - 1 = 24 999 999 (-1 car on commence à compter à 0) 
        
    bip_o <= activation_bip;
    temps_choix_o <= temp_choix_btn;

end architecture;