library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DACControlModule is
	port (
			Clk: in std_logic;
			nRst: in std_logic;
			DAC_I_sig: in std_logic_vector(9 downto 0); --sinphase component of moduled harmonic signal
			DAC_Q_sig: in std_logic_vector(9 downto 0); --quadrature component of moduled harmonic signal
			
			Rst_For_DAC: in std_logic; --reset only for DAC
			Power_Down: in std_logic; --Turn off DAC.If DAC_Rst=1 during 4 clocks of DAC_Clk, DAC circuit turns off
			
			
			DAC_Clk: out std_logic;
			DAC_Rst: out std_logic;	
			DAC_Write: out std_logic;
			DAC_Select: out std_logic;
			DAC_Data: out std_logic_vector(9 downto 0)
		  );
end DACControlModule;


architecture Behavioral of DACControlModule is
	signal ClkReduceFreq_count: std_logic := '0';
	signal IComponentGot: std_logic := '0';
	signal DAC_Write_Buf: std_logic := '0';
	signal DAC_Rst_buf: std_logic := '0';
	signal DAC_Rst_count: std_logic_vector(2 downto 0) := (others=>'0');
	
	
begin
	
	process(ClkReduceFreq_count,DAC_Rst_buf)
	begin
		if (rising_edge(ClkReduceFreq_count)) then
			if (DAC_Rst_buf='1') then
				DAC_Rst_count <= DAC_Rst_count + 1;
			elsif (DAC_Rst_buf='0' and DAC_Rst_count < "100") then
				DAC_Rst_Count <= "000";
			end if;
		end if;
	end process;
	
	
	
	
	process(Clk,nRst)  -- 80 MHz -> 40 MHz
	begin
	
		if (nRst='0') then
			DAC_Rst_buf <= '1';	
			DAC_Write_buf <= '0';
			DAC_Data <= "0000000000";
			DAC_Select <= '0';
			ClkReduceFreq_count <= '0';
			IComponentGot <= '0';
			
		elsif (Power_Down='1' or DAC_Rst_count >= "100" or Rst_For_DAC='1') then
			DAC_Rst_buf <= '1';
			DAC_Write_buf <= '0';
			DAC_Data <= "0000000000";
			DAC_Select <= '0';
			ClkReduceFreq_count <= '0';
		
		elsif (rising_edge(Clk)) then
				ClkReduceFreq_count <= not ClkReduceFreq_count;
				IComponentGot <= not IComponentGot;
				DAC_Write_buf <= not DAC_Write_buf;
	
		elsif (falling_edge(Clk)) then
				if (DAC_Q_sig="0000000000" or IComponentGot='0') then
					DAC_Select <= '1';  --route to I DAC
					DAC_Data <= DAC_I_sig;
				
				elsif (IComponentGot='1') then
						DAC_Select <= '0';
						DAC_Data <= DAC_Q_sig;
				end if;
				
			
		end if;
	end process;
	
	
	
	DAC_signals_assignment : process(ClkReduceFreq_count)
	begin
		DAC_Clk <= ClkReduceFreq_count;
		DAC_Rst <= DAC_Rst_buf;
		DAC_Write <= DAC_Write_Buf;
	end process;
	
	
	
end Behavioral;