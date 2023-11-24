-- ARQUITETURA E ORGANIZAÇÃO DE COMPUTADORES | LAB#5          --
-- Professor Juliano Mourão Vieira | UTFPR | 2023.2           -- 
-- Daniel Augusto Pires de Castro | Alexandre Vinicius Hubert --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end;

architecture a_processador_tb of processador_tb is
    component processador is
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
            carry_debug      : out std_logic
        );
    end component;

    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';

    signal clk             :std_logic;
    signal reset           :std_logic;
    signal wr_en           :std_logic;

    -- signal constante_ext :unsigned(15 downto 0);

    signal data_rom: unsigned(15 downto 0);
    signal estado : unsigned(1 downto 0);
    signal reg_lido_1 : unsigned(15 downto 0);
    signal reg_lido_2 : unsigned(15 downto 0);
    signal saida_ula : unsigned(15 downto 0);

    signal carry_debug : std_logic;

    begin
        uut: processador port map (
            wr_en    => wr_en,
            clk       => clk,
            reset     => reset,
            data_rom  => data_rom,
            saida_ula  => saida_ula,
            estado     => estado,
            reg_lido_1 => reg_lido_1,
            reg_lido_2 => reg_lido_2,
            carry_debug => carry_debug
        );

    reset_global: process
    begin
        reset <= '1';
        wait for period_time*2; -- espera 2 clocks, pra garantir
        reset <= '0';
        wait;
    end process reset_global;
    
    sim_time_proc: process
    begin
        wait for 500 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin                       -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process
    begin

        wait for 200 ns;

        wr_en <= '1';
        wait for 1 us;

        wait;

    end process;

      -- Conferindo


end architecture;
