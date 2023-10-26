-- ARQUITETURA E ORGANIZAÇÃO DE COMPUTADORES | LAB#2          --
-- Professor Juliano Mourão Vieira | UTFPR | 2023.2           -- 
-- Daniel Augusto Pires de Castro | Alexandre Vinicius Hubert --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_tb is
end;

architecture a_ULA_tb of ULA_tb is 

    component ULA 
        port(
            entrada0 : in unsigned (15 downto 0);
            entrada1 : in unsigned (15 downto 0);
            sel : in unsigned(1 downto 0);
            saida : out unsigned (15 downto 0)
        );
    end component;

    signal entrada0 : unsigned (15 downto 0);
    signal entrada1 : unsigned (15 downto 0);
    signal sel : unsigned(1 downto 0);
    signal saida: unsigned(15 downto 0);

    begin
        uut: ULA port map(
            entrada0 => entrada0,
            entrada1 => entrada1,
            sel => sel,
            saida => saida
        );
    
    process
        begin 
            -- ADIÇÃO
            sel <= "00";
            entrada0 <= "0000000000001101"; -- 13 = D 
            entrada1 <= "0000000000010010"; -- 18 = 12
            -- 13 + 18 = 31 = 1F
            wait for 50 ns;
            sel <= "00";
            entrada0 <= "0000000000101101"; -- 45 = 2D
            entrada1 <= "0000000000010010"; -- 18 = 12
            -- 45 + 18 = 63 = 3F
            wait for 50 ns;
            sel <= "00";
            entrada0 <= "0000000000010110"; -- 16 = 22
            entrada1 <= "1111111111111101"; -- 65533 = FFFD
            -- 16 + 65533 = 65549 = 1000D -> por algum motivo é mostrado o valor decimal de D = 13
            wait for 50 ns;

            -- SUBTRAÇÃO
            sel <= "01";
            entrada0 <= "0000000000001101"; -- 13 = D 
            entrada1 <= "0000000000010010"; -- 18 = 12
            -- 13 - 18 = -5 = FFFB
            wait for 50 ns;
            sel <= "01";
            entrada0 <= "0000000000101101"; -- 45 = 2D
            entrada1 <= "0000000000010010"; -- 18 = 12
            -- 45 - 18 = 27 = 1B
            wait for 50 ns;
            sel <= "01";
            entrada0 <= "0000000000010110"; -- 16 = 22
            entrada1 <= "1111111111111101"; -- 65533 = FFFD
            -- 16 - 65533 = -65517 -> por algum motivo é mostrado o valor decimal de 65533-65517+1 = 19
            wait for 50 ns;
           
            -- MULTIPLICAÇÃO
            sel <= "10";
            entrada0 <= "0000000000000011"; -- 3 = 3
            entrada1 <= "0000000000000101"; -- 5 = 5
            -- 3 * 5 = 15 = F
            wait for 50 ns;
            sel <= "10";
            entrada0 <= "0000000000000011"; -- 3 = 3
            entrada1 <= "1111111111111011"; -- 65531 = FFFB
            -- 3 * 5 = 15 = F
            wait for 50 ns;
            sel <= "10";
            entrada0 <= "1111111111111101"; -- 65533 = FFFD
            entrada1 <= "1111111111111011"; -- 65531 = FFFB
            -- 65533 * 65531 = 4294443023 = FFF8000F
            wait for 50 ns;

            sel <= "11";
            entrada0 <= "1111000011001010";
            entrada1 <= "1111000011001010";
            -- teste alternando com todos os bits iguais -> retorna 0 para todos
            wait for 50 ns;
            sel <= "11";
            entrada0 <= "1010101010101010";
            entrada1 <= "0101010101010101";
            -- teste alternando com todos os bits diferentes -> retorna 1 para todos
            wait for 50 ns;
            sel <= "11";
            entrada0 <= "1110111100001110";
            entrada1 <= "0011001110011110";
            -- valor aleatório -> 1101110010010000 = DC90
            wait for 50 ns;

            wait;
        end process; 

end architecture;