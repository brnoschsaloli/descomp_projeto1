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
  
  constant NOP   : std_logic_vector(3 downto 0) := "0000";
  constant LDA   : std_logic_vector(3 downto 0) := "0001";
  constant ADD   : std_logic_vector(3 downto 0) := "0010";
  constant SUB   : std_logic_vector(3 downto 0) := "0011";
  constant LDI   : std_logic_vector(3 downto 0) := "0100";
  constant STA   : std_logic_vector(3 downto 0) := "0101";
  constant JMP   : std_logic_vector(3 downto 0) := "0110";
  constant JEQ   : std_logic_vector(3 downto 0) := "0111";
  constant CEQ   : std_logic_vector(3 downto 0) := "1000";
  constant JSR   : std_logic_vector(3 downto 0) := "1001";
  constant RET   : std_logic_vector(3 downto 0) := "1010";
  constant AND1  : std_logic_vector(3 downto 0) := "1011";
  constant ANDi  : std_logic_vector(3 downto 0) := "1100";
  constant CEQi  : std_logic_vector(3 downto 0) := "1101";
  constant ADDi  : std_logic_vector(3 downto 0) := "1110";

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
    -- Palavra de Controle = SelMUX, Habilita_A, Operacao_ULA_2bits, habLeituraMEM, habEscritaMEM 
    -- Inicializa os endereços:
    tmp(0) := x"4" & '0' & x"00";	-- LDI $0			#Carrega o acumulador com o valor 0
    tmp(1) := x"5" & '1' & x"20";	-- STA @288		#Armazena o valor do acumulador em HEX0
    tmp(2) := x"5" & '1' & x"21";	-- STA @289		#Armazena o valor do acumulador em HEX1
    tmp(3) := x"5" & '1' & x"22";	-- STA @290		#Armazena o valor do acumulador em HEX2
    tmp(4) := x"5" & '1' & x"23";	-- STA @291		#Armazena o valor do acumulador em HEX3
    tmp(5) := x"5" & '1' & x"24";	-- STA @292		#Armazena o valor do acumulador em HEX4
    tmp(6) := x"5" & '1' & x"25";	-- STA @293		#Armazena o valor do acumulador em HEX5
    tmp(7) := x"0" & '0' & x"00";	-- NOP
    tmp(8) := x"4" & '0' & x"00";	-- LDI $0			#Carrega o acumulador com o valor 0
    tmp(9) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
    tmp(10) := x"5" & '1' & x"01";	-- STA @257		#Armazena o valor do bit0 do acumulador no LDR8
    tmp(11) := x"5" & '1' & x"02";	-- STA @258		#Armazena o valor do bit0 do acumulador no LDR9
    tmp(12) := x"0" & '0' & x"00";	-- NOP
    tmp(13) := x"4" & '0' & x"00";	-- LDI $0			#Carrega o acumulador com o valor 0
    tmp(14) := x"5" & '0' & x"00";	-- STA @0			#Armazena o valor do acumulador em MEM[0] (unidades)
    tmp(15) := x"5" & '0' & x"01";	-- STA @1			#Armazena o valor do acumulador em MEM[1] (dezenas)
    tmp(16) := x"5" & '0' & x"02";	-- STA @2			#Armazena o valor do acumulador em MEM[2] (centenas)
    tmp(17) := x"5" & '0' & x"06";	-- STA @6			#Armazena o valor do acumulador em MEM[6] (milhares)
    tmp(18) := x"5" & '0' & x"07";	-- STA @7			#Armazena o valor do acumulador em MEM[7] (dezenas de milhares)
    tmp(19) := x"5" & '0' & x"08";	-- STA @8			#Armazena o valor do acumulador em MEM[8] (centenas de milhares)
    tmp(20) := x"5" & '0' & x"09";	-- STA @9			#Armazena o valor do acumulador em MEM[9] (flag inibir contagem)
    tmp(21) := x"4" & '0' & x"09";	-- LDI $9			#Carrega o acumulador com o valor 9
    tmp(22) := x"5" & '0' & x"0A";	-- STA @10			#Armazena o valor do acumulador em MEM[10] (inibir unidade)
    tmp(23) := x"5" & '0' & x"0B";	-- STA @11			#Armazena o valor do acumulador em MEM[11] (inibir dezena)
    tmp(24) := x"5" & '0' & x"0C";	-- STA @12			#Armazena o valor do acumulador em MEM[12] (inibir centena)
    tmp(25) := x"5" & '0' & x"0D";	-- STA @13			#Armazena o valor do acumulador em MEM[13] (inibir milhar)
    tmp(26) := x"5" & '0' & x"0E";	-- STA @14			#Armazena o valor do acumulador em MEM[14] (inibir dezena de milhar)
    tmp(27) := x"5" & '0' & x"0F";	-- STA @15			#Armazena o valor do acumulador em MEM[15] (inibir centena de milhar)
    tmp(28) := x"4" & '0' & x"00";	-- LDI $0			#Carrega o acumulador com o valor 0
    tmp(29) := x"5" & '0' & x"03";	-- STA @3			#Armazena o valor do acumulador em MEM[3] (constante 0)
    tmp(30) := x"4" & '0' & x"01";	-- LDI $1			#Carrega o acumulador com o valor 1
    tmp(31) := x"5" & '0' & x"04";	-- STA @4			#Armazena o valor do acumulador em MEM[4] (constante 1)
    tmp(32) := x"4" & '0' & x"0A";	-- LDI $10			#Carrega o acumulador com o valor 10
    tmp(33) := x"5" & '0' & x"05";	-- STA @5			#Armazena o valor do acumulador em MEM[5] (constante 10)
    tmp(34) := x"0" & '0' & x"00";	-- NOP
    tmp(35) := x"5" & '1' & x"FF";	-- STA @511		#Limpa a leitura do botão zero
    tmp(36) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
    tmp(37) := x"0" & '0' & x"00";	-- NOP		
    tmp(38) := x"1" & '1' & x"60";	-- LDA @352		#Carrega o acumulador com a leitura do botão KEY0
    tmp(39) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
    tmp(40) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
    tmp(41) := x"7" & '0' & x"2C";	-- JEQ @44		#Desvia se igual a 0 (botão não foi pressionado)
    tmp(42) := x"9" & '0' & x"3E";	-- JSR @62		#O botão foi pressionado, chama a sub-rotina de incremento
    tmp(43) := x"0" & '0' & x"00";	-- NOP 			#Retorno da sub-rotina de incremento
    tmp(44) := x"9" & '0' & x"6F";	-- JSR @111 	#Escreve o valor das váriaveis de contagem nos displays
    tmp(45) := x"0" & '0' & x"00";	-- NOP			#Retorno da sub-rotina de salvar nos displays
    tmp(46) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
    tmp(47) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
    tmp(48) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
    tmp(49) := x"7" & '0' & x"34";	-- JEQ @52		#Desvia se igual a 0 (botão não foi pressionado)
    tmp(50) := x"9" & '0' & x"A2";	-- JSR @162		#O botão foi pressionado, chama a sub-rotina de incremento
    tmp(51) := x"0" & '0' & x"00";	-- NOP 			#Retorno da sub-rotina de definir limite
    tmp(52) := x"9" & '0' & x"86";	-- JSR @134
    tmp(53) := x"0" & '0' & x"00";	-- NOP			#Retorno da sub-rotina de verificar limite
    tmp(54) := x"1" & '1' & x"64";	-- LDA @356		#Carrega o acumulador com a leitura do botão FPGA_RESET
    tmp(55) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
    tmp(56) := x"D" & '0' & x"01";	-- CEQi $1			#Compara com constante 1
    tmp(57) := x"7" & '0' & x"3B";	-- JEQ @59		#Desvia se igual a 1 (botão não foi pressionado)
    tmp(58) := x"9" & '0' & x"7C";	-- JSR @124		#O botão foi pressionado, chama a sub-rotina de reset
    tmp(59) := x"0" & '0' & x"00";	-- NOP			#Retorno da sub-rotina de reset
    tmp(60) := x"6" & '0' & x"25";	-- JMP @37		#Fecha o laço principal, faz uma nova leitura de KEY0
    tmp(61) := x"0" & '0' & x"00";	-- NOP
    tmp(62) := x"5" & '1' & x"FF";	-- STA @511		#Limpa a leitura do botão
    tmp(63) := x"1" & '0' & x"09";	-- LDA @9			#Carrega o valor de MEM[9] (flag inibir contagem)
    tmp(64) := x"D" & '0' & x"00";	-- CEQi $0			#Compara o valor com constante 0
    tmp(65) := x"7" & '0' & x"43";	-- JEQ @67
    tmp(66) := x"A" & '0' & x"00";	-- RET
    tmp(67) := x"1" & '0' & x"00";	-- LDA @0			#Carrega o valor de MEM[0] (contador)
    tmp(68) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
    tmp(69) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
    tmp(70) := x"7" & '0' & x"49";	-- JEQ @73		#Realiza o carry out caso valor igual a 10
    tmp(71) := x"5" & '0' & x"00";	-- STA @0			#Salva o incremento em MEM[0] (contador)
    tmp(72) := x"A" & '0' & x"00";	-- RET			#Retorna da sub-rotina
    tmp(73) := x"1" & '0' & x"03";	-- LDA @3			#Carrega valor de MEM[3] no acumulador (constante 0)
    tmp(74) := x"5" & '0' & x"00";	-- STA @0			#Armazena o valor do acumulador em MEM[0] (unidades)
    tmp(75) := x"1" & '0' & x"01";	-- LDA @1			#Carrega valor de MEM[1] no acumulador (dezenas)
    tmp(76) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
    tmp(77) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
    tmp(78) := x"7" & '0' & x"51";	-- JEQ @81		#Realiza o carry out caso valor igual a 10
    tmp(79) := x"5" & '0' & x"01";	-- STA @1			#Salva o incremento em MEM[1] (dezenas)
    tmp(80) := x"A" & '0' & x"00";	-- RET
    tmp(81) := x"1" & '0' & x"03";	-- LDA @3			#Carrega valor de MEM[3] no acumulador (constante 0)
    tmp(82) := x"5" & '0' & x"01";	-- STA @1			#Armazena o valor do acumulador em MEM[1] (dezenas)
    tmp(83) := x"1" & '0' & x"02";	-- LDA @2			#Carrega valor de MEM[2] no acumulador (centenas)
    tmp(84) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
    tmp(85) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
    tmp(86) := x"7" & '0' & x"59";	-- JEQ @89		#Realiza o carry out caso valor igual a 10
    tmp(87) := x"5" & '0' & x"02";	-- STA @2			#Salva o incremento em MEM[2] (centenas)
    tmp(88) := x"A" & '0' & x"00";	-- RET
    tmp(89) := x"1" & '0' & x"03";	-- LDA @3			#Carrega valor de MEM[3] no acumulador (constante 0)
    tmp(90) := x"5" & '0' & x"02";	-- STA @2			#Armazena o valor do acumulador em MEM[2] (centenas)
    tmp(91) := x"1" & '0' & x"06";	-- LDA @6			#Carrega valor de MEM[6] no acumulador (milhares)
    tmp(92) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
    tmp(93) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
    tmp(94) := x"7" & '0' & x"61";	-- JEQ @97		#Realiza o carry out caso valor igual a 10
    tmp(95) := x"5" & '0' & x"06";	-- STA @6			#Salva o incremento em MEM[6] (milhares)
    tmp(96) := x"A" & '0' & x"00";	-- RET
    tmp(97) := x"1" & '0' & x"03";	-- LDA @3			#Carrega valor de MEM[3] no acumulador (constante 0)
    tmp(98) := x"5" & '0' & x"06";	-- STA @6			#Armazena o valor do acumulador em MEM[6] (milhares)
    tmp(99) := x"1" & '0' & x"07";	-- LDA @7			#Carrega valor de MEM[7] no acumulador (dezenas de milhares)
    tmp(100) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
    tmp(101) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
    tmp(102) := x"7" & '0' & x"69";	-- JEQ @105		#Realiza o carry out caso valor igual a 10
    tmp(103) := x"5" & '0' & x"07";	-- STA @7			#Salva o incremento em MEM[7] (dezenas de milhares)
    tmp(104) := x"A" & '0' & x"00";	-- RET
    tmp(105) := x"1" & '0' & x"03";	-- LDA @3			#Carrega valor de MEM[3] no acumulador (constante 0)
    tmp(106) := x"5" & '0' & x"07";	-- STA @7			#Armazena o valor do acumulador em MEM[6] (milhares)
    tmp(107) := x"1" & '0' & x"08";	-- LDA @8			#Carrega valor de MEM[7] no acumulador (dezenas de milhares)
    tmp(108) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
    tmp(109) := x"5" & '0' & x"07";	-- STA @7			#Salva o incremento em MEM[7] (dezenas de milhares)
    tmp(110) := x"A" & '0' & x"00";	-- RET
    tmp(111) := x"1" & '0' & x"00";	-- LDA @0 			#Carrega o valor de MEM[0] (unidades)
    tmp(112) := x"5" & '1' & x"20";	-- STA @288 		#Armazena valor do acumulador de unidades no HEX0
    tmp(113) := x"1" & '0' & x"01";	-- LDA @1 			#Carrega o valor de MEM[1] (dezenas)
    tmp(114) := x"5" & '1' & x"21";	-- STA @289 		#Armazena valor do acumulador de dezenas no HEX1
    tmp(115) := x"1" & '0' & x"02";	-- LDA @2 			#Carrega o valor de MEM[2] (centenas)
    tmp(116) := x"5" & '1' & x"22";	-- STA @290 		#Armazena valor do acumulador de centenas no HEX2
    tmp(117) := x"1" & '0' & x"06";	-- LDA @6 			#Carrega o valor de MEM[6] (milhares)
    tmp(118) := x"5" & '1' & x"23";	-- STA @291 		#Armazena valor do acumulador de unidades no HEX3
    tmp(119) := x"1" & '0' & x"07";	-- LDA @7 			#Carrega o valor de MEM[7] (dezenas de milhares)
    tmp(120) := x"5" & '1' & x"24";	-- STA @292 		#Armazena valor do acumulador de dezenas no HEX4
    tmp(121) := x"1" & '0' & x"08";	-- LDA @8 			#Carrega o valor de MEM[8] (centenas de milhares)
    tmp(122) := x"5" & '1' & x"25";	-- STA @293 		#Armazena valor do acumulador de centenas no HEX5
    tmp(123) := x"A" & '0' & x"00";	-- RET
    tmp(124) := x"4" & '0' & x"00";	-- LDI $0			#Carrega o acumulador com o valor 0
    tmp(125) := x"5" & '0' & x"00";	-- STA @0	 		#Armazena o valor do acumulador na MEM[0] (unidades)
    tmp(126) := x"5" & '0' & x"01";	-- STA @1	 		#Armazena o valor do acumulador na MEM[1] (dezenas)
    tmp(127) := x"5" & '0' & x"02";	-- STA @2	 		#Armazena o valor do acumulador na MEM[2] (centenas)
    tmp(128) := x"5" & '0' & x"06";	-- STA @6	 		#Armazena o valor do acumulador na MEM[6] (milhar)
    tmp(129) := x"5" & '0' & x"07";	-- STA @7	 		#Armazena o valor do acumulador na MEM[7] (dezena de milhar)
    tmp(130) := x"5" & '0' & x"08";	-- STA @8	 		#Armazena o valor do acumulador na MEM[8] (centena de milhar)
    tmp(131) := x"5" & '0' & x"09";	-- STA @9	 		#Armazena o valor do acumulador na MEM[9] (flag inibir contagem)
    tmp(132) := x"5" & '1' & x"01";	-- STA @257		#Armazena o valor do bit0 do acumulador no LDR8
    tmp(133) := x"A" & '0' & x"00";	-- RET
    tmp(134) := x"1" & '0' & x"00";	-- LDA @0			#Carrega o valor de MEM[0] (unidades)
    tmp(135) := x"8" & '0' & x"0A";	-- CEQ @10			#Compara o valor de MEM[10] (inibir unidade)
    tmp(136) := x"7" & '0' & x"8A";	-- JEQ @138
    tmp(137) := x"A" & '0' & x"00";	-- RET
    tmp(138) := x"1" & '0' & x"01";	-- LDA @1			#Carrega o valor de MEM[1] (dezenas)
    tmp(139) := x"8" & '0' & x"0B";	-- CEQ @11			#Compara o valor de MEM[11] (inibir dezenas)
    tmp(140) := x"7" & '0' & x"8E";	-- JEQ @142
    tmp(141) := x"A" & '0' & x"00";	-- RET
    tmp(142) := x"1" & '0' & x"02";	-- LDA @2			#Carrega o valor de MEM[2] (centenas)
    tmp(143) := x"8" & '0' & x"0C";	-- CEQ @12			#Compara o valor de MEM[12] (inibir centenas)
    tmp(144) := x"7" & '0' & x"92";	-- JEQ @146
    tmp(145) := x"A" & '0' & x"00";	-- RET
    tmp(146) := x"1" & '0' & x"06";	-- LDA @6			#Carrega o valor de MEM[6] (milhar)
    tmp(147) := x"8" & '0' & x"0D";	-- CEQ @13			#Compara o valor de MEM[13] (inibir milhar)
    tmp(148) := x"7" & '0' & x"96";	-- JEQ @150
    tmp(149) := x"A" & '0' & x"00";	-- RET
    tmp(150) := x"1" & '0' & x"07";	-- LDA @7			#Carrega o valor de MEM[7] (dezena de milhar)
    tmp(151) := x"8" & '0' & x"0E";	-- CEQ @14			#Compara o valor de MEM[10] (inibir dezena de milhar)
    tmp(152) := x"7" & '0' & x"9A";	-- JEQ @154
    tmp(153) := x"A" & '0' & x"00";	-- RET
    tmp(154) := x"1" & '0' & x"08";	-- LDA @8			#Carrega o valor de MEM[8] (centena de milhar)
    tmp(155) := x"8" & '0' & x"0F";	-- CEQ @15			#Compara o valor de MEM[10] (inibir centena de milhar)
    tmp(156) := x"7" & '0' & x"9E";	-- JEQ @158
    tmp(157) := x"A" & '0' & x"00";	-- RET
    tmp(158) := x"4" & '0' & x"01";	-- LDI $1			#Carrega o acumulador com o valor 1
    tmp(159) := x"5" & '0' & x"09";	-- STA @9			#Armazena o valor do acumulador em MEM[9] (flag inibir contagem)
    tmp(160) := x"5" & '1' & x"01";	-- STA @257		#Armazena o valor do bit0 do acumulador no LDR8
    tmp(161) := x"A" & '0' & x"00";	-- RET
    tmp(162) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
    tmp(163) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
    tmp(164) := x"5" & '0' & x"0A";	-- STA @10			#Armazena o valor do acumulador em MEM[10] (inibir unidade)
    tmp(165) := x"4" & '0' & x"04";	-- LDI $4			#Carrega o acumulador com o valor 4
    tmp(166) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
    tmp(167) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
    tmp(168) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
    tmp(169) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
    tmp(170) := x"7" & '0' & x"A7";	-- JEQ @167		#Desvia se igual a 0 (botão não foi pressionado)
    tmp(171) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
    tmp(172) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
    tmp(173) := x"5" & '0' & x"0B";	-- STA @11			#Armazena o valor do acumulador em MEM[11] (inibir dezena)
    tmp(174) := x"4" & '0' & x"10";	-- LDI $16			#Carrega o acumulador com o valor 16
    tmp(175) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
    tmp(176) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
    tmp(177) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
    tmp(178) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
    tmp(179) := x"7" & '0' & x"B0";	-- JEQ @176		#Desvia se igual a 0 (botão não foi pressionado)
    tmp(180) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
    tmp(181) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
    tmp(182) := x"5" & '0' & x"0C";	-- STA @12			#Armazena o valor do acumulador em MEM[12] (inibir centena)
    tmp(183) := x"4" & '0' & x"20";	-- LDI $32			#Carrega o acumulador com o valor 32
    tmp(184) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
    tmp(185) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
    tmp(186) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
    tmp(187) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
    tmp(188) := x"7" & '0' & x"B9";	-- JEQ @185		#Desvia se igual a 0 (botão não foi pressionado)
    tmp(189) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
    tmp(190) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
    tmp(191) := x"5" & '0' & x"0D";	-- STA @13			#Armazena o valor do acumulador em MEM[13] (inibir milhar)
    tmp(192) := x"4" & '0' & x"80";	-- LDI $128		#Carrega o acumulador com o valor 128
    tmp(193) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
    tmp(194) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
    tmp(195) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
    tmp(196) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
    tmp(197) := x"7" & '0' & x"C2";	-- JEQ @194		#Desvia se igual a 0 (botão não foi pressionado)
    tmp(198) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
    tmp(199) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
    tmp(200) := x"5" & '0' & x"0E";	-- STA @14			#Armazena o valor do acumulador em MEM[13] (inibir dezena de milhar)
    tmp(201) := x"4" & '0' & x"00";	-- LDI $0			#Carrega o acumulador com o valor 0
    tmp(202) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
    tmp(203) := x"4" & '0' & x"01";	-- LDI $1			#Carrega o acumulador com o valor 1
    tmp(204) := x"5" & '1' & x"02";	-- STA @258		#Armazena o valor do bit0 do acumulador no LDR9
    tmp(205) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
    tmp(206) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
    tmp(207) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
    tmp(208) := x"7" & '0' & x"CD";	-- JEQ @205		#Desvia se igual a 0 (botão não foi pressionado)
    tmp(209) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
    tmp(210) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
    tmp(211) := x"5" & '0' & x"0F";	-- STA @15			#Armazena o valor do acumulador em MEM[15] (inibir centena de milhar)
    tmp(212) := x"4" & '0' & x"00";	-- LDI $0			#Carrega o acumulador com o valor 0
    tmp(213) := x"5" & '1' & x"02";	-- STA @258		#Armazena o valor do bit0 do acumulador no LDR9
    tmp(214) := x"A" & '0' & x"00";	-- RET

      

        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;