library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity gestion_leds is
    port (
        clk_i           : in std_logic;
        raz_n_i         : in std_logic; 
        btn_babord_i    : in std_logic;
        btn_tribord_i   : in std_logic;
		mode_leds_i		: in std_logic;
        appui_btn_babord : in std_logic_vector(1 downto 0);
        appui_btn_tribord : in std_logic_vector(1 downto 0);
        code_fonction : in std_logic_vector(3 downto 0);
        
        ledBabord_o     : out std_logic;
        ledTribord_o    : out std_logic;
        ledSTBY_o       : out std_logic
    );
end entity;


architecture rtl of gestion_leds is
    signal led              : std_logic;
	signal rst_1_sec        : std_logic;
    signal rst_05_sec       : std_logic;
	signal ONE_sec          : std_logic_vector (25 downto 0);
	signal ZERO_FIVE_sec    : std_logic_vector(20 downto 0);
	signal allume_led_stby  : std_logic := '1';
	signal eteind_led_stby  : std_logic := '0';
    signal raz              : std_logic;
    signal RE_rst_1_sec     : std_logic;
    signal RE_rst_05_sec    : std_logic;
begin
    
    raz <= not (raz_n_i);

	gestion_led_mode_auto_inst : entity work.gestion_bip
    port map (
        clk_i         => clk_i,
        raz_n_i       => raz_n_i,
        btn_AUTO_i    => "00", 
        btn_Babord_i  => appui_btn_babord, 
        btn_Tribord_i => appui_btn_tribord, 
		en_i		  => mode_leds_i,

        bip_o		  => led
    );
	 
	counter_allume_led_stby_inst : entity work.counter
    generic map (
        N => 26 -- on veux compter jusqu'a 1s (--> 50 000 000 coups d'horloge) donc on a besoin de 26 bits
    )
    port map (
        clk_i   => clk_i,
        arst_i  => raz,
        srst_i  => rst_1_sec,
        en_i    => allume_led_stby,
        qn_o    => ONE_sec
    );
	 
	counter_eteindre_led_stby_inst : entity work.counter
    generic map (
        N => 21 -- on veux compter jusqu'a 0.5s (--> 25 000 000 coups d'horloge) donc on a besoin de 21 bits
    )
    port map (
        clk_i   => clk_i,
        arst_i  => raz,
        srst_i  => rst_05_sec,
        en_i    => eteind_led_stby,
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
	 
    -- led STBY clignotante + leds babord et tribord faiblement éclairées : mode veille
    -- led STBY allumée : mode auto
    -- leds allumées (babord ou tribord) lors de l'appui sur le bouton correspondant
    process (clk_i, btn_babord_i, btn_tribord_i, RE_rst_1_sec, RE_rst_05_sec, led, code_fonction)
    begin
		if(mode_leds_i = '0') then --mode veille
			if(btn_babord_i = '1') then
				ledBabord_o <= '1';
			elsif(btn_tribord_i = '1') then
				ledTribord_o <= '1';
			end if;
			if(btn_babord_i = '0') then 
				ledBabord_o <= '0';
            end if;
			if(btn_tribord_i = '0') then 
				ledTribord_o <= '0';
			end if;

			-- gerer clignotement leds stby
			if(RE_rst_1_sec = '1') then
				allume_led_stby <= '0'; 
				eteind_led_stby <= '1';
			end if;

			if(RE_rst_05_sec = '1') then
				allume_led_stby <= '1'; 
				eteind_led_stby <= '0';
			end if;

            if(allume_led_stby = '1') then
                ledSTBY_o <= '1';
            else 
                ledSTBY_o <= '0';
            end if;
		else
			ledSTBY_o <= '1';
			if(code_fonction = "0111" or code_fonction = "0110") then
				ledBabord_o <= led;
                ledTribord_o <= '0';
			elsif(code_fonction = "0100" or code_fonction = "0101") then 
				ledTribord_o <= led;
                ledBabord_o <= '0';
            else 
                ledBabord_o <= '0';
                ledTribord_o <= '0';
			end if;
		end if;
    end process;
	 
	rst_1_sec <= '1' when unsigned(ONE_sec) >= 49999999/100 else '0'; -- sur 26 bits, on veux s'arrêter à 1s soit à 50 000 000 - 1 = 49 999 999 (-1 car on commence à compter à 0) 
    rst_05_sec <= '1' when unsigned(ZERO_FIVE_sec) >= 24999999/100 else '0'; -- sur 21 bits,on veux s'arrêter à 1s soit à 25 000 000 - 1 = 24 999 999 (-1 car on commence à compter à 0) 
    
end architecture rtl;