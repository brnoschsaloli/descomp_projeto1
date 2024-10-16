-- Biblioteca IEEE
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entidade do componente bancoRegistradores
entity bancoRegistradores is
    Port (
        clk            : in  std_logic;                       -- Clock
        sel            : in  std_logic_vector(2 downto 0);    -- Seletor (3 bits para 8 registradores)
        data_in        : in  std_logic_vector(7 downto 0);    -- Dado de entrada (8 bits)
        habRegistrador : in  std_logic;                       -- Habilita a escrita no registrador
        data_out       : out std_logic_vector(7 downto 0)     -- Saída do registrador selecionado
    );
end entity;

-- Arquitetura do componente bancoRegistradores
architecture Behavioral of bancoRegistradores is

    -- Declaração de um array de registradores
    type reg_array is array (0 to 7) of std_logic_vector(7 downto 0);
    signal regs : reg_array := (others => (others => '0'));

begin

    -- Processo que escreve o dado de entrada no registrador selecionado na borda de subida do clock
    process(clk)
    begin
        if rising_edge(clk) then
            if habRegistrador = '1' then
                regs(to_integer(unsigned(sel))) <= data_in;
            end if;
        end if;
    end process;

    -- Atribuição da saída com o valor do registrador selecionado
    data_out <= regs(to_integer(unsigned(sel)));

end Behavioral;
