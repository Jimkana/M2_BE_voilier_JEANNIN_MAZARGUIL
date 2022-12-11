library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity avalon_pwm is
    port (
        arst_i : in std_logic;
        clk_i : in std_logic;
        address_i : in std_logic_vector(0 downto 0);
        write_data_i : in std_logic_vector(31 downto 0);
        write_i : in std_logic;
        read_data_o : out std_logic_vector(31 downto 0);
        q_o : out std_logic
    );
end entity avalon_pwm;

architecture rtl of avalon_pwm is
    component pwm
        port (
        arst_i : in std_logic;
        clk_i : in std_logic;
        duty_i : in std_logic_vector(31 downto 0);
        freq_i : in std_logic_vector(31 downto 0);
        q_o : out std_logic
      );
    end component;
    signal duty, freq : std_logic_vector(31 downto 0);
begin
    
    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            duty <= (others => '0');
            freq <= (others => '1');
        elsif rising_edge(clk_i) then
            if write_i = '1' then
                case to_integer(unsigned(address_i)) is
                    when 16#00# =>
                        duty <= write_data_i;
                    when 16#01# =>
                        freq <= write_data_i;
                    when others =>
                end case;
            end if;
        end if;
    end process;

    read_data_o <= 
        duty when unsigned(address_i) = 16#00# else
        freq;

-- Instanciation du composant pwm
    u_pwm : component pwm
        port map (
            arst_i => arst_i,
            clk_i => clk_i,
            duty_i => duty,
            freq_i => freq,
            q_o => q_o
        );

end architecture rtl;