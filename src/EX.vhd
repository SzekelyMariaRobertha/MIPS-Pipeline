----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2022 02:22:47 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX is
    Port(next_instr: in std_logic_vector (15 downto 0);
         rd1: in std_logic_vector (15 downto 0);
         rd2: in std_logic_vector (15 downto 0);
         extImm: in std_logic_vector (15 downto 0);
         func: in std_logic_vector (2 downto 0);
         sa: in std_logic;
         ALUSrc: in std_logic;
         ALUOp: in std_logic_vector (2 downto 0);
         branchAddr: out std_logic_vector (15 downto 0);
         ALURes: out std_logic_vector (15 downto 0);
         Zero: out std_logic; -- out beq
         GE: out std_logic; --out bgez
         GL: out std_logic; -- out bltz
         
         RegDst: in std_logic;
         rt : inout std_logic_vector(2 downto 0);
         rd : inout std_logic_vector(2 downto 0);
         rWA : out std_logic_vector(2 downto 0)
    );
end EX;

architecture Behavioral of EX is

signal ALUCtrl: std_logic_vector(2 downto 0) := "000";
signal mux_out: std_logic_vector(15 downto 0) := x"0000";
signal ALUResaux: std_logic_vector(15 downto 0) := x"0000";
signal isZero: std_logic_vector(15 downto 0) := x"0000";

begin

     process(ALUOp, func)
     begin
       case ALUOp is
           when "000" =>
               case func is
                   when "000" => ALUCtrl <= "000"; -- add
                   when "001" => ALUCtrl <= "001"; -- sub
                   when "010" => ALUCtrl <= "010"; -- sll
                   when "011" => ALUCtrl <= "011"; -- srl
                   when "100" => ALUCtrl <= "100"; -- and
                   when "101" => ALUCtrl <= "101"; -- or
                   when "110" => ALUCtrl <= "110"; -- xor
                   when "111" => ALUCtrl <= "XXX"; -- jr - nu conteaza ce se face in alu
               end case;
           when "011" => -- addi, lw, sw
               ALUCtrl <= "000"; -- adunare
           when "010" => -- beq, bgez, bltz
               ALUCtrl <= "001"; -- scadere
           when others => -- j
               ALUCtrl <= "XXX"; -- nu conteaza
       end case;
   end process;

   mux_out <= rd2 when ALUSrc = '0' else extImm;
   rWA <= rd when RegDst = '1' else rt;
   
   process(rd1, mux_out, ALUCtrl, sa)
       begin
           case ALUCtrl is
               when "000" => ALUResaux <= rd1 + mux_out;
               when "001" =>  if(func = "001") then ALUResaux <= rd1 - mux_out; 
                                 else ALUResaux <= mux_out; 
                                 end if;
                             
                             if(rd1 - mux_out) = x"0000" then Zero <= '1'; else Zero <= '0'; end if;
                             if(rd1 - mux_out) < x"0000" then GL <= '1'; else GL <= '0'; end if;
                             if(rd1 - mux_out) >= x"0000" then GE <= '1'; else GE <= '0'; end if;
                             
               when "010" => if sa = '1' then ALUResaux <= rd1(14 downto 0) & '0'; end if;
               when "011" => if sa = '1' then ALUResaux <= rd1(15) & rd1(15 downto 1); end if;
               when "100" => ALUResaux <= rd1 and mux_out;
               when "101" => ALUResaux <= rd1 or mux_out;
               when "110" => ALUResaux <= rd1 xor mux_out;
               when others =>               
           end case;
       end process;
       
       ALURes <= ALUResaux;
       branchAddr <= next_instr + extImm;

end Behavioral;
