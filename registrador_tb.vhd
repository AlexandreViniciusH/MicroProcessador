library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_tb is
end entity;

architecture a_registrador_tb of registrador_tb is
    component registrador
        port
        (
            clk : in std_logic;
            reset : in std_logic;
            wr_en: in std_logic;
            data_in : in unsigned (15 downto 0);
            data_out : out unsigned (15 downto 0)
        );
    end component;

    signal clk, reset, wr_en : std_logic;
    signal data_in,data_out : unsigned (15 downto 0);

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal resetar : std_logic;
    
begin 
    uut: registrador port map
    (
            clk => clk,
            reset => reset,
            wr_en=> wr_en,
            data_in => data_in,
            data_out => data_out
    );

    reset_global : process 
    begin
        resetar <= '1';
        wait for period_time*2;
        resetar <= '0';
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

        wr_en <= '1';
        data_in <= "1111000010101001";
        wait for period_time;

        wr_en <= '0';
        data_in <= "0000001101010010";
        wait for period_time;

        reset <= '1';
        wait for period_time;

        reset <= '0';
        wr_en <= '1';
        data_in <= "0000001101010010";
        wait for period_time;

        wait;
    end process;
    
end architecture;


