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
tmp(0) := x"4" & '0' & x"09";	-- LDI $9			#Carrega o acumulador com o valor 9
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
tmp(13) := x"4" & '0' & x"09";	-- LDI $9			#Carrega o acumulador com o valor 9
tmp(14) := x"5" & '0' & x"00";	-- STA @0			#Armazena o valor do acumulador em MEM[0] (unidades)
tmp(15) := x"5" & '0' & x"01";	-- STA @1			#Armazena o valor do acumulador em MEM[1] (dezenas)
tmp(16) := x"5" & '0' & x"02";	-- STA @2			#Armazena o valor do acumulador em MEM[2] (centenas)
tmp(17) := x"5" & '0' & x"03";	-- STA @3			#Armazena o valor do acumulador em MEM[3] (milhares)
tmp(18) := x"5" & '0' & x"04";	-- STA @4			#Armazena o valor do acumulador em MEM[4] (dezenas de milhares)
tmp(19) := x"5" & '0' & x"05";	-- STA @5			#Armazena o valor do acumulador em MEM[5] (centenas de milhares)
tmp(20) := x"0" & '0' & x"00";	-- NOP
tmp(21) := x"5" & '1' & x"FF";	-- STA @511		#Limpa a leitura do botão zero
tmp(22) := x"5" & '1' & x"FE";	-- STA @510		#Limpa a leitura do botão um
tmp(23) := x"0" & '0' & x"00";	-- NOP		
tmp(24) := x"1" & '1' & x"60";	-- LDA @352		#Carrega o acumulador com a leitura do botão KEY0
tmp(25) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(26) := x"D" & '0' & x"00";	-- CEQi $0			#Compara com constante 0
tmp(27) := x"7" & '0' & x"1E";	-- JEQ @30		#Desvia se igual a 0 (botão não foi pressionado)
tmp(28) := x"9" & '0' & x"28";	-- JSR @40		#O botão foi pressionado, chama a sub-rotina de incremento
tmp(29) := x"0" & '0' & x"00";	-- NOP 			#Retorno da sub-rotina de incremento
tmp(30) := x"9" & '0' & x"57";	-- JSR @87 	#Escreve o valor das váriaveis de contagem nos displays
tmp(31) := x"0" & '0' & x"00";	-- NOP			#Retorno da sub-rotina de salvar nos displays
tmp(32) := x"1" & '1' & x"64";	-- LDA @356		#Carrega o acumulador com a leitura do botão FPGA_RESET
tmp(33) := x"C" & '0' & x"01";	-- ANDi $1			#Utiliza a máscara b0000_0001 para limpar todos os bits menos o bit 0
tmp(34) := x"D" & '0' & x"01";	-- CEQi $1			#Compara com constante 1
tmp(35) := x"7" & '0' & x"25";	-- JEQ @37		#Desvia se igual a 1 (botão não foi pressionado)
tmp(36) := x"9" & '0' & x"64";	-- JSR @100		#O botão foi pressionado, chama a sub-rotina de reset
tmp(37) := x"0" & '0' & x"00";	-- NOP			#Retorno da sub-rotina de reset
tmp(38) := x"6" & '0' & x"17";	-- JMP @23		#Fecha o laço principal, faz uma nova leitura de KEY0
tmp(39) := x"0" & '0' & x"00";	-- NOP
tmp(40) := x"5" & '1' & x"FF";	-- STA @511		#Limpa a leitura do botão
tmp(41) := x"6" & '0' & x"2B";	-- JMP @43
tmp(42) := x"A" & '0' & x"00";	-- RET
tmp(43) := x"1" & '0' & x"00";	-- LDA @0          	# Carrega MEM[0] (unidades) no acumulador
tmp(44) := x"D" & '0' & x"00";	-- CEQi $0         	# Verifica se MEM[0] == 0
tmp(45) := x"7" & '0' & x"31";	-- JEQ @49    	# Se MEM[0] == 0, realiza o "empréstimo"  
tmp(46) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[0]
tmp(47) := x"5" & '0' & x"00";	-- STA @0          	# Armazena o novo valor de MEM[0]
tmp(48) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina
tmp(49) := x"4" & '0' & x"09";	-- LDI $9          	# Carrega 9 no acumulador
tmp(50) := x"5" & '0' & x"00";	-- STA @0          	# Define MEM[0] para 9
tmp(51) := x"1" & '0' & x"01";	-- LDA @1          	# Carrega MEM[1] (dezenas) no acumulador
tmp(52) := x"D" & '0' & x"00";	-- CEQi $0         	# Verifica se MEM[1] == 0
tmp(53) := x"7" & '0' & x"39";	-- JEQ @57    	# Se MEM[1] == 0, realiza o próximo "empréstimo"
tmp(54) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[1]
tmp(55) := x"5" & '0' & x"01";	-- STA @1          	# Armazena o novo valor de MEM[1]
tmp(56) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina
tmp(57) := x"4" & '0' & x"09";	-- LDI $9          	# Carrega 9 no acumulador
tmp(58) := x"5" & '0' & x"01";	-- STA @1          	# Define MEM[1] para 9
tmp(59) := x"1" & '0' & x"02";	-- LDA @2          	# Carrega MEM[2] (centenas) no acumulador
tmp(60) := x"D" & '0' & x"00";	-- CEQi $0         	# Verifica se MEM[2] == 0
tmp(61) := x"7" & '0' & x"41";	-- JEQ @65    	# Se MEM[2] == 0, realiza o próximo "empréstimo"
tmp(62) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[2]
tmp(63) := x"5" & '0' & x"02";	-- STA @2          	# Armazena o novo valor de MEM[2]
tmp(64) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina
tmp(65) := x"4" & '0' & x"09";	-- LDI $9          	# Carrega 9 no acumulador
tmp(66) := x"5" & '0' & x"02";	-- STA @2          	# Define MEM[2] para 9
tmp(67) := x"1" & '0' & x"03";	-- LDA @3          	# Carrega MEM[3] (milhares) no acumulador
tmp(68) := x"D" & '0' & x"00";	-- CEQi $0         	# Verifica se MEM[3] == 0
tmp(69) := x"7" & '0' & x"49";	-- JEQ @73   	# Se MEM[3] == 0, realiza o próximo "empréstimo"
tmp(70) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[3]
tmp(71) := x"5" & '0' & x"03";	-- STA @3          	# Armazena o novo valor de MEM[3]
tmp(72) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina
tmp(73) := x"4" & '0' & x"09";	-- LDI $9          	# Carrega 9 no acumulador
tmp(74) := x"5" & '0' & x"03";	-- STA @3          	# Define MEM[3] para 9
tmp(75) := x"1" & '0' & x"04";	-- LDA @4          	# Carrega MEM[4] (dezenas de milhares) no acumulador
tmp(76) := x"D" & '0' & x"00";	-- CEQi $0         	# Verifica se MEM[4] == 0
tmp(77) := x"7" & '0' & x"51";	-- JEQ @81   	# Se MEM[4] == 0, realiza o próximo "empréstimo"
tmp(78) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[4]
tmp(79) := x"5" & '0' & x"04";	-- STA @4          	# Armazena o novo valor de MEM[4]
tmp(80) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina
tmp(81) := x"4" & '0' & x"09";	-- LDI $9          	# Carrega 9 no acumulador
tmp(82) := x"5" & '0' & x"04";	-- STA @4          	# Define MEM[4] para 9
tmp(83) := x"1" & '0' & x"05";	-- LDA @5          	# Carrega MEM[5] (centenas de milhares) no acumulador
tmp(84) := x"F" & '0' & x"01";	-- SUBi $1         	# Subtrai 1 de MEM[5]
tmp(85) := x"5" & '0' & x"05";	-- STA @5          	# Armazena o novo valor de MEM[5]
tmp(86) := x"A" & '0' & x"00";	-- RET             	# Retorna da sub-rotina
tmp(87) := x"1" & '0' & x"00";	-- LDA @0 			#Carrega o valor de MEM[0] (unidades)
tmp(88) := x"5" & '1' & x"20";	-- STA @288 		#Armazena valor do acumulador de unidades no HEX0
tmp(89) := x"1" & '0' & x"01";	-- LDA @1 			#Carrega o valor de MEM[1] (dezenas)
tmp(90) := x"5" & '1' & x"21";	-- STA @289 		#Armazena valor do acumulador de dezenas no HEX1
tmp(91) := x"1" & '0' & x"02";	-- LDA @2 			#Carrega o valor de MEM[2] (centenas)
tmp(92) := x"5" & '1' & x"22";	-- STA @290 		#Armazena valor do acumulador de centenas no HEX2
tmp(93) := x"1" & '0' & x"03";	-- LDA @3 			#Carrega o valor de MEM[3] (milhares)
tmp(94) := x"5" & '1' & x"23";	-- STA @291 		#Armazena valor do acumulador de unidades no HEX3
tmp(95) := x"1" & '0' & x"04";	-- LDA @4 			#Carrega o valor de MEM[4] (dezenas de milhares)
tmp(96) := x"5" & '1' & x"24";	-- STA @292 		#Armazena valor do acumulador de dezenas no HEX4
tmp(97) := x"1" & '0' & x"05";	-- LDA @5 			#Carrega o valor de MEM[5] (centenas de milhares)
tmp(98) := x"5" & '1' & x"25";	-- STA @293 		#Armazena valor do acumulador de centenas no HEX5
tmp(99) := x"A" & '0' & x"00";	-- RET
tmp(100) := x"4" & '0' & x"09";	-- LDI $9			#Carrega o acumulador com o valor 9
tmp(101) := x"5" & '0' & x"00";	-- STA @0	 		#Armazena o valor do acumulador na MEM[0] (unidades)
tmp(102) := x"5" & '0' & x"01";	-- STA @1	 		#Armazena o valor do acumulador na MEM[1] (dezenas)
tmp(103) := x"5" & '0' & x"02";	-- STA @2	 		#Armazena o valor do acumulador na MEM[2] (centenas)
tmp(104) := x"5" & '0' & x"03";	-- STA @3	 		#Armazena o valor do acumulador na MEM[3] (milhar)
tmp(105) := x"5" & '0' & x"04";	-- STA @4	 		#Armazena o valor do acumulador na MEM[4] (dezena de milhar)
tmp(106) := x"5" & '0' & x"05";	-- STA @5	 		#Armazena o valor do acumulador na MEM[5] (centena de milhar)
tmp(107) := x"4" & '0' & x"00";	-- LDI $0          	#Carrega o acumulador com o valor 1
tmp(108) := x"5" & '1' & x"01";	-- STA @257		#Armazena o valor do bit0 do acumulador no LDR8
tmp(109) := x"A" & '0' & x"00";	-- RET
      

        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;