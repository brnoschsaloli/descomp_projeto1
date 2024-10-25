library ieee;
use ieee.std_logic_1164.all;

entity relogio_vga is
  -- Total de bits das entradas e saidas
  generic ( larguraDados_ROM : natural := 15;
        larguraEnderecos_ROM : natural := 9;
		  larguraDados_RAM     : natural := 8;
        larguraEnderecos_OUT : natural := 9;
		  larguraEnderecos_RAM : natural := 6;
        simulacao            : boolean := FALSE -- para gravar na placa, altere de TRUE para FALSE
  );

  port   (
    CLOCK_50 		: in std_logic;
	 FPGA_RESET_N  : in std_logic;
	 SW  				: in std_logic_vector(9 downto 0);
    KEY           : in std_logic_vector(3 downto 0);
	 
	 LEDR  			: out std_logic_vector(9 downto 0);
	 HEX0  			: out std_logic_vector(6 downto 0);
	 HEX1  			: out std_logic_vector(6 downto 0);
	 HEX2  			: out std_logic_vector(6 downto 0);
	 HEX3  			: out std_logic_vector(6 downto 0);
	 HEX4  			: out std_logic_vector(6 downto 0);
	 HEX5  			: out std_logic_vector(6 downto 0);
	 VGA_R			: out	std_logic_vector(3 DOWNTO 0);
	 VGA_G			: out	std_logic_vector(3 DOWNTO 0);
	 VGA_B			: out	std_logic_vector(3 DOWNTO 0);
	 VGA_HS	      : out	std_logic;							
	 VGA_VS			: out	std_logic
  );
end entity;


architecture arquitetura of relogio_vga is

  signal rom_addr : std_logic_vector(larguraEnderecos_ROM-1 downto 0);  -- Endereço da ROM para a CPU
  signal data_addr : std_logic_vector(larguraEnderecos_OUT-1 downto 0);  -- Endereço da RAM para a CPU
  signal saida_ROM : std_logic_vector(larguraDados_ROM-1 downto 0);  -- Instrução da ROM
  signal DATA_IN : std_logic_vector(larguraDados_RAM-1 downto 0);  -- Dados de entrada da RAM
  signal data_OUT : std_logic_vector(larguraDados_RAM-1 downto 0);  -- Dados de saída da CPU
  signal wr : std_logic;  -- Sinal de controle da CPU
  signal rd : std_logic;  -- Sinal de controle da CPU
  signal saida_Dec1 : std_logic_vector(7 downto 0); --Saida decoder 3x8
  signal saida_Dec2 : std_logic_vector(7 downto 0);
  signal saida_REG_LEDR : std_logic_vector(7 downto 0);
  signal saida_FF_LED8 : std_logic;
  signal saida_FF_LED9 : std_logic;
  signal saida_REG_HEX0 : std_logic_vector(3 downto 0);
  signal saida_REG_HEX1 : std_logic_vector(3 downto 0);
  signal saida_REG_HEX2 : std_logic_vector(3 downto 0);
  signal saida_REG_HEX3 : std_logic_vector(3 downto 0);
  signal saida_REG_HEX4 : std_logic_vector(3 downto 0);
  signal saida_REG_HEX5 : std_logic_vector(3 downto 0);
  signal saida_DEC_HEX0 : std_logic_vector(6 downto 0);
  signal saida_DEC_HEX1 : std_logic_vector(6 downto 0);
  signal saida_DEC_HEX2 : std_logic_vector(6 downto 0);
  signal saida_DEC_HEX3 : std_logic_vector(6 downto 0);
  signal saida_DEC_HEX4 : std_logic_vector(6 downto 0);
  signal saida_DEC_HEX5 : std_logic_vector(6 downto 0);
  signal habilita_LEDR : std_logic;
  signal habilita_LED8 : std_logic;
  signal habilita_LED9 : std_logic;
  signal habilita_HEX0 : std_logic;
  signal habilita_HEX1 : std_logic;
  signal habilita_HEX2 : std_logic;
  signal habilita_HEX3 : std_logic;
  signal habilita_HEX4 : std_logic;
  signal habilita_HEX5 : std_logic;
  signal habilita_SW7TO0 : std_logic;
  signal habilita_SW8 : std_logic;
  signal habilita_SW9 : std_logic;
  signal habilita_KEY0 : std_logic;
  signal habilita_KEY1 : std_logic;
  signal habilita_KEY2 : std_logic;
  signal habilita_KEY3 : std_logic;
  signal habilita_FPGA_RESET : std_logic;
  signal saida_1sec : std_logic;
  signal saida_EDGE_KEY0 : std_logic;
  signal saida_EDGE_KEY1 : std_logic;
  signal saida_EDGE_KEY2 : std_logic;
  signal KEY0 : std_logic;
  signal KEY1 : std_logic;
  signal KEY2 : std_logic;
  signal limpaLeitura0 : std_logic;
  signal limpaLeitura1 : std_logic;
  signal limpaLeitura2 : std_logic;
  signal	saidaRegCol : std_logic_vector(7 downto 0);
  signal	saidaRegLin : std_logic_vector(7 downto 0);
  signal	saidaRegData : std_logic_vector(5 downto 0);
  signal habilitaVGA : std_logic;
  signal habilitaColVGA : std_logic;
  signal habilitaLinVGA : std_logic;
  signal habilitaDataVGA : std_logic;
  
  alias CLK : std_logic is CLOCK_50;
