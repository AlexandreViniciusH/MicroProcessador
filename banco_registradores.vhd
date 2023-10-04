library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_registradores is
    port (
        sel_reg_lido_1  : in unsigned(2 downto 0);
        sel_reg_lido_2  : in unsigned(2 downto 0);
        escrita         : in unsigned(15 downto 0);
        sel_reg_escrito : in unsigned(2 downto 0);
        clk             : in std_logic;
        reset           : in std_logic;
        wr_en           : in std_logic;

        reg_lido_1      : out unsigned(15 downto 0);
        reg_lido_2      : out unsigned(15 downto 0)
    );
end entity;

architecture a_banco_registradores of banco_registradores is
    component reg8bits is
        port(
            clk      : in std_logic;
            reset    : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    
    signal lido_zero, 
           lido_x1, 
           lido_x2,
           lido_x3,
           lido_x4,
           lido_x5,
           lido_x6,
           lido_x7: unsigned(15 downto 0);
    signal wr_en_x0,
           wr_en_x1,
           wr_en_x2,
           wr_en_x3,
           wr_en_x4,
           wr_en_x5,
           wr_en_x6,
           wr_en_x7,
           rst :std_logic;

    begin

        wr_en_x0 <= '0'   when sel_reg_escrito = "000" else '0';
        wr_en_x1 <= wr_en when sel_reg_escrito = "001" else '0';
        wr_en_x2 <= wr_en when sel_reg_escrito = "010" else '0';
        wr_en_x3 <= wr_en when sel_reg_escrito = "011" else '0';
        wr_en_x4 <= wr_en when sel_reg_escrito = "100" else '0';
        wr_en_x5 <= wr_en when sel_reg_escrito = "101" else '0';
        wr_en_x6 <= wr_en when sel_reg_escrito = "110" else '0';
        wr_en_x7 <= wr_en when sel_reg_escrito = "111" else '0';

        rst <= '1' when reset = '1' else '0';

        zero: reg8bits port map(
            clk => clk, 
            reset => rst, 
            wr_en => wr_en_x0, 
            data_in => escrita, 
            data_out => lido_zero
        );
        x1: reg8bits port map(
            clk => clk, 
            reset => rst, 
            wr_en => wr_en_x1, 
            data_in => escrita, 
            data_out => lido_x1
        );
        x2: reg8bits port map(
            clk => clk, 
            reset => rst, 
            wr_en => wr_en_x2, 
            data_in => escrita, 
            data_out => lido_x2
        );
        x3: reg8bits port map(
            clk => clk, 
            reset => rst, 
            wr_en => wr_en_x3, 
            data_in => escrita, 
            data_out => lido_x3
        );
        x4: reg8bits port map(
            clk => clk, 
            reset => rst, 
            wr_en => wr_en_x4, 
            data_in => escrita, 
            data_out => lido_x4
        );
        x5: reg8bits port map(
            clk => clk, 
            reset => rst, 
            wr_en => wr_en_x5, 
            data_in => escrita, 
            data_out => lido_x5
        );
        x6: reg8bits port map(
            clk => clk, 
            reset => rst, 
            wr_en => wr_en_x6, 
            data_in => escrita, 
            data_out => lido_x6
        );
        x7: reg8bits port map(
            clk => clk, 
            reset => rst, 
            wr_en => wr_en_x7, 
            data_in => escrita, 
            data_out => lido_x7
        );
        
        reg_lido_1 <= lido_zero when sel_reg_lido_1 ="000" else
                        lido_x1 when sel_reg_lido_1 ="001" else
                        lido_x2 when sel_reg_lido_1 ="010" else
                        lido_x3 when sel_reg_lido_1 ="011" else
                        lido_x4 when sel_reg_lido_1 ="100" else
                        lido_x5 when sel_reg_lido_1 ="101" else
                        lido_x6 when sel_reg_lido_1 ="110" else
                        lido_x7 when sel_reg_lido_1 ="111" else
                        "0000000000000000";

        reg_lido_2 <= lido_zero when sel_reg_lido_2 ="000" else
                        lido_x1 when sel_reg_lido_2 ="001" else
                        lido_x2 when sel_reg_lido_2 ="010" else
                        lido_x3 when sel_reg_lido_2 ="011" else
                        lido_x4 when sel_reg_lido_2 ="100" else
                        lido_x5 when sel_reg_lido_2 ="101" else
                        lido_x6 when sel_reg_lido_2 ="110" else
                        lido_x7 when sel_reg_lido_2 ="111" else
                        "0000000000000000";

end architecture;