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
library UNISIM;
use UNISIM.VComponents.all;


entity top is
    Port (
        GPIO_DIP_SW1 : in  std_logic;
        GPIO_LED_0 : out  std_logic;
        GPIO_LED_1 : out  std_logic;
        GPIO_LED_2 : out  std_logic;
        SATA1_RX_N : in std_logic;
        SATA1_RX_P : in std_logic;
        SATA1_TX_N : out std_logic;
        SATA1_TX_P : out std_logic;
        SATACLK_QO_N : in std_logic;
        SATACLK_QO_P : in std_logic
   );
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

    COMPONENT sata_stack
    PORT(
        clk : IN std_logic;
        rst : IN std_logic;

        -- Controls where and how much data will be written.
        sector_address : IN std_logic_vector(47 downto 0);
        sector_count : IN std_logic_vector(15 downto 0);

        -- When the 'platform_ready' signal is high and the stack is not linked
        -- up it will continually send out the SATA OOB signals to the hard
        -- drive in order to initiate a linkup sequence. Once the entire linkup
        -- sequence is finished the 'linkup' signal will go high.
        linkup : OUT std_logic;
        -- Ready for commands (linkup && sata_ready && !sata_busy)
        sata_busy : OUT std_logic;
        sata_ready : OUT std_logic;

        -- Reset the command layer and send software reset to the hard drive.
        command_layer_reset : IN std_logic;
        -- Command enable signal. Similar to write enable signal in ram, etc.
        execute_command_stb : IN std_logic;
        -- Hard drive command describing what operation will occur in near
        -- future. For example 0x25: READ_DATA_EXT, 0x35: WRITE_DMA_EXT
        -- commands.
        hard_drive_command : IN std_logic_vector(7 downto 0);
        -- When some thing bad is reported by HD.
        hard_drive_error : OUT std_logic;
        -- Can be used together with command to enable some advanced features.
        user_features : IN std_logic_vector(15 downto 0);
        -- Terminate command which is already in progress. NOT TESTED!!!
        send_sync_escape : IN std_logic;


        -- I don't know what this is ... These are disconnected in this example:
        -- https://github.com/CospanDesign/nysa-verilog/blob/master/verilog/wishbone/slave/wb_sata/rtl/wb_sata.v#L457
        -- so I'll do the same.
        slw_buffer_pos : OUT std_logic_vector(3 downto 0);
        slw_d_count : OUT std_logic_vector(12 downto 0);
        slw_in_data_addra : OUT std_logic_vector(23 downto 0);
        slw_write_count : OUT std_logic_vector(12 downto 0);

        -- Signal representing that the hardware part of the SATA is up and
        -- running. In case of Xilinx it is signal
        platform_ready : IN std_logic;

        link_layer_ready : OUT std_logic;
        phy_ready : OUT std_logic;
        platform_error : OUT std_logic;
        transport_layer_ready : OUT std_logic;

        -- When communicated with the 'peripheral IO' portion of the SATA
        -- stack, this flag will indicate that there is data from the hard
        -- drive ready on the data interface (see below how to read data from
        -- the hard drive.
        pio_data_ready : OUT std_logic;

        -- These two signal should be used for debugging purposes in normal
        -- operations must be high (1).
        data_scrambler_en : IN std_logic;
        prim_scrambler_en : IN std_logic;

        -- Hard Drive status signals.
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

        -- Platform signals.
        -- The hardware will tell the SATA stack that the COMINIT was detected.
        -- On Virtex 5 it will be one of the RXSTATUS bits.
        comm_init_detect : IN std_logic;
        -- The hardware will tell the SATA stack that the COMWAKE was detected.
        -- On Virtex 5 it will be one of the RXSTATUS bits.
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

        -- Data in port.
        data_in_clk : IN std_logic;
        data_in_clk_valid : IN std_logic;
        user_din_activate : IN std_logic_vector(1 downto 0);
        user_din_empty : OUT std_logic;
        user_din : IN std_logic_vector(31 downto 0);
        user_din_ready : OUT std_logic_vector(1 downto 0);
        user_din_size : OUT std_logic_vector(23 downto 0);
        user_din_stb : IN std_logic;

        -- Data out port.
        data_out_clk : IN std_logic;
        data_out_clk_valid : IN std_logic;
        user_dout_activate : IN std_logic;
        user_dout : OUT std_logic_vector(31 downto 0);
        user_dout_ready : OUT std_logic;
        user_dout_size : OUT std_logic_vector(23 downto 0);
        user_dout_stb : IN std_logic;

        -- Debug signals.
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
        oob_state : OUT std_logic_vector(3 downto 0)
        );
    END COMPONENT;

    COMPONENT platform
    PORT(
        tx_dout_i : IN std_logic_vector(31 downto 0);
        tx_is_k_i : IN std_logic;
        tx_comm_reset_i : IN std_logic;
        tx_comm_wake_i : IN std_logic;
        tx_elec_idle_i : IN std_logic;
        phy_reset_i : IN std_logic;
        clk_150mhz_i : IN std_logic;
        RX_N : IN std_logic;
        RX_P : IN std_logic;
        rx_din_o : OUT std_logic_vector(31 downto 0);
        rx_is_k_o : OUT std_logic_vector(3 downto 0);
        rx_elec_idle_o : OUT std_logic;
        rx_byte_is_aligned_o : OUT std_logic;
        comm_init_detect_o : OUT std_logic;
        comm_wake_detect_o : OUT std_logic;
        tx_oob_complete_o : OUT std_logic;
        phy_error_o : OUT std_logic;
        platform_ready : OUT std_logic;
        clk_75mhz_o : OUT std_logic;
        TX_N : OUT std_logic;
        TX_P : OUT std_logic
    );
    END COMPONENT;

--    COMPONENT handle_reset
--    PORT(
--        clk : IN std_logic;
--        rst_o : OUT std_logic
--        );
--    END COMPONENT;

    signal comm_init_detect_s: std_logic := '0';
    signal comm_wake_detect_s: std_logic := '0';
    signal rx_elec_idle_s: std_logic := '0';
    signal tx_elec_idle_s: std_logic := '0';
    signal tx_is_k_s: std_logic := '0';
    signal rx_is_k_s: std_logic_vector(3 downto 0) := (others => '0');
    signal tx_comm_reset_s: std_logic := '0';
    signal tx_comm_wake_s: std_logic := '0';
    signal tx_dout_s: std_logic_vector(31 downto 0) := (others => '0');
    signal rx_din_s: std_logic_vector(31 downto 0) := (others => '0');
    signal tx_oob_complete_s: std_logic := '0';
    signal rx_byte_is_aligned_s: std_logic := '0';

    signal clk_150mhz_s: std_logic;
    signal clk_75mhz_s: std_logic;

    signal platform_ready_s: std_logic := '0';
    signal platform_not_ready_s: std_logic := '0';
    signal sata_busy_s: std_logic := '0';
    signal sata_ready_s: std_logic := '0';
    signal platform_error_s: std_logic := '0';
    signal sata_platform_error_s: std_logic := '0';
    signal linkup_s: std_logic := '0';
    signal hard_drive_error_s: std_logic := '0';
    signal phy_ready_s: std_logic := '0';

    signal dma_activate_stb_s: std_logic := '0';
    signal d2h_reg_stb_s: std_logic := '0';
    signal pio_setup_stb_s: std_logic := '0';
    signal d2h_data_stb_s: std_logic := '0';
    signal dma_setup_stb_s: std_logic := '0';
    signal set_device_bits_stb_s: std_logic := '0';
    signal d2h_fis_s: std_logic_vector(7 downto 0) := (others => '0');
    signal d2h_interrupt_s: std_logic := '0';
    signal d2h_notification_s: std_logic := '0';
    signal d2h_port_mult_s: std_logic_vector(3 downto 0) := (others => '0');
    signal d2h_device_s: std_logic_vector(7 downto 0) := (others => '0');
    signal d2h_lba_s: std_logic_vector(47 downto 0) := (others => '0');
    signal d2h_sector_count_s: std_logic_vector(15 downto 0) := (others => '0');
    signal d2h_status_s: std_logic_vector(7 downto 0) := (others => '0');
    signal d2h_error_s: std_logic_vector(7 downto 0) := (others => '0');

    signal user_din_ready_s: std_logic_vector(1 downto 0) := (others => '0');
    signal user_din_size_s: std_logic_vector(23 downto 0) := (others => '0');
    signal user_din_empty_s: std_logic := '0';
    signal data_in_s: std_logic_vector(31 downto 0) := (others => '0');
    signal user_din_stb_s: std_logic := '0';
    signal user_din_activate_s: std_logic_vector(1 downto 0) := (others => '0');
    signal rst_s: std_logic := '0';

begin
    GPIO_LED_0 <= GPIO_DIP_SW1;
    GPIO_LED_1 <= phy_ready_s;
    GPIO_LED_2 <= rst_s;
    rst_s <= GPIO_DIP_SW1;

    platform_not_ready_s <= not platform_ready_s;

    Inst_data_write: data_write PORT MAP(
        clk => clk_75mhz_s,
        -- TODO: enable should be used for a while.
        en => '0',
        data_in => data_in_s,
        user_din_stb => user_din_stb_s,
        user_din_ready => user_din_ready_s,
        user_din_activate => user_din_activate_s,
        user_din_size => user_din_size_s,
        user_din_empty => user_din_empty_s
    );

--    Inst_handle_reset: handle_reset PORT MAP(
--        clk => clk_150mhz_s,
--        rst_o => rst_s
--    );

    Inst_platform: platform PORT MAP(
        tx_dout_i => tx_dout_s,
        tx_is_k_i => tx_is_k_s,
        tx_comm_reset_i => tx_comm_reset_s,
        tx_comm_wake_i => tx_comm_wake_s,
        tx_elec_idle_i => tx_elec_idle_s,
        rx_din_o => rx_din_s,
        rx_is_k_o => rx_is_k_s,
        rx_elec_idle_o => rx_elec_idle_s,
        rx_byte_is_aligned_o => rx_byte_is_aligned_s,
        comm_init_detect_o => comm_init_detect_s,
        comm_wake_detect_o => comm_wake_detect_s,
        tx_oob_complete_o => tx_oob_complete_s,
        phy_error_o => sata_platform_error_s,
        platform_ready => platform_ready_s,
        phy_reset_i => rst_s,
        clk_75mhz_o => clk_75mhz_s,
        clk_150mhz_i => clk_150mhz_s,
        TX_N => SATA1_TX_N,
        TX_P => SATA1_TX_P,
        RX_N => SATA1_RX_N,
        RX_P => SATA1_RX_P
    );

    Inst_sata_stack: sata_stack PORT MAP(
        -- TODO: Initial reset
        rst => platform_not_ready_s,
        clk => clk_75mhz_s,

        data_in_clk => clk_75mhz_s,
        data_in_clk_valid => platform_ready_s,

        data_out_clk => clk_75mhz_s,
        data_out_clk_valid => platform_ready_s,
        platform_ready => platform_ready_s,
        -- TODO: Should I do something with this signal?
        platform_error => platform_error_s,
        -- TODO: Indicate disc synchronization finished successfully.
        linkup => linkup_s,
        -- We don't want to disable any commands, at least for now.
        send_sync_escape => '0',
        -- TODO: Look if this is really not needed in any mysterious way.
        user_features => (others => '0'),
        sata_ready => sata_ready_s,
        sata_busy => sata_busy_s,
        hard_drive_error => hard_drive_error_s,
        -- We won't send custom commands.
        execute_command_stb => '0',
        -- TODO: Don't know what this is.
        command_layer_reset => '0',
        hard_drive_command => (others => '0'),
        pio_data_ready => open,
        sector_count => (others => '0'),
        sector_address => (others => '0'),
        dma_activate_stb => dma_activate_stb_s,
        d2h_reg_stb => d2h_reg_stb_s,
        pio_setup_stb => pio_setup_stb_s,
        d2h_data_stb => d2h_data_stb_s,
        dma_setup_stb => dma_setup_stb_s,
        set_device_bits_stb => set_device_bits_stb_s,
        d2h_fis => d2h_fis_s,
        d2h_interrupt => d2h_interrupt_s,
        d2h_notification => d2h_notification_s,
        d2h_port_mult => d2h_port_mult_s,
        d2h_device => d2h_device_s,
        d2h_lba => d2h_lba_s,
        d2h_sector_count => d2h_sector_count_s,
        d2h_status => d2h_status_s,
        d2h_error => d2h_error_s,
        user_din => data_in_s,
        user_din_stb => user_din_stb_s,
        user_din_ready => user_din_ready_s,
        user_din_activate => user_din_activate_s,
        user_din_size => user_din_size_s,
        user_din_empty => user_din_empty_s,
        user_dout => open,
        user_dout_ready => open,
        user_dout_activate => '0',
        user_dout_stb => '0',
        user_dout_size => open,
        -- TODO: Is this correct?
        transport_layer_ready => open,
        -- TODO: Is this correct?
        link_layer_ready => open,
        phy_ready => phy_ready_s,
        tx_dout => tx_dout_s,
        tx_is_k => tx_is_k_s,
        tx_comm_reset => tx_comm_reset_s,
        tx_comm_wake => tx_comm_wake_s,
        tx_elec_idle => tx_elec_idle_s,
        rx_din => rx_din_s,
        rx_is_k => rx_is_k_s,
        rx_elec_idle => rx_elec_idle_s,
        rx_byte_is_aligned => rx_byte_is_aligned_s,
        comm_init_detect => comm_init_detect_s,
        comm_wake_detect => comm_wake_detect_s,
        tx_oob_complete => tx_oob_complete_s,
        phy_error => sata_platform_error_s,
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
        slw_in_data_addra => open,
        slw_d_count => open,
        slw_write_count => open,
        slw_buffer_pos => open
    );

    -- Generate clock from clock differential pair.
    tile0_refclk_ibufds_i : IBUFDS
    port map
    (
        O => clk_150mhz_s,
        I => SATACLK_QO_N,  -- Connect to package pin Y4
        IB => SATACLK_QO_P -- Connect to package pin Y3
    );

end Behavioral;

