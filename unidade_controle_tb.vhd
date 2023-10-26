library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle_tb is
end entity;

architecture a_unidade_controle_tb of unidade_controle_tb is

    component unidade_controle
    port
    (
        wr_en    : in std_logic;
        clk      : in std_logic;
        reset    : in std_logic;
        data_rom : out unsigned (31 downto 0);
        saida_ula: out unsigned (15 downto 0);
        estado   : out unsigned (1 downto 0);
        reg_lido_1      : out unsigned(15 downto 0);
        reg_lido_2      : out unsigned(15 downto 0)
    );
    end component;

    signal clk, reset, wr_en : std_logic;
    signal upcode : unsigned (5 downto 0);
    signal data_rom : unsigned (31 downto 0);
    signal saida_ula: unsigned (15 downto 0);
    signal estado   : unsigned (1 downto 0);
    signal reg_lido_1      : unsigned(15 downto 0);
    signal  reg_lido_2      : unsigned(15 downto 0);

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin
    uut:  unidade_controle port map
    (
        wr_en    => wr_en,
        clk      => clk,
        reset    => reset,
        data_rom => data_rom,
        saida_ula => saida_ula,
        estado => estado,
        reg_lido_1 => reg_lido_1,
        reg_lido_2 => reg_lido_2
    );

    reset_global : process
    begin
        reset <= '1';
        wait for period_time*2;
        reset <= '0';
        wait;
    end process reset_global;

    clk_process : process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait ;
    end process clk_process;

    sim_time_proc : process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    process
    begin

        wait for 200 ns;

        wr_en <= '1';
        wait for 1 us;

        wait;

    end process;
end architecture;
