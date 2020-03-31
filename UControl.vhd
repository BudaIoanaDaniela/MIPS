----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2019 10:33:22 AM
-- Design Name: 
-- Module Name: UControl - Behavioral
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

entity UControl is
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
end UControl;

architecture Behavioral of UControl is

component PhaseGen is
 Port ( clk :in std_logic ;
        instruction :in std_ulogic_vector(31 downto 0);
        nrState: out std_ulogic_vector(3 downto 0));
 
end component;
component ALUControl IS
 PORT (instr_15_0 : IN std_ulogic_vector(15 downto 0);
 ALUOp : IN std_ulogic_vector(1 downto 0);
 ALUopcode : OUT std_ulogic_vector(2 downto 0)
 );
 end component;
signal currentState: std_ulogic_vector(3 downto 0);
signal AluOpAux : std_ulogic_vector(1 downto 0);
signal AluopcodeAux : std_ulogic_vector(2 downto 0);
signal pcWriteAux,ExtOpAux : std_ulogic;
begin
generation: PhaseGen Port map (clk,instruction,currentState);
alucontroling  : ALUControl  port map (instruction(15 downto 0),AluOpAux,ALUopcode); 

process(currentState)
begin  
	currentState1 <= currentState;
case currentState is
when "0000" => RegDst <= '0';  -- R-Type
				  RegWrite <= '0';
				  AluSrcA <= '0';
				  MemRead<='1';
				  MemWrite <= '0';
				  MemtoReg <= '0'; 	
				  IorD<='0';
				  IrWrite<='1';
				  pcWrite<='1';
				ExtOpAux<= '0';	
				
				  pcWriteAux<='1';
				  ExtOpAux<='0';
				  AluOpAux <= "00";
				  AluSrcB <="001";	
				  PcSource<="00";--nu ne trebuie			 
				  
when "0001" => RegDst <= '0';  -- R-Type
                                   RegWrite <= '0';
                                   AluSrcA <= '1';
                                   MemRead<='0';
                                   MemWrite <= '0';
                                   MemtoReg <= '0';     
                                   IorD<='0';
                                   IrWrite<='0';
                                   pcWrite<='0';  
								    pcWriteAux<='0';
				  ExtOpAux<='1';
                                 ExtOP<= '1';
                                  AluOpAux <= "00";
                                   AluSrcB <="011";    
                                   PcSource<="00";--nu ne trebuie        

  when "0010"  => RegDst <= '0';  -- R-Type
                    RegWrite <= '0';
                    AluSrcA <= '1';
                    MemRead<='0';
                    MemWrite <= '0';
                    MemtoReg <= '0';     
                    IorD<='0';
                    IrWrite<='0';
                    pcWrite<='0'; 
					 pcWriteAux<='0';
				     ExtOpAux<='0';
                   ExtOp<= '0';
                   AluOpAux <= "10";--nu stiu sigur aici
                    AluSrcB <="000";    
                    PcSource<="00";--nu ne trebuie      

when "0011" => RegDst <= '1';  -- R-Type
                                       RegWrite <= '1';
                                       AluSrcA <= '0';
                                       MemRead<='0';
                                       MemWrite <= '0';
                                       MemtoReg <= '0';     
                                       IorD<='0';
                                       IrWrite<='0';
                                       pcWrite<='0';
                                      ExtOp<= '0';	 
									   pcWriteAux<='0';
				  ExtOpAux<='0';
                                      AluOpAux <= "00";
                                       AluSrcB <="001";    
                                       PcSource<="00";--nu ne trebuie    

when "0100" =>RegDst <= '0';  		   --memory lw sw
				  RegWrite <= '0';
				  AluSrcA <= '1';
				  MemRead<='0';
				  MemWrite <= '0';
				  MemtoReg <= '0'; 	
				  IorD<='0';
				  IrWrite<='0';
				  pcWrite<='0';	 
				  pcWriteAux<='0';
				  ExtOpAux<='0';
				ExtOp<= '0';
				 AluOpAux <= "00";
				  AluSrcB <="010";	
				  PcSource<="00";--nu ne trebuie		   

when "0101" =>  RegDst <= '0';  -- load word
                                    RegWrite <= '0';
                                    AluSrcA <= '0';
                                    MemRead<='1';
                                    MemWrite <= '0';
                                    MemtoReg <= '0';     
                                    IorD <= '1';
                                    IrWrite<='0';
                                    pcWritE<='0'; 
									pcWriteAux<='0';
									ExtOpAux<='0';
                                  ExtOp<= '0';
                                   AluOpAux <= "00";
                                    AluSrcB <="000";    
                                    PcSource<="00";--nu ne trebuie         

when "0110" => RegDst <= '0';  --wb load
                                                      RegWrite <= '1';
                                                      AluSrcA <= '0';
                                                      MemRead<='0';
                                                      MemWrite <= '0';
                                                      MemtoReg <= '1';     
                                                      IorD<='0';
                                                      IrWrite<='0';
                                                      pcWrite<='0';
													  pcWriteAux<='0';
                                                    ExtOp<= '0';	 
													ExtOpAux<='0';
                                                     AluOpAux <= "00";
                                                      AluSrcB <="001";    
                                                      PcSource<="00";--nu ne trebuie        

when "0111" =>RegDst <= '0';  --sw
                                                                        RegWrite <= '0';
                                                                        AluSrcA <= '0';
                                                                        MemRead<='0';
                                                                        MemWrite <= '1';
                                                                        MemtoReg <= '0';     
                                                                        IorD<='1';
                                                                        IrWrite<='0';
                                                                        pcWrite<='1'; 
																		pcWriteAux<='1';
                                                                      ExtOp<= '0';	 
																	  ExtOpAux<='1';
                                                                       AluOpAux <= "00";
                                                                        AluSrcB <="001";    
                                                                        PcSource<="00";--nu ne trebuie        
when others => null;
end case;
AluOp <=AluOpAux;
--PCWrite<=pcWriteAux;
--ExtOp <=ExtOpAux;
end process;
PC_en <= pcWriteAux OR ExtOpAux;
end Behavioral;
