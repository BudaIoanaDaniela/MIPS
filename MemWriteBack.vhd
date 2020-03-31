
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

USE work.procmem_definitions.ALL;
USE work.procmem_definitions.ALL;
ENTITY data_memwriteback IS
 PORT (clk, rst_n : IN std_ulogic;
 jump_addr : IN std_ulogic_vector(width-1 downto 0);
 alu_result : IN std_ulogic_vector(width-1 downto 0);
 PCSource : IN std_ulogic_vector(1 downto 0);

 pc_in : OUT std_ulogic_vector(width-1 downto 0);
 alu_out : OUT std_ulogic_vector(width-1 downto 0)
 );
END data_memwriteback;






ARCHITECTURE behave OF data_memwriteback IS
 COMPONENT tempreg
 PORT (
 clk : IN STD_ULOGIC;
 rst_n : IN STD_ULOGIC;
 reg_in : IN STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
 reg_out : OUT STD_ULOGIC_VECTOR(width-1 DOWNTO 0)
 );
 END COMPONENT;
 SIGNAL alu_out_internal : std_ulogic_vector(width-1 downto 0);
BEGIN
 tempreg_inst: tempreg
 PORT MAP (
 clk => clk,
 rst_n => rst_n,
 reg_in => alu_result,
 reg_out => alu_out_internal
 );


 mux : PROCESS (PCSource, ALU_result, ALU_out_internal, jump_addr)
 BEGIN
 CASE PCSource IS
 WHEN "00" => pc_in <= alu_result;
 WHEN "01" => pc_in <= alu_out_internal;
 WHEN "10" => pc_in <= jump_addr;
 WHEN OTHERS => pc_in <= (OTHERS => 'X');
 END CASE;
 END PROCESS;
 alu_out <= alu_out_internal;

END behave;