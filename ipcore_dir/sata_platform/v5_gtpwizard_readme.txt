

                    Core Name: Xilinx LogiCORE Virtex-5 FPGA RocketIO GTP Transceiver Wizard
                    Version: 2.1
                    Release Date: April 19, 2010


===============================================================================

This document contains the following sections:

1. Introduction
2. New Features
3. Supported Devices
4. Resolved Issues
5. Known Issues
6. Technical Support
7. Core Release History
8. Legal Disclaimer

===============================================================================

1. INTRODUCTION

For the most recent updates to the IP installation instructions for this core,
please go to:

   http://www.xilinx.com/ipcenter/coregen/ip_update_install_instructions.htm


For system requirements:

   http://www.xilinx.com/ipcenter/coregen/ip_update_system_requirements.htm



This file contains release notes for the Xilinx Virtex-5 FPGA GTP
Transceiver Wizard v2.1. For the latest core updates, see the product
page at:

   http://www.xilinx.com/products/ipcenter/V5_RocketIO_Wizard.htm


2. NEW FEATURES

   - Supports ISE 12.1
   
   - Virtex-5 QPro family support   

3. SUPPORTED DEVICES

   - Virtex5-LXT/SXT, QVirtex5-LXT/SXT

4. RESOLVED ISSUES

   - Fixed CR 550316, 547131, 501286, 479407

5. KNOWN ISSUES

   The following are known issues for v2.1 of this core at time of release:

   - If you set the comma alignment smaller than the datapath width, incoming
     data can be aligned to multiple positions.  The example design does not
     account for this, and may indicate errors even though data is being
     received correctly.

   - In the case of Clock correction, the GTP wrapper in the Example design is
     configured correctly but the BRAM data does not have embedded
     Clock-correction characters.

   - CR 550806: The design fails in functional simulation because of simplified 
     behavioral modeling of the CDR (clock and data recovery) in the PMA.This 
     occurs for low linerate designs which uses rxrecclk to generate the user 
     clocks.The workaround for the issue is to reset the RXUSRCLK DCM beyond 
     the point where the serial lines have become 1/0

   - RX buffer bypass in Oversampling mode is not supported.

   The most recent information, including known issues, workarounds, and
   resolutions for this version is provided in the release notes Answer Record
   for the ISE 12.1 IP Update at

   http://www.xilinx.com/support/documentation/user_guides/xtp025.pdf


6. TECHNICAL SUPPORT

   To obtain technical support, create a WebCase at www.xilinx.com/support.
   Questions are routed to a team with expertise using this product.

   Xilinx provides technical support for use of this product when used
   according to the guidelines described in the core documentation, and
   cannot guarantee timing, functionality, or support of this product for
   designs that do not follow specified guidelines.


7. CORE RELEASE HISTORY

Date        By            Version      Description
===============================================================================
04/19/2010  Xilinx, Inc.  2.1          ISE 12.1 Release
06/24/2009  Xilinx, Inc.  1.10         ISE 11.2 Release
06/27/2008  Xilinx, Inc.  1.9          TX Phase Alignment updates  
03/24/2008  Xilinx, Inc.  1.8          ISim,IPProtect,SRIO,SX240T support
10/10/2007  Xilinx, Inc.  1.7          Extended lxt package support
08/15/2007  Xilinx, Inc.  1.6          9.2i support
05/17/2007  Xilinx, Inc.  1.5          CPRI and OBSAI support
03/01/2007  Xilinx, Inc.  1.4          Extensive new features
11/30/2006  Xilinx, Inc.  1.3          Bug fixes
10/10/2006  Xilinx, Inc.  1.2          Initial release
===============================================================================


8. Legal Disclaimer

(c) Copyright 2006 - 2010 Xilinx, Inc. All rights reserved.

This file contains confidential and proprietary information
of Xilinx, Inc. and is protected under U.S. and
international copyright and other intellectual property
laws.

DISCLAIMER
This disclaimer is not a license and does not grant any
rights to the materials distributed herewith. Except as
otherwise provided in a valid license issued to you by
Xilinx, and to the maximum extent permitted by applicable
law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
(2) Xilinx shall not be liable (whether in contract or tort,
including negligence, or under any other theory of
liability) for any loss or damage of any kind or nature
related to, arising under or in connection with these
materials, including for any direct, or any indirect,
special, incidental, or consequential loss or damage
(including loss of data, profits, goodwill, or any type of
loss or damage suffered as a result of any action brought
by a third party) even if such damage or loss was
reasonably foreseeable or Xilinx had been advised of the
possibility of the same.

CRITICAL APPLICATIONS
Xilinx products are not designed or intended to be fail-
safe, or for use in any application requiring fail-safe
performance, such as life-support or safety devices or
systems, Class III medical devices, nuclear facilities,
applications related to the deployment of airbags, or any
other applications that could lead to death, personal
injury, or severe property or environmental damage
(individually and collectively, "Critical
Applications"). Customer assumes the sole risk and
liability of any use of Xilinx products in Critical
Applications, subject only to applicable laws and
regulations governing limitations on product liability.

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
PART OF THIS FILE AT ALL TIMES.


