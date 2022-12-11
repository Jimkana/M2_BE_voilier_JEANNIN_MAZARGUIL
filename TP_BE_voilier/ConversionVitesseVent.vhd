library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ConversionVitesseVent is
    port (
        clk_50M_i 			: in std_logic;
        raz_n_i 				: in std_logic;
        in_freq_anemometre_i : in std_logic;
		  continu_i 			: in std_logic;
		  start_stop_i 		: in std_logic;
        
		  data_valid_o 		: out std_logic;
        data_anemometre_o 	: out std_logic_vector(7 downto 0) --max front montant par sec = 250 --> 8 bits
    );
end entity;

architecture rtl of ConversionVitesseVent is
    signal sec 					: std_logic_vector(25 downto 0);
	 signal raz 					: std_logic;
    signal rst_comp 				: std_logic;
    signal re_freq 				: std_logic;
	 signal dem_acquisition 	: std_logic;
	 signal data_anemometre_1s : std_logic_vector(7 downto 0);
    signal nbr_re_by_sec 		: std_logic_vector(7 downto 0); --max front montant par sec = 250 --> 8 bits
begin

	 raz <= not(raz_n_i);
    --UUT
    inst_cascade : entity work.counter
    -- compte le nombre de fronts montants
    generic map (
        N => 8 -- max 250 fronts montants en 1 seconde 
    )
    port map (
        clk_i => clk_50M_i,
        arst_i => raz,
        srst_i => rst_comp,
        en_i => re_freq,
        qn_o => nbr_re_by_sec
    );

    inst_horloge : entity work.counter
    -- génération d'un signal toutes les secondes
    generic map (
        N => 26 -- on veux compter jusqu'a 1s (--> 50 000 000 coups d'horloge) donc on a besoin de 26 bits
    )
    port map (
        clk_i => clk_50M_i,
        arst_i => raz,
        srst_i => rst_comp,
        en_i => '1',
        qn_o => sec
    );

    inst_edge_detector : entity work.edge_detector
    port map (
        clk_i => clk_50M_i,
        en_i => '1',
        E_i => in_freq_anemometre_i,
        re_o => re_freq,
        fe_o => open
    );

    inst_registre : entity work.registre
    generic map (
        N => 8
    )
    port map (
        clk_i => clk_50M_i,
        arst_i => raz,
        en_i => rst_comp,
        E_i => nbr_re_by_sec,
        S_o => data_anemometre_1s
    );
	 
	 -- Machine à état qui défini dans quel état on se trouve (continu ou start_stop)
    def_etats_inst : entity work.def_etats
    port map (
        clk_i           => clk_50M_i,
        arst_i          => raz,
        continu_i       => continu_i,
        start_stop_i    => start_stop_i,
        data_valid_o    => data_valid_o,
        acquisition_o   => dem_acquisition
    );
	 
	 -- Actualise la valeur finale en fonction du mode de fonctionnement
    registre3_inst : entity work.registre
    generic map (
        N => 8 
    )
    port map (
        clk_i   => clk_50M_i,
        arst_i  => raz,
        en_i    => dem_acquisition,
        E_i     => data_anemometre_1s,
        S_o     => data_anemometre_o
    );
	       
	rst_comp <= '1' when unsigned(sec) >= 49999999/100 else '0'; -- sur 26 bit = 67 108 863 or on veux s'arrêter à 1s soit à 50 000 000 - 1 = 49 999 999 (-1 car on commence à compter à 0)  

end architecture;