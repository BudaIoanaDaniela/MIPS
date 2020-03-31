----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2019 02:36:36 PM
-- Design Name: 
-- Module Name: PhaseGen - Behavioral
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

entity PhaseGen is
 Port ( clk :in std_logic ;
        instruction :in std_ulogic_vector(31 downto 0);
        nrState: out std_ulogic_vector(3 downto 0));
 
end PhaseGen;

architecture Behavioral of PhaseGen is
TYPE state IS (IF1,ID1,EX,W1,M,S,J,WB,L);
signal nextState: state;
signal curr_state: state :=IF1;	 
signal stare2 : std_logic:='0';
begin
decide :process(clk,instruction)
     begin
	 case curr_state is 
	 
	 when IF1 =>
	  nrState <= "0000";
	  nextState <= ID1;
	 when ID1 => nrState<= "0001";
	             if (instruction(31 downto 26) ="000000"  )then
	               nextState <= EX;	
				   stare2<='1';
	             else
	             nextState <= M;
	             end if;
	 when EX =>  nrState <= "0010";
	        nextState <= W1;
	 when W1 => nrState<= "0011";
	         nextState <= IF1;
	 when M => nrState <="0100";
	      if instruction (31 downto 26) ="100011"  then
	               nextState <= L;
	              elsif ( instruction( 31 downto 26) ="101011") then
	              nextState <= S;
	              end if;
	              
	 when L => nrState<="0101";
	  nextState<= WB;
	 when WB => nrState <="0110";
	 nextState <=IF1;
	 when S => 	  nrState <="0111";
	 nextState <=IF1;
	
	 when others => nextState <=IF1;
	 end case;
	 end process;
	 
SCL : process (clk)
begin 
  if(rising_edge(clk) ) then
       
  curr_state <= nextState;
  end if;
  end process;
  

end Behavioral;
