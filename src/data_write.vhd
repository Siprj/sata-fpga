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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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

    signal r_count : std_logic_vector (23 downto 0) := 0;

begin
    -- Reset strobe signals
    if (rising_edge(clk))
        user_din_stb <= 0;
        if (en) begin
          if ((user_din_ready > 0) && (user_din_activate == 0)) begin
            r_count <=  0;
            if (user_din_ready(0)) begin
              -- Channel 0 is open
              user_din_activate(0) <=  1;
            end
            else begin
              -- Channel 1 is open
              user_din_activate(1) <=  1;
            end
          end
          else begin
            if (r_count < i_wr_size) begin
              -- More room left in the buffer
              r_count <= r_count + 1;
              user_din_stb <= 1;
              -- put the count in the data
              o_wr_data <= r_count;
            end
            else begin
              -- Filled up the buffer, release it
              user_din_activate <=  0;
            end
          end
        end
    end

end Behavioral;
