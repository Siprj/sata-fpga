----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    14:11:51 10/08/2017
-- Design Name:
-- Module Name:    handle_reset - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity handle_reset is
    Port ( clk : in  STD_LOGIC;
           rst_o : out  STD_LOGIC
    );
end handle_reset;

architecture Behavioral of handle_reset is
    signal tmp: std_logic_vector(7 downto 0) := (others => '0');
begin
    process (clk)
    begin
        -- Reset strobe signals
        if rising_edge(clk) then
            if unsigned(tmp) = 255 then
                rst_o <= '0';
            else
                tmp <= std_logic_vector(unsigned(tmp) + 1);
                rst_o <= '1';
            end if;
        end if;
    end process;

end Behavioral;
