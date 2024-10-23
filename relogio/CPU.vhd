	library ieee;
	use ieee.std_logic_1164.all;

	entity CPU is
	  -- Total de bits das entradas e saidas
	  generic ( larguraDados_ROM : natural := 15;
			  larguraEnderecos_ROM : natural := 9;
			  larguraDados_RAM : natural := 8;
			  larguraEnderecos_RAM : natural := 6;
			  simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
	  );

	  port   (
		  CLK : in std_logic;
		  Reset : in std_logic;
		  Rd : out std_logic;
		  Wr : out std_logic;
		  ROM_Address : out std_logic_vector(larguraEnderecos_ROM-1 downto 0);
		  Instruction_IN : in std_logic_vector(larguraDados_ROM-1 downto 0);
		  Data_Address : out std_logic_vector(larguraEnderecos_ROM-1 downto 0);
		  Data_OUT : out std_logic_vector(larguraDados_RAM-1 downto 0);
		  Data_IN : in std_logic_vector(larguraDados_RAM-1 downto 0)
	  );
	end entity;


	architecture arquitetura of CPU is
	  -- Instanciando os componentes:
		signal entradaB_ULA : std_logic_vector (7 downto 0);
		signal Saida_MUX_JMP : std_logic_vector (8 downto 0);
		signal entradaA_ULA : std_logic_vector (7 downto 0);
		signal REG_FLAG: std_logic;
		signal Saida_ULA : std_logic_vector (7 downto 0);
		signal Saida_PC : std_logic_vector (larguraEnderecos_ROM-1 downto 0);
		signal Saida_RAM : std_logic_vector (larguraDados_RAM-1 downto 0);
		signal Saida_dec : std_logic_vector (11 downto 0);
		signal Saida_REG_RET : std_logic_vector (larguraEnderecos_ROM - 1 downto 0);
		signal proxPC : std_logic_vector (8 downto 0);
		signal SelMUX_ULA : std_logic;
		signal Habilita_Banco : std_logic;
		signal habFlag_Igual : std_logic;
		signal habEscrita_ret : std_logic;
		signal Operacao_ULA : std_logic_vector(1 downto 0);
		signal jmp_signal  : std_logic;
		signal jeq_signal  : std_logic;
		signal zero_signal : std_logic;
		signal jsr_signal : std_logic;
		signal ret_signal : std_logic; 
		signal saida_desvio : std_logic_vector(1 downto 0);
	begin
	-- O port map completo do MUX.
	MUX_ULA :  entity work.muxGenerico2x1  generic map (larguraDados => larguraEnderecos_ROM-1)
			  port map( entradaA_MUX => Data_IN,
						  entradaB_MUX =>  Instruction_IN(7 downto 0),
						  seletor_MUX => SelMUX_ULA,
						  saida_MUX => entradaB_ULA);
						  
	MUX_JMP :  entity work.muxGenerico4x1  generic map (larguraDados => larguraEnderecos_ROM)
			  port map( entrada0_MUX => proxPC,
						  entrada1_MUX =>  Instruction_IN(8 downto 0),
						  entrada2_MUX =>  Saida_REG_RET,
						  entrada3_MUX =>  "000000000",
						  seletor_MUX => saida_desvio,
						  saida_MUX => Saida_MUX_JMP);

	-- O port map completo do Acumulador.
	
   BANCOREG : entity work.bancoRegistradoresArqRegMem   generic map (larguraDados => 8, larguraEndBancoRegs => 2)
          port map ( clk => CLK,
              endereco => Instruction_IN(14 downto 13),
              dadoEscrita => Saida_ULA,
              habilitaEscrita => Habilita_Banco,
              saida  => entradaA_ULA);
				  
	REG_RETORNO : entity work.registradorGenerico   generic map (larguraDados => larguraEnderecos_ROM)
				 port map (DIN => proxPC, DOUT => Saida_REG_RET, ENABLE => habEscrita_ret, CLK => CLK, RST => Reset);
				 
	FLAG : entity work.flipFlop
				 port map (DIN => zero_signal, DOUT => REG_FLAG, ENABLE => habFlag_Igual, CLK => CLK, RST => Reset);

	-- O port map completo do Prog Counter.
	PC : entity work.registradorGenerico   generic map (larguraDados => larguraEnderecos_ROM)
				 port map (DIN => Saida_MUX_JMP, DOUT => Saida_PC, ENABLE => '1', CLK => CLK, RST => Reset);

	incrementaPC :  entity work.somaConstante  generic map (larguraDados => larguraEnderecos_ROM, constante => 1)
			  port map( entrada => Saida_PC, saida => proxPC);


	-- O port map completo da ULA:
	ULA1 : entity work.ULASomaSub  generic map(larguraDados => 8)
				 port map (entradaA => entradaA_ULA, entradaB => entradaB_ULA, saida => Saida_ULA, seletor => Operacao_ULA, flagZero => zero_signal);
				 
	decoderI : entity work.decoderInstru
		 port map (
			opcode => Instruction_IN(12 downto 9),
			saida => Saida_dec
		 );

	desvio_inst : entity work.logicaDeDesvio
			port map (
				Zero  => REG_FLAG,
				JEQ   => jeq_signal,
				JMP   => jmp_signal,
				JSR	=> jsr_signal,
				RET	=> ret_signal,
				saida => saida_desvio   
			);

	habEscrita_ret <= Saida_dec(11);
	jmp_signal <= Saida_dec(10);
	ret_signal <= Saida_dec(9);
	jsr_signal <= Saida_dec(8);
	jeq_signal <= Saida_dec(7);
	SelMUX_ULA <= Saida_dec(6);
	Habilita_Banco <= Saida_dec(5);
	Operacao_ULA <= Saida_dec(4 downto 3);
	habFlag_Igual <= Saida_dec(2);
	Wr <= Saida_dec(0);
	Rd <= Saida_dec(1);
	Data_Address <= Instruction_IN(8 downto 0);
	Data_OUT <= entradaA_ULA;
	ROM_address <= Saida_PC;
	end architecture;