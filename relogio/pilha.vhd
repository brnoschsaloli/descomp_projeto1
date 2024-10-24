library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pilha is
    generic (
        STACK_DEPTH : integer := 16;  -- Tamanho da pilha
        DATA_WIDTH : integer := 9      -- Largura de dados
    );
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        push      : in  std_logic;    -- Sinal para operação de push
        pop       : in  std_logic;    -- Sinal para operação de pop
        data_in   : in  std_logic_vector(DATA_WIDTH-1 downto 0); -- Dado de entrada para push
        data_out  : out std_logic_vector(DATA_WIDTH-1 downto 0); -- Dado de saída para pop
        stack_full  : out std_logic;  -- Indica se a pilha está cheia
        stack_empty : out std_logic   -- Indica se a pilha está vazia
    );
end pilha;

architecture Behavioral of pilha is
    type stack_array is array (0 to STACK_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal stack : stack_array := (others => (others => '0'));  -- Array da pilha
    signal sp : integer range 0 to STACK_DEPTH;  -- Ponteiro do topo da pilha

begin
    process(clk, reset)
    begin
        if reset = '1' then
            sp <= 0;  -- Reseta o ponteiro da pilha
        elsif rising_edge(clk) then
            if push = '1' and sp < STACK_DEPTH then
                stack(sp) <= data_in;  -- Insere dado no topo da pilha
                sp <= sp + 1;
            elsif pop = '1' and sp > 0 then
                sp <= sp - 1;  -- Remove o dado do topo da pilha
            end if;
        end if;
    end process;

    -- Saída do dado do topo da pilha
    data_out <= stack(sp-1) when (sp > 0) else (others => '0');

    -- Sinais de status da pilha
    stack_full  <= '1' when sp = STACK_DEPTH else '0';
    stack_empty <= '1' when sp = 0 else '0';

end Behavioral;
