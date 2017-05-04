----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:23:38 05/04/2017 
-- Design Name: 
-- Module Name:    platform - Behavioral 
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

entity platform is
    Port ( tx_dout_i : in  STD_LOGIC_VECTOR (31 downto 0);
           tx_is_k_i : in  STD_LOGIC_VECTOR (3 downto 0);
           tx_comm_reset_i : in  STD_LOGIC;
           tx_comm_wake_i : in  STD_LOGIC;
           tx_elec_idle_i : in  STD_LOGIC;
           tx_oob_complete_o : out  STD_LOGIC;
           rx_din_o : out  STD_LOGIC_VECTOR (31 downto 0);
           rx_is_k_o : out  STD_LOGIC;
           rx_elec_idle_o : out  STD_LOGIC;
           rx_byte_is_aligned_o : out  STD_LOGIC;
           comm_init_detect_o : out  STD_LOGIC;
           comm_wake_detect_o : out  STD_LOGIC;
           phy_error_o : out  STD_LOGIC;
           clk_75mhz_o : out  STD_LOGIC;
           clk_150mhz_i : in  STD_LOGIC;
           TX_N : out  STD_LOGIC;
           TX_P : out  STD_LOGIC;
           RX_N : in  STD_LOGIC;
           RX_N : in  STD_LOGIC);
end platform;

architecture Behavioral of platform is

    component SATA_PLATFORM
    generic
    (
        -- Simulation attributes
        WRAPPER_SIM_GTPRESET_SPEEDUP    : integer   := 0; -- Set to 1 to speed up sim reset
        WRAPPER_SIM_PLL_PERDIV2         : bit_vector:= x"14d" -- Set to the VCO Unit Interval time
    );
    port
    (
        ----------------------- Receive Ports - 8b10b Decoder ----------------------
        TILE0_RXCHARISCOMMA0_OUT                : out  std_logic_vector(1 downto 0);
        TILE0_RXCHARISCOMMA1_OUT                : out  std_logic_vector(1 downto 0);
        TILE0_RXCHARISK0_OUT                    : out  std_logic_vector(1 downto 0);
        TILE0_RXCHARISK1_OUT                    : out  std_logic_vector(1 downto 0);
        TILE0_RXDISPERR0_OUT                    : out  std_logic_vector(1 downto 0);
        TILE0_RXDISPERR1_OUT                    : out  std_logic_vector(1 downto 0);
        TILE0_RXNOTINTABLE0_OUT                 : out  std_logic_vector(1 downto 0);
        TILE0_RXNOTINTABLE1_OUT                 : out  std_logic_vector(1 downto 0);
        ------------------- Receive Ports - Clock Correction Ports -----------------
        TILE0_RXCLKCORCNT0_OUT                  : out  std_logic_vector(2 downto 0);
        TILE0_RXCLKCORCNT1_OUT                  : out  std_logic_vector(2 downto 0);
        --------------- Receive Ports - Comma Detection and Alignment --------------
        TILE0_RXENMCOMMAALIGN0_IN               : in   std_logic;
        TILE0_RXENMCOMMAALIGN1_IN               : in   std_logic;
        TILE0_RXENPCOMMAALIGN0_IN               : in   std_logic;
        TILE0_RXENPCOMMAALIGN1_IN               : in   std_logic;
        ------------------- Receive Ports - RX Data Path interface -----------------
        TILE0_RXDATA0_OUT                       : out  std_logic_vector(15 downto 0);
        TILE0_RXDATA1_OUT                       : out  std_logic_vector(15 downto 0);
        TILE0_RXRECCLK0_OUT                     : out  std_logic;
        TILE0_RXRECCLK1_OUT                     : out  std_logic;
        TILE0_RXUSRCLK0_IN                      : in   std_logic;
        TILE0_RXUSRCLK1_IN                      : in   std_logic;
        TILE0_RXUSRCLK20_IN                     : in   std_logic;
        TILE0_RXUSRCLK21_IN                     : in   std_logic;
        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        TILE0_RXELECIDLE0_OUT                   : out  std_logic;
        TILE0_RXELECIDLE1_OUT                   : out  std_logic;
        TILE0_RXN0_IN                           : in   std_logic;
        TILE0_RXN1_IN                           : in   std_logic;
        TILE0_RXP0_IN                           : in   std_logic;
        TILE0_RXP1_IN                           : in   std_logic;
        -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        TILE0_RXSTATUS0_OUT                     : out  std_logic_vector(2 downto 0);
        TILE0_RXSTATUS1_OUT                     : out  std_logic_vector(2 downto 0);
        --------------------- Shared Ports - Tile and PLL Ports --------------------
        TILE0_CLKIN_IN                          : in   std_logic;
        TILE0_GTPRESET_IN                       : in   std_logic;
        TILE0_PLLLKDET_OUT                      : out  std_logic;
        TILE0_REFCLKOUT_OUT                     : out  std_logic;
        TILE0_RESETDONE0_OUT                    : out  std_logic;
        TILE0_RESETDONE1_OUT                    : out  std_logic;
        ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        TILE0_TXCHARISK0_IN                     : in   std_logic_vector(1 downto 0);
        TILE0_TXCHARISK1_IN                     : in   std_logic_vector(1 downto 0);
        ------------------ Transmit Ports - TX Data Path interface -----------------
        TILE0_TXDATA0_IN                        : in   std_logic_vector(15 downto 0);
        TILE0_TXDATA1_IN                        : in   std_logic_vector(15 downto 0);
        TILE0_TXOUTCLK0_OUT                     : out  std_logic;
        TILE0_TXOUTCLK1_OUT                     : out  std_logic;
        TILE0_TXUSRCLK0_IN                      : in   std_logic;
        TILE0_TXUSRCLK1_IN                      : in   std_logic;
        TILE0_TXUSRCLK20_IN                     : in   std_logic;
        TILE0_TXUSRCLK21_IN                     : in   std_logic;
        --------------- Transmit Ports - TX Driver and OOB signalling --------------
        TILE0_TXN0_OUT                          : out  std_logic;
        TILE0_TXN1_OUT                          : out  std_logic;
        TILE0_TXP0_OUT                          : out  std_logic;
        TILE0_TXP1_OUT                          : out  std_logic;
        ----------------- Transmit Ports - TX Ports for PCI Express ----------------
        TILE0_TXELECIDLE0_IN                    : in   std_logic;
        TILE0_TXELECIDLE1_IN                    : in   std_logic;
        --------------------- Transmit Ports - TX Ports for SATA -------------------
        TILE0_TXCOMSTART0_IN                    : in   std_logic;
        TILE0_TXCOMSTART1_IN                    : in   std_logic;
        TILE0_TXCOMTYPE0_IN                     : in   std_logic;
        TILE0_TXCOMTYPE1_IN                     : in   std_logic
    );
    end component;

    signal comm_init_detect_s : std_logic;
    signal comm_wake_detect_s : std_logic;
    signal rx_elec_idle_s : std_logic;
    signal tx_elec_idle_s : std_logic;
    signal tx_is_k_s : std_logic;
    signal rx_is_k_s : std_logic;

