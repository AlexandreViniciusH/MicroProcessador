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
    0 => "0111111100000001", -- CLR A
    1 => "1111011000011001", -- LD r3, A
    -- 2. Carrega R4 com 0
    2 => "0111111000000001", -- CLR A
    3 => "1111011000100001", -- LD  r4, A
    -- 3. Soma R3 com R4 e guarda em R4
    4 => "1111011000001011", -- LD A, R3
    5 => "1111101100000100", -- ADD A, r4
    6 => "1111011000100001", -- LD  r4, A
    -- 4. Soma 1 em R3
    7 => "1111011000001011", -- LD A, R3
    8 => "1010101100000001", -- ADD A, #$1
    9 => "1111011000011001", -- LD r3, A
    -- 5. Se r3<30 salta para endereço 3
    10 => "0111111100000001", -- CLR A
    11 => "1010101100011110", -- ADD A, #$30
    12 => "1111000000000011", -- SUB A, r3
    13 => "0010101011110111", -- JRPL #$-9
    -- 6. Copia o valor de R4 para R5
    14 => "1111011000101100", -- LD R5, R4
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

