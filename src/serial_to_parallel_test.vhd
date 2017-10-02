--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:13:24 09/26/2017
-- Design Name:   
-- Module Name:   /home/yrid/Programing/fpga/sigasiWorkspace/sata-fpga/src/serial_to_parallel_test.vhd
-- Project Name:  sata-fpga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: serial_to_parallel
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY serial_to_parallel_test IS
END serial_to_parallel_test;
 
ARCHITECTURE behavior OF serial_to_parallel_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT serial_to_parallel
    PORT(
         fast_clk : IN  std_logic;
         slow_clk : IN  std_logic;
         data_i_fast : IN  std_logic_vector(7 downto 0);
         is_k_i_fast : IN  std_logic;
         rx_elec_idle_i_fast : IN  std_logic;
         rx_byte_is_aligned_i_fast : IN  std_logic;
         comm_init_detect_i_fast : IN  std_logic;
         comm_wake_detect_i_fast : IN  std_logic;
         data_o_slow : OUT  std_logic_vector(31 downto 0);
         is_k_o_slow : OUT  std_logic_vector(3 downto 0);
         rx_elec_idle_o_slow : OUT  std_logic;
         rx_byte_is_aligned_o_slow : OUT  std_logic;
         comm_init_detect_o_slow : OUT  std_logic;
         comm_wake_detect_o_slow : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal fast_clk : std_logic := '0';
   signal slow_clk : std_logic := '0';
   signal data_i_fast : std_logic_vector(7 downto 0) := (others => '0');
   signal is_k_i_fast : std_logic := '0';
   signal rx_elec_idle_i_fast : std_logic := '0';
   signal rx_byte_is_aligned_i_fast : std_logic := '0';
   signal comm_init_detect_i_fast : std_logic := '0';
   signal comm_wake_detect_i_fast : std_logic := '0';

     --Outputs
   signal data_o_slow : std_logic_vector(31 downto 0);
   signal is_k_o_slow : std_logic_vector(3 downto 0);
   signal rx_elec_idle_o_slow : std_logic;
   signal rx_byte_is_aligned_o_slow : std_logic;
   signal comm_init_detect_o_slow : std_logic;
   signal comm_wake_detect_o_slow : std_logic;

   -- Clock period definitions
   constant fast_clk_period : time := 10 ns;
   constant slow_clk_period : time := 40 ns;
 
BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
    uut: serial_to_parallel PORT MAP (
          fast_clk => fast_clk,
          slow_clk => slow_clk,
          data_i_fast => data_i_fast,
          is_k_i_fast => is_k_i_fast,
          rx_elec_idle_i_fast => rx_elec_idle_i_fast,
          rx_byte_is_aligned_i_fast => rx_byte_is_aligned_i_fast,
          comm_init_detect_i_fast => comm_init_detect_i_fast,
          comm_wake_detect_i_fast => comm_wake_detect_i_fast,
          data_o_slow => data_o_slow,
          is_k_o_slow => is_k_o_slow,
          rx_elec_idle_o_slow => rx_elec_idle_o_slow,
          rx_byte_is_aligned_o_slow => rx_byte_is_aligned_o_slow,
          comm_init_detect_o_slow => comm_init_detect_o_slow,
          comm_wake_detect_o_slow => comm_wake_detect_o_slow
        );

    -- Clock process definitions
    fast_clk_process :process
    begin
        fast_clk <= '0';
        wait for fast_clk_period/2;
        fast_clk <= '1';
        wait for fast_clk_period/2;
    end process;
 
    slow_clk_process :process
    begin
        slow_clk <= '0';
        wait for slow_clk_period/2;
        slow_clk <= '1';
        wait for slow_clk_period/2;
    end process;
 

    -- Stimulus process
    stim_proc: process
    begin
        data_i_fast <= x"AA";
        wait for fast_clk_period;
        data_i_fast <= x"BB";
        wait for fast_clk_period;
        data_i_fast <= x"CC";
        wait for fast_clk_period;
        data_i_fast <= x"DD";
        wait for fast_clk_period;
        data_i_fast <= x"EE";
        wait for fast_clk_period;
        data_i_fast <= x"FF";
        wait for fast_clk_period;
        data_i_fast <= x"BC";
        is_k_i_fast <= '1';
        rx_byte_is_aligned_i_fast <= '1';
        wait for fast_clk_period;
        data_i_fast <= x"4A";
        is_k_i_fast <= '0';
        wait for fast_clk_period;
        data_i_fast <= x"4A";
        is_k_i_fast <= '0';
        wait for fast_clk_period;
        data_i_fast <= x"7B";
        is_k_i_fast <= '0';
        wait for fast_clk_period;
        data_i_fast <= x"11";
        is_k_i_fast <= '0';
        wait for fast_clk_period;
        data_i_fast <= x"22";
        is_k_i_fast <= '0';
        wait for fast_clk_period;
        data_i_fast <= x"33";
        is_k_i_fast <= '0';
        wait for fast_clk_period;
        data_i_fast <= x"44";
        is_k_i_fast <= '0';


        wait for fast_clk_period;
        data_i_fast <= x"12";
        is_k_i_fast <= '0';
        wait for fast_clk_period;
        data_i_fast <= x"34";
        is_k_i_fast <= '0';
        wait for fast_clk_period;
        data_i_fast <= x"56";
        is_k_i_fast <= '0';
        wait for fast_clk_period;
        data_i_fast <= x"78";
        is_k_i_fast <= '0';

        wait for fast_clk_period*5;

        wait;
    end process;

END;
