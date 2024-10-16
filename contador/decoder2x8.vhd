library ieee;
use ieee.std_logic_1164.all;

entity decoder2x8 is
  port ( entrada : in std_logic_vector(1 downto 0);
         saida : out std_logic_vector(3 downto 0)
  );
end entity;

architecture comportamento of decoder2x8 is
  begin
    saida(3) <= '1' when (entrada = "11") else '0';
    saida(2) <= '1' when (entrada = "10") else '0';
    saida(1) <= '1' when (entrada = "01") else '0';
    saida(0) <= '1' when (entrada = "00") else '0';
end architecture;