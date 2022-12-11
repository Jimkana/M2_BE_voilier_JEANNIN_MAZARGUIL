library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Conversion_Adaptation is
    port (
        clk_50M_i       : in std_logic;
        raz_n_i         : in std_logic;
        in_pwm_compas_i : in std_logic;
        continu_i       : in std_logic;   -- =1 acquisition toutes les secondes / =0 mode start_stop
        start_stop_i    : in std_logic;   -- =1 une acquisition =0 / data_valid = 0

        data_valid_o    : out std_logic;  -- =1 mesure valide / =0 sinon
        out_1s_o        : out std_logic;
        data_compas_o 	: out std_logic_vector (8 downto 0)
    );
end entity Conversion_Adaptation;

architecture rtl of Conversion_Adaptation is   
    signal temps_ms              : std_logic_vector(15 downto 0);
    signal degres                : std_logic_vector(8 downto 0);
    signal fe                    : std_logic;
    signal pwm_sync              : std_logic;
    signal refresh_1sec          : std_logic;
	 signal sec                   : std_logic_vector(25 downto 0);
    signal degres_stable_periode : std_logic_vector (8 downto 0);
    signal degres_stable_1s      : std_logic_vector (8 downto 0);
    signal dem_acquisition       : std_logic;
	 signal raz 						: std_logic;
begin

	 raz <= not (raz_n_i);
    -- Converti le temps à l'état haut en degrés
    conversion_degres_inst : entity work.conversion_degres
    port map (
        temps_ms_i  => temps_ms,
        degres_o    => degres
    );

    -- bascule qui permet d'avoir le signal de la PWM stable
    basculeD_inst : entity work.basculeD
    port map (
        clk_i   => clk_50M_i,
        en_i    => '1',
        E_i     => in_pwm_compas_i,
        srst_i  => '0',
        S_o     => pwm_sync
    );

    -- Compte le temps à l'état haut de la PWM
    cascadeCompteurs_inst : entity work.cascadeCompteurs
    port map (
        clk_i       => clk_50M_i,
        arst_i      => raz,
        pwm_i       => pwm_sync,
        temps_ms_o  => temps_ms
    );

    -- Détecte le front descendant de la PWM pour enregistrer le signal
    edge_detector_inst : entity work.edge_detector
    port map (
        clk_i   => clk_50M_i,
        en_i    => '1',
        E_i     => pwm_sync,
        re_o    => open,
        fe_o    => fe
    );

    -- Enregistre les degrés à la fin de chaque période de la PWM
    registre_inst : entity work.registre
    generic map (
        N => 9 
    )
    port map (
        clk_i   => clk_50M_i,
        arst_i  => raz,
        en_i    => fe,
        E_i     => degres,
        S_o     => degres_stable_periode
    );

    -- Compteur d'une seconde pour l'actualisation en mode continu
    counter_seconde_inst : entity work.counter
    -- génération d'une horloge qui a une période de 1 s
    generic map (
        N => 26 -- on veux compter jusqu'a 1s (--> 50 000 000 coups d'horloge) donc on a besoin de 26 bits
    )
    port map (
        clk_i   => clk_50M_i,
        arst_i  => raz,
        srst_i  => refresh_1sec,
        en_i    => '1',
        qn_o    => sec
    );

    -- Actualise la valeur de degrés toutes les secondes
    registre2_inst : entity work.registre
    generic map (
        N => 9 
    )
    port map (
        clk_i   => clk_50M_i,
        arst_i  => raz,
        en_i    => refresh_1sec,
        E_i     => degres_stable_periode,
        S_o     => degres_stable_1s
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
        N => 9 
    )
    port map (
        clk_i   => clk_50M_i,
        arst_i  => raz,
        en_i    => dem_acquisition,
        E_i     => degres_stable_1s,
        S_o     => data_compas_o
    );

    refresh_1sec <= '1' when unsigned(sec) >= 49999999/10 else '0'; -- sur 26 bits = 64 or on veux s'arrêter à 1s soit à 50 000 000 - 1 = 49 999 999 (-1 car on commence à compter à 0) 

    out_1s_o <= refresh_1sec;

end architecture;