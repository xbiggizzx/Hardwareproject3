---------------------------------------------------------------------------------
-- filename: mips_tb.vhd
-- author  : Wolfgang Brandt
-- company : TUHH, Institute of embedded systems
-- revision: 0.1
-- date    : 26/11/15   
---------------------------------------------------------------------------------

library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;
use work.all;

entity mips_top_testbench is
end;

architecture test of mips_top_testbench is
  

  signal clk, reset, sda, scl : STD_LOGIC := '0';
begin
    
    SDA <= 'H'; 
    SCL <= 'H';

  -- instantiate device to be tested
  dut: entity work.HWP3 port map(clk, reset, scl, sda);
  --ADS Simulator
  ADS: entity work.ADS7830 port map(sda, scl);
  -- Generate clock with 10 ns period
  process begin
    clk <= '1';
    wait for 5 ns; 
    clk <= '0';
    wait for 5 ns;
  end process;

  -- Generate reset for first two clock cycles
  process begin
    reset <= '0';
    wait for 2 ns;
    reset <= '1';
    wait for 20 ms;
    reset <= '0';
    
    wait for 2000 ns;
    reset <= '1';
    wait for 20 ns;
    reset <= '0';
    wait;
  end process;



  -- check that 7 gets written to address 84 at end of program
--  process (clk) begin
--    if (clk'event and clk = '0' and memwrite = '1') then
--      if (to_integer(dataadr) = 84 and to_integer(writedata) = 7) then 
--        report "NO ERRORS: Simulation succeeded" severity failure;
--      --elsif (dataadr = x"50") then 
--      --  report "Simulation failed" severity failure;
--      end if;
--    end if;
--  end process;
end;
