library ieee;
use ieee.std_logic_1164.all
use ieee.numeric_std.all

entity ULA_tb is
end entity

architecture a_ULA_tb of ULA_tb is 

    component ULA 
        port(
            entrada0 : in unsigned (15 downto 0);
            entrada1 : in unsigned (15 downto 0);
            sel0 : in std_logic;
            sel1 : in std_logic;
            saida : out unsigned (15 downto 0)
        );
    end component;

    signal entrada0, entrada1, saida : unsigned (15 downto 0);
    signal sel0,sel1 : std_logic;

    begin
        uut : ULA port map(
            entrada0 => entrada0,
            entrada1 => entrada1,
            sel0 => sel0,
            sel1 => sel1,
            saida => saida
        );
    
    process
        begin 
            sel0 = '0';
            sel1 = '0';
            entrada0 <= "0000000000001101";
            entrada1 <= "0000000000010010";
            wait for 50 ns;
            entrada0 <= "0000000000101101";
            entrada1 <= "0000000000010010";
            wait for 50 ns;
            entrada0 <= "0000000000010110";
            entrada1 <= "1111111111111101";
            wait for 50 ns;

            sel0 = '1';
            sel1 = '0';
            entrada0 <= "0000000000001101";
            entrada1 <= "0000000000010010";
            wait for 50 ns;
            entrada0 <= "0000000000101101";
            entrada1 <= "0000000000010010";
            wait for 50 ns;
            entrada0 <= "0000000000010110";
            entrada1 <= "1111111111111101";
            wait for 50 ns;
           

            sel0 = '0';
            sel1 = '1';
            entrada0 <= "0000000000000011";
            entrada1 <= "0000000000000101";
            wait for 50 ns;
            entrada0 <= "0000000000000011";
            entrada1 <= "1111111111111011";
            wait for 50 ns;
            entrada0 <= "1111111111111101";
            entrada1 <= "1111111111111011";
            wait for 50 ns;

            sel0 = '1';
            sel1 = '1';
            entrada0 <= "1110111100001110";
            entrada1 <= "0011001110011110";
            wait for 50 ns;


            wait;
        end process; 

end architecture;