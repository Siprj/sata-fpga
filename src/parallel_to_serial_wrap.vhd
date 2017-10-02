----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    16:14:36 09/23/2017
-- Design Name:
-- Module Name:    parallel_to_serila_wrap - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity parallel_to_serial_wrap is
    Port ( fast_clk : in  STD_LOGIC;
           slow_clk : in  STD_LOGIC;
           in_data_i_slow : in  STD_LOGIC_VECTOR(31 downto 0);
           in_is_k_i_slow : in STD_LOGIC;
           out_is_k_i_fast : out STD_LOGIC;
           out_data_o_fast : out  STD_LOGIC_VECTOR(7 downto 0)
   );
end parallel_to_serial_wrap;

architecture Behavioral of parallel_to_serial_wrap is
    COMPONENT edge_detector
    PORT(
        clk : IN std_logic;
        ce_i : IN std_logic;
        in_i : IN std_logic;
        positive_o : OUT std_logic;
        negative_o : OUT std_logic;
        edge_o : OUT std_logic
        );
    END COMPONENT;

    COMPONENT parallel_to_serial
    PORT(
        fast_clk : IN std_logic;
        slow_clk : IN std_logic;
        start_i_fast : IN std_logic;
        in_data_i_slow : IN std_logic_vector(31 downto 0);
        in_is_k_i_slow : IN std_logic;
        out_is_k_i_fast : OUT std_logic;
        out_data_o_fast : OUT std_logic_vector(7 downto 0)
        );
    END COMPONENT;

    signal positive_edge: std_logic := '0';

begin

    Inst_edge_detector: edge_detector PORT MAP(
        clk => fast_clk,
        ce_i => '1',
        in_i => slow_clk,
        positive_o => positive_edge,
        negative_o => open,
        edge_o => open
    );

    Inst_parallel_to_serial: parallel_to_serial PORT MAP(
        fast_clk => fast_clk,
        slow_clk => slow_clk,
        start_i_fast => positive_edge,
        in_data_i_slow => in_data_i_slow,
        in_is_k_i_slow => in_is_k_i_slow,
        out_is_k_i_fast => out_is_k_i_fast,
        out_data_o_fast => out_data_o_fast
    );

end Behavioral;

