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
            dado : out unsigned (31 downto 0)
        );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned (31 downto 0);
    constant conteudo_rom : mem := (

    -- 1. Carrega R3 (o registrador 3) com o valor 5
    0 => "00000000101010110000000000000101", -- ADD A, #$5
    1 => "00000000111101100000000000011001", -- LD r3, A
    2 => "00000000011111110000000000000001", -- CLR A
    -- 2. Carrega R4 com 8
    3 => "00000000101010110000000000001000", -- ADD A, #$8
    4 => "00000000111101100000000000100001", -- LD  r4, A
    5 => "00000000011111110000000000000001", -- CLR A
    -- 3. Soma R3 com R4 e guarda em R5
    6 => "00000000111110110000000000000011", -- ADD A, r3
    7 => "00000000111110110000000000000100", -- ADD A, r4
    8 => "00000000111101100000000000101001", -- LD r5, A
    9 => "00000000011111110000000000000001", -- CLR A
    -- 4. Subtrai 1 de R5
    10 => "00000000111110110000000000000101", -- ADD  A, r5
    11 => "00000000101000000000000000000001", -- SUB  A, #$1
    12 => "00000000111101100000000000101001", -- LD r5, A
    13 => "00000000011111110000000000000001", -- CLR r1
    -- 5. Salta para o endereço 20
    14 => "00000000101011000000000000010100", -- JPF #$14
    -- 6. No endereço 20, copia R5 para R3
    20 => "00000000111101100000000000011101", -- LD r3, r5
    -- 7. Salta para a terceira instrução desta lista (R5 <= R3+R4)
    21 => "00000000101011000000000000000110", -- JPF #$6

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

