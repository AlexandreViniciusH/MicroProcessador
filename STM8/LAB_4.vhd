library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LAB_4 is
    port (
        wr_en   : in std_logic;
        clk     : in std_logic;
        reset   : in std_logic;
        endereco: out unsigned (6 downto 0);
        dado    : out unsigned (31 downto 0)

        );
end entity;

architecture a_LAB_4 of LAB_4 is
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

    signal endereco_lido, data_in : unsigned (6 downto 0);
    signal jmp : std_logic;

    begin

    progC : PC port map(
        clk => clk,
        reset => reset,
        wr_en => wr_en,
        jmp => jmp,
        data_in => data_in,
        data_out => endereco_lido
    );

    progRom : rom port map(
        clk => clk,
        endereco => endereco_lido,
        dado => dado
    );

    endereco <= endereco_lido;

end architecture;
