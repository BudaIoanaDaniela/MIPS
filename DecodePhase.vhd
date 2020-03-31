LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
-- use package
USE work.procmem_definitions.ALL;

ENTITY data_decode2 IS
 PORT (
 -- inputs
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
 instr_15_0_se_sl : OUT STD_ULOGIC_VECTOR(width-1 DOWNTO 0)
 );
END data_decode2;