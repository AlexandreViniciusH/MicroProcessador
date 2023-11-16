library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flip_flop_D is
    port
    (
        clk             : in std_logic;
        reset           : in std_logic;
        D               : in std_logic;
        Q               : out std_logic;
        Q_barra         : out std_logic
    );
end entity;

architecture a_flip_flop_D of flip_flop_D is
 begin
    process(clk,reset)  -- acionado se houver mudança em clk, reset ou wr_en
    begin
        if reset='1' then
            Q <= '1';
            Q_barra <= '0';
        elsif rising_edge(clk) then
            Q <= D;
            Q_barra <= not D;
        end if;
    end process;
end architecture;
