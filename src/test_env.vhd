----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2022 06:28:02 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in std_logic;
           btn : in std_logic_vector (4 downto 0);
           sw : in std_logic_vector (15 downto 0);
           led : out std_logic_vector (15 downto 0);
           an : out std_logic_vector (3 downto 0);
           cat : out std_logic_vector (6 downto 0));

end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( btn : in std_logic;
           clk : in std_logic;
           en : out std_logic);
end component;

component SSD is
    Port ( digit : in std_logic_vector (15 downto 0);
           clk : in std_logic;
           cat : out std_logic_vector (6 downto 0);
           an : out std_logic_vector (3 downto 0));
end component;

component IFF is
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

end component;

component ID is
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

end component;

component UC is
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

end component;

component EX is
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
end component;

component MEM is
  Port ( 
        clk :       in std_logic;
        enable :    in std_logic;
        r_data : in std_logic_vector (15 downto 0);
        AluResIn :  in std_logic_vector (15 downto 0);
        MemWrite :  in std_logic;
        memdata :    out std_logic_vector (15 downto 0);
        AluResOut : out std_logic_vector (15 downto 0)
  );
end component;

signal en0 : std_logic;
signal en1 : std_logic;
signal next_instr : std_logic_vector (15 downto 0) := x"0000";
signal instr : std_logic_vector (15 downto 0) := x"0000";
signal branch_addr : std_logic_vector (15 downto 0) := x"0000";
signal jrAdress: std_logic_vector (15 downto 0);
signal jmpR: std_logic;
signal rdata1:  std_logic_vector(15 downto 0) := x"0000";
signal rdata2:  std_logic_vector(15 downto 0) := x"0000";
signal wdata:   std_logic_vector(15 downto 0):= x"0000";
signal func:    std_logic_vector(2 downto 0) := "000";
signal extImm:  std_logic_vector(15 downto 0) := x"0000";
signal sa:      std_logic := '0';
signal regDst:   std_logic := '0';
signal extOp:    std_logic := '0';
signal aluSrc:   std_logic := '0';
signal branch:   std_logic := '0';
signal bgez:     std_logic := '0';
signal bltz:     std_logic := '0';
signal jump:     std_logic := '0';
signal memWrite: std_logic := '0';
signal memToReg: std_logic := '0';
signal regWrite: std_logic := '0';
signal aluOp:    std_logic_vector(2 downto 0) := "000"; 
signal aluRes: std_logic_vector(15 downto 0) := x"0000";
signal jump_addr: std_logic_vector(15 downto 0) := x"0000";
signal zero: std_logic;
signal ge: std_logic := '0';
signal gl: std_logic := '0';
signal aluResout: std_logic_vector(15 downto 0) := x"0000";
signal memData: std_logic_vector(15 downto 0) := x"0000";
signal ssd_signal : std_logic_vector(15 downto 0) := x"0000";
signal pcsrc: std_logic; 
signal out_mux: std_logic_vector(15 downto 0) := x"0000";

signal rd: std_logic_vector(2 downto 0);
signal rt: std_logic_vector(2 downto 0);
signal rWA: std_logic_vector(2 downto 0);
signal IF_ID: std_logic_vector(33 downto 0);
signal ID_EX: std_logic_vector(86 downto 0);
signal EX_MEM: std_logic_vector(61 downto 0);
signal MEM_WB: std_logic_vector(38 downto 0);

