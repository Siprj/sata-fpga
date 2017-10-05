----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    10:29:51 04/08/2017
-- Design Name:
-- Module Name:    data_write - Behavioral
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


entity data_write is
    Port ( clk : in  STD_LOGIC;
           en : in STD_LOGIC;
           data_in : out  STD_LOGIC_VECTOR (31 downto 0);
           user_din_stb : out  STD_LOGIC;
           user_din_ready : in  STD_LOGIC_VECTOR (1 downto 0);
           user_din_activate : out  STD_LOGIC_VECTOR (1 downto 0);
           user_din_size : in  STD_LOGIC_VECTOR (23 downto 0);
           user_din_empty : in  STD_LOGIC);
end data_write;

architecture Behavioral of data_write is

    signal r_count : std_logic_vector (23 downto 0) := (others => '0');
    signal active : std_logic_vector (1 downto 0) := (others => '0');

begin

    user_din_activate <= active;

    process (clk)
    begin
        -- Reset strobe signals
        if rising_edge(clk) then
            user_din_stb <= '0';
            if en = '1' then
                if unsigned(user_din_ready) > 0
                and unsigned(active) = 0 then
                    r_count <=  std_logic_vector(to_unsigned(0, r_count'length));
                    if (user_din_ready(0) = '1') then
                        -- Channel 0 is open
                        active(0) <=  '1';
                    else
                        -- Channel 1 is open
                        active(1) <=  '1';
                    end if;
                else
                    if unsigned(r_count) < unsigned(user_din_size) then
                        -- More room left in the buffer
                        r_count <= std_logic_vector(unsigned(r_count) + 1);
                        user_din_stb <= '1';
                        -- put the count in the data
                        data_in(23 downto 0) <= r_count;
                        data_in(31 downto 24) <= (others => '0');
                    else
                      -- Filled up the buffer, release it
                      active <=  "00";
                    end if;
                end if;
          end if;
        end if;
    end process;

end Behavioral;
