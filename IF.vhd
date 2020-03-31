----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/20/2019 12:45:53 AM
-- Design Name: 
-- Module Name: IF - Behavioral
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



LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.procmem_definitions.ALL;	

ENTITY data_fetch IS
 PORT (
 instruction: out std_ulogic_vector(31 downto 0);
 clk : IN STD_ULOGIC;
 rst_n : IN STD_ULOGIC;
 pc_in : IN STD_ULOGIC_VECTOR(31 DOWNTO 0);
 alu_out : IN STD_ULOGIC_VECTOR(31 DOWNTO 0);
 mem_data : IN std_ulogic_vector(31 DOWNTO 0);
 PC_en : IN STD_ULOGIC;
 IorD : IN STD_ULOGIC;
 IRWrite : IN STD_ULOGIC;
 reg_memdata : OUT STD_ULOGIC_VECTOR(31 DOWNTO 0);
 instr_31_26 : OUT STD_ULOGIC_VECTOR(5 DOWNTO 0);
 instr_25_21 : OUT STD_ULOGIC_VECTOR(4 DOWNTO 0);
 instr_20_16 : OUT STD_ULOGIC_VECTOR(4 DOWNTO 0);
 instr_15_0 : OUT STD_ULOGIC_VECTOR(15 DOWNTO 0);
 mem_address : OUT std_ulogic_vector(31 DOWNTO 0);
 pc_out : OUT std_ulogic_vector(31 DOWNTO 0)
 );

END data_fetch;
ARCHITECTURE behave OF data_fetch IS


COMPONENT tempreg IS
 PORT (
 clk : IN STD_ULOGIC;
 rst_n : IN STD_ULOGIC;
 reg_in : IN STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
 reg_out : OUT STD_ULOGIC_VECTOR(width-1 DOWNTO 0) );
END COMPONENT;
COMPONENT pc IS
 PORT (
 clk : IN STD_ULOGIC;
 rst_n : IN STD_ULOGIC;
 pc_in : IN STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
 PC_en : IN STD_ULOGIC;
 pc_out : OUT STD_ULOGIC_VECTOR(width-1 DOWNTO 0) );
END COMPONENT;	
COMPONENT instreg IS
 PORT (
 clk : IN STD_ULOGIC;
 rst_n : IN STD_ULOGIC;
 memdata : IN STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
 IRWrite : IN STD_ULOGIC;
 instr_31_26 : OUT STD_ULOGIC_VECTOR(5 DOWNTO 0);
 instr_25_21 : OUT STD_ULOGIC_VECTOR(4 DOWNTO 0);
 instr_20_16 : OUT STD_ULOGIC_VECTOR(4 DOWNTO 0);
 instr_15_0 : OUT STD_ULOGIC_VECTOR(15 DOWNTO 0) );
END COMPONENT;


 SIGNAL AUXILIAR : STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
BEGIN


 proc: pc
 PORT MAP ( clk,rst_n,pc_in, PC_en,AUXILIAR);
 instr_reg : instreg
 PORT MAP (clk,rst_n, mem_data,IRWrite,instr_31_26 ,instr_25_21 ,instr_20_16 , instr_15_0 );

 mem_data_reg : tempreg
 PORT MAP (clk, rst_n, mem_data, reg_memdata );
 -- mux
 addr_mux : PROCESS(IorD, AUXILIAR, alu_out)
 VARIABLE mem_address_temp : STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
 BEGIN
 IF IorD = '0' THEN
 mem_address_temp := AUXILIAR;
 ELSIF IorD = '1' THEN
 mem_address_temp := alu_out;
 ELSE
mem_address_temp := (OTHERS => '0');
  END IF;
  mem_address <= mem_address_temp;
  END PROCESS;
 
  pc_out <= AUXILIAR;
 --instruction <= instr_31_26 & instr_25_21 & instr_20_16 & instr_15_0;
 END behave;