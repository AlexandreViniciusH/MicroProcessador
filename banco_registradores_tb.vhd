library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_registradores_tb is
end;

architecture a_banco_registradores_tb of banco_registradores_tb is
    component banco_registradores is          -- aqui vai seu componente a testar
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
    end component;
                                -- 100 ns é o período que escolhi para o clock
    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk : std_logic;
    signal   reset  : std_logic;
    signal   wr_en : std_logic;
    signal   sel_reg_lido_1,
             sel_reg_lido_2,
             sel_reg_escrito : unsigned(2 downto 0);
    signal   escrita,
             reg_lido_1,
             reg_lido_2 : unsigned(15 downto 0);

begin
    uut: banco_registradores port map (
        sel_reg_lido_1 => sel_reg_lido_1,
        sel_reg_lido_2 => sel_reg_lido_2,
        escrita => escrita,
        sel_reg_escrito => sel_reg_escrito,
        clk => clk,
        reset => reset,
        wr_en => wr_en,
        reg_lido_1 => reg_lido_1,
        reg_lido_2 => reg_lido_2
    );

    reset_global: process
    begin
        reset <= '1';
        wait for period_time*2; -- espera 2 clocks, pra garantir
        reset <= '0';
        wait;
    end process reset_global;
    
    sim_time_proc: process
    begin
        wait for 10 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin                       -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process                      -- sinais dos casos de teste (p.ex.)
    begin
      wait for 200 ns;

      -- Conferindo

      sel_reg_lido_1 <= "000";
      sel_reg_lido_2 <= "001";
      wait for 100 ns;

      sel_reg_lido_1 <= "010";
      sel_reg_lido_2 <= "011";
      wait for 100 ns;

      sel_reg_lido_1 <= "100";
      sel_reg_lido_2 <= "101";
      wait for 100 ns;

      sel_reg_lido_1 <= "110";
      sel_reg_lido_2 <= "111";
      wait for 100 ns;

      wr_en <= '1';
      sel_reg_escrito <= "001";
      escrita <= "1010010111000000";
      sel_reg_lido_1 <= "001";
      sel_reg_lido_2 <= "000";
      wait for 100 ns;

      wr_en <= '1';
      sel_reg_escrito <= "010";
      escrita <= "1011000011011110";
      sel_reg_lido_1 <= "010";
      sel_reg_lido_2 <= "001";
      wait for 100 ns;

      wr_en <= '1';
      sel_reg_escrito <= "011";
      escrita <= "1101000011001110";
      sel_reg_lido_1 <= "011";
      sel_reg_lido_2 <= "010";
      wait for 100 ns;

      wr_en <= '1';
      sel_reg_escrito <= "100";
      escrita <= "1111111111111111";
      sel_reg_lido_1 <= "100";
      sel_reg_lido_2 <= "011";
      wait for 100 ns;

      wr_en <= '1';
      sel_reg_escrito <= "101";
      escrita <= "1101000011001110";
      sel_reg_lido_1 <= "101";
      sel_reg_lido_2 <= "100";
      wait for 100 ns;

      wr_en <= '1';
      sel_reg_escrito <= "110";
      escrita <= "1100111011101111";
      sel_reg_lido_1 <= "110";
      sel_reg_lido_2 <= "101";
      wait for 100 ns;

      wr_en <= '1';
      sel_reg_escrito <= "111";
      escrita <= "1100111011101111";
      sel_reg_lido_1 <= "111";
      sel_reg_lido_2 <= "110";
      wait for 100 ns;

      sel_reg_lido_1 <= "000";
      sel_reg_lido_2 <= "001";
      wait for 100 ns;

      sel_reg_lido_1 <= "010";
      sel_reg_lido_2 <= "011";
      wait for 100 ns;

      sel_reg_lido_1 <= "100";
      sel_reg_lido_2 <= "101";
      wait for 100 ns;

      sel_reg_lido_1 <= "110";
      sel_reg_lido_2 <= "111";
      wait for 100 ns;

      wait;                     -- <== OBRIGATÓRIO TERMINAR COM WAIT; !!!
    end process;

end architecture a_banco_registradores_tb;
