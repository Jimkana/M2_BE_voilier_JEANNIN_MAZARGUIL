library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity basculeD is
    port (
        clk_i   : in std_logic;
        en_i    : in std_logic;
        E_i     : in std_logic;
        srst_i  : in std_logic;

        S_o     : out std_logic
    );
end entity;

architecture rtl of basculeD is
    
begin
    
    process(clk_i)
    begin
        if(rising_edge(clk_i)) then
            if(srst_i = '1') then
                S_o <= '0';
            elsif(en_i = '1') then
                S_o <= E_i;
            end if;
        end if;
    end process;    
    
end architecture rtl;