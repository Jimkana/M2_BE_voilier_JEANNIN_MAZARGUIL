library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity registre is
    generic (
        N : integer := 9
    );
    port (
        clk_i   : in std_logic;
        arst_i  : in std_logic;
        en_i    : in std_logic;
        E_i     : in std_logic_vector(N-1 downto 0);

        S_o     : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture rtl of registre is

begin
    process(clk_i, arst_i)
    begin
        if(arst_i = '1') then
            S_o <= (others => '0');
        elsif(rising_edge(clk_i)) then
            if(en_i = '1') then
                S_o <= E_i;
            end if;
        end if;
    end process;        
    
end architecture rtl;