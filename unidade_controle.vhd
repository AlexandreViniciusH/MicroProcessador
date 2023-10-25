library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle is
    port
    (
        wr_en   : in std_logic;
        clk     : in std_logic;
        reset   : in std_logic;
        data_rom: out unsigned (31 downto 0)
    );
end entity;

architecture a_unidade_controle of unidade_controle is

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

    component maquina_estados is
        port( 
            clk: in std_logic;
            rst: in std_logic;
            estado: out unsigned(1 downto 0)
        );
    end component;

    signal endereco_lido, endereco_jmp : unsigned (6 downto 0);
    signal pc_en, 
           jmp,
           add,
           addi : std_logic;
    signal dado : unsigned (31 downto 0);
    signal opcode : unsigned (5 downto 0);
    signal estado : unsigned(1 downto 0);

    begin

    maquina : maquina_estados port map(
        clk => clk,
        rst => reset,
        estado => estado
    );
    
    -- fetch
    data_rom <= dado when estado = "00";

    -- decode 
    opcode <= dado(31 downto 26) when estado == "01";
    jmp <= '1' when opcode = "000010" else '0';
    add <= '1' when opcode = "000000" else '0';
    addi <= '1' when opcode = "001000" else '0';

    pc_en <= '1' when estado = "01" else '0';
    
    endereco_jmp <= dado(6 downto 0) when jmp = '1' else
                    "0000000";

    progC : PC port map(
        clk => clk,
        reset => reset,
        wr_en => pc_en,
        jmp => jmp,
        data_in => endereco_jmp,
        data_out => endereco_lido
    );

    progRom : rom port map(
        clk => clk,
        endereco => endereco_lido,
        dado => dado
    );

end architecture;