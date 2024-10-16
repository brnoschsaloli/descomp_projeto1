 library ieee;
use ieee.std_logic_1164.all;

entity CPU is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 13;
        larguraEnderecos : natural := 9;
        simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
	 CLK: in std_logic;
	 Reset: in std_logic;
	 RD: out std_logic;
	 WR: out std_logic;
	 ROM_Address: out std_logic_vector(8 downto 0);
	 Instruction_IN: in std_logic_vector(13 downto 0);
	 Data_Address: out std_logic_vector(8 downto 0);
	 Data_OUT: out std_logic_vector(7 downto 0);
	 Data_IN: in std_logic_vector(7 downto 0)
  );
end entity;
                                      -- ALGUMA COISA DEU ERRADO NO CEQ, ELE NAO ESTA COMPARANDO POR ISSO NA INSTRUCAO E ELE NAO PULA PRA A POSICAO 9

architecture arquitetura of CPU is

  signal Saida_MUX : std_logic_vector (larguraDados-6 downto 0);
  signal Saida_MUX_PC : std_logic_vector (larguraDados-5 downto 0);
  signal Saida_REG_A : std_logic_vector (larguraDados-6 downto 0);
  signal Entrada_Flag_Equal : std_logic;
  signal Saida_Flag_Equal : std_logic;
  signal Entrada_Flag_Less : std_logic;
  signal Saida_Flag_Less : std_logic;
  signal Saida_ULA : std_logic_vector (larguraDados-6 downto 0);
  signal Saida_Decoder : std_logic_vector (13 downto 0);
  signal Saida_PC : std_logic_vector (8 downto 0);
  signal Saida_REG_RETORNO : std_logic_vector (8 downto 0);
  signal proxPC : std_logic_vector (8 downto 0);
  signal Operacao_ULA : std_logic_vector (1 downto 0);
  signal SelMUX : std_logic;
  signal JMP : std_logic;
  signal SelMUXPC : std_logic_vector (1 downto 0);
  signal JEQ : std_logic;
  signal JLT : std_logic;
  signal RET : std_logic;
  signal JSR : std_logic;
  signal Habilita_A : std_logic;
  signal habLeituraMEM : std_logic;
  signal habEscritaMEM : std_logic;
  signal habFlagIgual : std_logic;
  signal habFlagLess : std_logic;
  signal habEscritaRetorno : std_logic;

begin

-- Instanciando os componentes:


-- O port map completo do MUX.
MUX1 :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados-5)
        port map( entradaA_MUX => Data_IN,
                 entradaB_MUX =>  Instruction_IN(7 downto 0),
                 seletor_MUX => SelMUX,
                 saida_MUX => Saida_MUX);

					  
-- O port map completo do JMP.
MUXProxPC :  entity work.muxGenerico4x1  generic map (larguraEntrada => larguraDados-4)
        port map( entrada_0 => proxPC,
                  entrada_1 => Instruction_IN(8 downto 0),
					   entrada_2 => Saida_REG_RETORNO,
						entrada_3 => "000000000",
                  seletor_MUX => SelMUXPC,
                  saida_MUX => Saida_MUX_PC);
					  

-- O port map completo do Acumulador.
REGA : entity work.registradorGenerico   generic map (larguraDados => larguraDados-5)
          port map (DIN => Saida_ULA, DOUT => Saida_REG_A, ENABLE => Habilita_A, CLK => CLK, RST => '0');

FlagZero : entity work.FlipFlop   generic map (larguraDados => 1)											 
          port map (DIN => Entrada_Flag_Equal, DOUT => Saida_Flag_Equal, ENABLE => habFlagIgual, CLK => CLK, RST => '0');

FlagLess : entity work.FlipFlop   generic map (larguraDados => 1)											 
          port map (DIN => Entrada_Flag_Less, DOUT => Saida_Flag_Less, ENABLE => habFlagLess, CLK => CLK, RST => '0');
			 
			 
-- O port map completo do Program Counter.
PC : entity work.registradorGenerico   generic map (larguraDados => larguraEnderecos)
          port map (DIN => Saida_MUX_PC, DOUT => Saida_PC, ENABLE => '1', CLK => CLK, RST => '0');

REG_RETORNO : entity work.registradorGenerico   generic map (larguraDados => larguraEnderecos)
          port map (DIN => proxPC, DOUT => Saida_REG_RETORNO, ENABLE => habEscritaRetorno, CLK => CLK, RST => '0');

incrementaPC :  entity work.somaConstante  generic map (larguraDados => larguraEnderecos, constante => 1)
        port map( entrada => Saida_PC, saida => proxPC);


-- O port map completo da ULA:
ULA1 : entity work.ULASomaSub  generic map(larguraDados => larguraDados - 5)
          port map (entradaA => Saida_REG_A, entradaB => Saida_MUX, saida => Saida_ULA, seletor => Operacao_ULA, porta_nor => Entrada_Flag_Equal, porta_clt => Entrada_Flag_Less);		 		 
			 
-- O port map completo do decoderInstru.
DEC_Instrucao :  entity work.decoderInstru 
        port map( 
				opcode => Instruction_IN(13 downto 9),
            saida =>  Saida_Decoder
			);
			
LogicaDesvio1 : entity work.LogicaDesvio
			port map(
				entrada_flag_equal => Saida_Flag_Equal,
				entrada_jeq  => JEQ,
				entrada_flag_less => Saida_Flag_Less,
				entrada_jlt  => JLT,
				entrada_jmp  => JMP,
				entrada_jsr  => JSR,
				entrada_ret  => RET,
				saida        => SelMUXPC
			);
			
habEscritaRetorno <= Saida_Decoder(13);
JMP <= Saida_Decoder(12);
RET <= Saida_Decoder(11);
JSR <= Saida_Decoder(10);
JEQ <= Saida_Decoder(9);
JLT <= Saida_Decoder(8);
SelMUX <= Saida_Decoder(7);
Habilita_A <= Saida_Decoder(6);
Operacao_ULA <= Saida_Decoder(5 downto 4);
habFlagIgual <= Saida_Decoder(3);
habFlagLess <= Saida_Decoder(2);
habLeituraMEM <= Saida_Decoder(1);
habEscritaMEM <= Saida_Decoder(0);

WR <= habEscritaMEM;
RD <= habLeituraMEM;
ROM_Address <= Saida_PC;
Data_Address <= Instruction_IN(8 downto 0);
Data_OUT <= Saida_REG_A;

end architecture;