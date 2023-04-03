----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2022 02:23:03 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
  Port ( 
        clk :       in std_logic;
        enable :    in std_logic;
        r_data : in std_logic_vector (15 downto 0);
        AluResIn :  in std_logic_vector (15 downto 0);
        MemWrite :  in std_logic;
        memdata :    out std_logic_vector (15 downto 0);
        AluResOut : out std_logic_vector (15 downto 0)
  );
end MEM;

architecture Behavioral of MEM is

type ram_array is array (0 to 255) of std_logic_vector(15 downto 0);
signal RAM: ram_array := (x"0002", x"0005", x"0006", x"0009", x"0003", x"0005", x"0008", x"0010", x"0015", x"000B", others => x"0000");
    
begin
    process (clk) 
    begin
            if rising_edge(clk) then
                if enable = '1' and MemWrite = '1' then
                    RAM(conv_integer(AluResIn(4 downto 0))) <= r_data;
                end if;
            end if;
    end process;
    
    memdata <= RAM(conv_integer(AluResIn(4 downto 0)));
    AluResOut <= AluResIn;

end Behavioral;
