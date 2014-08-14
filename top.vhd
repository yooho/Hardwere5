library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity top is
  Port ( MCLK1 : in  STD_LOGIC;
         RS_RX : in  STD_LOGIC;
         RS_TX : out  STD_LOGIC);
end top;

architecture example of top is
  signal clk,iclk: std_logic;

  component r232c
    generic (wtime: std_logic_vector(15 downto 0) := x"1C08");
    Port ( clk  : in  STD_LOGIC;
           data : out  STD_LOGIC_VECTOR (7 downto 0);
           comp : out STD_LOGIC;
           rx   : in STD_LOGIC);
  end component;
  component u232c
    generic (wtime: std_logic_vector(15 downto 0) := x"1C06");
    Port ( clk  : in  STD_LOGIC;
           data : in  STD_LOGIC_VECTOR (7 downto 0);
           go   : in  STD_LOGIC;
           busy : out std_logic;
           tx   : out STD_LOGIC);
  end component;
  signal uart_comp : std_logic := '0';
  signal recvdata : std_logic_vector(7 downto 0) := (others=>'0');
  signal senddata : std_logic_vector(7 downto 0) := (others=>'0');
  signal uart_go: std_logic := '0';
  signal uart_busy: std_logic := '0';

begin
  ib: IBUFG port map (
    i=>MCLK1,
    o=>iclk);
  bg: BUFG port map (
    i=>iclk,
    o=>clk);
  rs232c: r232c generic map (wtime=>x"1C08")
  port map (
    clk=>clk,
    data=>recvdata,
    comp=>uart_comp,
    rx=>rs_rx);
  us232c: u232c generic map (wtime=>x"1C06")
  port map (
    clk=>clk,
    data=>senddata,
    go=>uart_go,
    busy=>uart_busy,
    tx=>rs_tx);
--program
  rom_inf: process(clk)
  begin
    if rising_edge(clk) then
     if uart_comp = '1' then
      senddata<=recvdata;
      uart_go<='1';
     end if;
     if uart_busy ='1' and uart_go ='1' then
      uart_go<='0';
     end if;
    end if;
  end process;
end example;
