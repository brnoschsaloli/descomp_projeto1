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
tmp(28) := x"0" & '0' & x"00";	-- NOP
tmp(29) := x"5" & '1' & x"FF";	-- STA @511		#Limpa a leitura do botão zero
tmp(30) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
tmp(31) := x"0" & '0' & x"00";	-- NOP		
tmp(32) := x"1" & '1' & x"60";	-- LDA @352		#Carrega o acumulador com a leitura do botão KEY0
tmp(33) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(34) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
tmp(35) := x"7" & '0' & x"26";	-- JEQ @38		#Desvia se igual a 0 (botão não foi pressionado)
tmp(36) := x"9" & '0' & x"3E";	-- JSR @62		#O botão foi pressionado, chama a sub-rotina de incremento
tmp(37) := x"0" & '0' & x"00";	-- NOP 			#Retorno da sub-rotina de incremento
tmp(38) := x"9" & '0' & x"71";	-- JSR @113 	#Escreve o valor das váriaveis de contagem nos displays
tmp(39) := x"0" & '0' & x"00";	-- NOP			#Retorno da sub-rotina de salvar nos displays
tmp(40) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
tmp(41) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(42) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
tmp(43) := x"7" & '0' & x"2E";	-- JEQ @46		#Desvia se igual a 0 (botão não foi pressionado)
tmp(44) := x"9" & '0' & x"AB";	-- JSR @171		#O botão foi pressionado, chama a sub-rotina de incremento
tmp(45) := x"0" & '0' & x"00";	-- NOP 			#Retorno da sub-rotina de definir limite
tmp(46) := x"9" & '0' & x"8F";	-- JSR @143
tmp(47) := x"0" & '0' & x"00";	-- NOP			#Retorno da sub-rotina de verificar limite
tmp(48) := x"1" & '1' & x"62";	-- LDA @354		#Carrega o acumulador com a leitura do botão KEY2
tmp(49) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(50) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
tmp(51) := x"7" & '0' & x"36";	-- JEQ @54		#Desvia se igual a 0 (botão não foi pressionado)
tmp(52) := x"9" & '0' & x"E0";	-- JSR @224		#O botão foi pressionado, chama a sub-rotina de incremento
tmp(53) := x"0" & '0' & x"00";	-- NOP 			#Retorno da sub-rotina de incremento
tmp(54) := x"1" & '1' & x"64";	-- LDA @356		#Carrega o acumulador com a leitura do botão FPGA_RESET
tmp(55) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(56) := x"D" & '0' & x"01";	-- CEQi $1			#Compara com constante 1
tmp(57) := x"7" & '0' & x"3B";	-- JEQ @59		#Desvia se igual a 1 (botão não foi pressionado)
tmp(58) := x"9" & '0' & x"7E";	-- JSR @126		#O botão foi pressionado, chama a sub-rotina de reset
tmp(59) := x"0" & '0' & x"00";	-- NOP			#Retorno da sub-rotina de reset
tmp(60) := x"6" & '0' & x"1F";	-- JMP @31		#Fecha o laço principal, faz uma nova leitura de KEY0
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
tmp(73) := x"4" & '0' & x"00";	-- LDI $0			#Carrega valor 0 no acumulador (constante 0)
tmp(74) := x"5" & '0' & x"00";	-- STA @0			#Armazena o valor do acumulador em MEM[0] (unidades)
tmp(75) := x"1" & '0' & x"01";	-- LDA @1			#Carrega valor de MEM[1] no acumulador (dezenas)
tmp(76) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
tmp(77) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
tmp(78) := x"7" & '0' & x"51";	-- JEQ @81		#Realiza o carry out caso valor igual a 10
tmp(79) := x"5" & '0' & x"01";	-- STA @1			#Salva o incremento em MEM[1] (dezenas)
tmp(80) := x"A" & '0' & x"00";	-- RET
tmp(81) := x"4" & '0' & x"00";	-- LDI $0			#Carrega valor 0 no acumulador (constante 0)
tmp(82) := x"5" & '0' & x"01";	-- STA @1			#Armazena o valor do acumulador em MEM[1] (dezenas)
tmp(83) := x"1" & '0' & x"02";	-- LDA @2			#Carrega valor de MEM[2] no acumulador (centenas)
tmp(84) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
tmp(85) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
tmp(86) := x"7" & '0' & x"59";	-- JEQ @89		#Realiza o carry out caso valor igual a 10
tmp(87) := x"5" & '0' & x"02";	-- STA @2			#Salva o incremento em MEM[2] (centenas)
tmp(88) := x"A" & '0' & x"00";	-- RET
tmp(89) := x"4" & '0' & x"00";	-- LDI $0			#Carrega valor 0 no acumulador (constante 0)
tmp(90) := x"5" & '0' & x"02";	-- STA @2			#Armazena o valor do acumulador em MEM[2] (centenas)
tmp(91) := x"1" & '0' & x"06";	-- LDA @6			#Carrega valor de MEM[6] no acumulador (milhares)
tmp(92) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
tmp(93) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
tmp(94) := x"7" & '0' & x"61";	-- JEQ @97		#Realiza o carry out caso valor igual a 10
tmp(95) := x"5" & '0' & x"06";	-- STA @6			#Salva o incremento em MEM[6] (milhares)
tmp(96) := x"A" & '0' & x"00";	-- RET
tmp(97) := x"4" & '0' & x"00";	-- LDI $0			#Carrega valor 0 no acumulador (constante 0)
tmp(98) := x"5" & '0' & x"06";	-- STA @6			#Armazena o valor do acumulador em MEM[6] (milhares)
tmp(99) := x"1" & '0' & x"07";	-- LDA @7			#Carrega valor de MEM[7] no acumulador (dezenas de milhares)
tmp(100) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
tmp(101) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
tmp(102) := x"7" & '0' & x"69";	-- JEQ @105		#Realiza o carry out caso valor igual a 10
tmp(103) := x"5" & '0' & x"07";	-- STA @7			#Salva o incremento em MEM[7] (dezenas de milhares)
tmp(104) := x"A" & '0' & x"00";	-- RET
tmp(105) := x"4" & '0' & x"00";	-- LDI $0			#Carrega valor 0 no acumulador (constante 0)
tmp(106) := x"5" & '0' & x"07";	-- STA @7			#Armazena o valor do acumulador em MEM[6] (milhares)
tmp(107) := x"1" & '0' & x"08";	-- LDA @8			#Carrega valor de MEM[7] no acumulador (dezenas de milhares)
tmp(108) := x"E" & '0' & x"01";	-- ADDi $1			#ADDi com a constante 1
tmp(109) := x"D" & '0' & x"0A";	-- CEQi $10			#Compara o valor com constante 10
tmp(110) := x"7" & '0' & x"7E";	-- JEQ @126		#Zera se chegar ao final
tmp(111) := x"5" & '0' & x"07";	-- STA @7			#Salva o incremento em MEM[7] (dezenas de milhares)
tmp(112) := x"A" & '0' & x"00";	-- RET
tmp(113) := x"1" & '0' & x"00";	-- LDA @0 			#Carrega o valor de MEM[0] (unidades)
tmp(114) := x"5" & '1' & x"20";	-- STA @288 		#Armazena valor do acumulador de unidades no HEX0
tmp(115) := x"1" & '0' & x"01";	-- LDA @1 			#Carrega o valor de MEM[1] (dezenas)
tmp(116) := x"5" & '1' & x"21";	-- STA @289 		#Armazena valor do acumulador de dezenas no HEX1
tmp(117) := x"1" & '0' & x"02";	-- LDA @2 			#Carrega o valor de MEM[2] (centenas)
tmp(118) := x"5" & '1' & x"22";	-- STA @290 		#Armazena valor do acumulador de centenas no HEX2
tmp(119) := x"1" & '0' & x"06";	-- LDA @6 			#Carrega o valor de MEM[6] (milhares)
tmp(120) := x"5" & '1' & x"23";	-- STA @291 		#Armazena valor do acumulador de unidades no HEX3
tmp(121) := x"1" & '0' & x"07";	-- LDA @7 			#Carrega o valor de MEM[7] (dezenas de milhares)
tmp(122) := x"5" & '1' & x"24";	-- STA @292 		#Armazena valor do acumulador de dezenas no HEX4
tmp(123) := x"1" & '0' & x"08";	-- LDA @8 			#Carrega o valor de MEM[8] (centenas de milhares)
tmp(124) := x"5" & '1' & x"25";	-- STA @293 		#Armazena valor do acumulador de centenas no HEX5
tmp(125) := x"A" & '0' & x"00";	-- RET
tmp(126) := x"4" & '0' & x"00";	-- LDI $0			#Carrega o acumulador com o valor 0
tmp(127) := x"5" & '0' & x"00";	-- STA @0	 		#Armazena o valor do acumulador na MEM[0] (unidades)
tmp(128) := x"5" & '0' & x"01";	-- STA @1	 		#Armazena o valor do acumulador na MEM[1] (dezenas)
tmp(129) := x"5" & '0' & x"02";	-- STA @2	 		#Armazena o valor do acumulador na MEM[2] (centenas)
tmp(130) := x"5" & '0' & x"06";	-- STA @6	 		#Armazena o valor do acumulador na MEM[6] (milhar)
tmp(131) := x"5" & '0' & x"07";	-- STA @7	 		#Armazena o valor do acumulador na MEM[7] (dezena de milhar)
tmp(132) := x"5" & '0' & x"08";	-- STA @8	 		#Armazena o valor do acumulador na MEM[8] (centena de milhar)
tmp(133) := x"5" & '0' & x"09";	-- STA @9	 		#Armazena o valor do acumulador na MEM[9] (flag inibir contagem)
tmp(134) := x"5" & '1' & x"01";	-- STA @257		#Armazena o valor do bit0 do acumulador no LDR8
tmp(135) := x"4" & '0' & x"09";	-- LDI $9			#Carrega o acumulador com o valor 9
tmp(136) := x"5" & '0' & x"0A";	-- STA @10			#Armazena o valor do acumulador em MEM[10] (inibir unidade)
tmp(137) := x"5" & '0' & x"0B";	-- STA @11			#Armazena o valor do acumulador em MEM[11] (inibir dezena)
tmp(138) := x"5" & '0' & x"0C";	-- STA @12			#Armazena o valor do acumulador em MEM[12] (inibir centena)
tmp(139) := x"5" & '0' & x"0D";	-- STA @13			#Armazena o valor do acumulador em MEM[13] (inibir milhar)
tmp(140) := x"5" & '0' & x"0E";	-- STA @14			#Armazena o valor do acumulador em MEM[14] (inibir dezena de milhar)
tmp(141) := x"5" & '0' & x"0F";	-- STA @15			#Armazena o valor do acumulador em MEM[15] (inibir centena de milhar)
tmp(142) := x"A" & '0' & x"00";	-- RET
tmp(143) := x"1" & '0' & x"00";	-- LDA @0			#Carrega o valor de MEM[0] (unidades)
tmp(144) := x"8" & '0' & x"0A";	-- CEQ @10			#Compara o valor de MEM[10] (inibir unidade)
tmp(145) := x"7" & '0' & x"93";	-- JEQ @147
tmp(146) := x"A" & '0' & x"00";	-- RET
tmp(147) := x"1" & '0' & x"01";	-- LDA @1			#Carrega o valor de MEM[1] (dezenas)
tmp(148) := x"8" & '0' & x"0B";	-- CEQ @11			#Compara o valor de MEM[11] (inibir dezenas)
tmp(149) := x"7" & '0' & x"97";	-- JEQ @151
tmp(150) := x"A" & '0' & x"00";	-- RET
tmp(151) := x"1" & '0' & x"02";	-- LDA @2			#Carrega o valor de MEM[2] (centenas)
tmp(152) := x"8" & '0' & x"0C";	-- CEQ @12			#Compara o valor de MEM[12] (inibir centenas)
tmp(153) := x"7" & '0' & x"9B";	-- JEQ @155
tmp(154) := x"A" & '0' & x"00";	-- RET
tmp(155) := x"1" & '0' & x"06";	-- LDA @6			#Carrega o valor de MEM[6] (milhar)
tmp(156) := x"8" & '0' & x"0D";	-- CEQ @13			#Compara o valor de MEM[13] (inibir milhar)
tmp(157) := x"7" & '0' & x"9F";	-- JEQ @159
tmp(158) := x"A" & '0' & x"00";	-- RET
tmp(159) := x"1" & '0' & x"07";	-- LDA @7			#Carrega o valor de MEM[7] (dezena de milhar)
tmp(160) := x"8" & '0' & x"0E";	-- CEQ @14			#Compara o valor de MEM[10] (inibir dezena de milhar)
tmp(161) := x"7" & '0' & x"A3";	-- JEQ @163
tmp(162) := x"A" & '0' & x"00";	-- RET
tmp(163) := x"1" & '0' & x"08";	-- LDA @8			#Carrega o valor de MEM[8] (centena de milhar)
tmp(164) := x"8" & '0' & x"0F";	-- CEQ @15			#Compara o valor de MEM[10] (inibir centena de milhar)
tmp(165) := x"7" & '0' & x"A7";	-- JEQ @167
tmp(166) := x"A" & '0' & x"00";	-- RET
tmp(167) := x"4" & '0' & x"01";	-- LDI $1			#Carrega o acumulador com o valor 1
tmp(168) := x"5" & '0' & x"09";	-- STA @9			#Armazena o valor do acumulador em MEM[9] (flag inibir contagem)
tmp(169) := x"5" & '1' & x"01";	-- STA @257		#Armazena o valor do bit0 do acumulador no LDR8
tmp(170) := x"A" & '0' & x"00";	-- RET
tmp(171) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
tmp(172) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
tmp(173) := x"5" & '0' & x"0A";	-- STA @10			#Armazena o valor do acumulador em MEM[10] (inibir unidade)
tmp(174) := x"4" & '0' & x"04";	-- LDI $4			#Carrega o acumulador com o valor 4
tmp(175) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(176) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
tmp(177) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(178) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
tmp(179) := x"7" & '0' & x"B0";	-- JEQ @176		#Desvia se igual a 0 (botão não foi pressionado)
tmp(180) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
tmp(181) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
tmp(182) := x"5" & '0' & x"0B";	-- STA @11			#Armazena o valor do acumulador em MEM[11] (inibir dezena)
tmp(183) := x"4" & '0' & x"10";	-- LDI $16			#Carrega o acumulador com o valor 16
tmp(184) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(185) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
tmp(186) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(187) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
tmp(188) := x"7" & '0' & x"B9";	-- JEQ @185		#Desvia se igual a 0 (botão não foi pressionado)
tmp(189) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
tmp(190) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
tmp(191) := x"5" & '0' & x"0C";	-- STA @12			#Armazena o valor do acumulador em MEM[12] (inibir centena)
tmp(192) := x"4" & '0' & x"20";	-- LDI $32			#Carrega o acumulador com o valor 32
tmp(193) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(194) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
tmp(195) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(196) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
tmp(197) := x"7" & '0' & x"C2";	-- JEQ @194		#Desvia se igual a 0 (botão não foi pressionado)
tmp(198) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
tmp(199) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
tmp(200) := x"5" & '0' & x"0D";	-- STA @13			#Armazena o valor do acumulador em MEM[13] (inibir milhar)
tmp(201) := x"4" & '0' & x"80";	-- LDI $128		#Carrega o acumulador com o valor 128
tmp(202) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(203) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
tmp(204) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(205) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
tmp(206) := x"7" & '0' & x"CB";	-- JEQ @203		#Desvia se igual a 0 (botão não foi pressionado)
tmp(207) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
tmp(208) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
tmp(209) := x"5" & '0' & x"0E";	-- STA @14			#Armazena o valor do acumulador em MEM[13] (inibir dezena de milhar)
tmp(210) := x"4" & '0' & x"00";	-- LDI $0			#Carrega o acumulador com o valor 0
tmp(211) := x"5" & '1' & x"00";	-- STA @256		#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(212) := x"4" & '0' & x"01";	-- LDI $1			#Carrega o acumulador com o valor 1
tmp(213) := x"5" & '1' & x"02";	-- STA @258		#Armazena o valor do bit0 do acumulador no LDR9
tmp(214) := x"1" & '1' & x"61";	-- LDA @353		#Carrega o acumulador com a leitura do botão KEY1
tmp(215) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(216) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
tmp(217) := x"7" & '0' & x"D6";	-- JEQ @214		#Desvia se igual a 0 (botão não foi pressionado)
tmp(218) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
tmp(219) := x"1" & '1' & x"40";	-- LDA @320		#Carrega o acumulador com a leitura do SW7TO0
tmp(220) := x"5" & '0' & x"0F";	-- STA @15			#Armazena o valor do acumulador em MEM[15] (inibir centena de milhar)
tmp(221) := x"4" & '0' & x"00";	-- LDI $0			#Carrega o acumulador com o valor 0
tmp(222) := x"5" & '1' & x"02";	-- STA @258		#Armazena o valor do bit0 do acumulador no LDR9
tmp(223) := x"A" & '0' & x"00";	-- RET
tmp(224) := x"4" & '0' & x"00";	-- LDI $0			#Carrega 0 para o acumulador
tmp(225) := x"5" & '1' & x"01";	-- STA @257		#Armazena o valor do bit0 do acumulador no LDR8
tmp(226) := x"5" & '0' & x"09";	-- STA @9	 		#Armazena o valor do acumulador na MEM[9] (flag inibir contagem)
tmp(227) := x"5" & '1' & x"FD";	-- STA @509		#Limpa a leitura do botão KEY2
tmp(228) := x"1" & '0' & x"00";	-- LDA @0          	# Carrega MEM[0] (unidades) no acumulador
tmp(229) := x"D" & '0' & x"00";	-- CEQi $0         	# Verifica se MEM[0] == 0
tmp(230) := x"7" & '0' & x"EA";	-- JEQ @234    	# Se MEM[0] == 0, realiza o "empréstimo"  
tmp(231) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[0]
tmp(232) := x"5" & '0' & x"00";	-- STA @0          	# Armazena o novo valor de MEM[0]
tmp(233) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina
tmp(234) := x"4" & '0' & x"09";	-- LDI $9          	# Carrega 9 no acumulador
tmp(235) := x"5" & '0' & x"00";	-- STA @0          	# Define MEM[0] para 9
tmp(236) := x"1" & '0' & x"01";	-- LDA @1          	# Carrega MEM[1] (dezenas) no acumulador
tmp(237) := x"D" & '0' & x"00";	-- CEQi $0         	# Verifica se MEM[1] == 0
tmp(238) := x"7" & '0' & x"F2";	-- JEQ @242    	# Se MEM[1] == 0, realiza o próximo "empréstimo"
tmp(239) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[1]
tmp(240) := x"5" & '0' & x"01";	-- STA @1          	# Armazena o novo valor de MEM[1]
tmp(241) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina
tmp(242) := x"4" & '0' & x"09";	-- LDI $9          	# Carrega 9 no acumulador
tmp(243) := x"5" & '0' & x"01";	-- STA @1          	# Define MEM[1] para 9
tmp(244) := x"1" & '0' & x"02";	-- LDA @2          	# Carrega MEM[2] (centenas) no acumulador
tmp(245) := x"D" & '0' & x"00";	-- CEQi $0         	# Verifica se MEM[2] == 0
tmp(246) := x"7" & '0' & x"FA";	-- JEQ @250    	# Se MEM[2] == 0, realiza o próximo "empréstimo"
tmp(247) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[2]
tmp(248) := x"5" & '0' & x"02";	-- STA @2          	# Armazena o novo valor de MEM[2]
tmp(249) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina
tmp(250) := x"4" & '0' & x"09";	-- LDI $9          	# Carrega 9 no acumulador
tmp(251) := x"5" & '0' & x"02";	-- STA @2          	# Define MEM[2] para 9
tmp(252) := x"1" & '0' & x"06";	-- LDA @6          	# Carrega MEM[3] (milhares) no acumulador
tmp(253) := x"D" & '0' & x"00";	-- CEQi $0         	# Verifica se MEM[3] == 0
tmp(254) := x"7" & '1' & x"02";	-- JEQ @258   	# Se MEM[3] == 0, realiza o próximo "empréstimo"
tmp(255) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[3]
tmp(256) := x"5" & '0' & x"06";	-- STA @6          	# Armazena o novo valor de MEM[3]
tmp(257) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina
tmp(258) := x"4" & '0' & x"09";	-- LDI $9          	# Carrega 9 no acumulador
tmp(259) := x"5" & '0' & x"06";	-- STA @6          	# Define MEM[3] para 9
tmp(260) := x"1" & '0' & x"07";	-- LDA @7          	# Carrega MEM[4] (dezenas de milhares) no acumulador
tmp(261) := x"D" & '0' & x"00";	-- CEQi $0         	# Verifica se MEM[4] == 0
tmp(262) := x"7" & '1' & x"0A";	-- JEQ @266   	# Se MEM[4] == 0, realiza o próximo "empréstimo"
tmp(263) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[4]
tmp(264) := x"5" & '0' & x"07";	-- STA @7          	# Armazena o novo valor de MEM[4]
tmp(265) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina
tmp(266) := x"4" & '0' & x"09";	-- LDI $9          	# Carrega 9 no acumulador
tmp(267) := x"5" & '0' & x"07";	-- STA @7          	# Define MEM[4] para 9
tmp(268) := x"1" & '0' & x"08";	-- LDA @8          	# Carrega MEM[5] (centenas de milhares) no acumulador
tmp(269) := x"D" & '0' & x"00";	-- CEQi $0         	# Verifica se MEM[5] == 0
tmp(270) := x"7" & '0' & x"7E";	-- JEQ @126		# Zera se for menos que 0
tmp(271) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[5]
tmp(272) := x"5" & '0' & x"08";	-- STA @8          	# Armazena o novo valor de MEM[5]
tmp(273) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina

        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;