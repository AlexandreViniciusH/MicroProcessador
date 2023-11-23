library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_tb is
end entity;

architecture a_ram_tb of ram_tb is
    component ram
        port(
            clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            wr_en    : in std_logic;
            dado_in  : in unsigned(15 downto 0);
            dado_out : out unsigned(15 downto 0) 
        );
    end component;

    signal clk : std_logic;
    signal endereco : unsigned (6 downto 0);
    signal wr_en : std_logic;
    signal dado_in : unsigned (15 downto 0);
    signal dado_out : unsigned (15 downto 0);

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

begin
    uut: ram port map
    (
        clk => clk,
        endereco => endereco,
        wr_en => wr_en,
        dado_in => dado_in,
        dado_out => dado_out
    );

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

        endereco <= "0000001";
        wr_en <= '1';
        dado_in <= "1101000011001110";
        wait for period_time;

        endereco <= "1001001";
        wr_en <= '0';
        dado_in <= "1111000011110000";
        wait for period_time;

        endereco <= "1111111";
        wr_en <= '1';
        dado_in <= "1011000010110000";
        wait for period_time;

        wait;

    end process;

end architecture;

-- CAFE DOCE = 11001010111111101101000011001110
-- FEIO FOFO = 11111110000100001111000011110000
-- ODIO FODA = 00001101000100001111000011011010
-- DECE 5CAO = 11011110110011100111110010100000
-- CABE CAOO = 11001010101111101100101000000000
-- BODE OCOO = 10110000110111100000110000000000
-- COCO BOBO = 11000000110000001011000010110000
-- BIBA BOBA = 10110001101110101011000010111010
-- EDFI 5ICA = 11101101111100010101000111001010
-- DEDO FEIO = 11011110110100001111111000010000
