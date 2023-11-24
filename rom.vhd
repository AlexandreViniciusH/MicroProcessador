-- ARQUITETURA E ORGANIZAÇÃO DE COMPUTADORES | LAB#5          --
-- Professor Juliano Mourão Vieira | UTFPR | 2023.2           -- 
-- Daniel Augusto Pires de Castro | Alexandre Vinicius Hubert --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port(
            clk : in std_logic;
            endereco : in unsigned (6 downto 0);
            dado : out unsigned (15 downto 0)
        );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned (15 downto 0);
    constant conteudo_rom : mem := (

    -- 1. Coloque na memória RAM, com um loop em assembly, os números de interesse do 1 até o 32
    -- >> Soma 1 em X1 
    0 => B"01001111_00000000",  -- CLR A
    1 => B"10101011_00000001",  -- ADD A,#$1
    2 => B"11111011_00000_001", -- ADD A,(X1)
    3 => B"11110111_00000_001", -- LD (X1),A
    -- >> Carrega o valor de A no endereço 0 + X1
    4 => B"11100111_00000000",  -- LD ($0,X1),A
    5 => B"01001111_00000000",  -- CLR A
    -- >> Se X1<32 salta para instrução 0
    6 => B"11111011_00000_001", -- ADD A,(X1)
    7 => B"10100000_00100000",  -- SUB A,#$32
    8 => B"00100101_0_1111000", -- JRC #$-8
    -- >> Limpa Registradores
    9 => B"01111111_00000_001", -- CLR (X1)
    10 => B"01001111_00000000",  -- CLR A

    -- 2. Elimine da lista, com um loop,  todos os múltiplos de 2.
    -- 3. Idem para 3 e 5.
    -- 4. Seria decente seguir o algoritmo completo (“tente” eliminar todos os não primos, como os múltiplos de 7, 11 e etc.), então faça isso se der.
    -- >> Primo inicial para conferir: 2
    11 => B"10101011_00000010",  -- ADD A,#$2
    12 => B"11111011_00000_010", -- ADD A,(X2)
    13 => B"11110111_00000_010", -- LD (X2),A
    -- >> Soma X2 em X1 (antes do loop para não eliminar o 2)
    14 => B"01001111_00000000",  -- CLR A
    15 => B"11111011_00000_010", -- ADD A,(X2)
    16 => B"11111011_00000_001", -- ADD A,(X1)
    17 => B"11110111_00000_001", -- LD (X1),A
    -- >> Soma X2 em X1 (dentro do loop)
    18 => B"01001111_00000000",  -- CLR A
    19 => B"11111011_00000_010", -- ADD A,(X2)
    20 => B"11111011_00000_001", -- ADD A,(X1)
    21 => B"11110111_00000_001", -- LD (X1),A
    -- >> Carrega 0 no endereço 0 + X1
    22 => B"01001111_00000000",  -- CLR A
    23 => B"11100111_00000000",  -- LD ($0,X1),A
    -- >> Se X1<32 salta para instrução 18
    24 => B"11111011_00000_001", -- ADD A,(X1)
    25 => B"10100000_00100000",  -- SUB A,#$32
    26 => B"00100101_0_1111000", -- JRC #$-8
    -- >> Limpa e soma o X1 com o X2 que tem o primo atual
    27 => B"01111111_00000_001", -- CLR (X1)
    28 => B"01001111_00000000",  -- CLR A
    29 => B"11111011_00000_010", -- ADD A,(X2)
    30 => B"11111011_00000_001", -- ADD A,(X1)
    31 => B"11110111_00000_001", -- LD (X1),A
    -- >> Soma 1 em X1 
    32 => B"01001111_00000000",  -- CLR A
    33 => B"10101011_00000001",  -- ADD A,#$1
    34 => B"11111011_00000_001", -- ADD A,(X1)
    35 => B"11110111_00000_001", -- LD (X1),A
    -- >> Carrega o valor do endereço 0 + X1 em A, se esse valor é igual a 0, pula para a instrução 32
    36 => B"11100110_00000000",  -- LD A,($0,X1)
    37 => B"10100000_00000000",  -- SUB A,#$00
    38 => B"00100111_0_1111010", -- JREQ #$-6
    -- >> Se o valor não for igual a 0, carrega A em X2
    39 => B"01111111_00000_001", -- CLR (X1)
    40 => B"11110111_00000_010", -- LD (X2),A
    -- >> Se X2 < 32 pula para a instrução 14
    41 => B"10100000_00100000",  -- SUB A,#$32
    42 => B"00100101_0_1100100", -- JRC #$-28

    -- 5. Faça um loop para ler a RAM do endereço 2 ao 32.
    -- >> Foi feito usando X2 para leitura da RAM
    43 => B"01111111_00000_001", -- CLR (X1)
    44 => B"01111111_00000_010", -- CLR (X2)
    45 => B"01001111_00000000",  -- CLR A
    46 => B"01111111_00000_010", -- ADD A,#$2
    47 => B"11110111_00000_001", -- LD (X1),A
    -- >> Soma 1 em X1 
    48 => B"01001111_00000000",  -- CLR A
    49 => B"10101011_00000001",  -- ADD A,#$1
    50 => B"11111011_00000_001", -- ADD A,(X1)
    51 => B"11110111_00000_001", -- LD (X1),A
    -- >> Carrega o valor do endereço 0 + X1 em A e armazena em X2
    52 => B"11100110_00000000",  -- LD A,($0,X1)
    53 => B"11110111_00000_010", -- LD (X2),A
    -- >> Se X1<32 salta para instrução 44
    54 => B"01001111_00000000",  -- CLR A
    55 => B"11111011_00000_001", -- ADD A,(X1)
    56 => B"10100000_00100000",  -- SUB A,#$32
    57 => B"00100101_0_1110111", -- JRC #$-9

    -- >> Limpa tudo no final
    58 => B"01001111_00000000",  -- CLR A
    59 => B"01111111_00000_001", -- CLR (X1)
    60 => B"01111111_00000_010", -- CLR (X2)

    others => (others => '0')
    );
begin
    process (clk)   
    begin
        if (rising_edge(clk))then
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;

