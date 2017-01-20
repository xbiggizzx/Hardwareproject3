----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2017 19:02:38
-- Design Name: 
-- Module Name: FSMachine - Behavioral
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

entity FSMachine is
    Port ( clk, 
           cmd_ack,
           reset : in STD_LOGIC; 
            
           start,
	       stop,
		   read,
		   write,
		   ack_in : out STD_LOGIC;
		   din    : out STD_LOGIC_VECTOR(7 downto 0)
    );
end FSMachine;

architecture Behavioral of FSMachine is

-- -- -- -- -- -- -- STATE MACHINE SIGNALS -- -- -- -- -- -- -- -- -- -- -- -- 
type statetype is (WRITE_ADDRESS, COMMAND_BYTE, READ_ADDRESS, GET_DATA);
signal CURRENTSTATE, NEXTSTATE : statetype;

signal FSControlSignals : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');  -- (  START 4 / STOP 3 / READ 2 / WRITE 1 / ACK_IN 0 )
signal dinREG           : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

begin
NEXT_STATE: process(clk, reset, cmd_ack) begin
if rising_edge(clk) then
    if reset = '1' then
        CURRENTSTATE <= WRITE_ADDRESS;
    elsif cmd_ack = '1' then 
        CURRENTSTATE <= NEXTSTATE;
    end if;
end if;

end process;

CURRENT_STATE_ACTION: process(CURRENTSTATE) begin
case CURRENTSTATE is

    when WRITE_ADDRESS =>  FSControlSignals <= "10010";
                           dinREG <= "10010000"; 
                           NEXTSTATE <= COMMAND_BYTE;
    
    when COMMAND_BYTE  =>  FSControlSignals <= "00010";
                           dinREG <= "10001100"; 
                           NEXTSTATE <= READ_ADDRESS;
    
    when READ_ADDRESS  =>  FSControlSignals <= "10010";
                           dinREG <= "10010001";
                           NEXTSTATE <= GET_DATA;
    
    when GET_DATA      =>  FSControlSignals <= "01101";
                           dinREG <= "00000000";
                           NEXTSTATE <= WRITE_ADDRESS;
                           
    when others        =>  NEXTSTATE <= WRITE_ADDRESS;
    
end case;
end process;

start       <= FSControlSignals(4);
stop        <= FSControlSignals(3);
read        <= FSControlSignals(2);
write       <= FSControlSignals(1);
ack_in      <= FSControlSignals(0);
din         <= dinREG;

end Behavioral;
