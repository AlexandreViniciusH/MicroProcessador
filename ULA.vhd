-- ARQUITETURA E ORGANIZAÇÃO DE COMPUTADORES | LAB#2          --
-- Professor Juliano Mourão Vieira | UTFPR | 2023.2           -- 
-- Daniel Augusto Pires de Castro | Alexandre Vinicius Hubert --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(
            entrada0 : in unsigned (15 downto 0); -- primeiro operando
            entrada1 : in unsigned (15 downto 0); -- segundo operando
            sel : in unsigned (1 downto 0); -- operação selecionada
            saida : out unsigned (15 downto 0)
    );
end entity;

architecture a_ULA of ULA is 
    -- gambiarra mostrada em sala de aula para efetuar multiplicação
    signal multiplicacao: unsigned (31 downto 0);
begin
    multiplicacao <= entrada0 * entrada1 when sel = "10" else 
                "00000000000000000000000000000000";

    -- saída selecionada conforme sel
    saida <=    entrada0 + entrada1 when sel = "00" else
                entrada0 - entrada1 when sel = "01" else
                multiplicacao(15 downto 0) when sel = "10" else
                entrada0 xor entrada1 when sel = "11" else
                "0000000000000000";

    -- foi avisado em sala de aula que não precisava ser mais obrigatório comparação
end architecture;