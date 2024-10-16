LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity muxGenerico4x1 is
  generic ( larguraEntrada : natural := 9;
        larguraSelecao : natural := 2;
        invertido : boolean := FALSE);
  port (
    entrada_0 : in  std_logic_vector(larguraEntrada-1 downto 0);
    entrada_1 : in  std_logic_vector(larguraEntrada-1 downto 0);
    entrada_2 : in  std_logic_vector(larguraEntrada-1 downto 0);
    entrada_3 : in  std_logic_vector(larguraEntrada-1 downto 0);
    seletor_MUX : in  std_logic_vector(larguraSelecao-1 downto 0);
    saida_MUX   : out std_logic_vector(larguraEntrada-1 downto 0)
  );
end entity;

architecture Behavioral of muxGenerico4x1 is
begin

    saida_MUX <= entrada_0 when (seletor_MUX = "00") else 
					  entrada_1 when (seletor_MUX = "01") else 
					  entrada_2 when (seletor_MUX = "10");


end architecture;