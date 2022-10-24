library ieee;
use ieee.std_logic_1164.all;


entity shiftRegister is                                  
	port	(
				serialInput: in std_logic;							
				inputClk: in std_logic;
				reset: in std_logic;
				parallelOutput: out std_logic_vector(3 downto 0);
				parallelOutputExtraBit: out std_logic
			);
			
end shiftRegister;

architecture Behavioral of shiftRegister is
	signal outputBuffer: std_logic_vector(3 downto 0) := (others=>'0');
	signal outputBufferExtraBit: std_logic := '0';
	
begin
	
	process(reset,inputClk, serialInput)
	begin
	
		if (reset='1') then
			outputBuffer <= "0000";
			outputBufferExtraBit <= '0';
			
			
		elsif (inputClk'event and inputClk='1') then
			outputBuffer(3) <= serialInput;
			outputBufferExtraBit <= outputBuffer(0);
			outputBuffer(2 downto 0) <= outputBuffer(3 downto 1);	
		end if;
	end process;
	
	
	
	process (outputBuffer, outputBufferExtraBit)
	begin
		parallelOutput <= outputBuffer;
		parallelOutputExtraBit <= outputBufferExtraBit;
	end process;
	
		
end Behavioral;