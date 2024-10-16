library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 4;
          addrWidth: natural := 3
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoriaROM is

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);
  
  constant NOP  : std_logic_vector(4 downto 0) := "00000";
  constant LDA  : std_logic_vector(4 downto 0) := "00001";
  constant ADD  : std_logic_vector(4 downto 0) := "00010";
  constant SUB  : std_logic_vector(4 downto 0) := "00011";
  constant LDI  : std_logic_vector(4 downto 0) := "00100";
  constant STA  : std_logic_vector(4 downto 0) := "00101";
  constant JMP  : std_logic_vector(4 downto 0) := "00110";
  constant JEQ  : std_logic_vector(4 downto 0) := "00111";
  constant CEQ  : std_logic_vector(4 downto 0) := "01000";
  constant JSR  : std_logic_vector(4 downto 0) := "01001";
  constant RET  : std_logic_vector(4 downto 0) := "01010";
  constant ANDm : std_logic_vector(4 downto 0) := "01011";
  constant ANDi : std_logic_vector(4 downto 0) := "01100";
  constant ADDi : std_logic_vector(4 downto 0) := "01101";
  constant SUBi : std_logic_vector(4 downto 0) := "01110";
  constant CLT  : std_logic_vector(4 downto 0) := "01111";
  constant JLT  : std_logic_vector(4 downto 0) := "10000";


  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
      -- Palavra de Controle = SelMUX, Habilita_A, Reset_A, Operacao_ULA
      -- Inicializa os endereços:
        tmp(0)  := STA & 9x"1FF";
        tmp(1)  := LDI & 9x"1";
        tmp(2)  := STA & 9x"1";
        tmp(3)  := NOP & 9x"0";
        tmp(4)  := LDA & 9x"160";
        tmp(5)  := STA & 9x"120";
        tmp(6)  := ANDi & 9x"1";
        tmp(7)  := STA & 9x"121";
        tmp(8)  := NOP & 9x"0";
        tmp(9)  := JMP & 9x"3";
		  return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;