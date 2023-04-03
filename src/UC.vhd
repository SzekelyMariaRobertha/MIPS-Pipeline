----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2022 02:22:33 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
    Port ( 
        Instr : in std_logic_vector(15 downto 0);
        RegDst : out std_logic;
        ExtOp : out std_logic;
        ALUSRC : out std_logic;
        Branch : out std_logic;
        Jump : out std_logic;
        MemWrite : out std_logic;
        MemtoReg : out std_logic;
        RegWrite : out std_logic;
        ALUOp : out std_logic_vector(2 downto 0);
        
        Bgez : out std_logic;
        Bltz : out std_logic;
        jmpR : out std_logic
   );

end UC;

architecture Behavioral of UC is
begin

     process(Instr)
     begin
       RegDst <= '0';
       ExtOp <= '0';
       ALUSrc <= '0';
       Branch <= '0';
       Bgez <= '0';
       Bltz <= '0';
       Jump <= '0';
       MemWrite <= '0';
       MemtoReg <= '0';
       ALUOp <= "000";
       RegWrite <= '0';
       jmpR <= '0';
       
       case (Instr(15 downto 13)) is
           when "000" => -- tip R
               RegDst <= '1'; RegWrite <= '1'; ALUOp <= "000";
               if Instr(2 downto 0) = "111" then -- cand func = "111" trebuie setat jrsel la '1'
                   jmpR <= '1'; --jr
               end if;
           when "001" => -- addi
               ExtOp <= '1';
               ALUSrc <= '1';
               RegWrite <= '1';
               ALUOp <= "011";
           when "010" => -- lw
               ALUOp <= "011";
               RegWrite <= '1';
               ALUSrc <= '1';
               ExtOp <= '1';
               MemtoReg <= '1';
           when "011" => -- sw
               ALUSrc <= '1';
               ExtOp <= '1';
               MemWrite <= '1';
               ALUOp <= "011";
           when "100" => -- beq
               ExtOp <= '1';
               ALUOp <= "010";
               Branch <= '1';
           when "101" => -- bgez
               ExtOp <= '1';
               Bgez <= '1';
               ALUOp <= "010";
           when "110" => -- bltz
               ExtOp <= '1';
               Bltz <= '1';
               ALUOp <= "010";
           when "111" => -- j
                ALUOp <= "001";
               Jump <= '1';
           when others =>
               RegDst <= 'X';
               ExtOp <= 'X';
               ALUSrc <= 'X';
               Branch <= 'X';
               Jump <= 'X';
               MemWrite <= 'X';
               MemtoReg <= 'X';
               ALUOp <= "XXX";
               RegWrite <= 'X';
       end case;
   end process;

end Behavioral;
