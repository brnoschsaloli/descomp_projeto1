library ieee;
use ieee.std_logic_1164.all;

entity LogicaDesvio is
  port ( entrada_flag_equal : in std_logic;
			entrada_flag_less : in std_logic;
			entrada_jlt : in std_logic;
			entrada_jeq  : in std_logic;
			entrada_jmp  : in std_logic;
			entrada_jsr  : in std_logic;
			entrada_ret  : in std_logic;
         saida : out std_logic_vector (1 downto 0)
  );
end entity;

architecture comportamento of LogicaDesvio is

  begin
saida <= "01" when ((entrada_flag_equal and entrada_jeq) or (entrada_flag_less and entrada_jlt) or entrada_jsr or entrada_jmp) else
			"10" when entrada_ret else
			"00";
end architecture;