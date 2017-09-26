library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity serial_to_parallel is
    Port ( fast_clk : in  STD_LOGIC;
           slow_clk : in  STD_LOGIC;
           data_i_fast : in  STD_LOGIC_VECTOR(31 downto 0);
           is_k_i_fast : in  STD_LOGIC;
           rx_elec_idle_i_fast : in STD_LOGIC;
           rx_byte_is_aligned_i_fast : in STD_LOGIC;
           comm_init_detect_i_fast : in STD_LOGIC;
           comm_wake_detect_i_fast : in STD_LOGIC;
           data_o_slow : out  STD_LOGIC_VECTOR(31 downto 0);
           is_k_o_slow : out  STD_LOGIC_VECTOR(3 downto 0);
           rx_elec_idle_o_slow : out STD_LOGIC;
           rx_byte_is_aligned_o_slow : out STD_LOGIC;
           comm_init_detect_o_slow : out STD_LOGIC;
           comm_wake_detect_o_slow : out STD_LOGIC;
    );
end serial_to_parallel;

architecture Behavioral of serial_to_parallel is

    signal tmp: std_logic := '0';
    signal tmpData std_logic_vector(31 downto 0) := (others => '0');
    signal tmpIsK std_logic_vector(3 downto 0) := (others => '0');

begin
    process (fast_clk)
    begin
      if rising_edge(fast_clk) then
          if 
      end if;
    end process;


end Behavioral;

