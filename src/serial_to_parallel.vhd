library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity serial_to_parallel is
    Port ( fast_clk : in  STD_LOGIC;
           slow_clk : in  STD_LOGIC;
           data_i_fast : in  STD_LOGIC_VECTOR(7 downto 0);
           is_k_i_fast : in  STD_LOGIC;

           rx_byte_is_aligned_i_fast : in STD_LOGIC;
           rx_byte_is_aligned_o_slow : out STD_LOGIC;

           data_o_slow : out  STD_LOGIC_VECTOR(31 downto 0);
           is_k_o_slow : out  STD_LOGIC_VECTOR(3 downto 0);

            -- TODO: handle these elsewhere
           rx_elec_idle_i_fast : in STD_LOGIC;
           comm_init_detect_i_fast : in STD_LOGIC;
           comm_wake_detect_i_fast : in STD_LOGIC;
           rx_elec_idle_o_slow : out STD_LOGIC;
           comm_init_detect_o_slow : out STD_LOGIC;
           comm_wake_detect_o_slow : out STD_LOGIC
    );
end serial_to_parallel;

-- TODO, FIXME: Connect all signal form entity declaration!!!
architecture Behavioral of serial_to_parallel is

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

    signal tmpDataOut: std_logic_vector(31 downto 0) := (others => '0');
    signal tmpIsKOut: std_logic_vector(3 downto 0) := (others => '0');
    -- Buffer needs to hold up to 7 bytes to compensate different clock
    -- domains.
    signal tmpData: std_logic_vector(55 downto 0) := (others => '0');
    signal tmpIsK: std_logic_vector(6 downto 0) := (others => '0');

    signal positiveEdge: std_logic;
    signal index: std_logic_vector(1 downto 0);

    -- Looks like only three values will be needed to time correctly next
    -- positive edge on the slow clock.
    signal clkPositiveEdgeCounter: std_logic_vector(1 downto 0);

    signal rx_elec_idle_s: std_logic := 0;
    signal rx_elec_idle_s: std_logic := 0;
    signal rx_byte_is_aligned_s: std_logic := 0;
    signal comm_init_detect_s: std_logic := 0;
    signal comm_wake_detect_s: std_logic := 0;
begin

    Inst_edge_detector: edge_detector PORT MAP(
        clk => fast_clk,
        ce_i => '1',
        in_i => slow_clk,
        positive_o => positiveEdge,
        negative_o => open,
        edge_o => open
    );

    process (fast_clk)
        variable indexRange: integer range 0 to 3;
    begin
        if rising_edge(fast_clk) then
            rx_elec_idle_o_slow <= rx_elec_idle_s
            rx_byte_is_aligned_o_slow <= rx_byte_is_aligned_s
            comm_init_detect_o_slow <= comm_init_detect_s
            comm_wake_detect_o_slow <= comm_wake_detect_s

            if positiveEdge = '1' then
                clkPositiveEdgeCounter <= std_logic_vector(
                    to_unsigned(1, clkPositiveEdgeCounter'length));
                data_o_slow <= tmpDataOut;
                is_k_o_slow <= tmpIsKOut;

            -- Test if we should put data out. Number 2 means we are one clock
            -- from the next positive edge of slow clock. So here we need to
            -- put our data out.
            elsif unsigned(clkPositiveEdgeCounter) = 2 then
                indexRange := to_integer(unsigned(index));
                case indexRange is
                    when 0 =>
                        data_o_slow(31 downto 24) <= data_i_fast;
                        tmpDataOut(31 downto 24) <= data_i_fast;
                        data_o_slow(23 downto 0) <= tmpData(55 downto 32);
                        tmpDataOut(23 downto 0) <= tmpData(55 downto 32);

                        is_k_o_slow(3) <= is_k_i_fast;
                        tmpIsKOut(3) <= is_k_i_fast;
                        is_k_o_slow(2 downto 0) <= tmpIsK(6 downto 4);
                        tmpIsKOut(2 downto 0) <= tmpIsK(6 downto 4);
                    when 1 =>
                        data_o_slow(31 downto 0) <= tmpData(55 downto 24);
                        tmpDataOut(31 downto 0) <= tmpData(55 downto 24);
                        is_k_o_slow(3 downto 0) <= tmpIsK(6 downto 3);
                        tmpIsKOut(3 downto 0) <= tmpIsK(6 downto 3);
                    when 2 =>
                        data_o_slow(31 downto 0) <= tmpData(47 downto 16);
                        tmpDataOut(31 downto 0) <= tmpData(47 downto 16);
                        is_k_o_slow(3 downto 0) <= tmpIsK(5 downto 2);
                        tmpIsKOut(3 downto 0) <= tmpIsK(5 downto 2);
                    when 3 =>
                        data_o_slow(31 downto 0) <= tmpData(39 downto 8);
                        tmpDataOut(31 downto 0) <= tmpData(39 downto 8);
                        is_k_o_slow(3 downto 0) <= tmpIsK(4 downto 1);
                        tmpIsKOut(3 downto 0) <= tmpIsK(4 downto 1);
                end case;

                clkPositiveEdgeCounter <=
                    std_logic_vector(unsigned(clkPositiveEdgeCounter) + 1);


                rx_elec_idle_s <= rx_elec_idle_s
                rx_byte_is_aligned_s <= rx_byte_is_aligned_s
                comm_init_detect_o_slow <= comm_init_detect_s
                comm_wake_detect_o_slow <= comm_wake_detect_s
            else
                clkPositiveEdgeCounter <=
                    std_logic_vector(unsigned(clkPositiveEdgeCounter) + 1);
                data_o_slow <= tmpDataOut;
                is_k_o_slow <= tmpIsKOut;
            end if;
            -- Check if ALIGNp character was received and if so, set correct
            -- index for next data transfer.
            if x"7B" = data_i_fast
                and tmpData(55 downto 32) = x"4A4ABC"
                and is_k_i_fast = '0'
                and tmpIsK(6 downto 4) = "001"
            then
                index <= std_logic_vector(unsigned(clkPositiveEdgeCounter) + 2);
            end if;

            tmpData(47 downto 0) <= tmpData(55 downto 8);
            tmpData(55 downto 48) <= data_i_fast;
            tmpIsK(5 downto 0) <= tmpIsK(6 downto 1);
            tmpIsK(6) <= is_k_i_fast;

        end if;
    end process;


end Behavioral;

