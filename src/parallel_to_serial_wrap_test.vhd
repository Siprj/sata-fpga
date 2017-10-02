--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   16:18:10 09/23/2017
-- Design Name:
-- Module Name:   /home/yrid/Programing/fpga/sigasiWorkspace/sata-fpga/src/parallel_to_serial_wrap_test.vhd
-- Project Name:  sata-fpga
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: parallel_to_serila_wrap
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

ENTITY parallel_to_serial_wrap_test IS
END parallel_to_serial_wrap_test;

ARCHITECTURE behavior OF parallel_to_serial_wrap_test IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT parallel_to_serial_wrap
    PORT(
         fast_clk : IN  std_logic;
         slow_clk : IN  std_logic;
         in_data_i_slow : IN  std_logic_vector(31 downto 0);
         in_is_k_i_slow : IN  std_logic;
         out_is_k_i_fast : OUT  std_logic;
         out_data_o_fast : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;


    --Inputs
    signal fast_clk : std_logic := '0';
    signal slow_clk : std_logic := '0';
    signal start_i_fast : std_logic := '0';
    signal in_data_i_slow : std_logic_vector(31 downto 0) := (others => '0');
    signal in_is_k_i_slow : std_logic := '0';

    --Outputs
    signal out_is_k_i_fast : std_logic;
    signal out_data_o_fast : std_logic_vector(7 downto 0);

    -- Clock period definitions
    constant fast_clk_period : time := 10 ns;
    constant slow_clk_period : time := 40 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: parallel_to_serial_wrap PORT MAP (
          fast_clk => fast_clk,
          slow_clk => slow_clk,
          in_data_i_slow => in_data_i_slow,
          in_is_k_i_slow => in_is_k_i_slow,
          out_is_k_i_fast => out_is_k_i_fast,
          out_data_o_fast => out_data_o_fast
        );

    -- Clock process definitions
    fast_clk_process :process
    begin
        fast_clk <= '1';
        wait for fast_clk_period/2;
        fast_clk <= '0';
        wait for fast_clk_period/2;
    end process;

    slow_clk_process :process
    begin
        slow_clk <= '1';
        wait for slow_clk_period/2;
        slow_clk <= '0';
        wait for slow_clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin

        wait for fast_clk_period*4;
        in_data_i_slow <= x"AA990160";
        in_is_k_i_slow <= '0';
        wait for fast_clk_period*4;
        start_i_fast <= '0';
        in_data_i_slow <= x"7B4A4ABC";
        in_is_k_i_slow <= '1';
        wait for fast_clk_period*4;

        wait;
    end process;

END;
