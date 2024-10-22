# Projeto de Contador Programado em VHDL

Este projeto consiste em um contador programado em VHDL que implementa uma CPU simples e sua integração em uma placa FPGA. O objetivo é demonstrar o funcionamento de instruções personalizadas em assembly e a interação com os componentes da placa.

## Declaração sobre a divisão do trabalho

O projeto foi desenvolvido em parceria por **Breno Schneider** e **Thiago Victoriano**. Ambos trabalharam separadamente na montagem do hardware, optando por utilizar como base o projeto do Thiago, uma vez que ele iniciou as implementações primeiro. O código principal em assembly foi elaborado em conjunto, com divisões básicas dentro de cada função de cada parte do código. O assembler foi desenvolvido pelo Thiago, enquanto as novas funcionalidades do hardware específicas para o projeto foram implementadas pelo Breno.

## Funcionamento dos botões e chaves

- **SW3 a SW0**: Determinam o limite da contagem. Ao pressionar o botão **KEY1**, o valor das chaves é definido, incrementando de unidade, dezena, centena até centena de milhar.
- **KEY0**: Incrementa a contagem.
- **KEY2**: Decrementa a contagem.
- **FPGA_RESET**: Reinicia a contagem.
- **SW9 a SW4**: Não possuem funcionalidade no projeto atual.
- **KEY3**: Não possui funcionalidade no projeto atual.

## Novas instruções implementadas

Foram implementadas as seguintes novas instruções no assembly:

- **AND**: Realiza a operação lógica AND entre o registrador A e o conteúdo de um endereço de memória especificado.
  - **Sintaxe**: `AND @<endereço>`
  - **Exemplo**: `AND @4` (Realiza o AND entre o registrador e o conteúdo do endereço 4 da memória)

- **ANDi**: Realiza a operação lógica AND entre o registrador A e um valor imediato.
  - **Sintaxe**: `ANDi $<valor_imediato>`
  - **Exemplo**: `ANDi $3` (Realiza o AND entre o registrador e o valor 3)

- **ADDi**: Realiza a soma entre o registrador A e um valor imediato.
  - **Sintaxe**: `ADDi $<valor_imediato>`

- **SUBi**: Realiza a subtração entre o registrador A e um valor imediato.
  - **Sintaxe**: `SUBi $<valor_imediato>`

- **CEQi**: Compara o valor do registrador A com um valor imediato, ativando a flag de igualdade se ambos forem iguais.
  - **Sintaxe**: `CEQi $<valor_imediato>`

### Fluxo de Dados para as Novas Instruções

#### Exemplo: Funcionamento da instrução **ANDi**

1. **Busca da Instrução (Fetch)**: A CPU busca a instrução `ANDi $<valor_imediato>` na memória de instruções (ROM).
2. **Decodificação**: A instrução é decodificada, identificando que é uma operação lógica AND com um valor imediato.
3. **Operação**:
   - O valor imediato é extraído da instrução.
   - A operação lógica AND é realizada entre o valor imediato e o conteúdo do registrador A.
4. **Escrita do Resultado**: O resultado da operação é armazenado no registrador A.

O fluxo de dados para as outras instruções segue uma lógica semelhante, adaptando-se à operação específica de cada uma.

## RTL Viewer do projeto

![Diagrama do Circuito](path_to_circuit_diagram.png)


## Novos periféricos

Não foram utilizados periféricos extras neste projeto.

## Código-fonte em Assembly

