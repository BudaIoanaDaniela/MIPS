-------------------------------------------------------------------------------
--
-- Title       : main2
-- Design      : MIPS
-- Author      : Ioana
-- Company     : Ioana
--
-------------------------------------------------------------------------------
--
-- File        : e:\MIPS\MIPS\src\main2.vhd
-- Generated   : Wed Nov 27 13:03:05 2019
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {main2} architecture {main2}}



-------------------------------------------------------------------------------
--
-- Title       : main
-- Design      : MIPS
-- Author      : Ioana
-- Company     : Ioana
--
-------------------------------------------------------------------------------
--
-- File        : e:\MIPS\MIPS\src\main.vhd
-- Generated   : Tue Nov 26 22:14:28 2019
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {main} architecture {main}}
 
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
-- use package
USE work.procmem_definitions.ALL;


entity main2 is	
	port( clk :in std_ulogic );
	
end main2;

--}} End of automatically maintained section

ARCHITECTURE behave OF main2 IS
 COMPONENT DataRegisters
 PORT (
 clk, rst_n : IN std_ulogic;
 mem_data : IN std_ulogic_vector(width-1 downto 0);
 reg_B, mem_address : OUT std_ulogic_vector(width-1 downto 0);
 MemRead, MemWrite : OUT std_ulogic);
 END COMPONENT;	
 
 COMPONENT my_memory
  
	port(clk,rst,rd,wr:in std_logic;
		addr,data:in std_ulogic_vector(31 downto 0);
		instr_data:out std_ulogic_vector(31 downto 0);
		data1:out std_ulogic_vector(31 downto 0));
end component;


SIGNAL mem_data ,showdata: std_ulogic_vector(width-1 downto 0);
signal reg_B : std_ulogic_vector(width-1 downto 0);
signal mem_address : std_ulogic_vector(width-1 downto 0);
signal MemRead,rst_n : std_ulogic;
signal MemWrite : std_ulogic;
BEGIN
 inst_mips : DataRegisters
 PORT MAP (
 clk => clk,
 rst_n => rst_n,
 mem_data => mem_data,
 reg_B => reg_B,
 mem_address => mem_address,
 MemRead => MemRead,
 MemWrite => MemWrite
 );
 inst_memory : my_memory
 PORT MAP (
 clk => clk,
 rst => rst_n,
 rd => MemRead,
 wr => MemWrite,
 addr => mem_address,
 data=> reg_B,
 instr_data => mem_data	,
 data1 =>	showdata
 );

END behave;