begin

-- Instanciando os componentes:

U_CPU : entity work.CPU
				 port map (
					CLK      => CLK,      -- Clock da placa
					Reset		=> '0',
					Wr       => wr,   -- Controle da CPU
					Rd       => rd,   -- Controle da CPU
					ROM_Address   => rom_addr,      -- Endereço da ROM
					Instruction_IN => saida_ROM,    -- Instrução recebida da ROM
					Data_Address  => data_addr,   
					Data_OUT      => data_OUT,  -- Saída de dados da CPU
					Data_IN       => DATA_IN
				 );
				 
-- Falta acertar o conteudo da ROM (no arquivo memoriaROM.vhd)
ROM1 : entity work.memoriaROM   generic map (dataWidth => larguraDados_ROM, addrWidth => larguraEnderecos_ROM)
          port map (Endereco => rom_addr, Dado => saida_ROM);

RAM1 : entity work.memoriaRAM   generic map (dataWidth => larguraDados_RAM, addrWidth => larguraEnderecos_RAM)
          port map (addr => data_addr(larguraEnderecos_RAM-1 downto 0), we => wr, re => rd, habilita  => saida_Dec1(0), dado_in => data_OUT, dado_out => DATA_IN, clk => CLK);
			 
decoderBlocos :  entity work.decoder3x8
        port map( entrada => data_addr(8 downto 6),
                 saida => saida_Dec1);

decoderEnderecos :  entity work.decoder3x8
        port map( entrada => data_addr(2 downto 0),
                 saida => saida_Dec2);

REG_LEDR : entity work.registradorGenerico   generic map (larguraDados => 8)
				 port map (DIN => data_OUT, DOUT => saida_REG_LEDR, ENABLE => habilita_LEDR, CLK => CLK, RST => '0');
				 
FF_LED8 : entity work.flipFlop
				 port map (DIN => data_OUT(0), DOUT => saida_FF_LED8, ENABLE => habilita_LED8, CLK => CLK, RST => '0');

FF_LED9 : entity work.flipFlop
				 port map (DIN => data_OUT(0), DOUT => saida_FF_LED9, ENABLE => habilita_LED9, CLK => CLK, RST => '0');

REG_HEX0 : entity work.registradorGenerico   generic map (larguraDados => 4)
				 port map (DIN => data_OUT(3 downto 0), DOUT => saida_REG_HEX0, ENABLE => habilita_HEX0, CLK => CLK, RST => '0');

REG_HEX1 : entity work.registradorGenerico   generic map (larguraDados => 4)
				 port map (DIN => data_OUT(3 downto 0), DOUT => saida_REG_HEX1, ENABLE => habilita_HEX1, CLK => CLK, RST => '0');

REG_HEX2 : entity work.registradorGenerico   generic map (larguraDados => 4)
				 port map (DIN => data_OUT(3 downto 0), DOUT => saida_REG_HEX2, ENABLE => habilita_HEX2, CLK => CLK, RST => '0');
				 
REG_HEX3 : entity work.registradorGenerico   generic map (larguraDados => 4)
				 port map (DIN => data_OUT(3 downto 0), DOUT => saida_REG_HEX3, ENABLE => habilita_HEX3, CLK => CLK, RST => '0');
				 
REG_HEX4 : entity work.registradorGenerico   generic map (larguraDados => 4)
				 port map (DIN => data_OUT(3 downto 0), DOUT => saida_REG_HEX4, ENABLE => habilita_HEX4, CLK => CLK, RST => '0');
				 
