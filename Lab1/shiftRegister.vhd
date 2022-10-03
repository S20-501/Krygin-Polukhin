library ieee;
use ieee.std_logic_1164.all;

entity shiftRegister is                                  --shifts both left and right 1 bit
	port	(serialInput: in std_logic;							
			clk: in std_logic;
			shiftRight: in std_logic;								--direction of shift: '0'-left, '1'-right
			clr: in std_logic;
			parallelOutput: inout std_logic_vector(3 downto 0));
end shiftRegister;

architecture Behavioral of shiftRegister is
begin
	process(clk,clr)
	begin
		if clr='1' then
			parallelOutput<="0000";
			
		elsif (clk'event and clk='1' and shiftRight='1') then
			parallelOutput(3)<=serialInput;
			parallelOutput(2 downto 0)<=parallelOutput(3 downto 1);
			
		elsif (clk'event and clk='1' and shiftRight='0') then
			parallelOutput(0)<=serialInput;
			parallelOutput(3 downto 1)<=parallelOutput(2 downto 0);
		end if;
	end process;
end Behavioral;