library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port(
            clk : in std_logic;
            endereco : in unsigned (6 downto 0);
            dado : out unsigned (31 downto 0)
        );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned (31 downto 0);
    constant conteudo_rom : mem := (

    0 => "10001010111001101000101011100110",
    1 => "11001011011000111100101101100011",
    2 => "00100000000000000010000000000000",
    3 => "00000001000000010000000100000001",
    4 => "00001000000010000000000000001000",
    5 => "00000000011100000000000001110000",
    6 => "00001111000011110000111100001111",
    32 => "11110000111100001111000011110000",

    others => (others => '0')
    );
begin
    process (clk)
    begin
        if (rising_edge(clk))then
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;

