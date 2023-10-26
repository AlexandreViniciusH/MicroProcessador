-- ARQUITETURA E ORGANIZAÇÃO DE COMPUTADORES | LAB#5          --
-- Professor Juliano Mourão Vieira | UTFPR | 2023.2           -- 
-- Daniel Augusto Pires de Castro | Alexandre Vinicius Hubert --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port
    (
        wr_en    : in std_logic;
        clk      : in std_logic;
        reset    : in std_logic;
        data_rom : out unsigned (31 downto 0);
        saida_ula: out unsigned (15 downto 0);
        estado    : out unsigned (1 downto 0);
        reg_lido_1      : out unsigned(15 downto 0);
        reg_lido_2      : out unsigned(15 downto 0)
    );

end entity;

architecture a_processador of processador is

    component unidade_controle is
        port
        (
            wr_en    : in std_logic;
            clk      : in std_logic;
            reset    : in std_logic;

            estado   : out unsigned (1 downto 0);
            data_rom : out unsigned (31 downto 0);
            sel_reg_lido_1  : out unsigned(2 downto 0);
            sel_reg_lido_2  : out unsigned(2 downto 0);
            sel_reg_escrito : out unsigned(2 downto 0);
            sel_operacao :    out unsigned(1 downto 0);
            im_en : out std_logic; 
            valor_imm : out unsigned (15 downto 0)
        );
    end component;

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

    component ula is 
        port(
            entrada0 : in unsigned (15 downto 0); -- primeiro operando
            entrada1 : in unsigned (15 downto 0); -- segundo operando
            sel : in unsigned (1 downto 0); -- operação selecionada
            saida : out unsigned (15 downto 0)
        );
    end component;

    signal state : unsigned(1 downto 0);
    signal escrita : unsigned(15 downto 0);
    signal entrada1 : unsigned(15 downto 0);
    
    signal im_en, w_e: std_logic;
    signal valor_imm : unsigned(15 downto 0);
    signal sel_reg_lido_1  : unsigned (2 downto 0);
    signal sel_reg_lido_2  : unsigned (2 downto 0);
    signal sel_reg_escrito : unsigned(2 downto 0);
    signal sel_operacao : unsigned(1 downto 0);

    signal reglido1 : unsigned(15 downto 0);
    signal reglido2 : unsigned(15 downto 0);

    begin

        ---------------------- FETCH/DECODE ---------------------------
        progUC: unidade_controle port map(
            wr_en => wr_en,
            clk   => clk ,
            reset => reset,
            estado => state,
    
            data_rom => data_rom,
            sel_reg_lido_1 => sel_reg_lido_1,
            sel_reg_lido_2  => sel_reg_lido_2,
            sel_reg_escrito => sel_reg_escrito,
            sel_operacao => sel_operacao,
            im_en => im_en,
            valor_imm => valor_imm
        );

        estado <= state;

        ---------------------- EXECUTE ---------------------------
        w_e <= wr_en when state = "10" else '0';

        ligacoes_banco: banco_registradores port map (
            sel_reg_lido_1 => sel_reg_lido_1,
            sel_reg_lido_2 => sel_reg_lido_2,
            escrita => escrita,
            sel_reg_escrito => sel_reg_escrito,
            clk => clk,
            reset => reset,
            wr_en => w_e,
            reg_lido_1 => reglido1,
            reg_lido_2 => reglido2
        );

        reg_lido_2 <= reglido2;
        reg_lido_1 <= reglido1;

        entrada1 <= reglido2 when im_en = '0' else
                    valor_imm when im_en = '1' else
                    "0000000000000000";
        saida_ula <= escrita;

        ligacoes_ula: ULA port map (
            entrada0 => reglido1,
            entrada1 => entrada1,
            sel => sel_operacao,
            saida => escrita
        );

end architecture;
