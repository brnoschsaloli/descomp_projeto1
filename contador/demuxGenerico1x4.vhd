LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity demuxGenerico1x4 is
  generic (
    larguraEntrada : natural := 9;
    larguraSelecao : natural := 2;
    invertido      : boolean := FALSE
  );
  port (
    entrada       : in  std_logic_vector(larguraEntrada-1 downto 0);
    seletor_demux : in  std_logic_vector(larguraSelecao-1 downto 0);
    saida_0       : out std_logic_vector(larguraEntrada-1 downto 0);
    saida_1       : out std_logic_vector(larguraEntrada-1 downto 0);
    saida_2       : out std_logic_vector(larguraEntrada-1 downto 0);
    saida_3       : out std_logic_vector(larguraEntrada-1 downto 0)
  );
end entity;

architecture Behavioral of demuxGenerico1x4 is
  signal entrada_processada : std_logic_vector(larguraEntrada-1 downto 0);
begin

  -- Processamento da entrada com base no parâmetro 'invertido'
  entrada_processada <= not entrada when invertido else entrada;

  process(entrada_processada, seletor_demux)
  begin
    -- Inicializa todas as saídas com zeros
    saida_0 <= (others => '0');
    saida_1 <= (others => '0');
    saida_2 <= (others => '0');
    saida_3 <= (others => '0');

    -- Direciona a entrada para a saída selecionada
    case seletor_demux is
      when "00" =>
        saida_0 <= entrada_processada;
      when "01" =>
        saida_1 <= entrada_processada;
      when "10" =>
        saida_2 <= entrada_processada;
      when "11" =>
        saida_3 <= entrada_processada;
      when others =>
        null; -- Não faz nada para valores de seletor inválidos
    end case;
  end process;

end architecture;
