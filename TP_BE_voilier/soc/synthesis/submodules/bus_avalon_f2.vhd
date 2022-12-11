library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bus_avalon_f2 is
    port (
        arst_i 		: in std_logic;
        clk_i			: in std_logic;
        address_i 	: in std_logic_vector(0 downto 0);
        write_data_i : in std_logic_vector(31 downto 0);
        write_i 		: in std_logic;
		  freq_i			: in std_logic; 		-- on garde dans l'entité uniquement les entrées physiques du composant
		  
        read_data_o 	: out std_logic_vector(31 downto 0)
    );
end entity bus_avalon_f2;

architecture rtl of bus_avalon_f2 is
    component ConversionVitesseVent
		 port (
			  clk_50M_i       		: in std_logic;
			  raz_n_i         		: in std_logic;
			  in_freq_anemometre_i 	: in std_logic;
			  continu_i       		: in std_logic;
			  start_stop_i    		: in std_logic;

			  data_valid_o    		: out std_logic;
			  data_anemometre_o 		: out std_logic_vector (7 downto 0)
		 );
    end component;
	 signal continu, start_stop, raz_n 	: std_logic;
	 signal data_valid 						: std_logic;
	 signal data_anemometre 				: std_logic_vector(7 downto 0);
	 signal valid_data 						: std_logic_vector (31 downto 0);
	 
begin
	 valid_data(8 downto 0) <= data_valid & data_anemometre;
	 
	 -- récupération des signaux du bus avalon (entrées)
    process (clk_i, arst_i)
    begin
        if (arst_i = '1') then
            --duty <= (others => '0');
            --freq <= (others => '1');
				raz_n <= '0';
				continu <= '0';
				start_stop <= '0';
        elsif rising_edge(clk_i) then
            if write_i = '1' then
                case to_integer(unsigned(address_i)) is
                    when 16#00# =>
                        raz_n <= write_data_i(0);
								continu <= write_data_i(1);
								start_stop <= write_data_i(2);
                    --when 16#01# =>
                        --freq <= write_data_i;
                    when others =>
                end case;
            end if;
        end if;
    end process;

	 -- écriture des signaux sur le bus avalon (sorties)
    read_data_o <= 
        valid_data when unsigned(address_i) = 16#01# else (others => '0');

	-- Instanciation du composant pwm
   anemometre_inst : component ConversionVitesseVent
		port map (
			clk_50M_i         	=>	clk_i,
         raz_n_i          		=>	raz_n,
         in_freq_anemometre_i =>	freq_i,
         continu_i       		=>	continu,
			start_stop_i    		=>	start_stop,

			data_valid_o    		=>	data_valid,
			data_anemometre_o 	=>	data_anemometre
		);

end architecture rtl;