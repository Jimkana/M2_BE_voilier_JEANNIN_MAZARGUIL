library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Machine_etat is
    port (
        clk_i                   : in std_logic;
        raz_i                   : in std_logic;
        btn_babord_i            : in std_logic;
        btn_tribord_i           : in std_logic;
        appui_btn_auto_i        : in std_logic_vector(1 downto 0);
        appui_btn_babord_i      : in std_logic_vector(1 downto 0);
        appui_btn_tribord_i     : in std_logic_vector(1 downto 0);
        temps_choix_btn_bip_i   : in std_logic;
        activation_bip_i        : in std_logic;

		  mode_leds_o			     : out std_logic; -- 1 pour le mode auto et 0 pour le mode veille
        codeFonction_o          : out std_logic_vector (3 downto 0)
    );
end entity;


architecture rtl of Machine_etat is
    type state_t is (st_STBY, st_AUTO, st_STBY_babord, st_STBY_tribord, st_AUTO_babord_1, st_AUTO_tribord_1, st_AUTO_babord_10, st_AUTO_tribord_10);  -- définition des états
    signal current_st, next_st : state_t := st_STBY;
begin
    -- Decodage de l'etat suivant 
    process(current_st, appui_btn_auto_i, appui_btn_babord_i, appui_btn_tribord_i, temps_choix_btn_bip_i, activation_bip_i, btn_babord_i, btn_tribord_i)
    begin
        case current_st is
            when st_STBY =>                         
                if(appui_btn_auto_i = "01" and activation_bip_i = '0') then
                    next_st <= st_AUTO;
                elsif(btn_babord_i = '1') then
                    next_st <= st_STBY_babord;
                elsif(btn_tribord_i = '1') then
                    next_st <= st_STBY_tribord;
                end if;
            when st_AUTO =>                         
                if (appui_btn_auto_i = "01" and activation_bip_i = '0') then
                    next_st <= st_STBY;
                elsif(appui_btn_auto_i = "10") then
                    next_st <= st_AUTO;
                elsif(appui_btn_babord_i = "01") then
                    next_st <= st_AUTO_babord_1;
                elsif(appui_btn_tribord_i = "01") then
                    next_st <= st_AUTO_tribord_1;
                elsif(appui_btn_babord_i = "10") then
                    next_st <= st_AUTO_babord_10;
                elsif(appui_btn_tribord_i = "10") then
                    next_st <= st_AUTO_tribord_10;
                end if; 
            when st_STBY_babord =>                 
                if(btn_babord_i = '0') then
                    next_st <= st_STBY;
				end if;
            when st_STBY_tribord =>
                if(btn_tribord_i = '0') then
                    next_st <= st_STBY;
				end if;
            when st_AUTO_babord_1 =>
                if(appui_btn_babord_i = "00" and activation_bip_i = '0' and temps_choix_btn_bip_i = '0') then
                    next_st <= st_AUTO;
				end if;
            when st_AUTO_tribord_1 =>
                if(appui_btn_tribord_i = "00" and activation_bip_i = '0' and temps_choix_btn_bip_i = '0') then
                    next_st <= st_AUTO;
			    end if;
            when st_AUTO_babord_10 =>
                if(appui_btn_babord_i = "00" and activation_bip_i = '0' and temps_choix_btn_bip_i = '0') then
                    next_st <= st_AUTO;
				end if;
            when st_AUTO_tribord_10 =>
                if(appui_btn_tribord_i = "00" and activation_bip_i = '0' and temps_choix_btn_bip_i = '0') then
                    next_st <= st_AUTO;
				end if;
            when others => 
                next_st <= st_STBY;
        end case;
    end process;

    -- Mise à jour de l'état suivant 
    process(clk_i, raz_i)
    begin
        if (raz_i = '0') then
            current_st <= st_STBY;
        elsif (rising_edge(clk_i)) then
            current_st <= next_st;
        end if;
    end process;
    
    -- Calcul des sorties en fonction de l'état présent
	 mode_leds_o <= '1' when current_st = st_AUTO
				  else '1' when current_st = st_AUTO_babord_1
				  else '1' when current_st = st_AUTO_babord_10
				  else '1' when current_st = st_AUTO_tribord_1
				  else '1' when current_st = st_AUTO_tribord_10
				  else '0' when current_st = st_STBY
				  else '0' when current_st = st_STBY_babord
				  else '0' when current_st = st_STBY_tribord;
				  
    codeFonction_o <= "0000" when current_st = st_STBY 
                 else "0011" when current_st = st_AUTO
                 else "0001" when current_st = st_STBY_babord
                 else "0010" when current_st = st_STBY_tribord
                 else "0111" when current_st = st_AUTO_babord_1
                 else "0100" when current_st = st_AUTO_tribord_1
                 else "0110" when current_st = st_AUTO_babord_10
                 else "0101" when current_st = st_AUTO_tribord_10;
    
end architecture rtl;