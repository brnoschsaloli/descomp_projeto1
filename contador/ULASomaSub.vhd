library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  -- Biblioteca IEEE para funções aritméticas

entity ULASomaSub is
    generic ( larguraDados : natural := 4 );
    port (
      entradaA, entradaB:  in STD_LOGIC_VECTOR((larguraDados-1) downto 0);
      seletor:  in STD_LOGIC_VECTOR(1 downto 0);
      saida:    out STD_LOGIC_VECTOR((larguraDados-1) downto 0);
      flagZero: out std_logic
    );
end entity;

architecture comportamento of ULASomaSub is
    signal soma :      STD_LOGIC_VECTOR((larguraDados-1) downto 0);
    signal subtracao : STD_LOGIC_VECTOR((larguraDados-1) downto 0);
    signal and_result : STD_LOGIC_VECTOR((larguraDados-1) downto 0);
    signal passa :     STD_LOGIC_VECTOR((larguraDados-1) downto 0);
    
begin
    soma      <= STD_LOGIC_VECTOR(unsigned(entradaA) + unsigned(entradaB));
    subtracao <= STD_LOGIC_VECTOR(unsigned(entradaA) - unsigned(entradaB));
    and_result <= entradaA and entradaB;
    passa     <= entradaB;

    -- Seleciona a operação com base no seletor
    saida <= soma when (seletor = "01") else
             subtracao when (seletor = "00") else
             and_result when (seletor = "11") else
             passa;

    flagZero <= '1' when unsigned(saida) = 0 else '0';
end architecture;
