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

    -- Carrega o valor 3 no acumulador e armazena no endereço 30
    0 => "1010101100000011", -- ADD A,#$3
    1 => "1011011100011110", -- LD $30,A
    2 => "0111111100000001", -- CLR A
    -- Carrega o acumulador com o valor do endereço 30 e carrega esse valor no registrador r2
    3 => "1011011000011110", -- LD A,$30
    4 => "1111111100010001", -- LDW (r2),A
    5 => "0111111100000001", -- CLR A
    -- Carrega o valor 255 no acumulador e armazena no endereço 127
    6 => "1010101111111111", -- ADD A,#$255
    7 => "1011011101111111", -- LD $127,A
    8 => "0111111100000001", -- CLR A
    -- Carrega o acumulador com o valor do endereço 127 e carrega esse valor no registrador r7
    9  => "1011011001111111", -- LD A,$127
    10 => "1111111100111001", -- LDW (r7),A
    11 => "0111111100000001", -- CLR A
    -- Carrega o acumulador com o valor do endereço 30 e carrega esse valor no registrador r5
    15 => "1011011000011110", -- LD A,$30
    16 => "1111111100101001", -- LDW (r5),A
    17 => "0111111100000001", -- CLR A
    -- Carrega o valor 123 no acumulador e armazena no endereço 100
    18 => "1010101101111011", -- ADD A,#$123
    19 => "1011011101100100", -- LD $100,A
    20 => "0111111100000001", -- CLR A
    -- Carrega o acumulador com o valor do endereço 100 e carrega esse valor no registrador r3
    21 => "1011011001100100", -- LD A,$100
    22 => "1111111100011001", -- LDW (r3),A
    23 => "0111111100000001", -- CLR A
    -- Carrega o acumulador com o valor do endereço 30 e carrega esse valor no registrador r4
    24 => "1011011000011110", -- LD A,$30
    25 => "1111111100100001", -- LDW (r4),A
    26 => "0111111100000001", -- CLR A
    -- Carrega o valor 84 no acumulador e armazena no endereço 100
    27 => "1010101101010100", -- ADD A,#$84
    28 => "1011011101100100", -- LD $100,A
    29 => "0111111100000001", -- CLR A
    -- Carrega o acumulador com o valor do endereço 100 e carrega esse valor no registrador r3
    30 => "1011011001100100", -- LD A,$100
    31 => "1111111100110001", -- LDW (r6),A
    32 => "0111111100000001", -- CLR A

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

