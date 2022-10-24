library ieee;
use ieee.std_logic_1164.all;

entity tb_shiftRegister is
end tb_shiftRegister;

architecture tb of tb_shiftRegister is

    component shiftRegister
        port (serialInput            : in std_logic;
              inputClk               : in std_logic;
              reset                  : in std_logic;
              parallelOutput         : out std_logic_vector (3 downto 0);
              parallelOutputExtraBit : out std_logic);
    end component;

    signal serialInput            : std_logic := '0';
    signal inputClk               : std_logic;
    signal reset                  : std_logic;
    signal parallelOutput         : std_logic_vector (3 downto 0);
    signal parallelOutputExtraBit : std_logic;

    constant TbPeriod : time := 50 ps; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
	 

begin

    dut : shiftRegister
    port map (serialInput            => serialInput,
              inputClk               => inputClk,
              reset                  => reset,
              parallelOutput         => parallelOutput,
              parallelOutputExtraBit => parallelOutputExtraBit);

    
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    inputClk <= TbClock;
	 
	 serialInput <= not serialInput after 33 ps when TbSimEnded /= '1';

    stimuli : process
    begin
       
        reset <= '1';
        wait for 500 ps;
        reset <= '0';
        wait for 500 ps;

        
        wait for 100 * TbPeriod;

        
        TbSimEnded <= '1';
        wait;
    end process;

end tb;



configuration cfg_tb_shiftRegister of tb_shiftRegister is
    for tb
    end for;
end cfg_tb_shiftRegister;