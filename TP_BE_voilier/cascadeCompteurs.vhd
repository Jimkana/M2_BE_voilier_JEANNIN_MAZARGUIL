library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cascadeCompteurs is
    port(
        clk_i : in std_logic;
        arst_i : in std_logic;
        pwm_i : in std_logic;
        
        temps_ms_o : out std_logic_vector(15 downto 0)
    );
end entity cascadeCompteurs;

architecture rtl of cascadeCompteurs is
    signal usec : std_logic_vector(5 downto 0);
    signal rst_comp : std_logic;
    signal not_pwm : std_logic := not(pwm_i);
begin
    not_pwm <= not(pwm_i);
        --UUT
    counter_inst_cascade : entity work.counter
    -- compte le temps à l'état haut de la PWM
    generic map (
        N => 16 -- max 36 990µs 
    )
    port map (
        clk_i => clk_i,
        arst_i => arst_i,
        srst_i => not_pwm,
        en_i => rst_comp,
        qn_o => temps_ms_o
    );

    counter_inst_horloge : entity work.counter
    -- génération d'une horloge qui a une période de 1 µs
    generic map (
        N => 6 -- on veux compter jusqu'a 1µs (--> 50 coups d'horloge) donc on a besoin de 6 bits
    )
    port map (
        clk_i => clk_i,
        arst_i => arst_i,
        srst_i => rst_comp,
        en_i => '1',
        qn_o => usec
    ); 

	rst_comp <= '1' when unsigned(usec) = 49 else '0'; -- sur 6 bit = 64 or on veux s'arrêter à 1µs soit à 50 - 1 = 49 (-1 car on commence à compter à 0)  

    end architecture rtl;