 library ieee;
use ieee.std_logic_1164.all;

entity contador is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 13;
        larguraEnderecos : natural := 9
  );
  port   (
    CLOCK_50 : in std_logic;
    SW: in std_logic_vector(9 downto 0);
	 LEDR: out std_logic_vector(9 downto 0); 
    HEX0 : out std_logic_vector (6 downto 0);
    HEX1 : out std_logic_vector (6 downto 0);
    HEX2 : out std_logic_vector (6 downto 0);
    HEX3 : out std_logic_vector (6 downto 0);
    HEX4 : out std_logic_vector (6 downto 0);
    HEX5 : out std_logic_vector (6 downto 0);
	 KEY : in std_logic_vector (3 downto 0);
	 FPGA_RESET_N : in std_logic
  );
end entity;

architecture arquitetura of contador is

  signal WR : std_logic;
  signal RD : std_logic;
  signal Data_Address : std_logic_vector (8 downto 0);
  signal Data_IN : std_logic_vector (7 downto 0);
  signal ROM_Address : std_logic_vector (8 downto 0);
  signal Data_OUT : std_logic_vector (7 downto 0);
  signal Instruction_IN : std_logic_vector (12 downto 0);
  signal Saida_Decoder_Enderecos : std_logic_vector (7 downto 0);
  signal Saida_Decoder_Blocos : std_logic_vector (7 downto 0);
  signal Hab_LEDR : std_logic;
  signal Hab_LED8 : std_logic;
  signal Hab_LED9 : std_logic;
  signal Hab_HEX0 : std_logic;
  signal Hab_HEX1 : std_logic;
  signal Hab_HEX2 : std_logic;
  signal Hab_HEX3 : std_logic;
  signal Hab_HEX4 : std_logic;
  signal Hab_HEX5 : std_logic;
  signal Entrada_HEX0 : std_logic_vector (3 downto 0);
  signal Entrada_HEX1 : std_logic_vector (3 downto 0);
  signal Entrada_HEX2 : std_logic_vector (3 downto 0);
  signal Entrada_HEX3 : std_logic_vector (3 downto 0);
  signal Entrada_HEX4 : std_logic_vector (3 downto 0);
  signal Entrada_HEX5 : std_logic_vector (3 downto 0);
  signal Hab_SW07 : std_logic;
  signal Hab_SW8 : std_logic;
  signal Hab_SW9 : std_logic;
  signal Hab_KEY0 : std_logic;
  signal Hab_KEY1 : std_logic;
  signal Hab_KEY2 : std_logic;
  signal Hab_KEY3 : std_logic;
  signal Hab_FPGA_RESET : std_logic;
  signal auxBt0 : std_logic;
  signal KEY0 : std_logic;
  signal limpaLeitura : std_logic;
  
  alias CLK : std_logic is CLOCK_50;

begin



CPU : entity work.CPU
			 port map (CLK => CLK, Reset => '0', Instruction_IN => Instruction_IN, Data_IN => Data_IN, ROM_Address => ROM_Address, WR => WR, RD => RD, Data_Address => Data_Address, Data_OUT => Data_OUT);

ROM1 : entity work.memoriaROM   generic map (dataWidth => larguraDados, addrWidth => larguraEnderecos)
          port map (Endereco => ROM_Address, Dado => Instruction_IN);
			 
			 
RAM1 : entity work.memoriaRAM   generic map (dataWidth => 8, addrWidth => 6)
          port map (addr => Data_Address(5 downto 0), we => WR, re => RD, habilita  => Saida_Decoder_Blocos(0), dado_in => Data_OUT, dado_out => Data_IN, clk => CLK);
			 		 
DEC3X8_BLOCOS :  entity work.decoder3x8
        port map( entrada => Data_Address(8 downto 6),
                 saida => Saida_Decoder_Blocos);

DEC3X8_ENDERECOS :  entity work.decoder3x8
        port map( entrada => Data_Address(2 downto 0),
                 saida => Saida_Decoder_Enderecos);

FFLED9 : entity work.FlipFlop   generic map (larguraDados => 1)											 
          port map (DIN => Data_OUT(0), DOUT => LEDR(9), ENABLE => Hab_LED9, CLK => CLK, RST => '0'); 

FFLED8 : entity work.FlipFlop   generic map (larguraDados => 1)											 
          port map (DIN => Data_OUT(0), DOUT => LEDR(8), ENABLE => Hab_LED8, CLK => CLK, RST => '0');	 

REGLEDR : entity work.registradorGenerico   generic map (larguraDados => 8)
          port map (DIN => Data_OUT, DOUT => LEDR(7 downto 0), ENABLE => Hab_LEDR, CLK => CLK, RST => '0');
			 
REGHEX0 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => Data_OUT(3 downto 0), DOUT => Entrada_HEX0, ENABLE => Hab_HEX0, CLK => CLK, RST => '0');

REGHEX1 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => Data_OUT(3 downto 0), DOUT => Entrada_HEX1, ENABLE => Hab_HEX1, CLK => CLK, RST => '0');

REGHEX2 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => Data_OUT(3 downto 0), DOUT => Entrada_HEX2, ENABLE => Hab_HEX2, CLK => CLK, RST => '0');
			 
REGHEX3 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => Data_OUT(3 downto 0), DOUT => Entrada_HEX3, ENABLE => Hab_HEX3, CLK => CLK, RST => '0');

REGHEX4 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => Data_OUT(3 downto 0), DOUT => Entrada_HEX4, ENABLE => Hab_HEX4, CLK => CLK, RST => '0');

