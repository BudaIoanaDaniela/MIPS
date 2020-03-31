library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity my_memory is
	port(clk,rst,rd,wr:in std_logic;
		addr,data:in std_ulogic_vector(31 downto 0);
		instr_data:out std_ulogic_vector(31 downto 0);
		data1:out std_ulogic_vector(31 downto 0));
end my_memory;

architecture Behavioral of my_memory is
type mem is array(0 to 15) of std_ulogic_vector(31 downto 0);
signal memory: mem := ("00000000000000010001000000100000","10101100000000100000000000000011", "10001100000100000000000010000000","10001100001000000000000000000000","00000000001000010001000000100000",others=>"00000000000000000000000000000000");

begin
process(clk,addr,rd)
begin
 if rst='0' then
	instr_data<=memory(0);
 elsif rd='1' then
	instr_data<=memory(to_integer(unsigned(addr)));
 end if;
 if clk='1' and clk'event then
	if wr='1' then
		memory(to_integer(unsigned(addr)))<=data;
	end if;
 end if;
 data1<=memory(1);
end process;
end Behavioral;

