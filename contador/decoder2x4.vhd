library ieee;
use ieee.std_logic_1164.all;

entity decoder2x4 is
  port ( entrada : in std_logic_vector(1 downto 0);
			hab : in std_logic;
         saida : out std_logic_vector(3 downto 0)
  );
end entity;

architecture comportamento of decoder2x4 is
  begin
    saida(3) <= '1' when (entrada = "11" and hab = '1') else '0';
    saida(2) <= '1' when (entrada = "10" and hab = '1') else '0';
    saida(1) <= '1' when (entrada = "01" and hab = '1') else '0';
    saida(0) <= '1' when (entrada = "00" and hab = '1') else '0';
end architecture;