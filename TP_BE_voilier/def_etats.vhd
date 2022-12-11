library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity def_etats is
    port (
        clk_i   : in std_logic;
        arst_i  : in std_logic;
        continu_i : in std_logic;
        start_stop_i : in std_logic;

        data_valid_o : out std_logic;
        acquisition_o : out std_logic       
    );
end entity;


architecture rtl of def_etats is
    type state_t is (st_continu, st_start_aq, st_acquisition, st_stop_aq);  -- définition des états
    signal current_st, next_st : state_t;
    --signal acquisition_1fois : std_logic := '1';
begin
    -- Decodage de l'etat suivant 
    process(current_st, continu_i, start_stop_i)
    begin
        case current_st is
            when st_continu => 
                if (continu_i = '0' and start_stop_i = '0') then
                    next_st <= st_stop_aq;
                elsif (continu_i = '0' and start_stop_i = '1') then
                    next_st <= st_acquisition;
                end if;
            when st_start_aq =>
                if (start_stop_i = '0') then
                    next_st <= st_stop_aq;
                elsif (continu_i = '1') then
                    next_st <= st_continu;
                end if;
            when st_acquisition =>
                next_st <= st_start_aq;
            when st_stop_aq => 
                if (start_stop_i = '1') then
                    next_st <= st_acquisition;
                elsif (continu_i = '1') then
                    next_st <= st_continu;
                end if;
            when others => 
                next_st <= st_continu;
        end case;
    end process;

    -- Mise à jour de l'état suivant 
    process(clk_i, arst_i)
    begin
        if (arst_i = '1') then
            current_st <= st_continu;
        elsif (rising_edge(clk_i)) then
            current_st <= next_st;
        end if;
    end process;
    
    -- Calcul des sorties en fonction de l'état présent
    acquisition_o <= '1' when current_st = st_continu
            else '1' when current_st = st_acquisition
            --else '1' when (current_st = st_start_aq and acquisition_1fois = '1')
            else '0';
    
    --acquisition_1fois <= '0' when current_st = st_start_aq
            --else '1';

    data_valid_o <= '0' when current_st = st_stop_aq
            else '0' when arst_i = '1'
            else '1' when current_st = st_acquisition
            else '1' when current_st = st_continu
            else '1' when current_st = st_start_aq
            else '0';
    
end architecture rtl;