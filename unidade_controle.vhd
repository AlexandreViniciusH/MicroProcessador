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

        estado   : out unsigned (1 downto 0);
        data_rom : out unsigned (31 downto 0);
        sel_reg_lido_1  : out unsigned(2 downto 0);
        sel_reg_lido_2  : out unsigned(2 downto 0);
        sel_reg_escrito : out unsigned(2 downto 0);
        sel_operacao :    out unsigned(1 downto 0);
        im_en : out std_logic; 
        valor_imm : out unsigned (15 downto 0)
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
            dado : out unsigned (31 downto 0)
        );
    end component;

    signal endereco_lido, endereco_jmp : unsigned (6 downto 0);
    signal w_e,
           pc_en, 
           jmp,
           add,
           addi,
           ld,
           clr,
           sub,
           subi : std_logic;

    signal escrita : unsigned(15 downto 0);
    signal dado : unsigned (31 downto 0);
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
    prefix <= dado(31 downto 24) when state = "01"; -- na documentação é um hexadecimal de 2 digitos, nas instruções abaixo equivale a 00(16)
    opcode <= dado(23 downto 16) when state = "01";

    add <= '1' when opcode = "11111011" else '0';   -- ADD(acumulador, src)
    addi <= '1' when opcode = "10101011" else '0';  -- ADD(acumulador, imm)
    sub <= '1' when opcode = "11110000" else '0';   -- SUB(acumulador, src)
    subi <= '1' when opcode = "10100000" else '0';  -- SUB(acumulador, imm)
    ld <= '1' when opcode = "11110110" else '0';    -- LD(dst, src)
    clr <= '1' when opcode = "01111111" else '0';   -- CLR(dst)
    jmp <= '1' when opcode = "10101100" else '0';   -- JMP(endereco_jmp)

    endereco_jmp <= dado(6 downto 0) when jmp = '1' else
                    "0000000";

    -- registrador acumulador eu defini sendo o 001
    sel_reg_lido_1 <= "001" when add = '1' or addi = '1' or sub = '1' or subi = '1' else 
                      dado(2 downto 0) when ld = '1' else 
                      "000" when clr = '1' else
                      "000";
    sel_reg_lido_2 <= dado(2 downto 0) when add = '1' or sub = '1' else
                      "000";

    sel_reg_escrito <= "001" when add = '1' or addi = '1' or sub = '1' or subi = '1' else  
                       dado(5 downto 3) when ld = '1' else
                       dado(2 downto 0) when clr = '1' else
                       "000";
    
    valor_imm <= dado(15 downto 0) when addi = '1' or subi = '1' else
               "0000000000000000";

    im_en <= '0' when add = '1' or sub = '1' else
             '1' when addi = '1' or subi = '1' or ld = '1' or clr = '1' else
             '0';

    sel_operacao <= "00" when add = '1' or addi = '1' or ld = '1' or clr = '1' else
                    "01" when sub = '1' or subi = '1' else
                    "00";

    ---------------------- EXECUTE ----------------------------
    w_e <= wr_en when state = "10" else '0';

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
