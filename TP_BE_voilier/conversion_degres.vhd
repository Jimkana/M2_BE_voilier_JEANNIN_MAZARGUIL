library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Fichier de Marlon 
entity conversion_degres is
   port (        
        temps_ms_i : in std_logic_vector(15 downto 0);
        degres_o : out std_logic_vector(8 downto 0)
   );
end entity conversion_degres;

architecture rtl of conversion_degres is
    signal degre_tmp : unsigned(15 downto 0);
	 signal temps_tmp : unsigned(15 downto 0);

begin
   temps_tmp <= unsigned(temps_ms_i); 
   degre_tmp <= (temps_tmp - 1000) / 100; 
   degres_o <= std_logic_vector(degre_tmp(8 downto 0));
   
end architecture;