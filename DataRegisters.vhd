----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/20/2019 02:20:32 PM
-- Design Name: 
-- Module Name: DataRegisters - Behavioral
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
-- use package
USE work.procmem_definitions.ALL;

entity DataRegisters is
 Port ( clk, rst_n : IN std_ulogic;
 mem_data : IN std_ulogic_vector(width-1 downto 0);
 reg_B, mem_address : OUT std_ulogic_vector(width-1 downto 0);
 zero: out std_ulogic;
 MemRead, MemWrite : OUT std_ulogic);
end DataRegisters;




architecture Behavioral of DataRegisters is
signal instruction,instruction_intern,instruction_1 : std_ulogic_vector(31 downto 0 );
component UControl is
 Port ( clk : in std_logic;
        currentState1: out std_ulogic_vector(3 downto 0);
        instruction : in std_ulogic_vector(31 downto 0 );
        
        RegDst : out  STD_uLOGIC;
        ExtOp : out  STD_uLOGIC;
        AluSrcA : out  STD_uLOGIC;
        zero        : IN std_ulogic;
                   --Branch : out  STD_LOGIC;
                  -- Jump : out  STD_LOGIC;
        ALUopcode,AluSrcB : out  STD_uLOGIC_VECTOR (2 downto 0);
        Aluop:out std_ulogic_Vector(1 downto 0);
        MemWrite ,MemRead: out  STD_uLOGIC;
        MemtoReg : out  STD_uLOGIC;
        RegWrite : out  STD_uLOGIC;
        IorD : OUT STD_ULOGIC;
        IRWrite: out std_ulogic;
        PCwrite:out std_ulogic;	   
		PcSource : out std_ulogic_vector(1 downto 0);
        PC_en       : OUT std_ulogic
 );
end component;

component data_fetch IS
 PORT (
 instruction: out std_ulogic_vector(31 downto 0);
 clk : IN STD_ULOGIC;
 rst_n : IN STD_ULOGIC;
 pc_in : IN STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
 alu_out : IN STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
 mem_data : IN std_ulogic_vector(width-1 DOWNTO 0);
 PC_en : IN STD_ULOGIC;
 IorD : IN STD_ULOGIC;
 IRWrite : IN STD_ULOGIC;
 reg_memdata : OUT STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
 instr_31_26 : OUT STD_ULOGIC_VECTOR(5 DOWNTO 0);
 instr_25_21 : OUT STD_ULOGIC_VECTOR(4 DOWNTO 0);
 instr_20_16 : OUT STD_ULOGIC_VECTOR(4 DOWNTO 0);
 instr_15_0 : OUT STD_ULOGIC_VECTOR(15 DOWNTO 0);
 mem_address : OUT std_ulogic_vector(width-1 DOWNTO 0);
 pc_out : OUT std_ulogic_vector(width-1 DOWNTO 0)
 
 );

END component;

component data_decode IS
 PORT (
 -- inputs
 instruction: in std_ulogic_vector(31 downto 0);
 clk : IN STD_ULOGIC;
 rst_n : IN STD_ULOGIC;
 instr_25_21 : IN STD_ULOGIC_VECTOR(4 DOWNTO 0);
 instr_20_16 : IN STD_ULOGIC_VECTOR(4 DOWNTO 0);
 instr_15_0 : IN STD_ULOGIC_VECTOR(15 DOWNTO 0);
 reg_memdata : IN STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
 alu_out : IN STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
 -- control signals
 RegDst : IN STD_ULOGIC;
 RegWrite : IN STD_ULOGIC;
 MemtoReg : IN STD_ULOGIC;
 -- outputs
 reg_A : OUT STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
 reg_B : OUT STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
 instr_15_0_se : OUT STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
 registervalue : out std_ulogic_vector(31 downto 0);
 instr_15_0_se_sl : OUT STD_ULOGIC_VECTOR(width-1 DOWNTO 0)
 );
 end component;
component data_execution IS
  PORT (instr_25_21 : IN std_ulogic_vector(4 downto 0);
  instr_20_16 : IN std_ulogic_vector(4 downto 0);
  instr_15_0 : IN std_ulogic_vector(15 downto 0);
  ALUSrcA : IN std_ulogic;
  ALUSrcB : IN std_ulogic_vector(1 downto 0);
  ALUopcode : IN std_ulogic_vector(2 downto 0);
  reg_A, reg_B : IN std_ulogic_vector(width-1 downto 0);
  pc_out : IN std_ulogic_vector(width-1 downto 0);
  instr_15_0_se : IN std_ulogic_vector(width-1 downto 0);
  instr_15_0_se_sl : IN std_ulogic_vector(width-1 downto 0);
 
 -- jump_addr : OUT std_ulogic_vector(width-1 downto 0);
  alu_result : OUT std_ulogic_vector(width-1 downto 0);
  zero : OUT std_ulogic
  );
 END component;
 
 
 component data_memwriteback IS
  PORT (clk, rst_n : IN std_ulogic;
  jump_addr : IN std_ulogic_vector(width-1 downto 0);
  alu_result : IN std_ulogic_vector(width-1 downto 0);
  PCSource : IN std_ulogic_vector(1 downto 0);
 
  pc_in : OUT std_ulogic_vector(width-1 downto 0);
  alu_out : OUT std_ulogic_vector(width-1 downto 0)
  );
 END component;
 signal pc_write :std_ulogic;
 SIGNAL instr_15_0_intern : std_ulogic_vector(15 downto 0);
 SIGNAL pc_out_intern : std_ulogic_vector(width-1 downto 0);
 SIGNAL reg_A_intern : std_ulogic_vector(width-1 downto 0);
 SIGNAL reg_B_intern : std_ulogic_vector(width-1 downto 0);
 SIGNAL instr_15_0_se_intern ,register_value_intern: std_ulogic_vector(width-1 downto 0);
 SIGNAL instr_15_0_se_sl_intern : std_ulogic_vector(width-1 downto 0);
 SIGNAL jump_addr_intern : std_ulogic_vector(width-1 downto 0);
 SIGNAL alu_result_intern : std_ulogic_vector(width-1 downto 0);
