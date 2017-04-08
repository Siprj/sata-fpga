----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    12:37:30 04/02/2017
-- Design Name:
-- Module Name:    top - Behavioral
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

entity top is
    Port ( GPIO_DIP_SW1 : in  STD_LOGIC;
           GPIO_LED_0 : out  STD_LOGIC);
end top;

architecture Behavioral of top is
    COMPONENT data_write
    PORT(
        clk : IN std_logic;
        en : IN std_logic;
        user_din_ready : IN std_logic_vector(1 downto 0);
        user_din_size : IN std_logic_vector(23 downto 0);
        user_din_empty : IN std_logic;
        data_in : OUT std_logic_vector(31 downto 0);
        user_din_stb : OUT std_logic;
        user_din_activate : OUT std_logic_vector(1 downto 0)
        );
    END COMPONENT;

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
        TILE0_RXCHARISCOMMA0_OUT                : out  std_logic;
        TILE0_RXCHARISCOMMA1_OUT                : out  std_logic;
        TILE0_RXCHARISK0_OUT                    : out  std_logic;
        TILE0_RXCHARISK1_OUT                    : out  std_logic;
        TILE0_RXDISPERR0_OUT                    : out  std_logic;
        TILE0_RXDISPERR1_OUT                    : out  std_logic;
        TILE0_RXNOTINTABLE0_OUT                 : out  std_logic;
        TILE0_RXNOTINTABLE1_OUT                 : out  std_logic;
        ------------------- Receive Ports - Clock Correction Ports -----------------
        TILE0_RXCLKCORCNT0_OUT                  : out  std_logic_vector(2 downto 0);
        TILE0_RXCLKCORCNT1_OUT                  : out  std_logic_vector(2 downto 0);
        --------------- Receive Ports - Comma Detection and Alignment --------------
        TILE0_RXENMCOMMAALIGN0_IN               : in   std_logic;
        TILE0_RXENMCOMMAALIGN1_IN               : in   std_logic;
        TILE0_RXENPCOMMAALIGN0_IN               : in   std_logic;
        TILE0_RXENPCOMMAALIGN1_IN               : in   std_logic;
        ------------------- Receive Ports - RX Data Path interface -----------------
        TILE0_RXDATA0_OUT                       : out  std_logic_vector(7 downto 0);
        TILE0_RXDATA1_OUT                       : out  std_logic_vector(7 downto 0);
        TILE0_RXRECCLK0_OUT                     : out  std_logic;
        TILE0_RXRECCLK1_OUT                     : out  std_logic;
        TILE0_RXUSRCLK0_IN                      : in   std_logic;
        TILE0_RXUSRCLK1_IN                      : in   std_logic;
        TILE0_RXUSRCLK20_IN                     : in   std_logic;
        TILE0_RXUSRCLK21_IN                     : in   std_logic;
        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        TILE0_RXELECIDLE0_OUT                   : out  std_logic;
        TILE0_RXELECIDLE1_OUT                   : out  std_logic;
        TILE0_RXEQMIX0_IN                       : in   std_logic_vector(1 downto 0);
        TILE0_RXEQMIX1_IN                       : in   std_logic_vector(1 downto 0);
        TILE0_RXEQPOLE0_IN                      : in   std_logic_vector(3 downto 0);
        TILE0_RXEQPOLE1_IN                      : in   std_logic_vector(3 downto 0);
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
        TILE0_TXCHARISK0_IN                     : in   std_logic;
        TILE0_TXCHARISK1_IN                     : in   std_logic;
        ------------------ Transmit Ports - TX Data Path interface -----------------
        TILE0_TXDATA0_IN                        : in   std_logic_vector(7 downto 0);
        TILE0_TXDATA1_IN                        : in   std_logic_vector(7 downto 0);
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

    COMPONENT sata_stack
    PORT(
        clk : IN std_logic;
        rst : IN std_logic;

        -- Controls where and how much data will be written
        sector_address : IN std_logic_vector(47 downto 0);
        sector_count : IN std_logic_vector(15 downto 0);

        -- Ready for commands (linkup && sata_ready && !sata_busy)
        linkup : OUT std_logic;
        sata_busy : OUT std_logic;
        sata_ready : OUT std_logic;

        -- Reset the command layer and send software reset to the hard drive
        command_layer_reset : IN std_logic;
        execute_command_stb : IN std_logic;
        hard_drive_command : IN std_logic_vector(7 downto 0);
        hard_drive_error : OUT std_logic;

        link_layer_ready : OUT std_logic;
        phy_ready : OUT std_logic;
        platform_error : OUT std_logic;
        platform_ready : IN std_logic;
        slw_buffer_pos : OUT std_logic_vector(3 downto 0)
        slw_d_count : OUT std_logic_vector(12 downto 0);
        slw_in_data_addra : OUT std_logic_vector(23 downto 0);
        slw_write_count : OUT std_logic_vector(12 downto 0);
        transport_layer_ready : OUT std_logic;
        user_features : IN std_logic_vector(15 downto 0);
        pio_data_ready : OUT std_logic;

        send_sync_escape : IN std_logic;

        data_scrambler_en : IN std_logic;
        prim_scrambler_en : IN std_logic;

        -- Hard Drive status signals
        d2h_data_stb : OUT std_logic;
        d2h_device : OUT std_logic_vector(7 downto 0);
        d2h_error : OUT std_logic_vector(7 downto 0);
        d2h_fis : OUT std_logic_vector(7 downto 0);
        d2h_interrupt : OUT std_logic;
        d2h_lba : OUT std_logic_vector(47 downto 0);
        d2h_notification : OUT std_logic;
        d2h_port_mult : OUT std_logic_vector(3 downto 0);
        d2h_reg_stb : OUT std_logic;
        d2h_sector_count : OUT std_logic_vector(15 downto 0);
        d2h_status : OUT std_logic_vector(7 downto 0);
        dma_activate_stb : OUT std_logic;
        dma_setup_stb : OUT std_logic;
        pio_setup_stb : OUT std_logic;
        set_device_bits_stb : OUT std_logic;

        -- Platform signals
        comm_init_detect : IN std_logic;
        comm_wake_detect : IN std_logic;
        phy_error : IN std_logic;
        rx_byte_is_aligned : IN std_logic;
        rx_din : IN std_logic_vector(31 downto 0);
        rx_elec_idle : IN std_logic;
        rx_is_k : IN std_logic_vector(3 downto 0);
        tx_comm_reset : OUT std_logic;
        tx_comm_wake : OUT std_logic;
        tx_dout : OUT std_logic_vector(31 downto 0);
        tx_elec_idle : OUT std_logic;
        tx_is_k : OUT std_logic;
        tx_oob_complete : IN std_logic;

        -- Data in port
        data_in_clk : IN std_logic;
        data_in_clk_valid : IN std_logic;
        user_din_activate : IN std_logic_vector(1 downto 0);
        user_din_empty : OUT std_logic;
        user_din : IN std_logic_vector(31 downto 0);
        user_din_ready : OUT std_logic_vector(1 downto 0);
        user_din_size : OUT std_logic_vector(23 downto 0);
        user_din_stb : IN std_logic;

        -- Data out port
        data_out_clk : IN std_logic;
        data_out_clk_valid : IN std_logic;
        user_dout_activate : IN std_logic;
        user_dout : OUT std_logic_vector(31 downto 0);
        user_dout_ready : OUT std_logic;
        user_dout_size : OUT std_logic_vector(23 downto 0);
        user_dout_stb : IN std_logic;

        -- Debug signals
        dbg_cc_lax_state : OUT std_logic_vector(3 downto 0);
        dbg_cw_lax_state : OUT std_logic_vector(3 downto 0);
        dbg_detect_align : OUT std_logic;
        dbg_detect_cont : OUT std_logic;
        dbg_detect_eof : OUT std_logic;
        dbg_detect_holda : OUT std_logic;
        dbg_detect_hold : OUT std_logic;
        dbg_detect_preq_p : OUT std_logic;
        dbg_detect_preq_s : OUT std_logic;
        dbg_detect_r_err : OUT std_logic;
        dbg_detect_r_ip : OUT std_logic;
        dbg_detect_r_ok : OUT std_logic;
        dbg_detect_r_rdy : OUT std_logic;
        dbg_detect_sof : OUT std_logic;
        dbg_detect_sync : OUT std_logic;
        dbg_detect_wtrm : OUT std_logic;
        dbg_detect_x_rdy : OUT std_logic;
        dbg_detect_xrdy_xrdy : OUT std_logic;
        dbg_li_lax_state : OUT std_logic_vector(3 downto 0);
        dbg_ll_paw : OUT std_logic;
        dbg_ll_send_crc : OUT std_logic;
        dbg_ll_write_ready : OUT std_logic;
        dbg_ll_write_strobe : OUT std_logic;
        dbg_lr_lax_state : OUT std_logic_vector(3 downto 0);
        dbg_lw_lax_fstate : OUT std_logic_vector(3 downto 0);
        dbg_lw_lax_state : OUT std_logic_vector(3 downto 0);
        dbg_send_holda : OUT std_logic;
        dbg_t_lax_state : OUT std_logic_vector(3 downto 0);
        oob_state : OUT std_logic_vector(3 downto 0);
        );
    END COMPONENT;

