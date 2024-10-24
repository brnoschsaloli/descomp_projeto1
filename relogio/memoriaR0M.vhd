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
tmp(0) := "00" & x"4" & '0' & x"00";	-- LDI 0, R0	#Carrega o acumulador com o valor 0
tmp(1) := "00" & x"5" & '1' & x"20";	-- STA 288, R0	#Armazena o valor do acumulador em HEX0
tmp(2) := "00" & x"5" & '1' & x"21";	-- STA 289, R0	#Armazena o valor do acumulador em HEX1
tmp(3) := "00" & x"5" & '1' & x"22";	-- STA 290, R0	#Armazena o valor do acumulador em HEX2
tmp(4) := "00" & x"5" & '1' & x"23";	-- STA 291, R0	#Armazena o valor do acumulador em HEX3
tmp(5) := "00" & x"5" & '1' & x"24";	-- STA 292, R0	#Armazena o valor do acumulador em HEX4
tmp(6) := "00" & x"5" & '1' & x"25";	-- STA 293, R0	#Armazena o valor do acumulador em HEX5
tmp(7) := "00" & x"0" & '0' & x"00";	-- NOP
tmp(8) := "00" & x"4" & '0' & x"00";	-- LDI 0, R0	#Carrega o acumulador com o valor 0
tmp(9) := "00" & x"5" & '1' & x"00";	-- STA 256, R0	#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(10) := "00" & x"5" & '1' & x"01";	-- STA 257, R0	#Armazena o valor do bit0 do acumulador no LDR8
tmp(11) := "00" & x"5" & '1' & x"02";	-- STA 258, R0	#Armazena o valor do bit0 do acumulador no LDR9
tmp(12) := "00" & x"0" & '0' & x"00";	-- NOP
tmp(13) := "00" & x"4" & '0' & x"00";	-- LDI 0, R0	#Carrega o acumulador com o valor 0
tmp(14) := "00" & x"5" & '0' & x"00";	-- STA 0, R0	#Armazena o valor do acumulador em MEM[0] (unidades)
tmp(15) := "00" & x"5" & '0' & x"01";	-- STA 1, R0	#Armazena o valor do acumulador em MEM[1] (dezenas)
tmp(16) := "00" & x"5" & '0' & x"02";	-- STA 2, R0	#Armazena o valor do acumulador em MEM[2] (centenas)
tmp(17) := "00" & x"5" & '0' & x"06";	-- STA 6, R0	#Armazena o valor do acumulador em MEM[6] (milhares)
tmp(18) := "00" & x"5" & '0' & x"07";	-- STA 7, R0	#Armazena o valor do acumulador em MEM[7] (dezenas de milhares)
tmp(19) := "00" & x"5" & '0' & x"08";	-- STA 8, R0	#Armazena o valor do acumulador em MEM[8] (centenas de milhares)
tmp(20) := "00" & x"5" & '0' & x"09";	-- STA 9, R0	#Armazena o valor do acumulador em MEM[9] (flag inibir contagem)
tmp(21) := "00" & x"4" & '0' & x"09";	-- LDI 9, R0	#Carrega o acumulador com o valor 9
tmp(22) := "00" & x"5" & '0' & x"0A";	-- STA 10, R0	#Armazena o valor do acumulador em MEM[10] (inibir unidade)
tmp(23) := "00" & x"5" & '0' & x"0B";	-- STA 11, R0	#Armazena o valor do acumulador em MEM[11] (inibir dezena)
tmp(24) := "00" & x"5" & '0' & x"0C";	-- STA 12, R0	#Armazena o valor do acumulador em MEM[12] (inibir centena)
tmp(25) := "00" & x"5" & '0' & x"0D";	-- STA 13, R0	#Armazena o valor do acumulador em MEM[13] (inibir milhar)
tmp(26) := "00" & x"5" & '0' & x"0E";	-- STA 14, R0	#Armazena o valor do acumulador em MEM[14] (inibir dezena de milhar)
tmp(27) := "00" & x"5" & '0' & x"0F";	-- STA 15, R0	#Armazena o valor do acumulador em MEM[15] (inibir centena de milhar)
tmp(28) := "00" & x"0" & '0' & x"00";	-- NOP
tmp(29) := "00" & x"5" & '1' & x"FF";	-- STA 511, R0	#Limpa a leitura do botão zero
tmp(30) := "00" & x"5" & '1' & x"FE";	-- STA 510, R0	#Limpa a leitura do botão um
tmp(31) := "00" & x"0" & '0' & x"00";	-- NOP
tmp(32) := "00" & x"1" & '1' & x"60";	-- LDA 352, R0	#Carrega o acumulador com a leitura do botão KEY0
tmp(33) := "00" & x"C" & '0' & x"01";	-- ANDi 1, R0	#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(34) := "00" & x"D" & '0' & x"00";	-- CEQi 0, R0	#Compara com constante 0
tmp(35) := "00" & x"7" & '0' & x"26";	-- JEQ NAO_CLICOU0	#Desvia se igual a 0 (botão não foi pressionado)
tmp(36) := "00" & x"9" & '0' & x"3E";	-- JSR INCREMENTO	#O botão foi pressionado, chama a sub-rotina de incremento
tmp(37) := "00" & x"0" & '0' & x"00";	-- NOP	#Retorno da sub-rotina de incremento
tmp(38) := "00" & x"9" & '0' & x"77";	-- JSR SALVA_DISP	#Escreve o valor das váriaveis de contagem nos displays
tmp(39) := "00" & x"0" & '0' & x"00";	-- NOP	#Retorno da sub-rotina de salvar nos displays
tmp(40) := "00" & x"1" & '1' & x"61";	-- LDA 353, R0	#Carrega o acumulador com a leitura do botão KEY1
tmp(41) := "00" & x"C" & '0' & x"01";	-- ANDi 1, R0	#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(42) := "00" & x"D" & '0' & x"00";	-- CEQi 0, R0	#Compara com constante 0
tmp(43) := "00" & x"7" & '0' & x"2E";	-- JEQ NAO_CLICOU1	#Desvia se igual a 0 (botão não foi pressionado)
tmp(44) := "00" & x"9" & '0' & x"B1";	-- JSR DEFINE_LIM	#O botão foi pressionado, chama a sub-rotina de incremento
tmp(45) := "00" & x"0" & '0' & x"00";	-- NOP	#Retorno da sub-rotina de definir limite
tmp(46) := "00" & x"9" & '0' & x"95";	-- JSR VERIFICA_LIM
tmp(47) := "00" & x"0" & '0' & x"00";	-- NOP	#Retorno da sub-rotina de verificar limite
tmp(48) := "00" & x"1" & '1' & x"62";	-- LDA 354, R0	#Carrega o acumulador com a leitura do botão KEY2
tmp(49) := "00" & x"C" & '0' & x"01";	-- ANDi 1, R0	#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(50) := "00" & x"D" & '0' & x"00";	-- CEQi 0, R0	#Compara com constante 0
tmp(51) := "00" & x"7" & '0' & x"36";	-- JEQ NAO_CLICOU2	#Desvia se igual a 0 (botão não foi pressionado)
tmp(52) := "00" & x"9" & '0' & x"E6";	-- JSR DECREMENTO	#O botão foi pressionado, chama a sub-rotina de incremento
tmp(53) := "00" & x"0" & '0' & x"00";	-- NOP	#Retorno da sub-rotina de incremento
tmp(54) := "00" & x"1" & '1' & x"64";	-- LDA 356, R0	#Carrega o acumulador com a leitura do botão FPGA_RESET
tmp(55) := "00" & x"C" & '0' & x"01";	-- ANDi 1, R0	#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(56) := "00" & x"D" & '0' & x"01";	-- CEQi 1, R0	#Compara com constante 1
tmp(57) := "00" & x"7" & '0' & x"3B";	-- JEQ REINICIO	#Desvia se igual a 1 (botão não foi pressionado)
tmp(58) := "00" & x"9" & '0' & x"84";	-- JSR RESET	#O botão foi pressionado, chama a sub-rotina de reset
tmp(59) := "00" & x"0" & '0' & x"00";	-- NOP	#Retorno da sub-rotina de reset
tmp(60) := "00" & x"6" & '0' & x"1F";	-- JMP INICIO	#Fecha o laço principal, faz uma nova leitura de KEY0
tmp(61) := "00" & x"0" & '0' & x"00";	-- NOP
tmp(62) := "00" & x"5" & '1' & x"FF";	-- STA 511, R0	#Limpa a leitura do botão
tmp(63) := "00" & x"1" & '0' & x"09";	-- LDA 9, R0	#Carrega o valor de MEM[9] (flag inibir contagem)
tmp(64) := "00" & x"D" & '0' & x"00";	-- CEQi 0, R0	#Compara o valor com constante 0
tmp(65) := "00" & x"7" & '0' & x"43";	-- JEQ INCREMENTAR
tmp(66) := "00" & x"A" & '0' & x"00";	-- RET
tmp(67) := "00" & x"1" & '0' & x"00";	-- LDA 0, R0	#Carrega o valor de MEM[0] (contador)
tmp(68) := "00" & x"E" & '0' & x"01";	-- ADDi 1, R0	#ADDi com a constante 1
tmp(69) := "00" & x"D" & '0' & x"0A";	-- CEQi 10, R0	#Compara o valor com constante 10
tmp(70) := "00" & x"7" & '0' & x"49";	-- JEQ VAIUM_D	#Realiza o carry out caso valor igual a 10
tmp(71) := "00" & x"5" & '0' & x"00";	-- STA 0, R0	#Salva o incremento em MEM[0] (contador)
tmp(72) := "00" & x"A" & '0' & x"00";	-- RET	#Retorna da sub-rotina
tmp(73) := "00" & x"4" & '0' & x"00";	-- LDI 0, R0	#Carrega valor 0 no acumulador (constante 0)
tmp(74) := "00" & x"5" & '0' & x"00";	-- STA 0, R0	#Armazena o valor do acumulador em MEM[0] (unidades)
tmp(75) := "00" & x"1" & '0' & x"01";	-- LDA 1, R0	#Carrega valor de MEM[1] no acumulador (dezenas)
tmp(76) := "00" & x"E" & '0' & x"01";	-- ADDi 1, R0	#ADDi com a constante 1
tmp(77) := "00" & x"D" & '0' & x"06";	-- CEQi 6, R0	#Compara o valor com constante 10
tmp(78) := "00" & x"7" & '0' & x"51";	-- JEQ VAIUM_C	#Realiza o carry out caso valor igual a 10
tmp(79) := "00" & x"5" & '0' & x"01";	-- STA 1, R0	#Salva o incremento em MEM[1] (dezenas)
tmp(80) := "00" & x"A" & '0' & x"00";	-- RET
tmp(81) := "00" & x"4" & '0' & x"00";	-- LDI 0, R0	#Carrega valor 0 no acumulador (constante 0)
tmp(82) := "00" & x"5" & '0' & x"01";	-- STA 1, R0	#Armazena o valor do acumulador em MEM[1] (dezenas)
tmp(83) := "00" & x"1" & '0' & x"02";	-- LDA 2, R0	#Carrega valor de MEM[2] no acumulador (centenas)
tmp(84) := "00" & x"E" & '0' & x"01";	-- ADDi 1, R0	#ADDi com a constante 1
tmp(85) := "00" & x"D" & '0' & x"0A";	-- CEQi 10, R0	#Compara o valor com constante 10
tmp(86) := "00" & x"7" & '0' & x"59";	-- JEQ VAIUM_M	#Realiza o carry out caso valor igual a 10
tmp(87) := "00" & x"5" & '0' & x"02";	-- STA 2, R0	#Salva o incremento em MEM[2] (centenas)
tmp(88) := "00" & x"A" & '0' & x"00";	-- RET
tmp(89) := "00" & x"4" & '0' & x"00";	-- LDI 0, R0	#Carrega valor 0 no acumulador (constante 0)
tmp(90) := "00" & x"5" & '0' & x"02";	-- STA 2, R0	#Armazena o valor do acumulador em MEM[2] (centenas)
tmp(91) := "00" & x"1" & '0' & x"06";	-- LDA 6, R0	#Carrega valor de MEM[6] no acumulador (milhares)
tmp(92) := "00" & x"E" & '0' & x"01";	-- ADDi 1, R0	#ADDi com a constante 1
tmp(93) := "00" & x"D" & '0' & x"06";	-- CEQi 6, R0	#Compara o valor com constante 10
tmp(94) := "00" & x"7" & '0' & x"61";	-- JEQ VAIUM_DM	#Realiza o carry out caso valor igual a 10
tmp(95) := "00" & x"5" & '0' & x"06";	-- STA 6, R0	#Salva o incremento em MEM[6] (milhares)
tmp(96) := "00" & x"A" & '0' & x"00";	-- RET
tmp(97) := "00" & x"4" & '0' & x"00";	-- LDI 0, R0	#Carrega valor 0 no acumulador (constante 0)
tmp(98) := "00" & x"5" & '0' & x"06";	-- STA 6, R0	#Armazena o valor do acumulador em MEM[6] (milhares)
tmp(99) := "00" & x"1" & '0' & x"07";	-- LDA 7, R0	#Carrega valor de MEM[7] no acumulador (dezenas de milhares)
tmp(100) := "00" & x"E" & '0' & x"01";	-- ADDi 1, R0	#ADDi com a constante 1
tmp(101) := "01" & x"1" & '0' & x"08";	-- LDA 8, R1	#Carrega valor de MEM[8] no acumulador (centenas de milhares)
tmp(102) := "01" & x"D" & '0' & x"02";	-- CEQi 2, R1	#Compara o valor com constante 2
tmp(103) := "00" & x"7" & '0' & x"6B";	-- JEQ COMPARA4	#Pula para o fim da rotina
tmp(104) := "00" & x"D" & '0' & x"0A";	-- CEQi 10, R0	#Compara o valor com constante 10
tmp(105) := "00" & x"7" & '0' & x"6F";	-- JEQ VAIUM_CM	#Realiza o carry out caso valor igual a 10
tmp(106) := "00" & x"6" & '0' & x"6D";	-- JMP END_DM
tmp(107) := "00" & x"D" & '0' & x"04";	-- CEQi 4, R0	#Compara o valor com constante 4
tmp(108) := "00" & x"7" & '0' & x"6F";	-- JEQ VAIUM_CM	#Realiza o carry out caso valor igual a 4
tmp(109) := "00" & x"5" & '0' & x"07";	-- STA 7, R0	#Salva o incremento em MEM[7] (dezenas de milhares)
tmp(110) := "00" & x"A" & '0' & x"00";	-- RET
tmp(111) := "00" & x"4" & '0' & x"00";	-- LDI 0, R0	#Carrega valor 0 no acumulador (constante 0)
tmp(112) := "00" & x"5" & '0' & x"07";	-- STA 7, R0	#Armazena o valor do acumulador em MEM[7] (dezenas milhares)
tmp(113) := "00" & x"1" & '0' & x"08";	-- LDA 8, R0	#Carrega valor de MEM[8] no acumulador (centenas de milhares)
tmp(114) := "00" & x"E" & '0' & x"01";	-- ADDi 1, R0	#ADDi com a constante 1
tmp(115) := "00" & x"D" & '0' & x"03";	-- CEQi 3, R0	#Compara o valor com constante 3
tmp(116) := "00" & x"7" & '1' & x"18";	-- JEQ ZERA_HEX	#Zera se chegar ao final
tmp(117) := "00" & x"5" & '0' & x"08";	-- STA 8, R0	#Salva o incremento em MEM[8] (centena de milhares)
tmp(118) := "00" & x"A" & '0' & x"00";	-- RET
tmp(119) := "00" & x"1" & '0' & x"00";	-- LDA 0, R0	#Carrega o valor de MEM[0] (unidades)
tmp(120) := "00" & x"5" & '1' & x"20";	-- STA 288, R0	#Armazena valor do acumulador de unidades no HEX0
tmp(121) := "00" & x"1" & '0' & x"01";	-- LDA 1, R0	#Carrega o valor de MEM[1] (dezenas)
tmp(122) := "00" & x"5" & '1' & x"21";	-- STA 289, R0	#Armazena valor do acumulador de dezenas no HEX1
tmp(123) := "00" & x"1" & '0' & x"02";	-- LDA 2, R0	#Carrega o valor de MEM[2] (centenas)
tmp(124) := "00" & x"5" & '1' & x"22";	-- STA 290, R0	#Armazena valor do acumulador de centenas no HEX2
tmp(125) := "00" & x"1" & '0' & x"06";	-- LDA 6, R0	#Carrega o valor de MEM[6] (milhares)
tmp(126) := "00" & x"5" & '1' & x"23";	-- STA 291, R0	#Armazena valor do acumulador de unidades no HEX3
tmp(127) := "00" & x"1" & '0' & x"07";	-- LDA 7, R0	#Carrega o valor de MEM[7] (dezenas de milhares)
tmp(128) := "00" & x"5" & '1' & x"24";	-- STA 292, R0	#Armazena valor do acumulador de dezenas no HEX4
tmp(129) := "00" & x"1" & '0' & x"08";	-- LDA 8, R0	#Carrega o valor de MEM[8] (centenas de milhares)
tmp(130) := "00" & x"5" & '1' & x"25";	-- STA 293, R0	#Armazena valor do acumulador de centenas no HEX5
tmp(131) := "00" & x"A" & '0' & x"00";	-- RET
tmp(132) := "00" & x"4" & '0' & x"00";	-- LDI 0, R0	#Carrega o acumulador com o valor 0
tmp(133) := "00" & x"5" & '0' & x"00";	-- STA 0, R0	#Armazena o valor do acumulador na MEM[0] (unidades)
tmp(134) := "00" & x"5" & '0' & x"01";	-- STA 1, R0	#Armazena o valor do acumulador na MEM[1] (dezenas)
tmp(135) := "00" & x"5" & '0' & x"02";	-- STA 2, R0	#Armazena o valor do acumulador na MEM[2] (centenas)
tmp(136) := "00" & x"5" & '0' & x"06";	-- STA 6, R0	#Armazena o valor do acumulador na MEM[6] (milhar)
tmp(137) := "00" & x"5" & '0' & x"07";	-- STA 7, R0	#Armazena o valor do acumulador na MEM[7] (dezena de milhar)
tmp(138) := "00" & x"5" & '0' & x"08";	-- STA 8, R0	#Armazena o valor do acumulador na MEM[8] (centena de milhar)
tmp(139) := "00" & x"5" & '0' & x"09";	-- STA 9, R0	#Armazena o valor do acumulador na MEM[9] (flag inibir contagem)
tmp(140) := "00" & x"5" & '1' & x"01";	-- STA 257, R0	#Armazena o valor do bit0 do acumulador no LDR8
tmp(141) := "00" & x"4" & '0' & x"09";	-- LDI 9, R0	#Carrega o acumulador com o valor 9
tmp(142) := "00" & x"5" & '0' & x"0A";	-- STA 10, R0	#Armazena o valor do acumulador em MEM[10] (inibir unidade)
tmp(143) := "00" & x"5" & '0' & x"0B";	-- STA 11, R0	#Armazena o valor do acumulador em MEM[11] (inibir dezena)
tmp(144) := "00" & x"5" & '0' & x"0C";	-- STA 12, R0	#Armazena o valor do acumulador em MEM[12] (inibir centena)
tmp(145) := "00" & x"5" & '0' & x"0D";	-- STA 13, R0	#Armazena o valor do acumulador em MEM[13] (inibir milhar)
tmp(146) := "00" & x"5" & '0' & x"0E";	-- STA 14, R0	#Armazena o valor do acumulador em MEM[14] (inibir dezena de milhar)
tmp(147) := "00" & x"5" & '0' & x"0F";	-- STA 15, R0	#Armazena o valor do acumulador em MEM[15] (inibir centena de milhar)
tmp(148) := "00" & x"A" & '0' & x"00";	-- RET
tmp(149) := "00" & x"1" & '0' & x"00";	-- LDA 0, R0	#Carrega o valor de MEM[0] (unidades)
tmp(150) := "00" & x"8" & '0' & x"0A";	-- CEQ 10, R0	#Compara o valor de MEM[10] (inibir unidade)
tmp(151) := "00" & x"7" & '0' & x"99";	-- JEQ NEXT_LIM1
tmp(152) := "00" & x"A" & '0' & x"00";	-- RET
tmp(153) := "00" & x"1" & '0' & x"01";	-- LDA 1, R0	#Carrega o valor de MEM[1] (dezenas)
tmp(154) := "00" & x"8" & '0' & x"0B";	-- CEQ 11, R0	#Compara o valor de MEM[11] (inibir dezenas)
tmp(155) := "00" & x"7" & '0' & x"9D";	-- JEQ NEXT_LIM2
tmp(156) := "00" & x"A" & '0' & x"00";	-- RET
tmp(157) := "00" & x"1" & '0' & x"02";	-- LDA 2, R0	#Carrega o valor de MEM[2] (centenas)
tmp(158) := "00" & x"8" & '0' & x"0C";	-- CEQ 12, R0	#Compara o valor de MEM[12] (inibir centenas)
tmp(159) := "00" & x"7" & '0' & x"A1";	-- JEQ NEXT_LIM3
tmp(160) := "00" & x"A" & '0' & x"00";	-- RET
tmp(161) := "00" & x"1" & '0' & x"06";	-- LDA 6, R0	#Carrega o valor de MEM[6] (milhar)
tmp(162) := "00" & x"8" & '0' & x"0D";	-- CEQ 13, R0	#Compara o valor de MEM[13] (inibir milhar)
tmp(163) := "00" & x"7" & '0' & x"A5";	-- JEQ NEXT_LIM4
tmp(164) := "00" & x"A" & '0' & x"00";	-- RET
tmp(165) := "00" & x"1" & '0' & x"07";	-- LDA 7, R0	#Carrega o valor de MEM[7] (dezena de milhar)
tmp(166) := "00" & x"8" & '0' & x"0E";	-- CEQ 14, R0	#Compara o valor de MEM[10] (inibir dezena de milhar)
tmp(167) := "00" & x"7" & '0' & x"A9";	-- JEQ NEXT_LIM5
tmp(168) := "00" & x"A" & '0' & x"00";	-- RET
tmp(169) := "00" & x"1" & '0' & x"08";	-- LDA 8, R0	#Carrega o valor de MEM[8] (centena de milhar)
tmp(170) := "00" & x"8" & '0' & x"0F";	-- CEQ 15, R0	#Compara o valor de MEM[10] (inibir centena de milhar)
tmp(171) := "00" & x"7" & '0' & x"AD";	-- JEQ TODOS_IGUAL
tmp(172) := "00" & x"A" & '0' & x"00";	-- RET
tmp(173) := "00" & x"4" & '0' & x"01";	-- LDI 1, R0	#Carrega o acumulador com o valor 1
tmp(174) := "00" & x"5" & '0' & x"09";	-- STA 9, R0	#Armazena o valor do acumulador em MEM[9] (flag inibir contagem)
tmp(175) := "00" & x"5" & '1' & x"01";	-- STA 257, R0	#Armazena o valor do bit0 do acumulador no LDR8
tmp(176) := "00" & x"A" & '0' & x"00";	-- RET
tmp(177) := "00" & x"5" & '1' & x"FE";	-- STA 510, R0	#Limpa a leitura do botão um
tmp(178) := "00" & x"1" & '1' & x"40";	-- LDA 320, R0	#Carrega o acumulador com a leitura do SW7TO0
tmp(179) := "00" & x"5" & '0' & x"0A";	-- STA 10, R0	#Armazena o valor do acumulador em MEM[10] (inibir unidade)
tmp(180) := "00" & x"4" & '0' & x"04";	-- LDI 4, R0	#Carrega o acumulador com o valor 4
tmp(181) := "00" & x"5" & '1' & x"00";	-- STA 256, R0	#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(182) := "00" & x"1" & '1' & x"61";	-- LDA 353, R0	#Carrega o acumulador com a leitura do botão KEY1
tmp(183) := "00" & x"C" & '0' & x"01";	-- ANDi 1, R0	#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(184) := "00" & x"D" & '0' & x"00";	-- CEQi 0, R0	#Compara com constante 0
tmp(185) := "00" & x"7" & '0' & x"B6";	-- JEQ AGUARDA_D	#Desvia se igual a 0 (botão não foi pressionado)
tmp(186) := "00" & x"5" & '1' & x"FE";	-- STA 510, R0	#Limpa a leitura do botão um
tmp(187) := "00" & x"1" & '1' & x"40";	-- LDA 320, R0	#Carrega o acumulador com a leitura do SW7TO0
tmp(188) := "00" & x"5" & '0' & x"0B";	-- STA 11, R0	#Armazena o valor do acumulador em MEM[11] (inibir dezena)
tmp(189) := "00" & x"4" & '0' & x"10";	-- LDI 16, R0	#Carrega o acumulador com o valor 16
tmp(190) := "00" & x"5" & '1' & x"00";	-- STA 256, R0	#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(191) := "00" & x"1" & '1' & x"61";	-- LDA 353, R0	#Carrega o acumulador com a leitura do botão KEY1
tmp(192) := "00" & x"C" & '0' & x"01";	-- ANDi 1, R0	#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(193) := "00" & x"D" & '0' & x"00";	-- CEQi 0, R0	#Compara com constante 0
tmp(194) := "00" & x"7" & '0' & x"BF";	-- JEQ AGUARDA_C	#Desvia se igual a 0 (botão não foi pressionado)
tmp(195) := "00" & x"5" & '1' & x"FE";	-- STA 510, R0	#Limpa a leitura do botão um
tmp(196) := "00" & x"1" & '1' & x"40";	-- LDA 320, R0	#Carrega o acumulador com a leitura do SW7TO0
tmp(197) := "00" & x"5" & '0' & x"0C";	-- STA 12, R0	#Armazena o valor do acumulador em MEM[12] (inibir centena)
tmp(198) := "00" & x"4" & '0' & x"20";	-- LDI 32, R0	#Carrega o acumulador com o valor 32
tmp(199) := "00" & x"5" & '1' & x"00";	-- STA 256, R0	#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(200) := "00" & x"1" & '1' & x"61";	-- LDA 353, R0	#Carrega o acumulador com a leitura do botão KEY1
tmp(201) := "00" & x"C" & '0' & x"01";	-- ANDi 1, R0	#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(202) := "00" & x"D" & '0' & x"00";	-- CEQi 0, R0	#Compara com constante 0
tmp(203) := "00" & x"7" & '0' & x"C8";	-- JEQ AGUARDA_M	#Desvia se igual a 0 (botão não foi pressionado)
tmp(204) := "00" & x"5" & '1' & x"FE";	-- STA 510, R0	#Limpa a leitura do botão um
tmp(205) := "00" & x"1" & '1' & x"40";	-- LDA 320, R0	#Carrega o acumulador com a leitura do SW7TO0
tmp(206) := "00" & x"5" & '0' & x"0D";	-- STA 13, R0	#Armazena o valor do acumulador em MEM[13] (inibir milhar)
tmp(207) := "00" & x"4" & '0' & x"80";	-- LDI 128, R0	#Carrega o acumulador com o valor 128
tmp(208) := "00" & x"5" & '1' & x"00";	-- STA 256, R0	#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(209) := "00" & x"1" & '1' & x"61";	-- LDA 353, R0	#Carrega o acumulador com a leitura do botão KEY1
tmp(210) := "00" & x"C" & '0' & x"01";	-- ANDi 1, R0	#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(211) := "00" & x"D" & '0' & x"00";	-- CEQi 0, R0	#Compara com constante 0
tmp(212) := "00" & x"7" & '0' & x"D1";	-- JEQ AGUARDA_DM	#Desvia se igual a 0 (botão não foi pressionado)
tmp(213) := "00" & x"5" & '1' & x"FE";	-- STA 510, R0	#Limpa a leitura do botão um
tmp(214) := "00" & x"1" & '1' & x"40";	-- LDA 320, R0	#Carrega o acumulador com a leitura do SW7TO0
tmp(215) := "00" & x"5" & '0' & x"0E";	-- STA 14, R0	#Armazena o valor do acumulador em MEM[13] (inibir dezena de milhar)
tmp(216) := "00" & x"4" & '0' & x"00";	-- LDI 0, R0	#Carrega o acumulador com o valor 0
tmp(217) := "00" & x"5" & '1' & x"00";	-- STA 256, R0	#Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(218) := "00" & x"4" & '0' & x"01";	-- LDI 1, R0	#Carrega o acumulador com o valor 1
tmp(219) := "00" & x"5" & '1' & x"02";	-- STA 258, R0	#Armazena o valor do bit0 do acumulador no LDR9
tmp(220) := "00" & x"1" & '1' & x"61";	-- LDA 353, R0	#Carrega o acumulador com a leitura do botão KEY1
tmp(221) := "00" & x"C" & '0' & x"01";	-- ANDi 1, R0	#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(222) := "00" & x"D" & '0' & x"00";	-- CEQi 0, R0	#Compara com constante 0
tmp(223) := "00" & x"7" & '0' & x"DC";	-- JEQ AGUARDA_CM	#Desvia se igual a 0 (botão não foi pressionado)
tmp(224) := "00" & x"5" & '1' & x"FE";	-- STA 510, R0	#Limpa a leitura do botão um
tmp(225) := "00" & x"1" & '1' & x"40";	-- LDA 320, R0	#Carrega o acumulador com a leitura do SW7TO0
tmp(226) := "00" & x"5" & '0' & x"0F";	-- STA 15, R0	#Armazena o valor do acumulador em MEM[15] (inibir centena de milhar)
tmp(227) := "00" & x"4" & '0' & x"00";	-- LDI 0, R0	#Carrega o acumulador com o valor 0
tmp(228) := "00" & x"5" & '1' & x"02";	-- STA 258, R0	#Armazena o valor do bit0 do acumulador no LDR9
tmp(229) := "00" & x"A" & '0' & x"00";	-- RET
tmp(230) := "00" & x"4" & '0' & x"00";	-- LDI 0, R0	#Carrega 0 para o acumulador
tmp(231) := "00" & x"5" & '1' & x"01";	-- STA 257, R0	#Armazena o valor do bit0 do acumulador no LDR8
tmp(232) := "00" & x"5" & '0' & x"09";	-- STA 9, R0	#Armazena o valor do acumulador na MEM[9] (flag inibir contagem)
tmp(233) := "00" & x"5" & '1' & x"FD";	-- STA 509, R0	#Limpa a leitura do botão KEY2
tmp(234) := "00" & x"1" & '0' & x"00";	-- LDA 0, R0	# Carrega MEM[0] (unidades) no acumulador
tmp(235) := "00" & x"D" & '0' & x"00";	-- CEQi 0, R0	# Verifica se MEM[0] == 0
tmp(236) := "00" & x"7" & '0' & x"F0";	-- JEQ VEMUM_D	# Se MEM[0] == 0, realiza o "empréstimo"
tmp(237) := "00" & x"F" & '0' & x"01";	-- SUBi 1, R0	# Subtrai 1 de MEM[0]
tmp(238) := "00" & x"5" & '0' & x"00";	-- STA 0, R0	# Armazena o novo valor de MEM[0]
tmp(239) := "00" & x"A" & '0' & x"00";	-- RET	# Retorna da sub-rotina
tmp(240) := "00" & x"4" & '0' & x"09";	-- LDI 9, R0	# Carrega 9 no acumulador
tmp(241) := "00" & x"5" & '0' & x"00";	-- STA 0, R0	# Define MEM[0] para 9
tmp(242) := "00" & x"1" & '0' & x"01";	-- LDA 1, R0	# Carrega MEM[1] (dezenas) no acumulador
tmp(243) := "00" & x"D" & '0' & x"00";	-- CEQi 0, R0	# Verifica se MEM[1] == 0
tmp(244) := "00" & x"7" & '0' & x"F8";	-- JEQ VEMUM_C	# Se MEM[1] == 0, realiza o próximo "empréstimo"
tmp(245) := "00" & x"F" & '0' & x"01";	-- SUBi 1, R0	# Subtrai 1 de MEM[1]
tmp(246) := "00" & x"5" & '0' & x"01";	-- STA 1, R0	# Armazena o novo valor de MEM[1]
tmp(247) := "00" & x"A" & '0' & x"00";	-- RET	# Retorna da sub-rotina
tmp(248) := "00" & x"4" & '0' & x"09";	-- LDI 9, R0	# Carrega 9 no acumulador
tmp(249) := "00" & x"5" & '0' & x"01";	-- STA 1, R0	# Define MEM[1] para 9
tmp(250) := "00" & x"1" & '0' & x"02";	-- LDA 2, R0	# Carrega MEM[2] (centenas) no acumulador
tmp(251) := "00" & x"D" & '0' & x"00";	-- CEQi 0, R0	# Verifica se MEM[2] == 0
tmp(252) := "00" & x"7" & '1' & x"00";	-- JEQ VEMUM_M	# Se MEM[2] == 0, realiza o próximo "empréstimo"
tmp(253) := "00" & x"F" & '0' & x"01";	-- SUBi 1, R0	# Subtrai 1 de MEM[2]
tmp(254) := "00" & x"5" & '0' & x"02";	-- STA 2, R0	# Armazena o novo valor de MEM[2]
tmp(255) := "00" & x"A" & '0' & x"00";	-- RET	# Retorna da sub-rotina
tmp(256) := "00" & x"4" & '0' & x"09";	-- LDI 9, R0	# Carrega 9 no acumulador
tmp(257) := "00" & x"5" & '0' & x"02";	-- STA 2, R0	# Define MEM[2] para 9
tmp(258) := "00" & x"1" & '0' & x"06";	-- LDA 6, R0	# Carrega MEM[3] (milhares) no acumulador
tmp(259) := "00" & x"D" & '0' & x"00";	-- CEQi 0, R0	# Verifica se MEM[3] == 0
tmp(260) := "00" & x"7" & '1' & x"08";	-- JEQ VEMUM_DM	# Se MEM[3] == 0, realiza o próximo "empréstimo"
tmp(261) := "00" & x"F" & '0' & x"01";	-- SUBi 1, R0	# Subtrai 1 de MEM[3]
tmp(262) := "00" & x"5" & '0' & x"06";	-- STA 6, R0	# Armazena o novo valor de MEM[3]
tmp(263) := "00" & x"A" & '0' & x"00";	-- RET	# Retorna da sub-rotina
tmp(264) := "00" & x"4" & '0' & x"09";	-- LDI 9, R0	# Carrega 9 no acumulador
tmp(265) := "00" & x"5" & '0' & x"06";	-- STA 6, R0	# Define MEM[3] para 9
tmp(266) := "00" & x"1" & '0' & x"07";	-- LDA 7, R0	# Carrega MEM[4] (dezenas de milhares) no acumulador
tmp(267) := "00" & x"D" & '0' & x"00";	-- CEQi 0, R0	# Verifica se MEM[4] == 0
tmp(268) := "00" & x"7" & '1' & x"10";	-- JEQ VEMUM_CM	# Se MEM[4] == 0, realiza o próximo "empréstimo"
tmp(269) := "00" & x"F" & '0' & x"01";	-- SUBi 1, R0	# Subtrai 1 de MEM[4]
tmp(270) := "00" & x"5" & '0' & x"07";	-- STA 7, R0	# Armazena o novo valor de MEM[4]
tmp(271) := "00" & x"A" & '0' & x"00";	-- RET	# Retorna da sub-rotina
tmp(272) := "00" & x"4" & '0' & x"09";	-- LDI 9, R0	# Carrega 9 no acumulador
tmp(273) := "00" & x"5" & '0' & x"07";	-- STA 7, R0	# Define MEM[4] para 9
tmp(274) := "00" & x"1" & '0' & x"08";	-- LDA 8, R0	# Carrega MEM[5] (centenas de milhares) no acumulador
tmp(275) := "00" & x"D" & '0' & x"00";	-- CEQi 0, R0	# Verifica se MEM[5] == 0
tmp(276) := "00" & x"7" & '1' & x"18";	-- JEQ ZERA_HEX	# Zera se for menos que 0
tmp(277) := "00" & x"F" & '0' & x"01";	-- SUBi 1, R0	# Subtrai 1 de MEM[5]
tmp(278) := "00" & x"5" & '0' & x"08";	-- STA 8, R0	# Armazena o novo valor de MEM[5]
tmp(279) := "00" & x"A" & '0' & x"00";	-- RET	# Retorna da sub-rotina
tmp(280) := "00" & x"4" & '0' & x"00";	-- LDI 0, R0	#Carrega o acumulador com o valor 0
tmp(281) := "00" & x"5" & '0' & x"00";	-- STA 0, R0	#Armazena o valor do acumulador na MEM[0] (unidades)
tmp(282) := "00" & x"5" & '0' & x"01";	-- STA 1, R0	#Armazena o valor do acumulador na MEM[1] (dezenas)
tmp(283) := "00" & x"5" & '0' & x"02";	-- STA 2, R0	#Armazena o valor do acumulador na MEM[2] (centenas)
tmp(284) := "00" & x"5" & '0' & x"06";	-- STA 6, R0	#Armazena o valor do acumulador na MEM[6] (milhar)
tmp(285) := "00" & x"5" & '0' & x"07";	-- STA 7, R0	#Armazena o valor do acumulador na MEM[7] (dezena de milhar)
tmp(286) := "00" & x"5" & '0' & x"08";	-- STA 8, R0	#Armazena o valor do acumulador na MEM[8] (centena de milhar)
tmp(287) := "00" & x"5" & '0' & x"09";	-- STA 9, R0	#Armazena o valor do acumulador na MEM[9] (flag inibir contagem)
tmp(288) := "00" & x"A" & '0' & x"00";	-- RET


        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;