SIGNAL pc_in_intern : std_ulogic_vector(width-1 downto 0);
 SIGNAL alu_out_intern : std_ulogic_vector(width-1 downto 0);
 SIGNAL reg_memdata_intern : std_ulogic_vector(width-1 downto 0);
 SIGNAL instr_25_21_intern : std_ulogic_vector(4 downto 0);
 SIGNAL instr_20_16_intern : std_ulogic_vector(4 downto 0);
   signal  currstate :  std_ulogic_vector(3 downto 0);
 
 signal PC_en, IorD, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst : std_ulogic;
  signal PCSource, ALUSrcB : std_ulogic_vector(1 downto 0);
 signal  ALUopcode :  std_ulogic_vector(2 downto 0);
 signal instr_31_26 :  std_ulogic_vector(5 downto 0);
 signal instr_15_0 :  std_ulogic_vector(15 downto 0);
 
 
 SIGNAL instr_31_26_intern : std_ulogic_vector(5 downto 0);
 --SIGNAL instr_15_0_intern : std_ulogic_vector(15 downto 0);
 SIGNAL zero_intern : std_ulogic;
 SIGNAL ALUopcode_intern : std_ulogic_vector(2 downto 0);
 SIGNAL RegDst_intern : std_ulogic;
 SIGNAL RegWrite_intern : std_ulogic;
 SIGNAL ALUSrcA_intern : std_ulogic;
 SIGNAL MemtoReg_intern : std_ulogic;
 SIGNAL IorD_intern : std_ulogic;
 SIGNAL IRWrite_intern : std_ulogic;
 SIGNAL ALUSrcB_intern :                               std_ulogic_vector(2 downto 0);
 signal aluop : std_ulogic_vector(1 downto 0);
 SIGNAL PCSource_intern : std_ulogic_vector(1 downto 0);
  SIGNAL PCSource_intern2 : std_ulogic;
 SIGNAL PC_en_intern,extop_intern: std_ulogic;
 
 


begin

control: UControl port map (clk,currstate,instruction,RegDst_intern,extop_intern,ALUSrcA_intern,zero_intern,ALUopcode,ALUSrcB_intern, aluop,MemWrite,MemRead,MemtoReg_intern,RegWrite_intern
,IorD_intern,IRWrite_intern,PC_write,PcSource_intern,Pc_en_intern);




 inst_data_fetch: data_fetch
 PORT MAP (instruction_intern,
 clk => clk,
 rst_n => rst_n,
 pc_in => pc_in_intern,
 alu_out => alu_out_intern,
 mem_data => mem_data,
 PC_en => PC_en_intern,
 IorD => IorD_intern,
 IRWrite => IRWrite_intern,
 reg_memdata => reg_memdata_intern,
 instr_31_26 => instr_31_26,
 instr_25_21 => instr_25_21_intern,
 instr_20_16 => instr_20_16_intern,
 instr_15_0 => instr_15_0_intern,
 mem_address => mem_address,
 pc_out => pc_out_intern);
 
 decoding :data_decode
 PORT MAP (instruction,		 ----mod
 clk => clk,
 rst_n => rst_n,
 instr_25_21 => instr_25_21_intern,
 instr_20_16 => instr_20_16_intern,
 instr_15_0 => instr_15_0_intern,
 reg_memdata => reg_memdata_intern,
 alu_out => alu_out_intern,
 RegDst => RegDst_intern,
 RegWrite => RegWrite_intern,
 MemtoReg => MemtoReg_intern,
 reg_A => reg_A_intern,
 reg_B => reg_B_intern,
 instr_15_0_se => instr_15_0_se_intern,
 registervalue => register_value_intern,
 instr_15_0_se_sl => instr_15_0_se_sl_intern
 );

 inst_data_execution: data_execution
 PORT MAP (
 instr_25_21 => instr_25_21_intern,
 instr_20_16 => instr_20_16_intern,
 instr_15_0 => instr_15_0_intern,
 ALUSrcA => ALUSrcA_intern,
 ALUSrcB => ALUSrcB_intern(1 downto 0),
 ALUopcode => ALUopcode,
 reg_A => reg_A_intern,
 reg_B => reg_B_intern,
 pc_out => pc_out_intern,
 instr_15_0_se => instr_15_0_se_intern,
 instr_15_0_se_sl => instr_15_0_se_sl_intern,
 --jump_addr => jump_addr_intern,
 alu_result => alu_result_intern,
 zero => zero_intern
 );

 inst_data_memwriteback : data_memwriteback
 PORT MAP (
 clk => clk,
 rst_n => rst_n,
 jump_addr => jump_addr_intern,
 alu_result => alu_result_intern,
 PCSource => PCSource_intern,
 pc_in => pc_in_intern,
 alu_out => alu_out_intern
 );

reg_B <= reg_B_intern;
instr_15_0 <= instr_15_0_intern; 
instruction(31 downto 26) <= instr_31_26;
instruction(15 downto 0) <= instr_15_0_intern;
instruction(25 downto 21) <= instr_25_21_intern;
instruction(20 downto 16) <= instr_20_16_intern;

end Behavioral;
