library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity design_top is
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
end design_top;

architecture behave of design_top is

component clk_wiz_0                          
port                                         
 (-- Clock in ports                          
  -- Clock out ports                         
  sys_clk_og          : out    std_logic; 
  -- Status and control signals              
  reset             : in     std_logic;      
  locked            : out    std_logic;      
  sys_clk_in           : in     std_logic     
 );                                          
end component;                               

    -- Component declaration for the Unit Under Test (UUT)
    component led_blinker_oscope_fsm_mini_project_zybo7020 is
      port (
        sys_clk_1       : in  std_logic;
        i_reset       : in  std_logic;
        i_switch_1    : in  std_logic;
        o_led_drive_1 : out std_logic;
        o_header_drive_1 : out std_logic
        );
    end component led_blinker_oscope_fsm_mini_project_zybo7020;
    
    -- Component declaration for the Unit Under Test (UUT2)
    component led_blinker_oscope_mini_project_zybo7020 is
      port (
        sys_clk_2        : in  std_logic;
        i_reset        : in  std_logic;
        i_switch_2     : in  std_logic;
        o_led_drive_2  : out std_logic;
        o_header_drive_2 : out std_logic
        );
    end component led_blinker_oscope_mini_project_zybo7020;
    
    signal sys_clk_1 : std_logic;
    signal locked : std_logic;
    
begin

clk_wiz_instance : clk_wiz_0                                                                                                                       
   port map (                                                                                                                                      
  -- Clock out ports                                                                                                                               
   sys_clk_og => sys_clk_1,      -- sys_clk_og reprents the output clock which is actually in real-life sys_clk_1                                                                                                            
  -- Status and control signals                                                                                                                    
   reset => reset,                                                                                                                                 
   locked => locked, --during initial clock booting, locked = '0' for a few nanoseconds till clock is stable and realiable for use and locked = '1'
   -- Clock in ports                                                                                                                               
   sys_clk_in => SYS_CLK_OG  -- sys_clk_in represents the input clock which is actually in real-life SYS_CLK_OG                                                                                                               
 );                                                                                                                                                

  -- Instantiate the Unit Under Test (UUT)
  UUT : led_blinker_oscope_fsm_mini_project_zybo7020
    port map (
      sys_clk_1     => sys_clk_1,
      i_reset       => RESET,
      i_switch_1    => SWITCH_1,
      o_led_drive_1 => LED_DRIVE_1,
      o_header_drive_1 => o_HEADER_DRIVE_1
      );
      
  -- Instantiate the Unit Under Test (UUT2)
  UUT2 : led_blinker_oscope_mini_project_zybo7020
    port map (
      sys_clk_2     => sys_clk_1,
      i_reset       => RESET,
      i_switch_2    => SWITCH_2,
      o_led_drive_2 => LED_DRIVE_2,
      o_header_drive_2 => o_HEADER_DRIVE_2
      ); 
	  
  -- Instead of component declaration and instantiation of the led_blinker files, you can instantiate directly without declaring using
  -- No component declaration required, but you do need the signals declared or coming into the design as input/output still
  -- - Instantiate the Unit Under Test (UUT)
  -- 
  -- UUT :  entity work.led_blinker_oscope_fsm_mini_project_zybo7020
  -- 
  -- port map (
  -- 
  -- sys_clk_1 => sys_clk_1,
  -- 
  -- i_reset => RESET,
  -- 
  -- i_switch_1 => SWITCH_1,
  -- 
  -- o_led_drive_1 => LED_DRIVE_1,
  -- 
  -- o_header_drive_1 => o_HEADER_DRIVE_1
  -- 
  -- );

end behave;















