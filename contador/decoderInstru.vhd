library ieee;
use ieee.std_logic_1164.all;

entity decoderInstru is
  port ( opcode : in std_logic_vector(4 downto 0);
         saida : out std_logic_vector(13 downto 0)
  );
end entity;

architecture comportamento of decoderInstru is

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

  begin
saida <= "00000000000000" when opcode = NOP else
         "00000001100010" when opcode = LDA else
         "00000001010010" when opcode = ADD else
         "00000001000010" when opcode = SUB else
         "00000011100000" when opcode = LDI else
         "00000000000001" when opcode = STA	else
			"01000000000000" when opcode = JMP else
			"00001000000000" when opcode = JEQ else
			"00000000001010" when opcode = CEQ else
			"10010000000000" when opcode = JSR else
			"00100000000000" when opcode = RET else
			"00000001110010" when opcode = ANDm else
			"00000011110000" when opcode = ANDi else
			"00000011010000" when opcode = ADDi else
			"00000011000000" when opcode = SUBi else
			"00000000000110" when opcode = CLT else
			"00000100000000" when opcode = JLT else
			"00000000000000";  -- NOP para os opcodes Indefinidos
end architecture;