begin

    process (clk_150mhz_i)
    begin
       if (rising_edge(clk_150mhz_i) then
           
       end if;
    end process;


    sata_platform_i : SATA_PLATFORM
    generic map
    (
        -- TODO: is this ok?
        -- I think, I should put WRAPPER_SIM_GTPRESET_SPEEDUP to zero...
        WRAPPER_SIM_GTPRESET_SPEEDUP => 1,
        WRAPPER_SIM_PLL_PERDIV2 => x"14d"
    )
    port map
    (
        --_____________________________________________________________________
        --_____________________________________________________________________
        --TILE0  (X0Y3)

        ----------------------- Receive Ports - 8b10b Decoder ----------------------
        -- TODO: Is this really not connected to the SATA stack; is
        -- TILE0_RXSTATUS0_OUT(2) sufficient?
        TILE0_RXCHARISCOMMA0_OUT => open,
        TILE0_RXCHARISK0_OUT => rx_is_k_s,
        -- This should be connected to error phy_error
        TILE0_RXDISPERR0_OUT =>      ,
        -- This should be connected to error phy_error
        -- This is signal indicating that invalid symbol (8B/10B) was received.
        TILE0_RXNOTINTABLE0_OUT =>      ,
        ------------------- Receive Ports - Clock Correction Ports -----------------
        -- TODO: I'm completely lost with these signal...
        TILE0_RXCLKCORCNT0_OUT =>      ,
        --------------- Receive Ports - Comma Detection and Alignment --------------
        -- ! This flags are set According to
        -- http://scholarworks.umass.edu/cgi/viewcontent.cgi?article=2250&context=theses
        TILE0_RXENMCOMMAALIGN0_IN => '1',
        TILE0_RXENPCOMMAALIGN0_IN => '1',
        ------------------- Receive Ports - RX Data Path interface -----------------
        TILE0_RXDATA0_OUT => ,
        TILE0_RXRECCLK0_OUT => ,
        TILE0_RXUSRCLK0_IN => ,
        TILE0_RXUSRCLK20_IN => ,
        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        TILE0_RXELECIDLE0_OUT => rx_elec_idle_s,
        -- Equalization setup
        -- TODO: I have no idea what to do with this... Ok, it looks like I
        -- have turned it off :D.
        -- TILE0_RXEQMIX0_IN => ,
        -- TILE0_RXEQPOLE0_IN => ,

        -- Connect directly to the output pin.
        -- SATA on the board is indexed from 1 not from zero so we use SATA 1.
        TILE0_RXN0_IN => SATA1_RX_N,
        TILE0_RXP0_IN => SATA1_RX_P,
        -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        -- TODO: is this correct? TILE0_RXSTATUS0_OUT(0) is TXCOMSTART and it
        -- is weird not to be connected...
        TILE0_RXSTATUS0_OUT(0) => open,
        TILE0_RXSTATUS0_OUT(1) => comm_wake_detect_s,
        TILE0_RXSTATUS0_OUT(2) => comm_init_detect_s,
        ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        TILE0_TXCHARISK0_IN => tx_is_k_s,
        ------------------ Transmit Ports - TX Data Path interface -----------------
        TILE0_TXDATA0_IN => ,
        -- Clock witch I can't use; because this may be affected by phase
        -- alignment circuit (probably turned off) and it is not free running
        -- which I don't like.
        TILE0_TXOUTCLK0_OUT => open,
        TILE0_TXUSRCLK0_IN =>      ,
        TILE0_TXUSRCLK20_IN =>      ,
        --------------- Transmit Ports - TX Driver and OOB signalling --------------
        -- Connect directly to the output pin.
        -- SATA on the board is indexed from 1 not from zero so we use SATA 1.
        TILE0_TXN0_OUT => SATA1_TX_N,
        TILE0_TXP0_OUT => SATA1_TX_P,
        TILE0_TXELECIDLE0_IN => tx_elec_idle_s,
        --------------------- Transmit Ports - TX Ports for SATA -------------------
        TILE0_TXCOMSTART0_IN =>      ,
        TILE0_TXCOMTYPE0_IN =>      ,
        --------------------- Shared Ports - Tile and PLL Ports --------------------
        TILE0_CLKIN_IN =>      ,
        TILE0_GTPRESET_IN =>      ,
        TILE0_PLLLKDET_OUT =>      ,
        -- TODO: Why does this exist?
        TILE0_REFCLKOUT_OUT =>      ,
        TILE0_RESETDONE0_OUT =>      ,
        TILE0_RESETDONE1_OUT => open,



        ----------------------- Receive Ports - 8b10b Decoder ----------------------
        TILE0_RXCHARISK1_OUT => open,
        TILE0_RXDISPERR1_OUT => open,
        TILE0_RXCHARISCOMMA1_OUT => open,
        TILE0_RXNOTINTABLE1_OUT => open,
        ------------------- Receive Ports - Clock Correction Ports -----------------
        TILE0_RXCLKCORCNT1_OUT => open,
        --------------- Receive Ports - Comma Detection and Alignment --------------
        TILE0_RXENMCOMMAALIGN1_IN => '1',
        TILE0_RXENPCOMMAALIGN1_IN => '1',
        ------------------- Receive Ports - RX Data Path interface -----------------
        TILE0_RXDATA1_OUT => open,
        TILE0_RXRECCLK1_OUT => open,
        TILE0_RXUSRCLK1_IN => open,
        TILE0_RXUSRCLK21_IN => open,
        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        TILE0_RXELECIDLE1_OUT => open,
        -- Turned off.
        -- TILE0_RXEQMIX1_IN => open,
        -- TILE0_RXEQPOLE1_IN => open,
        TILE0_RXN1_IN => open,
        TILE0_RXP1_IN => open,
        -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        TILE0_RXSTATUS1_OUT => open,
        ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        TILE0_TXCHARISK1_IN => open,
        ------------------ Transmit Ports - TX Data Path interface -----------------
        TILE0_TXDATA1_IN => open,
        TILE0_TXOUTCLK1_OUT => open,
        TILE0_TXUSRCLK1_IN => open,
        TILE0_TXUSRCLK21_IN => open,
        --------------- Transmit Ports - TX Driver and OOB signalling --------------
        TILE0_TXN1_OUT => open,
        TILE0_TXP1_OUT => open,
        ----------------- Transmit Ports - TX Ports for PCI Express ----------------
        TILE0_TXELECIDLE1_IN => open,
        --------------------- Transmit Ports - TX Ports for SATA -------------------
        TILE0_TXCOMSTART1_IN => open,
        TILE0_TXCOMTYPE1_IN => open
    );

end Behavioral;

