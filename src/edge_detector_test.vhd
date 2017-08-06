LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY edge_detector_test IS
END edge_detector_test;

ARCHITECTURE behavior OF edge_detector_test IS 
    COMPONENT edge_detector
    PORT(
         clk : IN  std_logic;
         ce_i : IN  std_logic;
         in_i : IN  std_logic;
         positive_o : OUT  std_logic;
         negative_o : OUT  std_logic;
         edge_o : OUT  std_logic
        );
    END COMPONENT;

    --Inputs
    signal clk : std_logic := '0';
    signal ce_i : std_logic := '0';
    signal in_i : std_logic := '0';

    --Outputs
    signal positive_o : std_logic;
    signal negative_o : std_logic;
    signal edge_o : std_logic;

    -- Clock period definitions
    constant clk_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: edge_detector PORT MAP (
           clk => clk,
           ce_i => ce_i,
           in_i => in_i,
           positive_o => positive_o,
           negative_o => negative_o,
           edge_o => edge_o
         );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process;


    -- Stimulus process
    stim_proc: process
    begin
        ce_i <= '1';

        wait for clk_period*10;
        in_i <= '1';
        wait for clk_period*2;
        in_i <= '0';
        wait for clk_period*4;
        in_i <= '1';
        wait for clk_period*5;

        wait;
    end process;

END;
