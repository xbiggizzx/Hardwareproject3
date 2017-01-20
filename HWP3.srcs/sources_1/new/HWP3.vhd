----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2017 18:31:41
-- Design Name: 
-- Module Name: HWP3 - Behavioral
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
use WORK.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity HWP3 is
    Port ( 
           CLK_66MHZ, RESET : in STD_LOGIC;
           SCL,SDA : inout STD_LOGIC;
           LED1 : out STD_LOGIC
           );
end HWP3;

architecture Behavioral of HWP3 is

signal switch,NRESET   : STD_LOGIC := '0';

signal scl_o, scl_i, scl_en, 	            -- BYTE_CTRL to TRISTATE SIGNALS
   	   sda_o, sda_i, sda_en,                -- BYTE_CTRL to TRISTATE SIGNALS
   	   start, stop, read, write, ack_in,    -- BYTTE_CTRL to FINITE_STATE_MACHINE SIGNALS
   	   cmd_ack, load : STD_LOGIC := '0';
   	   
     
signal pwm_wert, din : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

begin
----------------------------------------------------------------------------------------------------------------------------

--  INCLUDE ENTITY's   --   INCLUDE ENTITY's    --    INCLUDE ENTITY's   --   INCLUDE ENTITY's    --   INCLUDE ENTITY's   --

----------------------------------------------------------------------------------------------------------------------------

 BYTE_CONTROLLER: entity work.i2c_master_byte_ctrl port map (
        clk    => CLK_66MHZ,
		rst    => RESET,                    -- synchronous active high reset (WISHBONE compatible)
		nReset => NRESET,	                -- asynchornous active low reset (FPGA compatible)
		ena    => '1',                      -- core enable signal
 
	    clk_cnt => "0000000010100101",  	-- 4x SCL
 
		-- input signals
		start         => start,
		stop          => stop,
		read          => read,
		write         => write,
		ack_in        => ack_in,
		din           => din,
 
		-- output signals
		cmd_ack        => cmd_ack, -- Zeigt an, dass ein Kommando vollstandig gesendet und ein Acknowledge vom Slave empfangen wurde.
		ack_out        => open,         -- OPEN
		i2c_busy       => open,         -- OPEN
		i2c_al         => open,         -- OPEN
		dout           => pwm_wert,     -- Value received from Slave, send immediatly to PWM_MODUL
 
		-- i2c lines
		scl_i         => scl_i,         -- i2c clock line input
		scl_o         => scl_o,         -- i2c clock line output
		scl_oen       => scl_en,        -- i2c clock line output enable, active low
		sda_i         => sda_i,         -- i2c data line input
		sda_o         => sda_o,         -- i2c data line output
		sda_oen       => sda_en         -- i2c data line output enable, active low
);

 PWM_MODUL: entity work.pwmmodul port map(
        Swert       => pwm_wert,
        clk         => CLK_66MHZ, 
        load        => load,
        reset       => RESET,
        pwm_out     => switch --OUTPUT, signal to led1

);

 Tri_STATE: entity work.Task3TriState port map(
        scl          => SCL,
        sda          => SDA,
        scl_o        => scl_o,
   		scl_i        => scl_i,
   		scl_in_en    => scl_en,		
   		sda_o        => sda_o,      -- i2c data line input		
   		sda_i        => sda_i,      -- i2c data line output
   		sda_in_en    => sda_en      -- i2c data line output enable, active low
);

 Finite_State_Machine: entity work.FSMachine port map(
       clk          => CLK_66MHZ,
       cmd_ack      => cmd_ack,
       reset        => RESET,
       start        => start,
       stop         => stop,
       read         => read,
       write        => write,
       ack_in       => ack_in,
       din          => din
); 

load   <= '1' when (ack_in = '1' and cmd_ack = '1') else   -- WHEN SLAVE AND MASTER ACKNOWLEDGED, then load = 1
          '0';
NRESET <= not RESET;
LED1   <= switch;

end Behavioral;
