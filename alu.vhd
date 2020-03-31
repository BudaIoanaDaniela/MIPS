LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
-- use package
USE work.procmem_definitions.ALL;
ENTITY alu IS
PORT (
a, b : IN STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
opcode : IN STD_ULOGIC_VECTOR(2 DOWNTO 0);
result : OUT STD_ULOGIC_VECTOR(width-1 DOWNTO 0);
zero : OUT STD_ULOGIC);
END alu;
ARCHITECTURE behave OF alu IS

BEGIN

 PROCESS(a, b, opcode)
 -- declaration of variables
 VARIABLE a_uns : UNSIGNED(width-1 DOWNTO 0);
 VARIABLE b_uns : UNSIGNED(width-1 DOWNTO 0);
 VARIABLE r_uns : UNSIGNED(width-1 DOWNTO 0);
 VARIABLE z_uns : UNSIGNED(0 DOWNTO 0);

 BEGIN
 -- initialize values
 a_uns := UNSIGNED(a);
 b_uns := UNSIGNED(b);
 r_uns := (OTHERS => '0');
 z_uns(0) := '0';

 -- select desired operation
 CASE opcode IS
 -- add
 WHEN "010" =>
 r_uns := a_uns + b_uns;
 -- sub
 WHEN "110" =>
 r_uns := a_uns - b_uns;
 -- and
 WHEN "000" =>
 r_uns := a_uns AND b_uns;
 -- or
 WHEN "001" =>
 r_uns := a_uns OR b_uns;
 -- slt
 WHEN "111" =>
 r_uns := a_uns - b_uns;
 IF SIGNED(r_uns) < 0 THEN
 r_uns := TO_UNSIGNED(1, r_uns'LENGTH);
 ELSE
 r_uns := (OTHERS => '0');
 END IF;

 -- others
 WHEN OTHERS => r_uns := (OTHERS => 'X');
 END CASE;
 -- set zero bit if result equals zero
 IF TO_INTEGER(r_uns) = 0 THEN
 z_uns(0) := '1';
 ELSE
 z_uns(0) := '0';
 END IF;
 -- assign variables to output signals
 result <= STD_ULOGIC_VECTOR(r_uns);
 zero <= z_uns(0);

 END PROCESS;

END behave;
