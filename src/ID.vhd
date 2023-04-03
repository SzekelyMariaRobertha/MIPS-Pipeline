----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2022 02:22:22 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
    Port ( clk : in std_logic;
           en : in std_logic;
           instr : in std_logic_vector (15 downto 0);
           wd : inout std_logic_vector (15 downto 0);
           RegWrite : in std_logic;
           ExtOp : in std_logic;
           RD1 : inout std_logic_vector (15 downto 0);
           RD2 : inout std_logic_vector (15 downto 0);
           ExtImm : out std_logic_vector (15 downto 0);
           func : out std_logic_vector (2 downto 0);
           sa : out std_logic;
           
           wa : in std_logic_vector(2 downto 0);
           rt : inout std_logic_vector(2 downto 0);
           rd : out std_logic_vector(2 downto 0));

end ID;

architecture Behavioral of ID is

type reg is array (0 to 15) of std_logic_vector(15 downto 0);
signal reg_file : reg := (others=>x"0000");
signal rs:std_logic_vector(2 downto 0) := "000";
-- signal rd:std_logic_vector(2 downto 0) := "000";
-- signal rt:std_logic_vector(2 downto 0) := "000";
signal wadr:std_logic_vector(2 downto 0) := "000";

begin

    sa <= instr(3);
    func <= instr(2 downto 0);
    
    rs <= instr(12 downto 10);
    rt <= instr(9 downto 7);
    rd <= instr(6 downto 4);
    
    RD1 <= reg_file(conv_integer(rs));
    RD2 <= reg_file(conv_integer(rt));
    
    -- wadr <= rd when RegDst = '1' else rt;
    ExtImm <= "000000000" & instr(6 downto 0) when ExtOp = '0' else instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6 downto 0);
    
    wadr <= wa;
    process(clk)
    begin
        if rising_edge(clk) then
           if en = '1' and RegWrite<='1' then
                reg_file(conv_integer(wadr)) <= wd;
            end if;
        end if;
    end process;
    
end Behavioral;
