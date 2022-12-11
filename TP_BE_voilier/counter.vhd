library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
    generic (
        N : integer := 7
    );
    port (
        clk_i   : in std_logic;
        arst_i  : in std_logic;
        srst_i  : in std_logic;
        en_i    : in std_logic;

        qn_o    : out std_logic_vector(N-1 downto 0)
    );
end entity counter;



architecture rtl of counter is
    signal qn_temp : unsigned(N-1 downto 0) := (others => '0');

begin
    process(clk_i, arst_i) 
    begin
        if(arst_i = '1') then
            qn_temp <= (others => '0');
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                qn_temp <= (others => '0');
            elsif en_i = '1' then
                qn_temp <= qn_temp + 1;
            end if;
        end if;
    end process;
    qn_o <= std_logic_vector(qn_temp);

end architecture rtl;