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
  constant ADD  : std_logic_vector(3 downto 0) := "0010";
  constant SUB   : std_logic_vector(3 downto 0) := "0011";
  constant LDI   : std_logic_vector(3 downto 0) := "0100";
  constant STA   : std_logic_vector(3 downto 0) := "0101";
  constant JMP   : std_logic_vector(3 downto 0) := "0110";
  constant JEQ   : std_logic_vector(3 downto 0) := "0111";
  constant CEQ   : std_logic_vector(3 downto 0) := "1000";
  constant JSR   : std_logic_vector(3 downto 0) := "1001";
  constant RET   : std_logic_vector(3 downto 0) := "1010";
  constant AND1  : std_logic_vector(3 downto 0) := "1011";

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
        tmp(17) := x"5" & '0' & x"03";	-- STA @3			#Armazena o valor do acumulador em MEM[3] (milhares)
        tmp(18) := x"5" & '0' & x"04";	-- STA @4			#Armazena o valor do acumulador em MEM[4] (dezenas de milhares)
        tmp(19) := x"5" & '0' & x"05";	-- STA @5			#Armazena o valor do acumulador em MEM[5] (centenas de milhares)
        tmp(20) := x"5" & '0' & x"06";	-- STA @6			#Armazena o valor do acumulador em MEM[6] (flag inibir contagem)
        tmp(21) := x"4" & '0' & x"09";	-- LDI $9			#Carrega o acumulador com o valor 9
        tmp(22) := x"5" & '0' & x"0A";	-- STA @10			#Armazena o valor do acumulador em MEM[10] (inibir unidade)
        tmp(23) := x"5" & '0' & x"0B";	-- STA @11			#Armazena o valor do acumulador em MEM[11] (inibir dezena)
        tmp(24) := x"5" & '0' & x"0C";	-- STA @12			#Armazena o valor do acumulador em MEM[12] (inibir centena)
        tmp(25) := x"5" & '0' & x"0D";	-- STA @13			#Armazena o valor do acumulador em MEM[13] (inibir milhar)
        tmp(26) := x"5" & '0' & x"0E";	-- STA @14			#Armazena o valor do acumulador em MEM[14] (inibir dezena de milhar)
        tmp(27) := x"5" & '0' & x"0F";	-- STA @15			#Armazena o valor do acumulador em MEM[15] (inibir centena de milhar)
        tmp(28) := x"0" & '0' & x"00";	-- NOP
        tmp(29) := x"5" & '1' & x"FF";	-- STA @511		#Limpa a leitura do botão zero
        tmp(30) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
        tmp(31) := x"0" & '0' & x"00";	-- NOP		
        tmp(32) := x"1" & '1' & x"60";	-- LDA @352		#Carrega o acumulador com a leitura do botão KEY0
        tmp(33) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
        tmp(34) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
        tmp(35) := x"7" & '0' & x"26";	-- JEQ @38		#Desvia se igual a 0 (botão não foi pressionado)
        tmp(36) := x"9" & '0' & x"38";	-- JSR @56		#O botão foi pressionado, chama a sub-rotina de incremento
        tmp(37) := x"0" & '0' & x"00";	-- NOP 			#Retorno da sub-rotina de incremento
        tmp(38) := x"9" & '0' & x"69";	-- JSR @105 	#Escreve o valor das váriaveis de contagem nos displays
        tmp(39) := x"0" & '0' & x"00";	-- NOP			#Retorno da sub-rotina de salvar nos displays
        tmp(40) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
        tmp(41) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
        tmp(42) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
        tmp(43) := x"7" & '0' & x"2E";	-- JEQ @46		#Desvia se igual a 0 (botão não foi pressionado)
        tmp(44) := x"9" & '0' & x"9C";	-- JSR @156		#O botão foi pressionado, chama a sub-rotina de incremento
        tmp(45) := x"0" & '0' & x"00";	-- NOP 			#Retorno da sub-rotina de definir limite
        tmp(46) := x"9" & '0' & x"80";	-- JSR @128
        tmp(47) := x"0" & '0' & x"00";	-- NOP			#Retorno da sub-rotina de verificar limite
        tmp(48) := x"1" & '1' & x"64";	-- LDA @356		#Carrega o acumulador com a leitura do botão FPGA_RESET
        tmp(49) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
        tmp(50) := x"D" & '0' & x"01";	-- CEQi $1			#Compara com constante 1
        tmp(51) := x"7" & '0' & x"35";	-- JEQ @53		#Desvia se igual a 1 (botão não foi pressionado)
        tmp(52) := x"9" & '0' & x"76";	-- JSR @118		#O botão foi pressionado, chama a sub-rotina de reset
        tmp(53) := x"0" & '0' & x"00";	-- NOP			#Retorno da sub-rotina de reset
        tmp(54) := x"6" & '0' & x"1F";	-- JMP @31		#Fecha o laço principal, faz uma nova leitura de KEY0
        tmp(55) := x"0" & '0' & x"00";	-- NOP
        tmp(56) := x"5" & '1' & x"FF";	-- STA @511		#Limpa a leitura do botão
        tmp(57) := x"1" & '0' & x"09";	-- LDA @9			#Carrega o valor de MEM[6] (flag inibir contagem)
        tmp(58) := x"D" & '0' & x"00";	-- CEQi $0			#Compara o valor com constante 0
        tmp(59) := x"7" & '0' & x"3D";	-- JEQ @61
        tmp(60) := x"A" & '0' & x"00";	-- RET
        tmp(61) := x"1" & '0' & x"00";	-- LDA @0			#Carrega o valor de MEM[0] (contador)
        tmp(62) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
        tmp(63) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
        tmp(64) := x"7" & '0' & x"43";	-- JEQ @67		#Realiza o carry out caso valor igual a 10
        tmp(65) := x"5" & '0' & x"00";	-- STA @0			#Salva o incremento em MEM[0] (contador)
        tmp(66) := x"A" & '0' & x"00";	-- RET			#Retorna da sub-rotina
        tmp(67) := x"1" & '0' & x"03";	-- LDA @3			#Carrega valor de MEM[3] no acumulador (constante 0)
        tmp(68) := x"5" & '0' & x"00";	-- STA @0			#Armazena o valor do acumulador em MEM[0] (unidades)
        tmp(69) := x"1" & '0' & x"01";	-- LDA @1			#Carrega valor de MEM[1] no acumulador (dezenas)
        tmp(70) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
        tmp(71) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
        tmp(72) := x"7" & '0' & x"4B";	-- JEQ @75		#Realiza o carry out caso valor igual a 10
        tmp(73) := x"5" & '0' & x"01";	-- STA @1			#Salva o incremento em MEM[1] (dezenas)
        tmp(74) := x"A" & '0' & x"00";	-- RET
        tmp(75) := x"1" & '0' & x"03";	-- LDA @3			#Carrega valor de MEM[3] no acumulador (constante 0)
        tmp(76) := x"5" & '0' & x"01";	-- STA @1			#Armazena o valor do acumulador em MEM[1] (dezenas)
        tmp(77) := x"1" & '0' & x"02";	-- LDA @2			#Carrega valor de MEM[2] no acumulador (centenas)
        tmp(78) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
        tmp(79) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
        tmp(80) := x"7" & '0' & x"53";	-- JEQ @83		#Realiza o carry out caso valor igual a 10
        tmp(81) := x"5" & '0' & x"02";	-- STA @2			#Salva o incremento em MEM[2] (centenas)
        tmp(82) := x"A" & '0' & x"00";	-- RET
        tmp(83) := x"1" & '0' & x"03";	-- LDA @3			#Carrega valor de MEM[3] no acumulador (constante 0)
        tmp(84) := x"5" & '0' & x"02";	-- STA @2			#Armazena o valor do acumulador em MEM[2] (centenas)
        tmp(85) := x"1" & '0' & x"06";	-- LDA @6			#Carrega valor de MEM[3] no acumulador (milhares)
        tmp(86) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
        tmp(87) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
        tmp(88) := x"7" & '0' & x"5B";	-- JEQ @91		#Realiza o carry out caso valor igual a 10
        tmp(89) := x"5" & '0' & x"03";	-- STA @3			#Salva o incremento em MEM[3] (milhares)
        tmp(90) := x"A" & '0' & x"00";	-- RET
        tmp(91) := x"1" & '0' & x"03";	-- LDA @3			#Carrega valor de MEM[3] no acumulador (constante 0)
        tmp(92) := x"5" & '0' & x"03";	-- STA @3			#Armazena o valor do acumulador em MEM[3] (milhares)
        tmp(93) := x"1" & '0' & x"07";	-- LDA @7			#Carrega valor de MEM[4] no acumulador (dezenas de milhares)
        tmp(94) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
        tmp(95) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
        tmp(96) := x"7" & '0' & x"63";	-- JEQ @99		#Realiza o carry out caso valor igual a 10
        tmp(97) := x"5" & '0' & x"04";	-- STA @4			#Salva o incremento em MEM[4] (dezenas de milhares)
        tmp(98) := x"A" & '0' & x"00";	-- RET
        tmp(99) := x"1" & '0' & x"03";	-- LDA @3			#Carrega valor de MEM[3] no acumulador (constante 0)
        tmp(100) := x"5" & '0' & x"04";	-- STA @4			#Armazena o valor do acumulador em MEM[3] (milhares)
        tmp(101) := x"1" & '0' & x"08";	-- LDA @8			#Carrega valor de MEM[4] no acumulador (dezenas de milhares)
        tmp(102) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
        tmp(103) := x"5" & '0' & x"04";	-- STA @4			#Salva o incremento em MEM[4] (dezenas de milhares)
        tmp(104) := x"A" & '0' & x"00";	-- RET
        tmp(105) := x"1" & '0' & x"00";	-- LDA @0 			#Carrega o valor de MEM[0] (unidades)
        tmp(106) := x"5" & '1' & x"20";	-- STA @288 		#Armazena valor do acumulador de unidades no HEX0
        tmp(107) := x"1" & '0' & x"01";	-- LDA @1 			#Carrega o valor de MEM[1] (dezenas)
        tmp(108) := x"5" & '1' & x"21";	-- STA @289 		#Armazena valor do acumulador de dezenas no HEX1
        tmp(109) := x"1" & '0' & x"02";	-- LDA @2 			#Carrega o valor de MEM[2] (centenas)
        tmp(110) := x"5" & '1' & x"22";	-- STA @290 		#Armazena valor do acumulador de centenas no HEX2
        tmp(111) := x"1" & '0' & x"06";	-- LDA @6 			#Carrega o valor de MEM[3] (milhares)
        tmp(112) := x"5" & '1' & x"23";	-- STA @291 		#Armazena valor do acumulador de unidades no HEX3
        tmp(113) := x"1" & '0' & x"07";	-- LDA @7 			#Carrega o valor de MEM[4] (dezenas de milhares)
        tmp(114) := x"5" & '1' & x"24";	-- STA @292 		#Armazena valor do acumulador de dezenas no HEX4
        tmp(115) := x"1" & '0' & x"08";	-- LDA @8 			#Carrega o valor de MEM[5] (centenas de milhares)
        tmp(116) := x"5" & '1' & x"25";	-- STA @293 		#Armazena valor do acumulador de centenas no HEX5
        tmp(117) := x"A" & '0' & x"00";	-- RET
        tmp(118) := x"4" & '0' & x"00";	-- LDI $0			#Carrega o acumulador com o valor 0
        tmp(119) := x"5" & '0' & x"00";	-- STA @0	 		#Armazena o valor do acumulador na MEM[0] (unidades)
        tmp(120) := x"5" & '0' & x"01";	-- STA @1	 		#Armazena o valor do acumulador na MEM[1] (dezenas)
        tmp(121) := x"5" & '0' & x"02";	-- STA @2	 		#Armazena o valor do acumulador na MEM[2] (centenas)
        tmp(122) := x"5" & '0' & x"03";	-- STA @3	 		#Armazena o valor do acumulador na MEM[3] (milhar)
        tmp(123) := x"5" & '0' & x"04";	-- STA @4	 		#Armazena o valor do acumulador na MEM[4] (dezena de milhar)
        tmp(124) := x"5" & '0' & x"05";	-- STA @5	 		#Armazena o valor do acumulador na MEM[5] (centena de milhar)
        tmp(125) := x"5" & '0' & x"06";	-- STA @6	 		#Armazena o valor do acumulador na MEM[6] (flag inibir contagem)
        tmp(126) := x"5" & '1' & x"01";	-- STA @257		#Armazena o valor do bit0 do acumulador no LDR8
        tmp(127) := x"A" & '0' & x"00";	-- RET
        tmp(128) := x"1" & '0' & x"00";	-- LDA @0			#Carrega o valor de MEM[0] (unidades)
        tmp(129) := x"8" & '0' & x"0A";	-- CEQ @10			#Compara o valor de MEM[10] (inibir unidade)
        tmp(130) := x"7" & '0' & x"84";	-- JEQ @132
        tmp(131) := x"A" & '0' & x"00";	-- RET
        tmp(132) := x"1" & '0' & x"01";	-- LDA @1			#Carrega o valor de MEM[1] (dezenas)
        tmp(133) := x"8" & '0' & x"0B";	-- CEQ @11			#Compara o valor de MEM[11] (inibir dezenas)
        tmp(134) := x"7" & '0' & x"88";	-- JEQ @136
        tmp(135) := x"A" & '0' & x"00";	-- RET
        tmp(136) := x"1" & '0' & x"02";	-- LDA @2			#Carrega o valor de MEM[2] (centenas)
        tmp(137) := x"8" & '0' & x"0C";	-- CEQ @12			#Compara o valor de MEM[12] (inibir centenas)
        tmp(138) := x"7" & '0' & x"8C";	-- JEQ @140
        tmp(139) := x"A" & '0' & x"00";	-- RET
        tmp(140) := x"1" & '0' & x"06";	-- LDA @6			#Carrega o valor de MEM[3] (milhar)
        tmp(141) := x"8" & '0' & x"0D";	-- CEQ @13			#Compara o valor de MEM[13] (inibir milhar)
        tmp(142) := x"7" & '0' & x"90";	-- JEQ @144
        tmp(143) := x"A" & '0' & x"00";	-- RET
        tmp(144) := x"1" & '0' & x"07";	-- LDA @7			#Carrega o valor de MEM[4] (dezena de milhar)
        tmp(145) := x"8" & '0' & x"0E";	-- CEQ @14			#Compara o valor de MEM[10] (inibir dezena de milhar)
        tmp(146) := x"7" & '0' & x"94";	-- JEQ @148
        tmp(147) := x"A" & '0' & x"00";	-- RET
        tmp(148) := x"1" & '0' & x"08";	-- LDA @8			#Carrega o valor de MEM[5] (centena de milhar)
        tmp(149) := x"8" & '0' & x"0F";	-- CEQ @15			#Compara o valor de MEM[10] (inibir centena de milhar)
        tmp(150) := x"7" & '0' & x"98";	-- JEQ @152
        tmp(151) := x"A" & '0' & x"00";	-- RET
        tmp(152) := x"4" & '0' & x"01";	-- LDI $1			#Carrega o acumulador com o valor 1
        tmp(153) := x"5" & '0' & x"06";	-- STA @6			#Armazena o valor do acumulador em MEM[6] (flag inibir contagem)
        tmp(154) := x"5" & '1' & x"01";	-- STA @257		#Armazena o valor do bit0 do acumulador no LDR8
        tmp(155) := x"A" & '0' & x"00";	-- RET
        tmp(156) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
        tmp(157) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
        tmp(158) := x"5" & '0' & x"0A";	-- STA @10			#Armazena o valor do acumulador em MEM[10] (inibir unidade)
        tmp(159) := x"4" & '0' & x"04";	-- LDI $4			#Carrega o acumulador com o valor 4
        tmp(160) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
        tmp(161) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
        tmp(162) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
        tmp(163) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
        tmp(164) := x"7" & '0' & x"A1";	-- JEQ @161		#Desvia se igual a 0 (botão não foi pressionado)
        tmp(165) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
        tmp(166) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
        tmp(167) := x"5" & '0' & x"0B";	-- STA @11			#Armazena o valor do acumulador em MEM[11] (inibir dezena)
        tmp(168) := x"4" & '0' & x"10";	-- LDI $16			#Carrega o acumulador com o valor 16
        tmp(169) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
        tmp(170) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
        tmp(171) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
        tmp(172) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
        tmp(173) := x"7" & '0' & x"AA";	-- JEQ @170		#Desvia se igual a 0 (botão não foi pressionado)
        tmp(174) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
        tmp(175) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
        tmp(176) := x"5" & '0' & x"0C";	-- STA @12			#Armazena o valor do acumulador em MEM[12] (inibir centena)
        tmp(177) := x"4" & '0' & x"20";	-- LDI $32			#Carrega o acumulador com o valor 32
        tmp(178) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
        tmp(179) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
        tmp(180) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
        tmp(181) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
        tmp(182) := x"7" & '0' & x"B3";	-- JEQ @179		#Desvia se igual a 0 (botão não foi pressionado)
        tmp(183) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
        tmp(184) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
        tmp(185) := x"5" & '0' & x"0D";	-- STA @13			#Armazena o valor do acumulador em MEM[13] (inibir milhar)
        tmp(186) := x"4" & '0' & x"80";	-- LDI $128		#Carrega o acumulador com o valor 128
        tmp(187) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
        tmp(188) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
        tmp(189) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
        tmp(190) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
        tmp(191) := x"7" & '0' & x"BC";	-- JEQ @188		#Desvia se igual a 0 (botão não foi pressionado)
        tmp(192) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
        tmp(193) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
        tmp(194) := x"5" & '0' & x"0E";	-- STA @14			#Armazena o valor do acumulador em MEM[13] (inibir dezena de milhar)
        tmp(195) := x"4" & '0' & x"00";	-- LDI $0			#Carrega o acumulador com o valor 0
        tmp(196) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
        tmp(197) := x"4" & '0' & x"01";	-- LDI $1			#Carrega o acumulador com o valor 1
        tmp(198) := x"5" & '1' & x"02";	-- STA @258		#Armazena o valor do bit0 do acumulador no LDR9
        tmp(199) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
        tmp(200) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
        tmp(201) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
        tmp(202) := x"7" & '0' & x"C7";	-- JEQ @199		#Desvia se igual a 0 (botão não foi pressionado)
        tmp(203) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
        tmp(204) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
        tmp(205) := x"5" & '0' & x"0F";	-- STA @15			#Armazena o valor do acumulador em MEM[15] (inibir centena de milhar)
        tmp(206) := x"4" & '0' & x"00";	-- LDI $0			#Carrega o acumulador com o valor 0
        tmp(207) := x"5" & '1' & x"02";	-- STA @258		#Armazena o valor do bit0 do acumulador no LDR9
        tmp(208) := x"A" & '0' & x"00";	-- RET

      

        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;