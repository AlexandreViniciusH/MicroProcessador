library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port (
        wr_en : in std_logic;
        clk : in std_logic;
        reset : in std_logic;
        jmp : in std_logic;
        data_in : in unsigned (6 downto 0);
        data_out : out unsigned (6 downto 0)
        );
end entity;

architecture a_PC of PC is

    component registrador7b is
        port(
            clk      : in std_logic;
            reset    : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;

    signal data_in_reg, data_out_reg : unsigned (6 downto 0);


    begin

        PCregister : registrador7b port map(
            clk => clk,
            reset => reset,
            wr_en => wr_en,
            data_in => data_in_reg,
            data_out => data_out_reg
        );

        data_out <= data_out_reg;

        data_in_reg <= data_out_reg + "0000001" when jmp = '0' else
                       data_in                  when jmp = '1' else
                       "0000000";

end architecture;
