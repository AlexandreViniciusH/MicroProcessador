library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LAB_4_tb is
end entity;

architecture a_LAB_4_tb of LAB_4_tb is
    component LAB_4
        port (
        wr_en   : in std_logic;
        clk     : in std_logic;
        reset   : in std_logic;
        endereco: out unsigned (6 downto 0);
        dado    : out unsigned (31 downto 0)

        );
    end component;

    signal clk, reset, wr_en : std_logic;
    signal endereco : unsigned (6 downto 0);
    signal dado : unsigned (31 downto 0);

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin
    uut: LAB_4 port map
    (
        wr_en    => wr_en,
        clk      => clk,
        reset    => reset,
        endereco => endereco,
        dado     => dado
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
