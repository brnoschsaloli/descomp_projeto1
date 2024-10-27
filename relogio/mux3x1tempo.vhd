library ieee;
use ieee.std_logic_1164.all;

entity mux3x1tempo is
  port (
    entrada0_MUX, entrada1_MUX, entrada2_MUX: in std_logic;
    seletor_MUX : in std_logic_vector(1 downto 0);
    saida_MUX : out std_logic
  );
end entity;

architecture comportamento of mux3x1tempo is
  begin
    saida_MUX <= entrada0_MUX when (seletor_MUX = "00") else
					  entrada1_MUX when (seletor_MUX = "01") else
					  entrada2_MUX when (seletor_MUX = "10") else entrada0_MUX;
	 
end architecture;