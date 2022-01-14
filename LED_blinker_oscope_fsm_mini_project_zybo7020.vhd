library Ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Library UNISIM;
use UNISIM.vcomponents.all;
 
entity led_blinker_oscope_fsm_mini_project_zybo7020 is
  port (
    sys_clk_1        : in  std_logic;
    i_switch_1     : in  std_logic;
    i_reset        : in  std_logic; -- all clocked processes need reset signal
    o_led_drive_1  : out std_logic;
    o_header_drive_1 : out std_logic
    );
end led_blinker_oscope_fsm_mini_project_zybo7020;
 
architecture rtl of led_blinker_oscope_fsm_mini_project_zybo7020 is

--component clk_wiz_0
--port
-- (-- Clock in ports
--  -- Clock out ports
--  new_sys_clk_1          : out    std_logic;
--  -- Status and control signals
--  reset             : in     std_logic;
--  locked            : out    std_logic;
--  sys_clk_1           : in     std_logic
-- );
--end component;
 
  -- Constants to create the frequencies needed:
  -- Formula is: (50 MHz / 4 Hz * 50% duty cycle)
  -- So for 4 Hz: 100,000,000 / 4 * 0.5 = 12,500,000
  -- So for 2 Hz: 100,000,000 / 2 * 0.5 = 25,000,000
  constant c_CNT_4HZ : natural := 12500000; --15625000; --8681; --17361; --1250000;
  constant c_CNT_2HZ : natural := 25000000; --31250000; --17361; --34722; --2500000;
 
  -- These signals will be the counters:
  signal r_CNT_4HZ : unsigned(31 downto 0);
  signal r_CNT_2HZ : unsigned(31 downto 0);
  -- signal r_CNT_4HZ : natural range 0 to c_CNT_4HZ;
  -- signal r_CNT_2HZ : natural range 0 to c_CNT_2HZ;

  -- These signals will toggle at the frequencies needed:
  signal r_TOGGLE_4HZ : std_logic := '0';
  signal r_TOGGLE_2HZ : std_logic := '0';
  --attribute mark_debug : string;
  --attribute mark_debug of r_TOGGLE_4HZ : signal is "true";
  --attribute mark_debug of r_TOGGLE_2HZ : signal is "true";

 
  -- One bit select wire.
  signal w_LED_SELECT : std_logic;
  
  -- Enumerated type declaration and state declaration
  type freq_State is (DRIVE_2HZ, DRIVE_4HZ);
  signal state : freq_State;
  
  -- system clock
  signal new_sys_clk_1: std_logic;
  signal reset: std_logic;
  signal locked: std_logic;
  
begin
  
--clk_wiz_instance : clk_wiz_0
--   port map ( 
--  -- Clock out ports  
--   sys_clk_1 => sys_clk_1,
--  -- Status and control signals                
--   reset => reset,
--   locked => locked, --during initial clock booting, locked = '0' for a few nanoseconds till clock is stable and realiable for use and locked = '1'
--   -- Clock in ports
--   sys_clk_1 => sys_clk_1
-- );
  
  -- MAIN CODE
 
  -- Finite State Machine process
  process(sys_clk_1) is
  begin
    if rising_edge(sys_clk_1) then
      if i_reset = '1' then --or locked = '0' then
        -- Reset values
        r_CNT_4HZ <= (others => '0');
        r_CNT_2HZ <= (others => '0');
        r_TOGGLE_4HZ <= '0';
        r_TOGGLE_2HZ <= '0';
      else
        if i_switch_1 = '0' then
          state <= DRIVE_2HZ;
        else
          state <= DRIVE_4HZ;
        end if;
        
        -- Below states toggle a specific signal at a different frequency.
        case state is
        
          -- when i_switch is 1
          when DRIVE_4HZ =>
            if r_CNT_4HZ = c_CNT_4HZ-1 then  -- -1, since counter starts at 0
              r_TOGGLE_4HZ <= not r_TOGGLE_4HZ;
              r_CNT_4HZ    <= (others => '0');
            else
              r_CNT_4HZ <= r_CNT_4HZ + 1;
            end if;
            
          -- when i_switch is 0
          when DRIVE_2HZ =>
            if r_CNT_2HZ = c_CNT_2HZ-1 then  -- -1, since counter starts at 0
              r_TOGGLE_2HZ <= not r_TOGGLE_2HZ;
              r_CNT_2HZ    <= (others => '0');
            else
              r_CNT_2HZ <= r_CNT_2HZ + 1;
            end if;
        end case;
      end if;
    end if;
  end process;
  
  -- Create a multiplexor based on switch inputs
  w_LED_SELECT <= r_TOGGLE_4HZ when (i_switch_1 = '1') else
                  r_TOGGLE_2HZ;
 
   
  -- Allow o_led_drive & o_header_drive to drive according to w_LED_SELECT
  o_led_drive_1 <= w_LED_SELECT;
  o_header_drive_1 <= w_LED_SELECT;
 
end rtl;
