library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity gestion_barre is
    port (
        clk_50M_i         : in std_logic;
        raz_n_i           : in std_logic;
        BP_STBY_i         : in std_logic;
        BP_Babord_i       : in std_logic;
        BP_Tribord_i      : in std_logic;
        
        codeFonction_o    : out std_logic_vector (3 downto 0);
        ledBabord_o       : out std_logic;
        ledTribord_o      : out std_logic;
        ledSTBY_o         : out std_logic;
        out_bip_o         : out std_logic
    );
end entity;

architecture rtl of gestion_barre is
    signal appui_btn_auto       : std_logic_vector (1 downto 0);
    signal appui_btn_babord     : std_logic_vector (1 downto 0);
    signal appui_btn_tribord    : std_logic_vector (1 downto 0);
	 signal mode_leds				  : std_logic;
    signal code_fonction        : std_logic_vector(3 downto 0);
    signal bip                  : std_logic;
    signal temps_btn_bip        : std_logic;
begin

    Machine_etat_inst : entity work.Machine_etat
    port map (
        clk_i               => clk_50M_i,
        raz_i               => raz_n_i,
        btn_babord_i        => BP_Babord_i,
        btn_tribord_i       => BP_Tribord_i,
        appui_btn_auto_i    => appui_btn_auto,
        appui_btn_babord_i  => appui_btn_babord,
        appui_btn_tribord_i => appui_btn_tribord,
        temps_choix_btn_bip_i => temps_btn_bip,
        activation_bip_i     => bip, 
		  mode_leds_o		    => mode_leds,
        codeFonction_o      => code_fonction
    );

    gestion_btn_auto_inst : entity work.gestion_temps_appui_bouton
    port map (
        clk_i       => clk_50M_i,
        raz_n_i     => raz_n_i,
        btn_i       => BP_STBY_i,
        appui_btn_o => appui_btn_auto
    );
  
    gestion_btn_babord_inst : entity work.gestion_temps_appui_bouton
    port map (
        clk_i       => clk_50M_i,
        raz_n_i     => raz_n_i,
        btn_i       => BP_Babord_i,
        appui_btn_o => appui_btn_babord
    );

    gestion_btn_tribord_inst : entity work.gestion_temps_appui_bouton
    port map (
        clk_i       => clk_50M_i,
        raz_n_i     => raz_n_i,
        btn_i       => BP_Tribord_i,
        appui_btn_o => appui_btn_tribord
    );
	 
	gestion_bip_inst : entity work.gestion_bip
    port map (
        clk_i       		=> clk_50M_i,
        raz_n_i     		=> raz_n_i,
        btn_AUTO_i		    => appui_btn_auto,
		btn_Babord_i		=> appui_btn_babord,
		btn_Tribord_i	    => appui_btn_tribord,
		en_i				=> '1',
        temps_choix_o       => temps_btn_bip,
		bip_o				=> bip
    );
	 
	gestion_leds_inst : entity work.gestion_leds
    port map (
        clk_i       		=> clk_50M_i,
        raz_n_i     		=> raz_n_i,
        btn_babord_i		=> BP_Babord_i,
		btn_tribord_i	    => BP_Tribord_i,
		mode_leds_i		    => mode_leds,
        appui_btn_babord    => appui_btn_babord,
        appui_btn_tribord   => appui_btn_tribord,
        code_fonction       => code_fonction,
		ledBabord_o		    => ledBabord_o,
		ledTribord_o		=> ledTribord_o,
		ledSTBY_o			=> ledSTBY_o
    );

    codeFonction_o <= code_fonction;
    out_bip_o <= bip;
end architecture;