REG_HEX5 : entity work.registradorGenerico   generic map (larguraDados => 4)
				 port map (DIN => data_OUT(3 downto 0), DOUT => saida_REG_HEX5, ENABLE => habilita_HEX5, CLK => CLK, RST => '0');

DEC_HEX0 :  entity work.conversorHex7Seg
        port map(dadoHex => saida_REG_HEX0,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => saida_DEC_HEX0);
				
DEC_HEX1 :  entity work.conversorHex7Seg
        port map(dadoHex => saida_REG_HEX1,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => saida_DEC_HEX1);
					  
DEC_HEX2 :  entity work.conversorHex7Seg
        port map(dadoHex => saida_REG_HEX2,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => saida_DEC_HEX2);
					  
DEC_HEX3 :  entity work.conversorHex7Seg
        port map(dadoHex => saida_REG_HEX3,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => saida_DEC_HEX3);
					  
DEC_HEX4 :  entity work.conversorHex7Seg
        port map(dadoHex => saida_REG_HEX4,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => saida_DEC_HEX4);

DEC_HEX5 :  entity work.conversorHex7Seg
        port map(dadoHex => saida_REG_HEX5,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => saida_DEC_HEX5);

SW7TO0_TRI :  entity work.buffer_3_state_8portas
        port map(entrada => SW(7 downto 0), habilita =>  habilita_SW7TO0, saida => DATA_IN);

SW8_TRI :  entity work.buffer_3_state_1porta
        port map(entrada => SW(8), habilita =>  habilita_SW8, saida => DATA_IN(0));  
		
SW9_TRI :  entity work.buffer_3_state_1porta
        port map(entrada => SW(9), habilita =>  habilita_SW9, saida => DATA_IN(0));  	
		 
KEY0_TRI :  entity work.buffer_3_state_1porta
        port map(entrada => KEY0, habilita =>  habilita_KEY0, saida => DATA_IN(0));
		 
KEY1_TRI :  entity work.buffer_3_state_1porta
        port map(entrada => KEY1, habilita =>  habilita_KEY1, saida => DATA_IN(0)); 
		 
KEY2_TRI :  entity work.buffer_3_state_1porta
        port map(entrada => KEY2, habilita =>  habilita_KEY2, saida => DATA_IN(0)); 
		 
KEY3_TRI :  entity work.buffer_3_state_1porta
        port map(entrada => KEY(3), habilita =>  habilita_KEY3, saida => DATA_IN(0));
		
FPGA_RESET_TRI :  entity work.buffer_3_state_1porta
        port map(entrada => FPGA_RESET_N, habilita =>  habilita_FPGA_RESET, saida => DATA_IN(0)); 	

divisor : entity work.divisorGenerico
            generic map (divisor => 25000000)   -- divide por 50M.
            port map (clk => CLK, saida_clk => saida_1sec);
				
DETECTORKEY0: work.edgeDetector(bordaSubida) port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => saida_EDGE_KEY0);

FF_KEY0 : entity work.flipFlop											 
          port map (DIN => '1', DOUT => KEY0, ENABLE => '1', CLK => saida_1sec, RST => limpaLeitura0);
			 
DETECTORKEY1: work.edgeDetector(bordaSubida) port map (clk => CLOCK_50, entrada => (not KEY(1)), saida => saida_EDGE_KEY1);

FF_KEY1 : entity work.flipFlop											 
          port map (DIN => '1', DOUT => KEY1, ENABLE => '1', CLK => saida_EDGE_KEY1, RST => limpaLeitura1);
			 
DETECTORKEY2: work.edgeDetector(bordaSubida) port map (clk => CLOCK_50, entrada => (not KEY(2)), saida => saida_EDGE_KEY2); 

FF_KEY2 : entity work.flipFlop											 
          port map (DIN => '1', DOUT => KEY2, ENABLE => '1', CLK => saida_EDGE_KEY2, RST => limpaLeitura2);
			 
REG_VGA_COL : entity work.registradorGenerico   generic map (larguraDados => 8)
				 port map (DIN => data_OUT, DOUT => saidaRegCol, ENABLE => habilitaColVGA, CLK => CLK, RST => '0');

REG_VGA_LIN : entity work.registradorGenerico   generic map (larguraDados => 8)
				 port map (DIN => data_OUT, DOUT => saidaRegLin, ENABLE => habilitaLinVGA, CLK => CLK, RST => '0');

REG_VGA_DATA : entity work.registradorGenerico   generic map (larguraDados => 6)
				 port map (DIN => data_OUT(5 downto 0), DOUT => saidaRegData, ENABLE => habilitaDataVGA, CLK => CLK, RST => '0');		 
			 
			 
