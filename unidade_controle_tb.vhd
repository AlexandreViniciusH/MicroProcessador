-- ARQUITETURA E ORGANIZAÇÃO DE COMPUTADORES | LAB#5          --
-- Professor Juliano Mourão Vieira | UTFPR | 2023.2           -- 
-- Daniel Augusto Pires de Castro | Alexandre Vinicius Hubert --
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
        carry_add : in std_logic;
        carry_sub : in std_logic;

        estado   : out unsigned (1 downto 0);
        data_rom        : out unsigned (15 downto 0);
        sel_reg_lido_1  : out unsigned(2 downto 0);
        sel_reg_lido_2  : out unsigned(2 downto 0);
        sel_reg_escrito : out unsigned(2 downto 0);
        sel_operacao    : out unsigned(1 downto 0);
        im_en           : out std_logic; 
        valor_imm       : out unsigned (7 downto 0)
    );
    end component;

    signal clk, reset, wr_en : std_logic;
    signal estado   : unsigned (1 downto 0);

    signal data_rom        : unsigned (15 downto 0);
    signal sel_reg_lido_1  : unsigned(2 downto 0);
    signal sel_reg_lido_2  : unsigned(2 downto 0);
    signal sel_reg_escrito : unsigned(2 downto 0);
    signal sel_operacao    : unsigned(1 downto 0);
    signal im_en           : std_logic; 
    signal valor_imm       : unsigned (7 downto 0);
    signal carry_add, carry_sub : std_logic;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin
    uut:  unidade_controle port map
    (
        wr_en    => wr_en,
        clk      => clk,
        reset    => reset,
        estado   => estado,
        carry_add =>carry_add,
        carry_sub => carry_sub,
        data_rom  => data_rom,
        sel_reg_lido_1  => sel_reg_lido_1,
        sel_reg_lido_2  => sel_reg_lido_2,
        sel_reg_escrito => sel_reg_escrito,
        sel_operacao    => sel_operacao,
        im_en           => im_en,
        valor_imm       => valor_imm
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
        wait for 100 us;
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
