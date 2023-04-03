----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2022 02:22:07 PM
-- Design Name: 
-- Module Name: IFF - Behavioral
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

entity IFF is
    Port ( clk : in std_logic; 
           en : in std_logic;  
           jmpA : in std_logic_vector (15 downto 0); 
           brA : in std_logic_vector (15 downto 0); 
           jmp : in std_logic; 
           pcsrc : in std_logic; 
           rst : in std_logic; 
           instr : out std_logic_vector (15 downto 0);
           next_instr : out std_logic_vector (15 downto 0);  -- PC + 1 pe schema 
           
           jrAdress: in std_logic_vector (15 downto 0); 
           jmpR: in std_logic
     );

end IFF;

architecture Behavioral of IFF is

type rom_type is array(0 to 255) of std_logic_vector(15 downto 0);
signal mem:rom_type:=(
-- dublul primelor 10 numere stocat in memorie si suma lor

b"000_000_000_001_0_000",	    -- 0010
b"001_000_100_0001010"  ,	    -- 220A
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_010_0_000",	    -- 0020
b"000_000_000_110_0_000",	    -- 0060
b"100_001_100_0100001",		    -- 8621
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"010_010_011_0000000",		    -- 4980
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"000_011_000_011_1_010",		-- 0C3A
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"000_011_000_011_0_000",		-- 0C30
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"000_110_011_110_0_000",		-- 19E0
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"000_110_000_110_0_000",       -- 1860
b"011_010_011_0000000",		    -- 6980
b"001_010_010_0000001",		    -- 2901
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"000_010_000_010_0_000",       -- 0820
b"001_001_001_0000001",		    -- 2481
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"000_001_000_001_0_000",       -- 0410
b"001_000_100_0001010"  ,       -- 220A
b"111_0000000000101",			-- E005
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_111_0_000",		-- 0070
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000        
b"000_111_110_111_0_000",		-- 1F70
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"000_000_000_000_0_000",       -- 0000
b"011_000_111_0001011",		    -- 638B
others=>x"0000");

signal out_pc: std_logic_vector(15 downto 0) := x"0000";
signal out_mux_1: std_logic_vector(15 downto 0) := x"0000";
signal out_mux_2: std_logic_vector(15 downto 0) := x"0000";
signal out_mux_3: std_logic_vector(15 downto 0) := x"0000";

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if(rst = '1') then
                out_pc <= x"0000";
            elsif(en = '1') then
            out_pc <= out_mux_3;
            end if;
        end if;
    end process;

    process(brA, pcsrc)
    begin
    case pcsrc is
        when '0' => out_mux_1 <= out_pc + 1;
        when '1' => out_mux_1 <= brA; 
    end case;
    end process;
    
    process(out_mux_1, jmpA, jmp)
    begin
    case jmp is
        when '0' => out_mux_2 <= out_mux_1;
        when '1' => out_mux_2 <= jmpA;
    end case;
    end process;
    
    process(out_mux_3, jrAdress, jmpR)
    begin
    case jmpR is
        when '0' => out_mux_3 <= out_mux_2;
        when '1' => out_mux_3 <= jrAdress;
    end case;
    end process;
    
    next_instr <= out_pc + 1;
    instr <= mem(conv_integer(out_pc(7 downto 0)));

end Behavioral;
