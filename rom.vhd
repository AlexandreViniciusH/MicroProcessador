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

    -- 1. Carrega R3 (registrador 3) com 0
    0 => "1010101100000000", -- ADD A,#$0
    1 => "1111011100000011", -- LD (X3),A
    2 => "0100111100000000", -- CLR A
    -- 2. Carrega R4 com 0
    3 => "1010101100000000", -- ADD A,#$0
    4 => "1111011100000100", -- LD (X4),A
    5 => "0100111100000000", -- CLR A
    -- 3. Soma R3 com R4 e guarda em R4
    6 => "0100111100000000", -- CLR A
    7 => "1111101100000011", -- ADD A,(X3)
    8 => "1111101100000100", -- ADD A,(X4)
    9 => "1111011100000100", -- LD (X4),A
    10 => "0100111100000000", -- CLR A
    -- 4. Soma 1 em R3 
    11 => "1010101100000001", -- ADD A, #$1
    12 => "1111101100000011", -- ADD A,(X3)
    13 => "1111011100000011", -- LD (X3),A
    14 => "0100111100000000", -- CLR A
    -- 5. Se r3<30 salta para endereço 3
    15 => "1010101100011110", -- ADD A, #$30
    16 => "1111011100000001", -- LD (X1),A
    17 => "0100111100000000", -- CLR A
    18 => "1111101100000011", -- ADD A,(X3)
    19 => "1111000000000001", -- SUB A,(X1)
    20 => "0010010101110010", -- JRC #$-11
    -- 6. Copia o valor de R4 para R5
    21 => "1111111100101100", -- LDW R5, R4

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

