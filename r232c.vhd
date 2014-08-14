library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity r232c is
  generic (wtime: std_logic_vector(15 downto 0) := x"1C08");
  Port ( clk  : in  STD_LOGIC;
         data : out  STD_LOGIC_VECTOR (7 downto 0);
         comp : out  STD_LOGIC;
         rx   : in STD_LOGIC);
end r232c;

architecture whitebox of r232c is
  signal countdown: std_logic_vector(15 downto 0) := (others=>'0');
  signal state: std_logic_vector(3 downto 0) := "0000";
  signal buf : std_logic_vector(7 downto 0) := "11111111";
  signal comp_sig: std_logic := '0';
begin
  statemachine: process(clk)
  begin
    if rising_edge(clk) then
      case state is
        when "0000"=>
          comp_sig<='0';
          if rx = '0' then
           countdown<=wtime;
           buf<="11111111";
           state<=state+1;
          end if;
        when "1001"=>
         if countdown = 0 then
          state<="0000";
          data<=buf;
          comp_sig<='1';
         else
          countdown<=countdown-1;
         end if;
        when others=>
         if countdown = 0 then
          buf<=rx&buf(7 downto 1);
          state<=state+1;
          countdown<=wtime;
         else
          countdown<=countdown-1;
         end if;
      end case;
    end if;
  end process;
comp<=comp_sig;
end whitebox;
