library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detector is
    Port ( clk : in STD_LOGIC;
           ce_i : in STD_LOGIC;
           in_i : in  STD_LOGIC;
           positive_o : out  STD_LOGIC;
           negative_o : out  STD_LOGIC;
           edge_o : out STD_LOGIC
    );
end edge_detector;

architecture Behavioral of edge_detector is

    signal tmp: std_logic := '0';

begin

    process (clk)
    begin
        if rising_edge(clk) then
            if ce_i = '1' then
                edge_o <= '0';
                positive_o <= '0';
                negative_o <= '0';
                if tmp /= in_i then
                    if in_i = '1' then
                        positive_o <= '1';
                        negative_o <= '0';
                    else
                        positive_o <= '0';
                        negative_o <= '1';
                    end if;
                    edge_o <= '1';
                end if;
                tmp <= in_i;
            end if;
        end if;
    end process;

end Behavioral;
