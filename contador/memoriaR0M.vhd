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
tmp(42) := x"9" & '0' & x"44";	-- JSR @68		#O botão foi pressionado, chama a sub-rotina de incremento
tmp(43) := x"0" & '0' & x"00";	-- NOP 			#Retorno da sub-rotina de incremento
tmp(44) := x"9" & '0' & x"75";	-- JSR @117 	#Escreve o valor das váriaveis de contagem nos displays
tmp(45) := x"0" & '0' & x"00";	-- NOP			#Retorno da sub-rotina de salvar nos displays
tmp(46) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
tmp(47) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(48) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
tmp(49) := x"7" & '0' & x"34";	-- JEQ @52		#Desvia se igual a 0 (botão não foi pressionado)
tmp(50) := x"9" & '0' & x"A8";	-- JSR @168		#O botão foi pressionado, chama a sub-rotina de incremento
tmp(51) := x"0" & '0' & x"00";	-- NOP 			#Retorno da sub-rotina de definir limite
tmp(52) := x"9" & '0' & x"8C";	-- JSR @140
tmp(53) := x"0" & '0' & x"00";	-- NOP			#Retorno da sub-rotina de verificar limite
tmp(54) := x"1" & '1' & x"62";	-- LDA @354		#Carrega o acumulador com a leitura do botão KEY2
tmp(55) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(56) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
tmp(57) := x"7" & '0' & x"3C";	-- JEQ @60		#Desvia se igual a 0 (botão não foi pressionado)
tmp(58) := x"9" & '0' & x"DD";	-- JSR @221		#O botão foi pressionado, chama a sub-rotina de incremento
tmp(59) := x"0" & '0' & x"00";	-- NOP 			#Retorno da sub-rotina de incremento
tmp(60) := x"1" & '1' & x"64";	-- LDA @356		#Carrega o acumulador com a leitura do botão FPGA_RESET
tmp(61) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(62) := x"D" & '0' & x"01";	-- CEQi $1			#Compara com constante 1
tmp(63) := x"7" & '0' & x"41";	-- JEQ @65		#Desvia se igual a 1 (botão não foi pressionado)
tmp(64) := x"9" & '0' & x"82";	-- JSR @130		#O botão foi pressionado, chama a sub-rotina de reset
tmp(65) := x"0" & '0' & x"00";	-- NOP			#Retorno da sub-rotina de reset
tmp(66) := x"6" & '0' & x"25";	-- JMP @37		#Fecha o laço principal, faz uma nova leitura de KEY0
tmp(67) := x"0" & '0' & x"00";	-- NOP
tmp(68) := x"5" & '1' & x"FF";	-- STA @511		#Limpa a leitura do botão
tmp(69) := x"1" & '0' & x"09";	-- LDA @9			#Carrega o valor de MEM[9] (flag inibir contagem)
tmp(70) := x"D" & '0' & x"00";	-- CEQi $0			#Compara o valor com constante 0
tmp(71) := x"7" & '0' & x"49";	-- JEQ @73
tmp(72) := x"A" & '0' & x"00";	-- RET
tmp(73) := x"1" & '0' & x"00";	-- LDA @0			#Carrega o valor de MEM[0] (contador)
tmp(74) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
tmp(75) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
tmp(76) := x"7" & '0' & x"4F";	-- JEQ @79		#Realiza o carry out caso valor igual a 10
tmp(77) := x"5" & '0' & x"00";	-- STA @0			#Salva o incremento em MEM[0] (contador)
tmp(78) := x"A" & '0' & x"00";	-- RET			#Retorna da sub-rotina
tmp(79) := x"1" & '0' & x"03";	-- LDA @3			#Carrega valor de MEM[3] no acumulador (constante 0)
tmp(80) := x"5" & '0' & x"00";	-- STA @0			#Armazena o valor do acumulador em MEM[0] (unidades)
tmp(81) := x"1" & '0' & x"01";	-- LDA @1			#Carrega valor de MEM[1] no acumulador (dezenas)
tmp(82) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
tmp(83) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
tmp(84) := x"7" & '0' & x"57";	-- JEQ @87		#Realiza o carry out caso valor igual a 10
tmp(85) := x"5" & '0' & x"01";	-- STA @1			#Salva o incremento em MEM[1] (dezenas)
tmp(86) := x"A" & '0' & x"00";	-- RET
tmp(87) := x"1" & '0' & x"03";	-- LDA @3			#Carrega valor de MEM[3] no acumulador (constante 0)
tmp(88) := x"5" & '0' & x"01";	-- STA @1			#Armazena o valor do acumulador em MEM[1] (dezenas)
tmp(89) := x"1" & '0' & x"02";	-- LDA @2			#Carrega valor de MEM[2] no acumulador (centenas)
tmp(90) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
tmp(91) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
tmp(92) := x"7" & '0' & x"5F";	-- JEQ @95		#Realiza o carry out caso valor igual a 10
tmp(93) := x"5" & '0' & x"02";	-- STA @2			#Salva o incremento em MEM[2] (centenas)
tmp(94) := x"A" & '0' & x"00";	-- RET
tmp(95) := x"1" & '0' & x"03";	-- LDA @3			#Carrega valor de MEM[3] no acumulador (constante 0)
tmp(96) := x"5" & '0' & x"02";	-- STA @2			#Armazena o valor do acumulador em MEM[2] (centenas)
tmp(97) := x"1" & '0' & x"06";	-- LDA @6			#Carrega valor de MEM[6] no acumulador (milhares)
tmp(98) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
tmp(99) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
tmp(100) := x"7" & '0' & x"67";	-- JEQ @103		#Realiza o carry out caso valor igual a 10
tmp(101) := x"5" & '0' & x"06";	-- STA @6			#Salva o incremento em MEM[6] (milhares)
tmp(102) := x"A" & '0' & x"00";	-- RET
tmp(103) := x"1" & '0' & x"03";	-- LDA @3			#Carrega valor de MEM[3] no acumulador (constante 0)
tmp(104) := x"5" & '0' & x"06";	-- STA @6			#Armazena o valor do acumulador em MEM[6] (milhares)
tmp(105) := x"1" & '0' & x"07";	-- LDA @7			#Carrega valor de MEM[7] no acumulador (dezenas de milhares)
tmp(106) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
tmp(107) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
tmp(108) := x"7" & '0' & x"6F";	-- JEQ @111		#Realiza o carry out caso valor igual a 10
tmp(109) := x"5" & '0' & x"07";	-- STA @7			#Salva o incremento em MEM[7] (dezenas de milhares)
tmp(110) := x"A" & '0' & x"00";	-- RET
tmp(111) := x"1" & '0' & x"03";	-- LDA @3			#Carrega valor de MEM[3] no acumulador (constante 0)
tmp(112) := x"5" & '0' & x"07";	-- STA @7			#Armazena o valor do acumulador em MEM[6] (milhares)
tmp(113) := x"1" & '0' & x"08";	-- LDA @8			#Carrega valor de MEM[7] no acumulador (dezenas de milhares)
tmp(114) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
tmp(115) := x"5" & '0' & x"07";	-- STA @7			#Salva o incremento em MEM[7] (dezenas de milhares)
tmp(116) := x"A" & '0' & x"00";	-- RET
tmp(117) := x"1" & '0' & x"00";	-- LDA @0 			#Carrega o valor de MEM[0] (unidades)
tmp(118) := x"5" & '1' & x"20";	-- STA @288 		#Armazena valor do acumulador de unidades no HEX0
tmp(119) := x"1" & '0' & x"01";	-- LDA @1 			#Carrega o valor de MEM[1] (dezenas)
tmp(120) := x"5" & '1' & x"21";	-- STA @289 		#Armazena valor do acumulador de dezenas no HEX1
tmp(121) := x"1" & '0' & x"02";	-- LDA @2 			#Carrega o valor de MEM[2] (centenas)
tmp(122) := x"5" & '1' & x"22";	-- STA @290 		#Armazena valor do acumulador de centenas no HEX2
tmp(123) := x"1" & '0' & x"06";	-- LDA @6 			#Carrega o valor de MEM[6] (milhares)
tmp(124) := x"5" & '1' & x"23";	-- STA @291 		#Armazena valor do acumulador de unidades no HEX3
tmp(125) := x"1" & '0' & x"07";	-- LDA @7 			#Carrega o valor de MEM[7] (dezenas de milhares)
tmp(126) := x"5" & '1' & x"24";	-- STA @292 		#Armazena valor do acumulador de dezenas no HEX4
tmp(127) := x"1" & '0' & x"08";	-- LDA @8 			#Carrega o valor de MEM[8] (centenas de milhares)
tmp(128) := x"5" & '1' & x"25";	-- STA @293 		#Armazena valor do acumulador de centenas no HEX5
tmp(129) := x"A" & '0' & x"00";	-- RET
tmp(130) := x"4" & '0' & x"00";	-- LDI $0			#Carrega o acumulador com o valor 0
tmp(131) := x"5" & '0' & x"00";	-- STA @0	 		#Armazena o valor do acumulador na MEM[0] (unidades)
tmp(132) := x"5" & '0' & x"01";	-- STA @1	 		#Armazena o valor do acumulador na MEM[1] (dezenas)
tmp(133) := x"5" & '0' & x"02";	-- STA @2	 		#Armazena o valor do acumulador na MEM[2] (centenas)
tmp(134) := x"5" & '0' & x"06";	-- STA @6	 		#Armazena o valor do acumulador na MEM[6] (milhar)
tmp(135) := x"5" & '0' & x"07";	-- STA @7	 		#Armazena o valor do acumulador na MEM[7] (dezena de milhar)
tmp(136) := x"5" & '0' & x"08";	-- STA @8	 		#Armazena o valor do acumulador na MEM[8] (centena de milhar)
tmp(137) := x"5" & '0' & x"09";	-- STA @9	 		#Armazena o valor do acumulador na MEM[9] (flag inibir contagem)
tmp(138) := x"5" & '1' & x"01";	-- STA @257		#Armazena o valor do bit0 do acumulador no LDR8
tmp(139) := x"A" & '0' & x"00";	-- RET
tmp(140) := x"1" & '0' & x"00";	-- LDA @0			#Carrega o valor de MEM[0] (unidades)
tmp(141) := x"8" & '0' & x"0A";	-- CEQ @10			#Compara o valor de MEM[10] (inibir unidade)
tmp(142) := x"7" & '0' & x"90";	-- JEQ @144
tmp(143) := x"A" & '0' & x"00";	-- RET
tmp(144) := x"1" & '0' & x"01";	-- LDA @1			#Carrega o valor de MEM[1] (dezenas)
tmp(145) := x"8" & '0' & x"0B";	-- CEQ @11			#Compara o valor de MEM[11] (inibir dezenas)
tmp(146) := x"7" & '0' & x"94";	-- JEQ @148
tmp(147) := x"A" & '0' & x"00";	-- RET
tmp(148) := x"1" & '0' & x"02";	-- LDA @2			#Carrega o valor de MEM[2] (centenas)
tmp(149) := x"8" & '0' & x"0C";	-- CEQ @12			#Compara o valor de MEM[12] (inibir centenas)
tmp(150) := x"7" & '0' & x"98";	-- JEQ @152
tmp(151) := x"A" & '0' & x"00";	-- RET
tmp(152) := x"1" & '0' & x"06";	-- LDA @6			#Carrega o valor de MEM[6] (milhar)
tmp(153) := x"8" & '0' & x"0D";	-- CEQ @13			#Compara o valor de MEM[13] (inibir milhar)
tmp(154) := x"7" & '0' & x"9C";	-- JEQ @156
tmp(155) := x"A" & '0' & x"00";	-- RET
tmp(156) := x"1" & '0' & x"07";	-- LDA @7			#Carrega o valor de MEM[7] (dezena de milhar)
tmp(157) := x"8" & '0' & x"0E";	-- CEQ @14			#Compara o valor de MEM[10] (inibir dezena de milhar)
tmp(158) := x"7" & '0' & x"A0";	-- JEQ @160
tmp(159) := x"A" & '0' & x"00";	-- RET
tmp(160) := x"1" & '0' & x"08";	-- LDA @8			#Carrega o valor de MEM[8] (centena de milhar)
tmp(161) := x"8" & '0' & x"0F";	-- CEQ @15			#Compara o valor de MEM[10] (inibir centena de milhar)
tmp(162) := x"7" & '0' & x"A4";	-- JEQ @164
tmp(163) := x"A" & '0' & x"00";	-- RET
tmp(164) := x"4" & '0' & x"01";	-- LDI $1			#Carrega o acumulador com o valor 1
tmp(165) := x"5" & '0' & x"09";	-- STA @9			#Armazena o valor do acumulador em MEM[9] (flag inibir contagem)
tmp(166) := x"5" & '1' & x"01";	-- STA @257		#Armazena o valor do bit0 do acumulador no LDR8
tmp(167) := x"A" & '0' & x"00";	-- RET
tmp(168) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
tmp(169) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
tmp(170) := x"5" & '0' & x"0A";	-- STA @10			#Armazena o valor do acumulador em MEM[10] (inibir unidade)
tmp(171) := x"4" & '0' & x"04";	-- LDI $4			#Carrega o acumulador com o valor 4
tmp(172) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(173) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
tmp(174) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(175) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
tmp(176) := x"7" & '0' & x"AD";	-- JEQ @173		#Desvia se igual a 0 (botão não foi pressionado)
tmp(177) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
tmp(178) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
tmp(179) := x"5" & '0' & x"0B";	-- STA @11			#Armazena o valor do acumulador em MEM[11] (inibir dezena)
tmp(180) := x"4" & '0' & x"10";	-- LDI $16			#Carrega o acumulador com o valor 16
tmp(181) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(182) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
tmp(183) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(184) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
tmp(185) := x"7" & '0' & x"B6";	-- JEQ @182		#Desvia se igual a 0 (botão não foi pressionado)
tmp(186) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
tmp(187) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
tmp(188) := x"5" & '0' & x"0C";	-- STA @12			#Armazena o valor do acumulador em MEM[12] (inibir centena)
tmp(189) := x"4" & '0' & x"20";	-- LDI $32			#Carrega o acumulador com o valor 32
tmp(190) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(191) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
tmp(192) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(193) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
tmp(194) := x"7" & '0' & x"BF";	-- JEQ @191		#Desvia se igual a 0 (botão não foi pressionado)
tmp(195) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
tmp(196) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
tmp(197) := x"5" & '0' & x"0D";	-- STA @13			#Armazena o valor do acumulador em MEM[13] (inibir milhar)
tmp(198) := x"4" & '0' & x"80";	-- LDI $128		#Carrega o acumulador com o valor 128
tmp(199) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(200) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
tmp(201) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(202) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
tmp(203) := x"7" & '0' & x"C8";	-- JEQ @200		#Desvia se igual a 0 (botão não foi pressionado)
tmp(204) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
tmp(205) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
tmp(206) := x"5" & '0' & x"0E";	-- STA @14			#Armazena o valor do acumulador em MEM[13] (inibir dezena de milhar)
tmp(207) := x"4" & '0' & x"00";	-- LDI $0			#Carrega o acumulador com o valor 0
tmp(208) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(209) := x"4" & '0' & x"01";	-- LDI $1			#Carrega o acumulador com o valor 1
tmp(210) := x"5" & '1' & x"02";	-- STA @258		#Armazena o valor do bit0 do acumulador no LDR9
tmp(211) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
tmp(212) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(213) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
tmp(214) := x"7" & '0' & x"D3";	-- JEQ @211		#Desvia se igual a 0 (botão não foi pressionado)
tmp(215) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
tmp(216) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
tmp(217) := x"5" & '0' & x"0F";	-- STA @15			#Armazena o valor do acumulador em MEM[15] (inibir centena de milhar)
tmp(218) := x"4" & '0' & x"00";	-- LDI $0			#Carrega o acumulador com o valor 0
tmp(219) := x"5" & '1' & x"02";	-- STA @258		#Armazena o valor do bit0 do acumulador no LDR9
tmp(220) := x"A" & '0' & x"00";	-- RET
tmp(221) := x"5" & '1' & x"FD";	-- STA @509		#Limpa a leitura do botão KEY2
tmp(222) := x"6" & '0' & x"E0";	-- JMP @224
tmp(223) := x"A" & '0' & x"00";	-- RET
tmp(224) := x"1" & '0' & x"00";	-- LDA @0          	# Carrega MEM[0] (unidades) no acumulador
tmp(225) := x"D" & '0' & x"00";	-- CEQi $0         	# Verifica se MEM[0] == 0
tmp(226) := x"7" & '0' & x"E6";	-- JEQ @230    	# Se MEM[0] == 0, realiza o "empréstimo"  
tmp(227) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[0]
tmp(228) := x"5" & '0' & x"00";	-- STA @0          	# Armazena o novo valor de MEM[0]
tmp(229) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina
tmp(230) := x"4" & '0' & x"09";	-- LDI $9          	# Carrega 9 no acumulador
tmp(231) := x"5" & '0' & x"00";	-- STA @0          	# Define MEM[0] para 9
tmp(232) := x"1" & '0' & x"01";	-- LDA @1          	# Carrega MEM[1] (dezenas) no acumulador
tmp(233) := x"D" & '0' & x"00";	-- CEQi $0         	# Verifica se MEM[1] == 0
tmp(234) := x"7" & '0' & x"EE";	-- JEQ @238    	# Se MEM[1] == 0, realiza o próximo "empréstimo"
tmp(235) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[1]
tmp(236) := x"5" & '0' & x"01";	-- STA @1          	# Armazena o novo valor de MEM[1]
tmp(237) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina
tmp(238) := x"4" & '0' & x"09";	-- LDI $9          	# Carrega 9 no acumulador
tmp(239) := x"5" & '0' & x"01";	-- STA @1          	# Define MEM[1] para 9
tmp(240) := x"1" & '0' & x"02";	-- LDA @2          	# Carrega MEM[2] (centenas) no acumulador
tmp(241) := x"D" & '0' & x"00";	-- CEQi $0         	# Verifica se MEM[2] == 0
tmp(242) := x"7" & '0' & x"F6";	-- JEQ @246    	# Se MEM[2] == 0, realiza o próximo "empréstimo"
tmp(243) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[2]
tmp(244) := x"5" & '0' & x"02";	-- STA @2          	# Armazena o novo valor de MEM[2]
tmp(245) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina
tmp(246) := x"4" & '0' & x"09";	-- LDI $9          	# Carrega 9 no acumulador
tmp(247) := x"5" & '0' & x"02";	-- STA @2          	# Define MEM[2] para 9
tmp(248) := x"1" & '0' & x"06";	-- LDA @6          	# Carrega MEM[3] (milhares) no acumulador
tmp(249) := x"D" & '0' & x"00";	-- CEQi $0         	# Verifica se MEM[3] == 0
tmp(250) := x"7" & '0' & x"FE";	-- JEQ @254   	# Se MEM[3] == 0, realiza o próximo "empréstimo"
tmp(251) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[3]
tmp(252) := x"5" & '0' & x"06";	-- STA @6          	# Armazena o novo valor de MEM[3]
tmp(253) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina
tmp(254) := x"4" & '0' & x"09";	-- LDI $9          	# Carrega 9 no acumulador
tmp(255) := x"5" & '0' & x"03";	-- STA @3          	# Define MEM[3] para 9
tmp(256) := x"1" & '0' & x"07";	-- LDA @7          	# Carrega MEM[4] (dezenas de milhares) no acumulador
tmp(257) := x"D" & '0' & x"00";	-- CEQi $0         	# Verifica se MEM[4] == 0
tmp(258) := x"7" & '1' & x"06";	-- JEQ @262   	# Se MEM[4] == 0, realiza o próximo "empréstimo"
tmp(259) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[4]
tmp(260) := x"5" & '0' & x"07";	-- STA @7          	# Armazena o novo valor de MEM[4]
tmp(261) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina
tmp(262) := x"4" & '0' & x"09";	-- LDI $9          	# Carrega 9 no acumulador
tmp(263) := x"5" & '0' & x"04";	-- STA @4          	# Define MEM[4] para 9
tmp(264) := x"1" & '0' & x"08";	-- LDA @8          	# Carrega MEM[5] (centenas de milhares) no acumulador
tmp(265) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[5]
tmp(266) := x"5" & '0' & x"08";	-- STA @8          	# Armazena o novo valor de MEM[5]
tmp(267) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina

        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;