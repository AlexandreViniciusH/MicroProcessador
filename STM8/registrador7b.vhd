library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador7b is
   port( clk      : in std_logic;
         reset    : in std_logic;
         wr_en    : in std_logic;
         data_in  : in unsigned(6 downto 0);
         data_out : out unsigned(6 downto 0)
   );

end entity;

architecture a_registrador7b of registrador7b is
    signal registro: unsigned(6 downto 0);
 begin
    process(clk,reset,wr_en)  -- acionado se houver mudança em clk, reset ou wr_en
    begin                
       if reset='1' then
          registro <= "0000000";
       elsif wr_en='1' then
          if rising_edge(clk) then
             registro <= data_in;
          end if;
       end if;
    end process;
    
    data_out <= registro;  -- conexao direta, fora do processo
 end architecture;
