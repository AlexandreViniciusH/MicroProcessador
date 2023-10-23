library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port(
            clk : in std_logic;
            endereço : in unsigned (7 downto 0);
            dado : out unsigned (15 downto 0)
        );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned ( 15 downto 0);
    constant conteudo_rom : mem := (

    0 => "1000101011100110",
    1 => "1100101101100011",
    2 => "0010000000000000",
    3 => "0000000100000001",
    4 => "0000000000001000",
    5 => "0000000001110000",
    6 => "0000111100001111",

    others =: (others => '0')
    );
begin
    process (clk)
    begin
        if (rising_edge(clk))then
            dado <= conteudo_rom(to_integer(endereço));
        end if;
    end process;
end architecture;