REGHEX5 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => Data_OUT(3 downto 0), DOUT => Entrada_HEX5, ENABLE => Hab_HEX5, CLK => CLK, RST => '0');
		
DECHEX0 :  entity work.conversorHex7Seg
        port map(dadoHex => Entrada_HEX0,
                 saida7seg => HEX0
					  );

DECHEX1 :  entity work.conversorHex7Seg
        port map(dadoHex => Entrada_HEX1,
                 saida7seg => HEX1
					  );			  

DECHEX2 :  entity work.conversorHex7Seg
        port map(dadoHex => Entrada_HEX2,
                 saida7seg => HEX2
					  );

DECHEX3 :  entity work.conversorHex7Seg
        port map(dadoHex => Entrada_HEX3,
                 saida7seg => HEX3
					  );

DECHEX4 :  entity work.conversorHex7Seg
        port map(dadoHex => Entrada_HEX4,
                 saida7seg => HEX4
					  );

DECHEX5 :  entity work.conversorHex7Seg
        port map(dadoHex => Entrada_HEX5,
                 saida7seg => HEX5
					  );
					  
TSSW07 :  entity work.buffer_3_state_8portas
        port map(entrada => SW(7 DOWNTO 0), habilita =>  Hab_SW07, saida => Data_IN);

TSSW8 :  entity work.buffer_3_state
        port map(entrada => SW(8), habilita =>  Hab_SW8, saida => Data_IN(0));

TSSW9 :  entity work.buffer_3_state
        port map(entrada => SW(9), habilita =>  Hab_SW9, saida => Data_IN(0));
		  

detectorSub0: work.edgeDetector(bordaSubida) port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => auxBt0);

FFKEY0 : entity work.FlipFlop   generic map (larguraDados => 1)											 
          port map (DIN => '1', DOUT => KEY0, ENABLE => '1', CLK => auxBt0, RST => limpaLeitura);	
		  
TSKEY0 :  entity work.buffer_3_state
        port map(entrada => KEY0, habilita =>  Hab_KEY0, saida => Data_IN(0));		  
		  
TSKEY1 :  entity work.buffer_3_state
        port map(entrada => KEY(1), habilita =>  Hab_KEY1, saida => Data_IN(0));

TSKEY2 :  entity work.buffer_3_state
        port map(entrada => KEY(2), habilita =>  Hab_KEY2, saida => Data_IN(0));

TSKEY3 :  entity work.buffer_3_state
        port map(entrada => KEY(3), habilita =>  Hab_KEY3, saida => Data_IN(0));

TSFPGARESET :  entity work.buffer_3_state
        port map(entrada => FPGA_RESET_N, habilita =>  Hab_FPGA_RESET, saida => Data_IN(0));		  
					  
Hab_LEDR <= WR and Saida_Decoder_Blocos(4) and Saida_Decoder_Enderecos(0) and not(Data_Address(5));
Hab_LED8 <= WR and Saida_Decoder_Blocos(4) and Saida_Decoder_Enderecos(1) and not(Data_Address(5));		
Hab_LED9 <= WR and Saida_Decoder_Blocos(4) and Saida_Decoder_Enderecos(2) and not(Data_Address(5));
	
Hab_HEX0 <= WR and Saida_Decoder_Blocos(4) and Saida_Decoder_Enderecos(0) and (Data_Address(5));	
Hab_HEX1 <= WR and Saida_Decoder_Blocos(4) and Saida_Decoder_Enderecos(1) and (Data_Address(5));	
Hab_HEX2 <= WR and Saida_Decoder_Blocos(4) and Saida_Decoder_Enderecos(2) and (Data_Address(5));	
Hab_HEX3 <= WR and Saida_Decoder_Blocos(4) and Saida_Decoder_Enderecos(3) and (Data_Address(5));	
Hab_HEX4 <= WR and Saida_Decoder_Blocos(4) and Saida_Decoder_Enderecos(4) and (Data_Address(5));	
Hab_HEX5 <= WR and Saida_Decoder_Blocos(4) and Saida_Decoder_Enderecos(5) and (Data_Address(5));	

Hab_SW07 <= RD and not(Data_Address(5)) and Saida_Decoder_Enderecos(0) and Saida_Decoder_Blocos(5);
Hab_SW8 <= RD and not(Data_Address(5)) and Saida_Decoder_Enderecos(1) and Saida_Decoder_Blocos(5);
Hab_SW9 <= RD and not(Data_Address(5)) and Saida_Decoder_Enderecos(2) and Saida_Decoder_Blocos(5);

Hab_KEY0 <= RD and (Data_Address(5)) and Saida_Decoder_Enderecos(0) and Saida_Decoder_Blocos(5);
Hab_KEY1 <= RD and (Data_Address(5)) and Saida_Decoder_Enderecos(1) and Saida_Decoder_Blocos(5);
Hab_KEY2 <= RD and (Data_Address(5)) and Saida_Decoder_Enderecos(2) and Saida_Decoder_Blocos(5);
Hab_KEY3 <= RD and (Data_Address(5)) and Saida_Decoder_Enderecos(3) and Saida_Decoder_Blocos(5);
Hab_FPGA_RESET <= RD and (Data_Address(5)) and Saida_Decoder_Enderecos(4) and Saida_Decoder_Blocos(5);	

limpaLeitura <= Data_Address(0) and Data_Address(1) and Data_Address(2) and Data_Address(3) and Data_Address(4) and Data_Address(5) and Data_Address(6) and Data_Address(7) and Data_Address(8) and WR;		 

end architecture;