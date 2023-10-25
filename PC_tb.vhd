library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity PC_tb is
end entity;

architecture a_PC_tb of PC_tb is

    component PC
        port (
            wr_en : in std_logic;
            clk : in std_logic;
            reset : in std_logic;
            jmp : in std_logic;
            data_in : in unsigned (6 downto 0);
            data_out : out unsigned (6 downto 0)
            );
    end component;

    signal wr_en, clk, reset, jmp : std_logic;
    signal data_out, data_in : unsigned (6 downto 0);

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin
    uut: PC port map
    (
        clk => clk,
        wr_en => wr_en,
        reset => reset,
        jmp => jmp,
        data_in => data_in,
        data_out => data_out
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
