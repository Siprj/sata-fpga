library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity input_sync is
    Port ( fast_clk : in  STD_LOGIC;
           slow_clk : in  STD_LOGIC;
           data_i_fast : in  STD_LOGIC_VECTOR(7 downto 0);
           is_k_i_fast : in  STD_LOGIC;

           rx_byte_is_aligned_i_fast : in STD_LOGIC;
           rx_byte_is_aligned_o_slow : out STD_LOGIC;

           data_o_slow : out  STD_LOGIC_VECTOR(31 downto 0);
           is_k_o_slow : out  STD_LOGIC_VECTOR(3 downto 0);

           rx_elec_idle_i_fast : in STD_LOGIC;
           comm_init_detect_i_fast : in STD_LOGIC;
           comm_wake_detect_i_fast : in STD_LOGIC;
           tx_oob_complete_i_fast : in STD_LOGIC;
           rx_elec_idle_o_slow : out STD_LOGIC;
           comm_init_detect_o_slow : out STD_LOGIC;
           comm_wake_detect_o_slow : out STD_LOGIC;
           tx_oob_complete_o_slow : out STD_LOGIC
    );
end input_sync;

-- TODO, FIXME: Connect all signal form entity declaration!!!
architecture Behavioral of input_sync is

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
    signal tmpIsAlignedOut: std_logic := '0';
    signal tmpRxElecIdleOut: std_logic := '0';
    signal tmpCommInitDetectOut: std_logic := '0';
	 signal tmpCommWakeDetectOut: std_logic := '0';
    signal tmpTxOobComplete: std_logic := '0';
    signal tmpTxOob: std_logic := '0';
    -- Buffer needs to hold up to 7 bytes to compensate different clock
    -- domains.
    signal tmpData: std_logic_vector(55 downto 0) := (others => '0');
    signal tmpIsK: std_logic_vector(6 downto 0) := (others => '0');
    signal tmpIsAligned: std_logic_vector(6 downto 0) := (others => '0');

    signal positiveEdge: std_logic;
    signal index: std_logic_vector(1 downto 0);

    -- Looks like only three values will be needed to time correctly next
    -- positive edge on the slow clock.
    signal clkPositiveEdgeCounter: std_logic_vector(1 downto 0);

    signal rxElecIdleShouldAssert: std_logic := '0';
    signal commInitDetectShouldAssert: std_logic := '0';
    signal commWakeDetectShouldAssert: std_logic := '0';
    signal txOobCompleteShouldAssert: std_logic := '0';
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

            rx_elec_idle_o_slow <= tmpRxElecIdleOut;
            comm_init_detect_o_slow <= tmpCommInitDetectOut;
            comm_wake_detect_o_slow <= tmpCommWakeDetectOut;
            tx_oob_complete_o_slow <= tmpTxOobComplete;


            if positiveEdge = '1' then
                clkPositiveEdgeCounter <= std_logic_vector(
                    to_unsigned(1, clkPositiveEdgeCounter'length));
                data_o_slow <= tmpDataOut;
                is_k_o_slow <= tmpIsKOut;
                rx_byte_is_aligned_o_slow <= tmpIsAlignedOut;

                if rx_elec_idle_i_fast = '1' then
                    rxElecIdleShouldAssert <= '1';
                end if;

                if comm_init_detect_i_fast = '1' then
                    commInitDetectShouldAssert <= '1';
                end if;

                if comm_wake_detect_i_fast = '1' then
                    commWakeDetectShouldAssert <= '1';
                end if;
                if tx_oob_complete_i_fast  = '1' then
                    txOobCompleteShouldAssert <= '1';
                end if;
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

                        if rx_byte_is_aligned_i_fast = '1'
                            or tmpIsAligned(6 downto 4) > "000" then
                            rx_byte_is_aligned_o_slow <= '1';
                            tmpIsAlignedOut <= '1';
                        else
                            rx_byte_is_aligned_o_slow <= '0';
                            tmpIsAlignedOut <= '0';
                        end if;
                    when 1 =>
                        data_o_slow(31 downto 0) <= tmpData(55 downto 24);
                        tmpDataOut(31 downto 0) <= tmpData(55 downto 24);
                        is_k_o_slow(3 downto 0) <= tmpIsK(6 downto 3);
                        tmpIsKOut(3 downto 0) <= tmpIsK(6 downto 3);

                        if tmpIsAligned(6 downto 3) > "0000" then
                            rx_byte_is_aligned_o_slow <= '1';
                            tmpIsAlignedOut <= '1';
                        else
                            rx_byte_is_aligned_o_slow <= '0';
                            tmpIsAlignedOut <= '0';
                        end if;
                    when 2 =>
                        data_o_slow(31 downto 0) <= tmpData(47 downto 16);
                        tmpDataOut(31 downto 0) <= tmpData(47 downto 16);
                        is_k_o_slow(3 downto 0) <= tmpIsK(5 downto 2);
                        tmpIsKOut(3 downto 0) <= tmpIsK(5 downto 2);

                        if tmpIsAligned(5 downto 2) > "0000" then
                            rx_byte_is_aligned_o_slow <= '1';
                            tmpIsAlignedOut <= '1';
                        else
                            rx_byte_is_aligned_o_slow <= '0';
                            tmpIsAlignedOut <= '0';
                        end if;
                    when 3 =>
                        data_o_slow(31 downto 0) <= tmpData(39 downto 8);
                        tmpDataOut(31 downto 0) <= tmpData(39 downto 8);
                        is_k_o_slow(3 downto 0) <= tmpIsK(4 downto 1);
                        tmpIsKOut(3 downto 0) <= tmpIsK(4 downto 1);

                        if tmpIsAligned(4 downto 1) > "0000" then
                            rx_byte_is_aligned_o_slow <= '1';
                            tmpIsAlignedOut <= '1';
                        else
                            rx_byte_is_aligned_o_slow <= '0';
                            tmpIsAlignedOut <= '0';
                        end if;
                end case;

                clkPositiveEdgeCounter <=
                    std_logic_vector(unsigned(clkPositiveEdgeCounter) + 1);

                -- Handle rxElectIdele, commInit and commWake
                if rxElecIdleShouldAssert = '1' or rxElecIdleShouldAssert = '1' then
                    rx_elec_idle_o_slow <= '1';
                    tmpRxElecIdleOut <= '1';
                    rxElecIdleShouldAssert <= '0';
                else
                    rx_elec_idle_o_slow <= '0';
                    tmpRxElecIdleOut <= '0';
                end if;

                if comm_init_detect_i_fast = '1' or commInitDetectShouldAssert = '1' then
                    comm_init_detect_o_slow <= '1';
                    tmpCommInitDetectOut <= '1';
                    commInitDetectShouldAssert <= '0';
                else
                    comm_init_detect_o_slow <= '0';
                    tmpCommInitDetectOut <= '0';
                end if;

                if comm_wake_detect_i_fast = '1' or commWakeDetectShouldAssert = '1' then
                    comm_wake_detect_o_slow <= '1';
                    tmpCommWakeDetectOut <= '1';
                    commInitDetectShouldAssert <= '0';
                else
                    comm_wake_detect_o_slow <= '0';
                    tmpCommWakeDetectOut <= '0';
                end if;

                if tx_oob_complete_i_fast = '1' or txOobCompleteShouldAssert = '1' then
                    comm_wake_detect_o_slow <= '1';
                    tmpTxOobComplete <= '1';
                    txOobCompleteShouldAssert <= '0';
                else
                    tx_oob_complete_o_slow <= '0';
                    tmpTxOobComplete <= '0';
                end if;

            else
                clkPositiveEdgeCounter <=
                    std_logic_vector(unsigned(clkPositiveEdgeCounter) + 1);
                data_o_slow <= tmpDataOut;
                is_k_o_slow <= tmpIsKOut;
                rx_byte_is_aligned_o_slow <= tmpIsAlignedOut;

                if rx_elec_idle_i_fast = '1' then
                    rxElecIdleShouldAssert <= '1';
                end if;

                if comm_init_detect_i_fast = '1' then
                    commInitDetectShouldAssert <= '1';
                end if;

                if comm_wake_detect_i_fast = '1' then
                    commWakeDetectShouldAssert <= '1';
                end if;
                if tx_oob_complete_i_fast  = '1' then
                    txOobCompleteShouldAssert <= '1';
                end if;
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

