library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bus_avalon_f7 is
    port (
        arst_i 		: in std_logic;
        clk_i			: in std_logic;
        address_i 	: in std_logic_vector(0 downto 0);
        write_data_i : in std_logic_vector(31 downto 0);
        write_i 		: in std_logic;
		  BP_STBY_i 	: in std_logic;
		  BP_babord_i	: in std_logic;
		  BP_tribord_i	: in std_logic;
		  
        read_data_o 		: out std_logic_vector(31 downto 0);
		  ledBabord_o  	: out std_logic;
		  ledTribord_o 	: out std_logic;
		  ledSTBY_o			: out std_logic;
        out_bip_o			: out std_logic
    );
end entity bus_avalon_f7;

architecture rtl of bus_avalon_f7 is
    component gestion_barre
		 port (
			  clk_50M_i       : in std_logic;
			  raz_n_i         : in std_logic;
			  BP_STBY_i 		: in std_logic;
			  BP_babord_i     : in std_logic;
			  BP_tribord_i    : in std_logic;

			  codeFonction_o  : out std_logic_vector(3 downto 0);
			  ledBabord_o     : out std_logic;
			  ledTribord_o 	: out std_logic;
			  ledSTBY_o			: out std_logic;
			  out_bip_o			: out std_logic
		 );
    end component;
	 signal codeFonction  : std_logic_vector(3 downto 0);
	 signal code_fonction_envoie : std_logic_vector (31 downto 0);
	 signal raz : std_logic;
	 
begin
    code_fonction_envoie(3 downto 0) <= codeFonction;
	 
    process (clk_i, arst_i)
    begin
        if (arst_i = '1') then
				raz <= '0';
        elsif rising_edge(clk_i) then
            if write_i = '1' then
                case to_integer(unsigned(address_i)) is
                    when 16#00# =>
								raz <= write_data_i(0);
                    --when 16#01# =>
                        --freq <= write_data_i;
                    when others =>
                end case;
            end if;
        end if;
    end process;

	 -- écriture des signaux sur le bus avalon (sorties)
    read_data_o <= 
        code_fonction_envoie when unsigned(address_i) = 16#01# else (others => '0');

	-- Instanciation du composant pwm
   barre_inst : component gestion_barre
		port map (
			clk_50M_i     	=>	clk_i,
         raz_n_i        =>	raz,
         BP_STBY_i 		=> BP_STBY_i,
			BP_babord_i    => BP_babord_i,
			BP_tribord_i   => BP_tribord_i,

			codeFonction_o => codeFonction,
			ledBabord_o    => ledBabord_o,
			ledTribord_o 	=> ledTribord_o,
			ledSTBY_o	 	=> ledSTBY_o,
			out_bip_o		=> out_bip_o
		);

end architecture rtl;