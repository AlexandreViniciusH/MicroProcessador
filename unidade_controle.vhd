-- ARQUITETURA E ORGANIZAÇÃO DE COMPUTADORES | LAB#5          --
-- Professor Juliano Mourão Vieira | UTFPR | 2023.2           -- 
-- Daniel Augusto Pires de Castro | Alexandre Vinicius Hubert --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle is
    port
    (
        wr_en    : in std_logic;
        clk      : in std_logic;
        reset    : in std_logic;
        carry_add : in std_logic;
        carry_sub : in std_logic;

        estado   : out unsigned (1 downto 0);
        data_rom : out unsigned (15 downto 0);
        sel_reg_lido_1  : out unsigned(2 downto 0);
        sel_reg_lido_2  : out unsigned(2 downto 0);
        sel_reg_escrito : out unsigned(2 downto 0);
        sel_operacao :    out unsigned(1 downto 0);
        im_en : out std_logic; 
        valor_imm : out unsigned (7 downto 0)
    );
end entity;


architecture a_unidade_controle of unidade_controle is
    component maquina_estados is
        port( 
            clk: in std_logic;
            rst: in std_logic;
            estado: out unsigned(1 downto 0)
        );
    end component;

    component PC is
        port (
            wr_en : in std_logic;
            clk : in std_logic;
            reset : in std_logic;
            jmp : in std_logic;
            data_in : in unsigned (6 downto 0);
            data_out : out unsigned (6 downto 0)
        );
    end component;

    component rom is
        port(
            clk : in std_logic;
            endereco : in unsigned (6 downto 0);
            dado : out unsigned (15 downto 0)
        );
    end component;

    signal endereco_lido, endereco_jmp : unsigned (6 downto 0);
    signal w_e,
           pc_en, 
           jmp,
           jpf,
           jra,
           jrpl,
           add,
           addi,
           ld,
           clr,
           sub,
           subi : std_logic;
    signal escrita : unsigned(15 downto 0);
    signal dado : unsigned (15 downto 0);
    signal opcode : unsigned (7 downto 0);
    signal prefix : unsigned (7 downto 0);
    signal state : unsigned (1 downto 0);

    begin
    
    maquina : maquina_estados port map(
        clk => clk,
        rst => reset,
        estado => state
    );

    estado <= state;

    ---------------------- FETCH -----------------------------
    progRom : rom port map(
        clk => clk,
        endereco => endereco_lido,
        dado => dado
    );

    data_rom <= dado when state = "00";

    ---------------------- DECODE ----------------------------
    --prefix <= dado(31 downto 24) when state = "01"; -- na documentação é um hexadecimal de 2 digitos, nas instruções abaixo equivale a 00(16)
    opcode <= dado(15 downto 8) when state = "01";

    add <= '1' when opcode = "11111011" else '0';   -- ADD(acumulador, src)
    addi <= '1' when opcode = "10101011" else '0';  -- ADD(acumulador, imm)
    sub <= '1' when opcode = "11110000" else '0';   -- SUB(acumulador, src)
    subi <= '1' when opcode = "10100000" else '0';  -- SUB(acumulador, imm)
    ld <= '1' when opcode = "11110110" else '0';    -- LD(dst, src)
    clr <= '1' when opcode = "01111111" else '0';   -- CLR(dst)
    jpf <= '1' when opcode = "10101100" else '0';   -- JMP(endereco_jmp)
    jra <= '1' when opcode = "00100000" else '0';   -- JRA (dst)
    jrpl <= '1' when opcode = "00101010" else '0';  -- JRPL (dst)

    endereco_jmp <= dado(6 downto 0) when jpf = '1' else
                    endereco_lido + dado(6 downto 0) when jra = '1' else
                    endereco_lido + dado(6 downto 0) when jrpl = '1' and carry_sub = '0' else
                    endereco_lido + 1 when jrpl = '1' and carry_sub = '1' else
                    "0000000";

    jmp <=  '1' when jpf = '1' or jra = '1' or jrpl = '1' else
            '0';

    -- registrador acumulador eu defini sendo o 001
    sel_reg_lido_1 <= "001" when add = '1' or addi = '1' or sub = '1' or subi = '1' or jrpl = '1'  else
                      dado(2 downto 0) when ld = '1' else -- src do ld
                      "000" when clr = '1' else -- no fim o clear é dst <= 0 + 0
                      "000";
    sel_reg_lido_2 <= dado(2 downto 0) when add = '1' or sub = '1' else -- src do sub
                      "000";

    sel_reg_escrito <= "001" when add = '1' or addi = '1' or sub = '1' or subi = '1' else  -- todos os dst são o acumulador
                       dado(5 downto 3) when ld = '1' else -- dst do ld
                       dado(2 downto 0) when clr = '1' else -- dst do clear
                       "000";
    
    valor_imm <= dado(7 downto 0) when addi = '1' or subi = '1' else
               "00000000";

    -- habilita ou não o uso de valor imediato
    im_en <= '0' when add = '1' or sub = '1' else
             '1' when addi = '1' or subi = '1' or ld = '1' or clr = '1' else
             '0';

    -- seleciona se a operação é adição ou subtração para a ula realizar
    sel_operacao <= "00" when add = '1' or addi = '1' or ld = '1' or clr = '1' else
                    "01" when sub = '1' or subi = '1' else
                    "00";

    ---------------------- EXECUTE ----------------------------

    pc_en <= '1' when state = "10" else '0';
    
    progC : PC port map(
        clk => clk,
        reset => reset,
        wr_en => pc_en,
        jmp => jmp,
        data_in => endereco_jmp,
        data_out => endereco_lido
    );

end architecture;
