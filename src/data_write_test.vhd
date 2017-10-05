--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   21:03:16 10/05/2017
-- Design Name:
-- Module Name:   /home/yrid/Programing/fpga/sigasiWorkspace/sata-fpga/src/data_write_test.vhd
-- Project Name:  sata-fpga
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: data_write
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
USE ieee.numeric_std.ALL;


ENTITY data_write_test IS
END data_write_test;

ARCHITECTURE behavior OF data_write_test IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT data_write
    PORT(
         clk : IN  std_logic;
         en : IN  std_logic;
         data_in : OUT  std_logic_vector(31 downto 0);
         user_din_stb : OUT  std_logic;
         user_din_ready : IN  std_logic_vector(1 downto 0);
         user_din_activate : OUT  std_logic_vector(1 downto 0);
         user_din_size : IN  std_logic_vector(23 downto 0);
         user_din_empty : IN  std_logic
        );
    END COMPONENT;


    --Inputs
    signal clk : std_logic := '0';
    signal en : std_logic := '0';
    signal user_din_ready : std_logic_vector(1 downto 0) := (others => '0');
    signal user_din_size : std_logic_vector(23 downto 0) := (others => '0');
    signal user_din_empty : std_logic := '0';

    --Outputs
    signal data_in : std_logic_vector(31 downto 0);
    signal user_din_stb : std_logic;
    signal user_din_activate : std_logic_vector(1 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: data_write PORT MAP (
        clk => clk,
        en => en,
        data_in => data_in,
        user_din_stb => user_din_stb,
        user_din_ready => user_din_ready,
        user_din_activate => user_din_activate,
        user_din_size => user_din_size,
        user_din_empty => user_din_empty
    );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;


    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;

        user_din_ready <= "01";
        en <= '1';
        user_din_size <= std_logic_vector(to_unsigned(2048, user_din_size'length));
        wait for clk_period*100;

        -- insert stimulus here

        wait;
    end process;

END;