begin

    M0: MPG port map(btn(0), clk, en0);
    M1: MPG port map(btn(1), clk, en1);
   
    mux_afisare: process(sw(7 downto 5))
                     begin 
                             case sw(7 downto 5) is
                                when "000" => ssd_signal <= instr;
                                when "001" => ssd_signal <= next_instr;
                                when "010" => ssd_signal <= ID_EX(75 downto 60);
                                when "011" => ssd_signal <= ID_EX(59 downto 44);
                                when "100" => ssd_signal <= ID_EX(43 downto 28);
                                when "101" => ssd_signal <= aluRes;
                                when "110" => ssd_signal <= memData;
                                when "111" => ssd_signal <= out_mux; 
                                when others=> ssd_signal <= (others=>'0');
                             end case;
                     end process;
    S: SSD port map(ssd_signal, clk => clk, cat => cat, an => an);
    
    IF_ID(0) <= clk;
    IF_ID(1) <= en0;
    IF_ID(17 downto 2) <= next_instr;
    IF_ID(33 downto 18) <= instr;
    jump_addr <= IF_ID(17 downto 15) & IF_ID(30 downto 18);
    pcsrc <= (EX_MEM(57) and  EX_MEM(53)) or (EX_MEM(60) and EX_MEM(58)) or (EX_MEM(61) and EX_MEM(59));
    I: IFF port map (clk, en0, jump_addr, EX_MEM(52 downto 37), jump, pcsrc, en1, instr, next_instr, rdata1, jmpR);
    
    out_mux <= MEM_WB(36 downto 21) when MEM_WB(38) = '0' else  MEM_WB(20 downto 5);
    IDD: ID port map (clk, en0, IF_ID(33 downto 18), out_mux, MEM_WB(37), extOp, rdata1, rdata2, extImm, func, sa, MEM_WB(4 downto 2), rt, rd);
    U: UC port map(IF_ID(33 downto 18), regDst, extOp, aluSrc, branch, jump, memWrite, memToReg, regWrite, aluOp, bgez, bltz, jmpR);
    
    ID_EX(0) <= clk;
    ID_EX(1) <= en0;
    ID_EX(17 downto 2) <= IF_ID(17 downto 2);
    ID_EX(20 downto 18) <= rt;
    ID_EX(23 downto 21) <= rd;
    ID_EX(24) <= sa; 
    ID_EX(27 downto 25) <= func;
    ID_EX(43 downto 28) <= extImm;
    ID_EX(59 downto 44) <= rdata2;
    ID_EX(75 downto 60) <= rdata1;
    ID_EX(76) <= regWrite;
    ID_EX(77) <= memToReg;
    ID_EX(78) <= memWrite;
    ID_EX(81 downto 79) <= aluOp;
    ID_EX(82) <= branch;
    ID_EX(83) <= bltz;
    ID_EX(84) <= bgez;
    ID_EX(85) <= aluSrc;
    ID_EX(86) <= regDst;
    
    E: EX port map(ID_EX(17 downto 2), ID_EX(75 downto 60), ID_EX(59 downto 44), ID_EX(43 downto 28), ID_EX(27 downto 25), ID_EX(24), ID_EX(85), ID_EX(81 downto 79), branch_addr, aluRes, zero, ge, gl, ID_EX(86), ID_EX(20 downto 18), ID_EX(23 downto 21), rWA);
    
    EX_MEM(0) <= clk;
    EX_MEM(1) <= en0;
    EX_MEM(17 downto 2) <= rdata2;
    EX_MEM(20 downto 18) <= rWA;
    EX_MEM(36 downto 21) <= aluRes;
    EX_MEM(52 downto 37) <= branch_addr;
    EX_MEM(53) <= zero;
    EX_MEM(54) <= ID_EX(76);
    EX_MEM(55) <= ID_EX(77);
    EX_MEM(56) <= ID_EX(78);
    EX_MEM(57) <= ID_EX(82);
    EX_MEM(58) <= ID_EX(83);
    EX_MEM(59) <= ID_EX(84);
    EX_MEM(60) <= gl;
    EX_MEM(61) <= ge;
    
    M: MEM port map(clk, en0, EX_MEM(17 downto 2), EX_MEM(36 downto 21), EX_MEM(56),  memData, aluResout);
    
    
    MEM_WB(0) <= clk;
    MEM_WB(1) <= en0;
    MEM_WB(4 downto 2) <= EX_MEM(20 downto 18);
    MEM_WB(20 downto 5) <= memdata;
    MEM_WB(36 downto 21) <= aluResout;
    MEM_WB(37) <= EX_MEM(54);
    MEM_WB(38) <= EX_MEM(55);
    
  
    led(13 downto 0) <= aluOp & regDst & extOp & aluSrc & branch & bgez & bltz & jump & jmpR & memWrite & memToReg & regWrite;
                       -- 3        1        1       1        1        1      1      1      1        1         1         1  
end Behavioral;
