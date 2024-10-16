-- Biblioteca IEEE
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entidade do componente bancoRegistradores
entity bancoRegistradores is
    Port (
        clk            : in  std_logic;                    
        sel            : in  std_logic_vector(1 downto 0); 
        data_in        : in  std_logic_vector(7 downto 0); 
        habReg         : in  std_logic;                       
        data_out       : out std_logic_vector(7 downto 0)     
    );
end entity;

-- Arquitetura do componente bancoRegistradores
architecture Behavioral of bancoRegistradores is

    -- Declaração de um array de registradores
    signal saida_decoder_hab : std_logic_vector(3 downto 0);
	 signal entrada_reg0 : std_logic_vector(3 downto 0);
	 signal entrada_reg1 : std_logic_vector(3 downto 0);
	 signal entrada_reg2 : std_logic_vector(3 downto 0);
	 signal entrada_reg3 : std_logic_vector(3 downto 0);
	 signal saida_reg0 : std_logic_vector(3 downto 0);
	 signal saida_reg1 : std_logic_vector(3 downto 0);
	 signal saida_reg2 : std_logic_vector(3 downto 0);
	 signal saida_reg3 : std_logic_vector(3 downto 0);

begin

	REG1 : entity work.registradorGenerico   generic map (larguraDados => 8)
          port map (DIN => data_in, DOUT => data_out, ENABLE => saida_decoder_hab(0), CLK => CLK, RST => '0');

	REG2 : entity work.registradorGenerico   generic map (larguraDados => 8)
          port map (DIN => data_in, DOUT => data_out, ENABLE => saida_decoder_hab(1), CLK => CLK, RST => '0');

	REG3 : entity work.registradorGenerico   generic map (larguraDados => 8)
          port map (DIN => data_in, DOUT => data_out, ENABLE => saida_decoder_hab(2), CLK => CLK, RST => '0');
			 
	REG4 : entity work.registradorGenerico   generic map (larguraDados => 8)
          port map (DIN => data_in, DOUT => data_out, ENABLE => saida_decoder_hab(3), CLK => CLK, RST => '0');
			 
			 
	DECHAB :  entity work.decoder2x4
			  port map(entrada => sel, hab => habReg,
						  saida => saida_decoder_hab);
						  
	MUXSAIDA :  entity work.muxGenerico4x1  generic map (larguraEntrada => 8)
        port map( entrada_0 => saida_reg0,
                  entrada_1 => saida_reg1,
					   entrada_2 => saida_reg2,
						entrada_3 => saida_reg3,
                  seletor_MUX => sel,
                  saida_MUX => data_out);

	DMUXENTRADA:  entity work.demuxGenerico1x4  generic map (larguraEntrada => 8)
        port map( entrada => data_in,
                  saida_0 => entrada_reg0,
					   saida_1 => entrada_reg1,
						saida_2 => entrada_reg2,
                  saida_3 => entrada_reg3,
                  seletor_demux => sel);
end Behavioral;
