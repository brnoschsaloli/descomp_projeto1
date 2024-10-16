library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    -- Biblioteca IEEE para funções aritméticas

entity ULASomaSub is
    generic ( larguraDados : natural := 8 );
    port (
      entradaA, entradaB:  in STD_LOGIC_VECTOR((larguraDados-1) downto 0);
      seletor:  in STD_LOGIC_VECTOR(1 downto 0);
      saida:    out STD_LOGIC_VECTOR((larguraDados-1) downto 0);
		porta_nor: out STD_LOGIC;
		porta_clt: out STD_LOGIC
		);
end entity;

architecture comportamento of ULASomaSub is
   signal soma :      STD_LOGIC_VECTOR((larguraDados-1) downto 0);
   signal subtracao : STD_LOGIC_VECTOR((larguraDados-1) downto 0);
	signal passa : STD_LOGIC_VECTOR((larguraDados-1) downto 0);
	signal andi : STD_LOGIC_VECTOR((larguraDados-1) downto 0);
	signal lessthen : BOOLEAN;
    begin
      soma      <= STD_LOGIC_VECTOR(unsigned(entradaA) + unsigned(entradaB));
      subtracao <= STD_LOGIC_VECTOR(unsigned(entradaA) - unsigned(entradaB));
		passa <= entradaB;
		andi <= entradaA and entradaB;
		lessthen <= unsigned(entradaA) < unsigned(entradaB);
      saida <= soma when (seletor = "01") else subtracao when (seletor = "00") else andi when (seletor = "11") else passa;
		porta_nor <= '1' when unsigned(saida) = 0 else '0';
		porta_clt <= '1' when lessthen else '0';
end architecture;