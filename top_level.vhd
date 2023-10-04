-- ARQUITETURA E ORGANIZAÇÃO DE COMPUTADORES | LAB#3          --
-- Professor Juliano Mourão Vieira | UTFPR | 2023.2           -- 
-- Daniel Augusto Pires de Castro | Alexandre Vinicius Hubert --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port(
        sel_cte_ext : in std_logic;

        sel_reg_lido_1 :  in unsigned(2 downto 0);
        sel_reg_lido_2 :  in unsigned(2 downto 0);
        sel_reg_escrito : in unsigned(2 downto 0);

        sel_operacao : in unsigned(1 downto 0);
        clk             : in std_logic;
        reset           : in std_logic;
        wr_en           : in std_logic;

        constante_ext : in unsigned(15 downto 0);

        saida_ula : out unsigned(15 downto 0)
    );

end entity;

architecture a_top_level of top_level is
    component banco_registradores is
        port (
            sel_reg_lido_1  : in unsigned(2 downto 0);
            sel_reg_lido_2  : in unsigned(2 downto 0);
            escrita         : in unsigned(15 downto 0);
            sel_reg_escrito : in unsigned(2 downto 0);
            clk             : in std_logic;
            reset           : in std_logic;
            wr_en           : in std_logic;

            reg_lido_1      : out unsigned(15 downto 0);
            reg_lido_2      : out unsigned(15 downto 0)
        );
    end component;

    component ULA is
        port(
            entrada0 : in unsigned (15 downto 0); -- primeiro operando
            entrada1 : in unsigned (15 downto 0); -- segundo operando
            sel : in unsigned (1 downto 0);       -- operação selecionada
            saida : out unsigned (15 downto 0)
        );
    end component;

    signal escrita : unsigned(15 downto 0);
    signal reg_lido_1 : unsigned(15 downto 0);
    signal reg_lido_2 : unsigned(15 downto 0);
    signal entrada1 : unsigned(15 downto 0);

    begin
        ligacoes_banco: banco_registradores port map (
            sel_reg_lido_1 => sel_reg_lido_1,
            sel_reg_lido_2 => sel_reg_lido_2,
            escrita => escrita,
            sel_reg_escrito => sel_reg_escrito,
            clk => clk,
            reset => reset,
            wr_en => wr_en,
            reg_lido_1 => reg_lido_1,
            reg_lido_2 => reg_lido_2
        );

        entrada1 <= reg_lido_2 when sel_cte_ext = '0' else
                    constante_ext when sel_cte_ext = '1' else
                    "0000000000000000";
        saida_ula <= escrita;

        ligacoes_ula: ULA port map (
            entrada0 => reg_lido_1,
            entrada1 => entrada1,
            sel => sel_operacao,
            saida => escrita
        );

end architecture;