```assembly
LDI $0       # Carrega o acumulador com o valor 0
STA @288     # Armazena o valor do acumulador em HEX0
STA @289     # Armazena o valor do acumulador em HEX1
STA @290     # Armazena o valor do acumulador em HEX2
STA @291     # Armazena o valor do acumulador em HEX3
STA @292     # Armazena o valor do acumulador em HEX4
STA @293     # Armazena o valor do acumulador em HEX5
NOP
LDI $0       # Carrega o acumulador com o valor 0
STA @256     # Armazena o valor do acumulador em LEDR0 ~ LEDR7
STA @257     # Armazena o valor do acumulador em LEDR8
STA @258     # Armazena o valor do acumulador em LEDR9
NOP
LDI $0       # Carrega o acumulador com o valor 0
STA @0       # Armazena o valor do acumulador em MEM[0] (unidades)
STA @1       # Armazena o valor do acumulador em MEM[1] (dezenas)
STA @2       # Armazena o valor do acumulador em MEM[2] (centenas)
STA @6       # Armazena o valor do acumulador em MEM[6] (milhares)
STA @7       # Armazena o valor do acumulador em MEM[7] (dezenas de milhares)
STA @8       # Armazena o valor do acumulador em MEM[8] (centenas de milhares)
STA @9       # Armazena o valor do acumulador em MEM[9] (flag inibir contagem)
LDI $9       # Carrega o acumulador com o valor 9
STA @10      # Armazena o valor do acumulador em MEM[10] (inibir unidade)
STA @11      # Armazena o valor do acumulador em MEM[11] (inibir dezena)
STA @12      # Armazena o valor do acumulador em MEM[12] (inibir centena)
STA @13      # Armazena o valor do acumulador em MEM[13] (inibir milhar)
STA @14      # Armazena o valor do acumulador em MEM[14] (inibir dezena de milhar)
STA @15      # Armazena o valor do acumulador em MEM[15] (inibir centena de milhar)
LDI $0       # Carrega o acumulador com o valor 0
STA @3       # Armazena o valor do acumulador em MEM[3] (constante 0)
LDI $1       # Carrega o acumulador com o valor 1
STA @4       # Armazena o valor do acumulador em MEM[4] (constante 1)
LDI $10      # Carrega o acumulador com o valor 10
STA @5       # Armazena o valor do acumulador em MEM[5] (constante 10)
NOP
STA @511     # Limpa a leitura do botão zero
STA @510     # Limpa a leitura do botão um
INICIO:
NOP
LDA @352     # Carrega o acumulador com a leitura do botão KEY0
ANDi $1      # Utiliza a máscara b0000_0001 para isolar o bit 0
CEQi $0      # Compara com constante 0
JEQ .NAO_CLICOU0  # Desvia se igual a 0 (botão não foi pressionado)
JSR .INCREMENTO   # Chama a sub-rotina de incremento
NOP              # Retorno da sub-rotina
.NAO_CLICOU0:
JSR .SALVA_DISP   # Atualiza os displays com o valor atual
NOP              # Retorno da sub-rotina
LDA @353     # Carrega o acumulador com a leitura do botão KEY1
ANDi $1      # Isola o bit 0
CEQi $0      # Compara com 0
JEQ .NAO_CLICOU1  # Desvia se igual a 0
JSR .DEFINE_LIM   # Chama a sub-rotina para definir o limite
NOP              # Retorno da sub-rotina
.NAO_CLICOU1:
JSR .VERIFICA_LIM # Verifica se o limite foi atingido
NOP              # Retorno da sub-rotina
LDA @354     # Carrega o acumulador com a leitura do botão KEY2
ANDi $1      # Isola o bit 0
CEQi $0      # Compara com 0
JEQ .NAO_CLICOU2  # Desvia se igual a 0
JSR .DECREMENTO   # Chama a sub-rotina de decremento
NOP              # Retorno da sub-rotina
.NAO_CLICOU2:
LDA @356     # Carrega o acumulador com a leitura do FPGA_RESET
ANDi $1      # Isola o bit 0
CEQi $1      # Compara com 1
JEQ .REINICIO     # Desvia se igual a 1
JSR .RESET        # Chama a sub-rotina de reset
.REINICIO:
NOP              # Retorno da sub-rotina
JMP .INICIO      # Loop principal
NOP
.INCREMENTO:
STA @511     # Limpa a leitura do botão
LDA @9       # Carrega a flag de inibição
CEQi $0      # Compara com 0
JEQ .INCREMENTAR
RET
.INCREMENTAR:
LDA @0       # Carrega o valor das unidades
ADDi $1      # Incrementa
CEQi $10     # Compara com 10
JEQ .VAIUM_D  # Se igual a 10, realiza o carry
STA @0       # Armazena o novo valor
RET
.VAIUM_D:
LDA @3       # Carrega 0
STA @0       # Reseta as unidades
LDA @1       # Carrega as dezenas
ADDi $1      # Incrementa
CEQi $10     # Compara com 10
JEQ .VAIUM_C
STA @1       # Armazena o novo valor
RET
.VAIUM_C:
LDA @3       # Carrega 0
STA @1       # Reseta as dezenas
LDA @2       # Carrega as centenas
ADDi $1      # Incrementa
CEQi $10     # Compara com 10
JEQ .VAIUM_M
STA @2       # Armazena o novo valor
RET
.VAIUM_M:
LDA @3       # Carrega 0
STA @2       # Reseta as centenas
LDA @6       # Carrega os milhares
ADDi $1      # Incrementa
CEQi $10     # Compara com 10
JEQ .VAIUM_DM
STA @6       # Armazena o novo valor
RET
.VAIUM_DM:
LDA @3       # Carrega 0
STA @6       # Reseta os milhares
LDA @7       # Carrega dezenas de milhares
ADDi $1      # Incrementa
CEQi $10     # Compara com 10
JEQ .VAIUM_CM
STA @7       # Armazena o novo valor
RET
.VAIUM_CM:
LDA @3       # Carrega 0
STA @7       # Reseta dezenas de milhares
LDA @8       # Carrega centenas de milhares
ADDi $1      # Incrementa
STA @8       # Armazena o novo valor
RET
.SALVA_DISP:
LDA @0       # Carrega unidades
STA @288     # Atualiza HEX0
LDA @1       # Carrega dezenas
STA @289     # Atualiza HEX1
LDA @2       # Carrega centenas
STA @290     # Atualiza HEX2
LDA @6       # Carrega milhares
STA @291     # Atualiza HEX3
LDA @7       # Carrega dezenas de milhares
STA @292     # Atualiza HEX4
LDA @8       # Carrega centenas de milhares
STA @293     # Atualiza HEX5
RET
.RESET:
LDI $0       # Carrega 0
STA @0       # Reseta unidades
STA @1       # Reseta dezenas
STA @2       # Reseta centenas
STA @6       # Reseta milhares
STA @7       # Reseta dezenas de milhares
STA @8       # Reseta centenas de milhares
STA @9       # Reseta flag de inibição
STA @257     # Atualiza LEDR8
RET
.VERIFICA_LIM:
LDA @0       # Carrega unidades
CEQ @10      # Compara com limite definido
JEQ .NEXT_LIM1
RET
.NEXT_LIM1:
LDA @1       # Carrega dezenas
CEQ @11      # Compara com limite definido
JEQ .NEXT_LIM2
RET
.NEXT_LIM2:
LDA @2       # Carrega centenas
CEQ @12      # Compara com limite definido
JEQ .NEXT_LIM3
RET
.NEXT_LIM3:
LDA @6       # Carrega milhares
CEQ @13      # Compara com limite definido
JEQ .NEXT_LIM4
RET
.NEXT_LIM4:
LDA @7       # Carrega dezenas de milhares
CEQ @14      # Compara com limite definido
JEQ .NEXT_LIM5
RET
.NEXT_LIM5:
LDA @8       # Carrega centenas de milhares
CEQ @15      # Compara com limite definido
JEQ .TODOS_IGUAL
RET
.TODOS_IGUAL:
LDI $1       # Carrega 1
STA @9       # Seta flag de inibição
STA @257     # Atualiza LEDR8
RET
.DEFINE_LIM:
STA @510     # Limpa a leitura do botão KEY1
LDA @320     # Carrega as chaves SW7TO0
STA @10      # Define limite das unidades
LDI $4       # Carrega 4
STA @256     # Atualiza LEDs
.AGUARDA_D:
LDA @353     # Lê KEY1
ANDi $1
CEQi $0
JEQ .AGUARDA_D
STA @510
LDA @320
STA @11      # Define limite das dezenas
LDI $16
STA @256
.AGUARDA_C:
LDA @353
ANDi $1
CEQi $0
JEQ .AGUARDA_C
STA @510
LDA @320
STA @12      # Define limite das centenas
LDI $32
STA @256
.AGUARDA_M:
LDA @353
ANDi $1
CEQi $0
JEQ .AGUARDA_M
STA @510
LDA @320
STA @13      # Define limite dos milhares
LDI $128
STA @256
.AGUARDA_DM:
LDA @353
ANDi $1
CEQi $0
JEQ .AGUARDA_DM
STA @510
LDA @320
STA @14      # Define limite das dezenas de milhares
LDI $0
STA @256
LDI $1
STA @258
.AGUARDA_CM:
LDA @353
ANDi $1
CEQi $0
JEQ .AGUARDA_CM
STA @510
LDA @320
STA @15      # Define limite das centenas de milhares
LDI $0
STA @258
RET
.DECREMENTO:
STA @509     # Limpa a leitura do botão KEY2
JMP .DECREMENTAR
RET
.DECREMENTAR:
LDA @0       # Carrega unidades
CEQi $0
JEQ .VEMUM_D
SUBi $1
STA @0
RET
.VEMUM_D:
LDI $9
STA @0
LDA @1       # Carrega dezenas
CEQi $0
JEQ .VEMUM_C
SUBi $1
STA @1
RET
.VEMUM_C:
LDI $9
STA @1
LDA @2       # Carrega centenas
CEQi $0
JEQ .VEMUM_M
SUBi $1
STA @2
RET
.VEMUM_M:
LDI $9
STA @2
LDA @6       # Carrega milhares
CEQi $0
JEQ .VEMUM_DM
SUBi $1
STA @6
RET
.VEMUM_DM:
LDI $9
STA @6
LDA @7       # Carrega dezenas de milhares
CEQi $0
JEQ .VEMUM_CM
SUBi $1
STA @7
RET
.VEMUM_CM:
LDI $9
STA @7
LDA @8       # Carrega centenas de milhares
SUBi $1
STA @8
RET
```

## GitHub do Projeto

Para mais detalhes e acesso ao código completo, visite o repositório no GitHub:

[GitHub - Projeto Contador VHDL](https://github.com/brnoschsaloli/descomp_projeto1)

---