begin
    GPIO_LED_0 <= GPIO_DIP_SW1;
    Inst_data_write: data_write PORT MAP(
        clk => ,
        en => ,
        data_in => ,
        user_din_stb => ,
        user_din_ready => ,
        user_din_activate => ,
        user_din_size => ,
        user_din_empty =>
    );

    Inst_sata_stack: sata_stack PORT MAP(
        rst => ,
        clk => ,
        data_in_clk => ,
        data_in_clk_valid => ,
        data_out_clk => ,
        data_out_clk_valid => ,
        platform_ready => ,
        platform_error => ,
        linkup => ,
        send_sync_escape => ,
        user_features => ,
        sata_ready => ,
        sata_busy => ,
        hard_drive_error => ,
        execute_command_stb => ,
        command_layer_reset => ,
        hard_drive_command => ,
        pio_data_ready => ,
        sector_count => ,
        sector_address => ,
        dma_activate_stb => ,
        d2h_reg_stb => ,
        pio_setup_stb => ,
        d2h_data_stb => ,
        dma_setup_stb => ,
        set_device_bits_stb => ,
        d2h_fis => ,
        d2h_interrupt => ,
        d2h_notification => ,
        d2h_port_mult => ,
        d2h_device => ,
        d2h_lba => ,
        d2h_sector_count => ,
        d2h_status => ,
        d2h_error => ,
        user_din => ,
        user_din_stb => ,
        user_din_ready => ,
        user_din_activate => ,
        user_din_size => ,
        user_din_empty => ,
        user_dout => ,
        user_dout_ready => ,
        user_dout_activate => ,
        user_dout_stb => ,
        user_dout_size => ,
        transport_layer_ready => ,
        link_layer_ready => ,
        phy_ready => ,
        tx_dout => ,
        tx_is_k => ,
        tx_comm_reset => ,
        tx_comm_wake => ,
        tx_elec_idle => ,
        rx_din => ,
        rx_is_k => ,
        rx_elec_idle => ,
        rx_byte_is_aligned => ,
        comm_init_detect => ,
        comm_wake_detect => ,
        tx_oob_complete => ,
        phy_error => ,
        dbg_cc_lax_state => open,
        dbg_cw_lax_state => open,
        dbg_t_lax_state => open,
        dbg_li_lax_state => open,
        dbg_lr_lax_state => open,
        dbg_lw_lax_state => open,
        dbg_lw_lax_fstate => open,
        -- ! These two values look to be set correctly according to:
        -- https://github.com/CospanDesign/nysa-verilog/blob/master/verilog/wishbone/slave/wb_sata/rtl/wb_sata.v#L412
        prim_scrambler_en => '1',
        data_scrambler_en => '1',
        dbg_ll_write_ready => open,
        dbg_ll_paw => open,
        dbg_ll_write_strobe => open,
        dbg_ll_send_crc => open,
        -- ! TODO: Is it correct?
        oob_state => open,
        dbg_detect_sync => open,
        dbg_detect_r_rdy => open,
        dbg_detect_r_ip => open,
        dbg_detect_r_ok => open,
        dbg_detect_r_err => open,
        dbg_detect_x_rdy => open,
        dbg_detect_sof => open,
        dbg_detect_eof => open,
        dbg_detect_wtrm => open,
        dbg_detect_cont => open,
        dbg_detect_hold => open,
        dbg_detect_holda => open,
        dbg_detect_align => open,
        dbg_detect_preq_s => open,
        dbg_detect_preq_p => open,
        dbg_detect_xrdy_xrdy => open,
        dbg_send_holda => open,
        slw_in_data_addra => ,
        slw_d_count => ,
        slw_write_count => ,
        slw_buffer_pos =>
    );

     sata_platform_i : SATA_PLATFORM
    generic map
    (
        WRAPPER_SIM_GTPRESET_SPEEDUP    =>      1,
        WRAPPER_SIM_PLL_PERDIV2         =>      x"14d"
    )
    port map
    (
        --_____________________________________________________________________
        --_____________________________________________________________________
        --TILE0  (X0Y3)

        ----------------------- Receive Ports - 8b10b Decoder ----------------------
        TILE0_RXCHARISCOMMA0_OUT        =>      ,
        TILE0_RXCHARISK0_OUT            =>      ,
        TILE0_RXDISPERR0_OUT            =>      ,
        TILE0_RXNOTINTABLE0_OUT         =>      ,
        ------------------- Receive Ports - Clock Correction Ports -----------------
        TILE0_RXCLKCORCNT0_OUT          =>      ,
        --------------- Receive Ports - Comma Detection and Alignment --------------
        -- ! This flags are set According to
        -- http://scholarworks.umass.edu/cgi/viewcontent.cgi?article=2250&context=theses
        TILE0_RXENMCOMMAALIGN0_IN       =>      '1',
        TILE0_RXENPCOMMAALIGN0_IN       =>      '1',
        ------------------- Receive Ports - RX Data Path interface -----------------
        TILE0_RXDATA0_OUT               =>      ,
        TILE0_RXRECCLK0_OUT             =>      ,
        TILE0_RXUSRCLK0_IN              =>      ,
        TILE0_RXUSRCLK20_IN             =>      ,
        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        TILE0_RXELECIDLE0_OUT           =>      ,
        TILE0_RXEQMIX0_IN               =>      ,
        TILE0_RXEQPOLE0_IN              =>      ,
        TILE0_RXN0_IN                   =>      ,
        TILE0_RXP0_IN                   =>      ,
        -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        TILE0_RXSTATUS0_OUT             =>      ,
        ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        TILE0_TXCHARISK0_IN             =>      ,
        ------------------ Transmit Ports - TX Data Path interface -----------------
        TILE0_TXDATA0_IN                =>      ,
        TILE0_TXOUTCLK0_OUT             =>      ,
        TILE0_TXUSRCLK0_IN              =>      ,
        TILE0_TXUSRCLK20_IN             =>      ,
        --------------- Transmit Ports - TX Driver and OOB signalling --------------
        TILE0_TXN0_OUT                  =>      ,
        TILE0_TXP0_OUT                  =>      ,
        ----------------- Transmit Ports - TX Ports for PCI Express ----------------
        TILE0_TXELECIDLE0_IN            =>      ,
        --------------------- Transmit Ports - TX Ports for SATA -------------------
        TILE0_TXCOMSTART0_IN            =>      ,
        TILE0_TXCOMTYPE0_IN             =>      ,
        --------------------- Shared Ports - Tile and PLL Ports --------------------
        TILE0_CLKIN_IN                  =>      ,
        TILE0_GTPRESET_IN               =>      ,
        TILE0_PLLLKDET_OUT              =>      ,
        TILE0_REFCLKOUT_OUT             =>      ,
        TILE0_RESETDONE0_OUT            =>      ,
        TILE0_RESETDONE1_OUT            =>      ,



        ----------------------- Receive Ports - 8b10b Decoder ----------------------
        TILE0_RXCHARISK1_OUT            =>      ,
        TILE0_RXDISPERR1_OUT            =>      ,
        TILE0_RXCHARISCOMMA1_OUT        =>      ,
        TILE0_RXNOTINTABLE1_OUT         =>      ,
        ------------------- Receive Ports - Clock Correction Ports -----------------
        TILE0_RXCLKCORCNT1_OUT          =>      ,
        --------------- Receive Ports - Comma Detection and Alignment --------------
        TILE0_RXENMCOMMAALIGN1_IN       =>      '1',
        TILE0_RXENPCOMMAALIGN1_IN       =>      '1',
        ------------------- Receive Ports - RX Data Path interface -----------------
        TILE0_RXDATA1_OUT               =>      ,
        TILE0_RXRECCLK1_OUT             =>      ,
        TILE0_RXUSRCLK1_IN              =>      ,
        TILE0_RXUSRCLK21_IN             =>      ,
        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        TILE0_RXELECIDLE1_OUT           =>      ,
        TILE0_RXEQMIX1_IN               =>      ,
        TILE0_RXEQPOLE1_IN              =>      ,
        TILE0_RXN1_IN                   =>      ,
        TILE0_RXP1_IN                   =>      ,
        -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        TILE0_RXSTATUS1_OUT             =>      ,
        ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        TILE0_TXCHARISK1_IN             =>      ,
        ------------------ Transmit Ports - TX Data Path interface -----------------
        TILE0_TXDATA1_IN                =>      ,
        TILE0_TXOUTCLK1_OUT             =>      ,
        TILE0_TXUSRCLK1_IN              =>      ,
        TILE0_TXUSRCLK21_IN             =>      ,
        --------------- Transmit Ports - TX Driver and OOB signalling --------------
        TILE0_TXN1_OUT                  =>      ,
        TILE0_TXP1_OUT                  =>      ,
        ----------------- Transmit Ports - TX Ports for PCI Express ----------------
        TILE0_TXELECIDLE1_IN            =>      ,
        --------------------- Transmit Ports - TX Ports for SATA -------------------
        TILE0_TXCOMSTART1_IN            =>      ,
        TILE0_TXCOMTYPE1_IN             =>
    );



    -----------------------Dedicated GTP Reference Clock Inputs ---------------
    -- Each dedicated refclk you are using in your design will need its own IBUFDS instance

    tile0_refclk_ibufds_i : IBUFDS
    port map
    (
        O                               =>      ,
        I                               =>      ,  -- Connect to package pin Y4
        IB                              =>        -- Connect to package pin Y3
    );


end Behavioral;

