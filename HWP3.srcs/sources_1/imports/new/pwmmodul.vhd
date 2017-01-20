----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.11.2016 11:56:56
-- Design Name: 
-- Module Name: pwmmodul - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwmmodul is
    Port ( 
           Swert : in STD_LOGIC_VECTOR(7 downto 0);
           clk, load : in STD_LOGIC;
           reset : in STD_LOGIC;
           pwm_out : out STD_LOGIC
           );
           
end pwmmodul;

--architecture Behavioral of pwmmodul is

--signal switch : STD_LOGIC := '1';
--signal counter : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
--signal SwertReg : STD_LOGIC_VECTOR(7 downto 0):= "00000000";
--constant SwertMax : STD_LOGIC_VECTOR(7 downto 0):= "11111111";
--begin

--process(clk, load) begin
--if load = '1' then
--SwertReg <= Swert;

--elsif rising_edge(clk) then
--    if SwertReg = "00000000" then switch <= '0';
--    elsif SwertReg = SwertMax then switch <= '1';
--    elsif counter < SwertReg then counter <= counter +1; switch <= '1';
--    elsif counter = SwertMax then counter <= (others => '0');
--                                  switch <= '1';
--    else switch <= '0'; counter <= counter +1;    
--    end if;
--end if;

--end process;

--pwm_out <= switch;


--end Behavioral;
architecture Behavioral of pwmmodul is

signal counter  : UNSIGNED(7 downto 0) := (others => '0');
signal duty_reg : UNSIGNED(7 downto 0) := "00000000";
begin
    counter <= (others => '0') when reset = '1' else
               counter + 1 when rising_edge(clk);
    duty_reg <= (others => '0') when reset = '1' else
                unsigned(swert) when rising_edge(clk) and load = '1';
    pwm_out <= '1' when counter < duty_reg else
               '0';
end Behavioral;
