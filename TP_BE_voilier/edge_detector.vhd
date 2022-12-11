library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity edge_detector is
    port (
        clk_i   : in std_logic;
        en_i    : in std_logic;
        E_i     : in std_logic;

        re_o    : out std_logic;
        fe_o    : out std_logic        
    );
end entity;

architecture rtl of edge_detector is
	signal s : std_logic;
begin

    basculeD_inst : entity work.basculeD
    port map (
        clk_i => clk_i,
        en_i => en_i,
        E_i => E_i,
        srst_i => '0',
        S_o => s
    );

    process(clk_i, E_i, s)
    begin
        if(E_i = '1' and s = '0') then
            re_o <= '1';
            fe_o <= '0';
        elsif (E_i = '0' and s = '1') then
            fe_o <= '1';
            re_o <= '0';
        else
            fe_o <= '0';
            re_o <= '0';
        end if;
    end process;

end architecture;