VGA : entity work.driverVGA
  port map (
    CLOCK_50  =>  CLK, -- DE0-CV -> CLOCK_50
    VGA_HS    =>  VGA_HS, -- DE0-CV -> VGA_HS
    VGA_VS    =>  VGA_VS, -- DE0-CV -> VGA_VS
    VGA_R     =>  VGA_R, -- DE0-CV -> VGA_R
    VGA_G     =>  VGA_G, -- DE0-CV -> VGA_G
    VGA_B     =>  VGA_B, -- DE0-CV -> VGA_B
    posCol    =>  saidaRegCol, -- Posição da Coluna(X)
    posLin    =>  saidaRegLin, -- Posição da Linha(Y)
    dadoIN    =>  "10" & saidaRegData, -- Posição do carac. dentro do arquivo mapaDeCaracteres
    VideoRAMWREnable => '1'
    );
			 

			 
			 
 
habilita_LEDR <= saida_Dec1(4) AND wr AND saida_Dec2(0) AND not(data_addr(5));
habilita_LED8 <= saida_Dec1(4) AND wr AND saida_Dec2(1) AND not(data_addr(5));
habilita_LED9 <= saida_Dec1(4) AND wr AND saida_Dec2(2) AND not(data_addr(5));

habilita_HEX0 <= saida_Dec1(4) AND wr AND saida_Dec2(0) AND data_addr(5);
habilita_HEX1 <= saida_Dec1(4) AND wr AND saida_Dec2(1) AND data_addr(5);
habilita_HEX2 <= saida_Dec1(4) AND wr AND saida_Dec2(2) AND data_addr(5);
habilita_HEX3 <= saida_Dec1(4) AND wr AND saida_Dec2(3) AND data_addr(5);
habilita_HEX4 <= saida_Dec1(4) AND wr AND saida_Dec2(4) AND data_addr(5);
habilita_HEX5 <= saida_Dec1(4) AND wr AND saida_Dec2(5) AND data_addr(5);

habilita_SW7TO0 <= saida_Dec1(5) AND rd AND saida_Dec2(0) AND not(data_addr(5));
habilita_SW8 <= saida_Dec1(5) AND rd AND saida_Dec2(1) AND not(data_addr(5));
habilita_SW9 <= saida_Dec1(5) AND rd AND saida_Dec2(2) AND not(data_addr(5));

habilita_KEY0 <= saida_Dec1(5) AND rd AND saida_Dec2(0) AND data_addr(5);
habilita_KEY1 <= saida_Dec1(5) AND rd AND saida_Dec2(1) AND data_addr(5);
habilita_KEY2 <= saida_Dec1(5) AND rd AND saida_Dec2(2) AND data_addr(5);
habilita_KEY3 <= saida_Dec1(5) AND rd AND saida_Dec2(3) AND data_addr(5);
habilita_FPGA_RESET <= saida_Dec1(5) AND rd AND saida_Dec2(4) AND data_addr(5);


habilitaColVGA  <= saida_Dec1(6) and saida_Dec2(0) and wr; --384
habilitaLinVGA  <= saida_Dec1(6) and saida_Dec2(1) and wr; --385
habilitaDataVGA <= saida_Dec1(6) and saida_Dec2(2) and wr; --386
habilitaVGA     <= saida_Dec1(6) and saida_Dec2(3) and wr; --387

LEDR(7 downto 0) <= saida_REG_LEDR;
LEDR(8) <= saida_FF_LED8;
LEDR(9) <= saida_FF_LED9;
	
HEX0 <= saida_DEC_HEX0;
HEX1 <= saida_DEC_HEX1;
HEX2 <= saida_DEC_HEX2;
HEX3 <= saida_DEC_HEX3;
HEX4 <= saida_DEC_HEX4;
HEX5 <= saida_DEC_HEX5;

limpaLeitura0 <= data_addr(0) and data_addr(1) and data_addr(2) and data_addr(3) and data_addr(4) and data_addr(5) and data_addr(6) and data_addr(7) and data_addr(8) and wr;
limpaLeitura1 <= not(data_addr(0)) and data_addr(1) and data_addr(2) and data_addr(3) and data_addr(4) and data_addr(5) and data_addr(6) and data_addr(7) and data_addr(8) and wr;
limpaLeitura2 <= data_addr(0) and not(data_addr(1)) and data_addr(2) and data_addr(3) and data_addr(4) and data_addr(5) and data_addr(6) and data_addr(7) and data_addr(8) and wr;


end architecture;
