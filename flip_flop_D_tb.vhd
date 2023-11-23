library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flip_flop_D_tb is
end entity;

architecture a_flip_flop_D_tb of flip_flop_D_tb is
    component flip_flop_D is
        port
            (
                clk             : in std_logic;
                reset           : in std_logic;
                we              : in std_logic;
                D               : in std_logic;
                Q               : out std_logic
            );
    end component;

    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk : std_logic;
    signal   reset, we : std_logic;
    signal   D, Q : std_logic;

    begin

    uut: flip_flop_D port map
    (
        clk => clk,
        reset => reset,
        we => we,
        D => D,
        Q => Q
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
        wait for 10 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
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

    process                      -- sinais dos casos de teste (p.ex.)
    begin


    wait for 200 ns;

    we <= '1';
    D <= '1';
    wait for period_time;

    D <= '1';
    wait for period_time;

    D <= '0';
    wait for period_time;

    D <= '0';
    wait for period_time;

    D <= '1';
    wait for period_time;

    wait;
    end process;

end architecture;
