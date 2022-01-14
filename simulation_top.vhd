library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity simulation_top is
end simulation_top;
 
architecture behave of simulation_top is
 
  -- 100 MHz = 10 nanoseconds period
  constant c_CLOCK_PERIOD : time := 10 ns; 
 
  signal r_SYS_CLK     : std_logic := '0';
  signal r_RESET       : std_logic := '0';
  signal r_SWITCH_1    : std_logic := '0';
  signal r_SWITCH_2     : std_logic := '0';
  signal w_LED_DRIVE_1   : std_logic; 
  signal w_LED_DRIVE_2   : std_logic; 
  signal o_HEADER_DRIVE_1 : std_logic;
  signal o_HEADER_DRIVE_2 : std_logic;
 
  -- Component declaration for the Unit Under Test (UUT)
  component design_top is
    port (
      SYS_CLK_OG  : in std_logic;
      RESET       : in std_logic;
      SWITCH_1    : in std_logic := '0';
      SWITCH_2    : in std_logic := '0';
      LED_DRIVE_1 : out std_logic; 
      LED_DRIVE_2 : out std_logic;
      o_HEADER_DRIVE_1 : out std_logic;
      o_HEADER_DRIVE_2 : out std_logic
      );
  end component design_top;
  
begin
 
  -- Instantiate the Unit Under Test (UUT)
  UUT : design_top
    port map (
      SYS_CLK_OG  => r_SYS_CLK,
      RESET       => r_RESET,
      SWITCH_1    => r_SWITCH_1,
      SWITCH_2    => r_SWITCH_2,
      LED_DRIVE_1 => w_LED_DRIVE_1,
      LED_DRIVE_2 => w_LED_DRIVE_2,
      o_HEADER_DRIVE_1 => o_HEADER_DRIVE_1,
      o_HEADER_DRIVE_2 => o_HEADER_DRIVE_2
      );
 
  p_CLK_GEN : process is
  begin
    wait for c_CLOCK_PERIOD/2;
    r_SYS_CLK <= not r_SYS_CLK;
  end process p_CLK_GEN; 
   
  process                               -- main testing
  begin
  -- Run for 3.75 seconds (because clock freq is so high, just simulate one part from below at at time)
  
    --r_RESET <= '0';
    wait for 100ns; -- wait for new_sys_clk to be stable (locked = '1')
    
    -- test 2HZ frequency signal
    r_SWITCH_1 <= '0';
    r_SWITCH_2 <= '0';
    wait for 1 sec;
 
    -- test 4HZ frequency signal
    r_SWITCH_1 <= '1';
    r_SWITCH_2 <= '1';
    wait for 1 sec;
    
    -- test RESET switch
    r_SWITCH_1 <= '0';
    r_SWITCH_2 <= '0';
    wait for 0.75 sec;
    r_RESET <= '1';
    wait for 0.01 sec;
    r_RESET <= '0';
    wait for 1 sec;

  end process;

end behave;
