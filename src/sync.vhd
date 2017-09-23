library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sync is
    Port ( in_i_clk_fast: in STD_LOGIC_VECTOR(7 downto 0);
           rst_i_clk_fast: in STD_LOGIC;
           start_i_clk_fast: in STD_LOGIC;
           out_o_clk_slow: out STD_LOGIC_VECTOR(31 downto 0);
           fast_clk: in STD_LOGIC;
           slow_clk: in STD_LOGIC;
           initial_data: in STD_LOGIC_VECTOR(31 downto 0));
end sync;

architecture Behavioral of sync is
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

    signal buffer1: std_logic_vector(31 downto 0) := (others => '0');
    signal buffer2: std_logic_vector(31 downto 0) := (others => '0');
    signal writeBuffer: std_logic := '0';
    signal showBuffer: std_logic := '0';
    signal counter: std_logic_vector(1 downto 0) := (others => '0');
    signal positiveEdge: std_logic := '0';
    signal initialState: std_logic := '0';
    signal outputDefault: std_logic := '1';

begin
    -- Double buffering is here to enable us get the full data even if they
    -- starts arrive in the middle of slow clock.
    -- Initial data are here for the seam reason when we starts to receive data
    -- in the middle of slow clock we can't have full data ready after the
    -- clock so we give away the initial data in this case.
    process (fast_clk)
    begin
        if start_i_clk_fast = '1' then
            buffer1 <= (others => '0');
            buffer0 <= (others => '0');
            -- Currently writing to buffer 0
            writeBuffer <= '0';
            -- Currently showing initial data and after first positive edge
            -- this will show. So this gives as time to fill the
            -- buffer 0.
            showBuffer <= '0';
            counter <= "00";
            initialState <= '1';
            outputDefault <= '0';
        end if;
        if positiveEdge = '1' then
            if initialState = '1' then

            end if;
        end if;

    end process;

    Inst_edge_detector: edge_detector PORT MAP(
        clk => fast_clk,
        ce_i => '1',
        in_i => start_i_clk_fast,
        positive_o => positiveEdge,
        negative_o => open,
        edge_o => open
    );

end Behavioral;

