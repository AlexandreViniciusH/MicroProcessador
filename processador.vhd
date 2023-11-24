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
        data_rom : out unsigned (15 downto 0);
        saida_ula: out unsigned (15 downto 0);
        estado    : out unsigned (1 downto 0);
        reg_lido_1      : out unsigned(15 downto 0);
        reg_lido_2      : out unsigned(15 downto 0);

        carry_debug : out std_logic
    );

end entity;

architecture a_processador of processador is

    component unidade_controle is
        port
        (
            wr_en    : in std_logic;
            clk      : in std_logic;
            reset    : in std_logic;
            carry : in std_logic;
            zero : in std_logic;

            estado   : out unsigned (1 downto 0);
            data_rom : out unsigned (15 downto 0);
            sel_reg_lido_1  : out unsigned(2 downto 0);
            sel_reg_lido_2  : out unsigned(2 downto 0);
            sel_reg_escrito : out unsigned(2 downto 0);
            sel_operacao :    out unsigned(1 downto 0);
            im_en : out std_logic; 
            valor_imm : out unsigned (7 downto 0);
            read_ram : out std_logic;
            we_ram : out std_logic;
            endereco_ram : out unsigned (6 downto 0)
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
            saida : out unsigned (15 downto 0);
            carry : out std_logic
        );
    end component;

    component flip_flop_D is
       port(
            clk             : in std_logic;
            reset           : in std_logic;
            we              : in std_logic;
            D               : in std_logic;
            Q               : out std_logic
        );
    end component;

    component ram is
        port( 
            clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            wr_en    : in std_logic;
            dado_in  : in unsigned(15 downto 0);
            dado_out : out unsigned(15 downto 0) 
        );
    end component;

    signal state : unsigned(1 downto 0);
    signal escrita : unsigned(15 downto 0);
    signal entrada0 : unsigned(15 downto 0);
    signal entrada1 : unsigned(15 downto 0);
    
    signal im_en, w_e, read_ram, we_ram: std_logic;
    signal valor_imm : unsigned(7 downto 0);
    signal endereco_ram : unsigned(6 downto 0);
    signal valor_imm_16 : unsigned (15 downto 0);
    signal sel_reg_lido_1  : unsigned (2 downto 0);
    signal sel_reg_lido_2  : unsigned (2 downto 0);
    signal sel_reg_escrito : unsigned(2 downto 0);
    signal sel_operacao : unsigned(1 downto 0);

    signal reglido1 : unsigned(15 downto 0);
    signal reglido2 : unsigned(15 downto 0);
    signal valor_ram : unsigned(15 downto 0);

    signal reglido1_17, reglido2_17, soma_17 : unsigned (16 downto 0);
    signal carry, zero: std_logic;
    signal carry_uc, zero_uc: std_logic;
    signal data : unsigned(15 downto 0);

    signal D,Q: std_logic;

    begin

        ---------------------- FETCH/DECODE ---------------------------
        progUC: unidade_controle port map(
            wr_en => wr_en,
            clk   => clk ,
            reset => reset,
            estado => state,
            carry => carry_uc,
            zero => zero_uc,
    
            data_rom => data,
            sel_reg_lido_1 => sel_reg_lido_1,
            sel_reg_lido_2  => sel_reg_lido_2,
            sel_reg_escrito => sel_reg_escrito,
            sel_operacao => sel_operacao,
            im_en => im_en,
            valor_imm => valor_imm,
            read_ram => read_ram,
            we_ram => we_ram,
            endereco_ram => endereco_ram
        );
        data_rom <= data;
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

        -- D <= reglido1(15) when data(15 downto 8) = "00101010"  else -- como usamos um acomulador o carry de subtração vai ser o MSB do acumulador
        --              '0';

        carry_flag : flip_flop_D port map(
            clk => clk,
            reset => reset,
            we => w_e,
            D => carry,
            Q => carry_uc
        );

        zero_flag : flip_flop_D port map(
            clk => clk,
            reset => reset,
            we => w_e,
            D => zero,
            Q => zero_uc
        );

        leitura_ram : ram port map(
            clk => clk,
            endereco => endereco_ram,
            wr_en => we_ram,
            dado_in => reglido1,
            dado_out => valor_ram
        );

        valor_imm_16 <= "00000000" & valor_imm when valor_imm(7) = '0' else
                        "11111111" & valor_imm when valor_imm(7) = '1' else
                        "0000000000000000";

        entrada0 <= reglido1 when read_ram = '0' else
                    valor_ram when read_ram = '1' else
                    "0000000000000000";
        entrada1 <= reglido2 when im_en = '0' else
                    valor_imm_16 when im_en = '1' else
                    "0000000000000000";
        saida_ula <= escrita;

        zero <= '1' when escrita = "0000000000000000";

        ligacoes_ula: ULA port map (
            entrada0 => entrada0,
            entrada1 => entrada1,
            sel => sel_operacao,
            saida => escrita,
            carry => carry
        );

        carry_debug <= carry;

end architecture;
