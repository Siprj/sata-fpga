
Core name    : Xilinx LogiCORE Virtex-5 FPGA RocketIO GTP Transceiver Wizard
Version      : 2.1
Release Date : April 19, 2010
File         : readme_sata.txt

############################
# README FOR SATA PROTOCOL #
############################

SATA Gen 1/II (Rev 1.0a) and SATA Gen 2 (Rev 1.0a) are supported by Virtex-5
RocketIO GTP Transceiver.
Some of the supported features are : OOB Signaling (including COM signal support),
LOS and Rate Negotiation for Gen2.


# OOB Signaling Support in RocketIO GTP Transceiver
SATA specifies the use of OOB signaling for Reset and Power Management.

To transmit an OOB signal, the RocketIO GTP transmitter reduces the
differential output to a common mode, irrespective of the data being
transmitted. SATA uses OOB signals in its COMRESET,COMINIT and COMWAKE
sequences. The 'Type', 'Number of Bursts' and 'Timing of the COM' sequence
can be controlled in the Transmitter. The Timing of the COM sequence needs
to be changed for changing SATA rate at run time (autonegotiation). The
Dynamic Reconfiguration Port can be used to change the Timing at run time.
For more information on Transmitter support for OOB signaling, please refer to
the topic "TX Out of Band (OOB) Signaling" in chapter "GTP Transmitter (TX)"
in Section1 of the Virtex-5 RocketIO GTP Transceiver User Guide (UG196).

The Receiver detects an OOB signal when the differential voltage drops
below a preset threshold. The RocketIO GTP Receiver has analog circuitry
to detect the OOB signal state and state machines to decode bursts of
SATA OOB signals (COMRESET,COMINIT,COMWAKE sequences).
For more information on the SATA OOB Detector, please refer to
the topic "RX OOB Signaling" in chapter "GTP Receiver (RX)" in
Section1 of the Virtex-5 RocketIO GTP Transceiver User Guide (UG196).

# A NOTE on the Example design generated from sata/sata2 protocol file
The Example design demonstrates the Recommended Attribute/Port settings
required by the SATA protocol @ 1.5Gbps(sata)/3Gbps(sata2). All the Ports
required to control TX/RX OOB signaling are brought out to the top-level.
SATA employs Spread Spectrum Clocking(SSC). SSC is enabled in the example
design.

Typically a Reference Clock of 150 Mhz is used for SATA. Please refer
to the Xilinx Generic Interface SuperClock Module User Guide (UG091) for
configuring the Xilinx Generic Interface (XGI) SuperClock Module to
generate the appropriate reference clock.


# REFERENCES
1. UG196 : Virtex-5 RocketIO GTP Transceiver User Guide
2. UG091 : Xilinx Generic Interface (XGI) SuperClock Module User Guide

==============

// 
// 
// (c) Copyright 2006-2010 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES. 


