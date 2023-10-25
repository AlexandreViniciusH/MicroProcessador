library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end;

architecture a_processador_tb of processador_tb is
    component processador is
        port(
            sel_cte_ext : in std_logic;
    
            sel_reg_lido_1 :  in unsigned(2 downto 0);
            sel_reg_lido_2 :  in unsigned(2 downto 0);
            sel_reg_escrito : in unsigned(2 downto 0);
    
            sel_operacao : in unsigned(1 downto 0);
            clk             : in std_logic;
            reset           : in std_logic;
            wr_en           : in std_logic;
    
            constante_ext : in unsigned(15 downto 0);
    
            saida_ula : out unsigned(15 downto 0)
        );
    end component;

    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';

    signal sel_cte_ext :std_logic;
    
    signal sel_reg_lido_1 : unsigned(2 downto 0);
    signal sel_reg_lido_2 : unsigned(2 downto 0);
    signal sel_reg_escrito :unsigned(2 downto 0);

    signal sel_operacao :unsigned(1 downto 0);
    signal clk             :std_logic;
    signal reset           :std_logic;
    signal wr_en           :std_logic;

    signal constante_ext :unsigned(15 downto 0);

    signal saida_ula : unsigned(15 downto 0);

    begin
        uut: processador port map (
            sel_cte_ext => sel_cte_ext,
            sel_reg_lido_1 => sel_reg_lido_1,
            sel_reg_lido_2 => sel_reg_lido_2,
            sel_reg_escrito => sel_reg_escrito,
            sel_operacao => sel_operacao,
            clk => clk,
            reset => reset,
            wr_en => wr_en,
            constante_ext => constante_ext,
            saida_ula => saida_ula
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

      -- Armazenando a constante 1 no Registrador x1 (como se fizesse um addi x1, zero, 1)
      sel_cte_ext <= '1';
      constante_ext <= "0000000000000001";
      sel_reg_lido_1 <= "000";
      sel_reg_escrito <= "001";
      wr_en <= '1';
      sel_operacao <= "00";
      wait for 100 ns;

      -- Atribuindo a soma do Registrador x1 consigo mesmo ao registrador x2
      sel_cte_ext <= '0';
      sel_reg_lido_1 <= "001";
      sel_reg_lido_2 <= "001";
      sel_reg_escrito <= "010";
      wr_en <= '1';
      sel_operacao <= "00";
      wait for 100 ns;

      -- Armazenando a constante 3 no Registrador x3 (como se fizesse um addi x3, zero, 3)
      sel_cte_ext <= '1';
      constante_ext <= "0000000000000011";
      sel_reg_lido_1 <= "000";
      sel_reg_escrito <= "011";
      wr_en <= '1';
      sel_operacao <= "00";
      wait for 100 ns;

      -- Atribuindo a multiplicação do Registrador x2 com o Registrador x3 ao registrador x4
      sel_cte_ext <= '0';
      sel_reg_lido_1 <= "010";
      sel_reg_lido_2 <= "011";
      sel_reg_escrito <= "100";
      wr_en <= '1';
      sel_operacao <= "10";
      wait for 100 ns;

      wait;                     -- <== OBRIGATÓRIO TERMINAR COM WAIT; !!!
      end process;

      -- Conferindo


end architecture;
