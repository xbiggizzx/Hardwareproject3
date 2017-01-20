----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.12.2016 16:01:41
-- Design Name: 
-- Module Name: Task3TriState - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Task3TriState is
    Port ( 
            scl   : inout std_logic;  -- i2c clock line input
            sda   : inout std_logic;  -- i2c clock line input
            scl_o   : in std_logic;  -- i2c clock line input
    		scl_i   : out std_logic; -- i2c clock line output
    		scl_in_en : in std_logic; -- i2c clock line output enable, active low  		
    		sda_o   : in std_logic;  -- i2c data line input		
    		sda_i   : out std_logic; -- i2c data line output
    		sda_in_en : in std_logic  -- i2c data line output enable, active low
          );
          
end Task3TriState;

architecture Behavioral of Task3TriState is

begin

sda_i <= sda;
sda   <= sda_o when sda_in_en = '0' else  
         'Z';
       
scl_i <= scl;
scl   <= scl_o when scl_in_en = '0' else
         'Z';

end Behavioral;
