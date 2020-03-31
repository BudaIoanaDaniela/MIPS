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

entity MPG is
 Port (   btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
signal cnt: std_logic_vector(15 downto 0);
signal q1:STD_LOGIC;
signal q2:STD_LOGIC;
signal q3:STD_LOGIC;


begin
count: process(clk)
        begin
            if rising_edge(clk) then
            cnt <= cnt+1;
            end if;
           end process count;
d1: process(clk)
begin
	if rising_edge(clk) then
	if cnt = x"FFFF" then
		q1 <= btn;
	end if;
	end if;
	
end process;
d2: process (clk)
begin
	if rising_edge(clk) then
	
		q2 <= q1;
	
	end if;
end process;

d3: process (clk)
begin
	if rising_edge(clk) then
	
		q3 <= q2;
	end if;
end process;
              
enable <= q2 and (not q3);

end Behavioral;