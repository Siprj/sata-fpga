----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    20:05:12 09/16/2017
-- Design Name:
-- Module Name:    parallel_to_serial - Behavioral
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

entity parallel_to_serial is
    Port ( fast_clk : in  STD_LOGIC;
           slow_clk : in  STD_LOGIC;
           in_data_i_slow : in  STD_LOGIC_VECTOR(31 downto 0);
           in_is_k_i_slow : in STD_LOGIC;
           out_is_k_i_fast : out STD_LOGIC;
           out_data_o_fast : out  STD_LOGIC_VECTOR(7 downto 0)
   );
end parallel_to_serial;

architecture Behavioral of parallel_to_serial is
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

    -- Temporary register to store data which need to be serialized.
    -- It's only 24 bit long because first 8 bits is send directly to output.
    signal tmpData: std_logic_vector(23 downto 0) := (others => '0');
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

     process (fast_clk)
     begin
         if rising_edge(fast_clk) then
             if positive_edge = '1' then
                 out_is_k_i_fast <= in_is_k_i_slow;
                 out_data_o_fast <= in_data_i_slow(7 downto 0);
                 tmpData <= in_data_i_slow(31 downto 8);
             else
                 out_data_o_fast <= tmpData(7 downto 0);
                 tmpData(15 downto 0) <= tmpData(23 downto 8);
                 -- Only first byte can be a K character
                 out_is_k_i_fast <= '0';
             end if;
         end if;
     end process;

end Behavioral;

