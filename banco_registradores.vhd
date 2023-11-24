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
    component registrador8b is
        port(
            clk      : in std_logic;
            reset    : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    
    signal lido_zero, 
           lido_A, 
           lido_X1,
           lido_X2,
           lido_X3,
           lido_X4,
           lido_X5,
           lido_X6: unsigned(15 downto 0);
    signal wr_en_zero,
           wr_en_A,
           wr_en_X1,
           wr_en_X2,
           wr_en_X3,
           wr_en_X4,
           wr_en_X5,
           wr_en_X6,
           rst :std_logic;

    begin

        wr_en_zero <= '0'   when sel_reg_escrito = "000" else '0';
        wr_en_A <= wr_en when sel_reg_escrito = "111" else '0';
        wr_en_X1 <= wr_en when sel_reg_escrito = "001" else '0';
        wr_en_X2 <= wr_en when sel_reg_escrito = "010" else '0';
        wr_en_X3 <= wr_en when sel_reg_escrito = "011" else '0';
        wr_en_X4 <= wr_en when sel_reg_escrito = "100" else '0';
        wr_en_X5 <= wr_en when sel_reg_escrito = "101" else '0';
        wr_en_X6 <= wr_en when sel_reg_escrito = "110" else '0';

        rst <= '1' when reset = '1' else '0';

        zero: registrador8b port map(
            clk => clk, 
            reset => rst, 
            wr_en => wr_en_zero, 
            data_in => escrita, 
            data_out => lido_zero
        );
        A: registrador8b port map(
            clk => clk, 
            reset => rst, 
            wr_en => wr_en_A, 
            data_in => escrita, 
            data_out => lido_A
        );
        X1: registrador8b port map(
            clk => clk, 
            reset => rst, 
            wr_en => wr_en_X1, 
            data_in => escrita, 
            data_out => lido_X1
        );
        X2: registrador8b port map(
            clk => clk, 
            reset => rst, 
            wr_en => wr_en_X2, 
            data_in => escrita, 
            data_out => lido_X2
        );
        X3: registrador8b port map(
            clk => clk, 
            reset => rst, 
            wr_en => wr_en_X3, 
            data_in => escrita, 
            data_out => lido_X3
        );
        X4: registrador8b port map(
            clk => clk, 
            reset => rst, 
            wr_en => wr_en_X4, 
            data_in => escrita, 
            data_out => lido_X4
        );
        X5: registrador8b port map(
            clk => clk, 
            reset => rst, 
            wr_en => wr_en_X5, 
            data_in => escrita, 
            data_out => lido_X5
        );
        X6: registrador8b port map(
            clk => clk, 
            reset => rst, 
            wr_en => wr_en_X6, 
            data_in => escrita, 
            data_out => lido_X6
        );
        
        reg_lido_1 <= lido_zero when sel_reg_lido_1 ="000" else
                        lido_A when sel_reg_lido_1 ="111" else
                        lido_X1 when sel_reg_lido_1 ="001" else
                        lido_X2 when sel_reg_lido_1 ="010" else
                        lido_X3 when sel_reg_lido_1 ="011" else
                        lido_X4 when sel_reg_lido_1 ="100" else
                        lido_X5 when sel_reg_lido_1 ="101" else
                        lido_X6 when sel_reg_lido_1 ="110" else
                        "0000000000000000";

        reg_lido_2 <= lido_zero when sel_reg_lido_2 ="000" else
                        lido_A when sel_reg_lido_2 ="111" else
                        lido_X1 when sel_reg_lido_2 ="001" else
                        lido_X2 when sel_reg_lido_2 ="010" else
                        lido_X3 when sel_reg_lido_2 ="011" else
                        lido_X4 when sel_reg_lido_2 ="100" else
                        lido_X5 when sel_reg_lido_2 ="101" else
                        lido_X6 when sel_reg_lido_2 ="110" else
                        "0000000000000000";

end architecture;
