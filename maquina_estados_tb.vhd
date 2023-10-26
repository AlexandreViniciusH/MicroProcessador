-- ARQUITETURA E ORGANIZAÇÃO DE COMPUTADORES | LAB#5          --
-- Professor Juliano Mourão Vieira | UTFPR | 2023.2           -- 
-- Daniel Augusto Pires de Castro | Alexandre Vinicius Hubert --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina_estados_tb is
end entity;

architecture a_maquina_estados_tb of maquina_estados_tb is
    component maquina_estados
        port
        (
            clk : in std_logic;
            rst : in std_logic;
            wr_en: in std_logic;
            data_out : out std_logic
        );
    end component;

    signal clk, rst, wr_en : std_logic;
    signal data_out : std_logic;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    
begin 
    uut: maquina_estados port map
    (
            clk => clk,
            rst => rst,
            wr_en=> wr_en,
            data_out => data_out
    );

    reset_global : process 
    begin
        rst <= '1';
        wait for period_time*2;
        rst <= '0';
        wait;
    end process reset_global;

    sim_time_proc : process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

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

    process
    begin

        wait for 200 ns;
        -- inverte para mudar o estado de 0 para 1
        wr_en <= '1';
        wait for period_time;

        -- impede de inverter
        wr_en <= '0';
        wait for period_time;

        -- inverte novamente para mudar o estado de 1 para 0
        wr_en <= '1';
        wait for period_time;

        wait;
    end process;
    
end architecture;
