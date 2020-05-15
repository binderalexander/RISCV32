#*******************************************************************************
#* This file is part of fhlow (fast handling of a lot of work), a working
#* environment that speeds up the development of and structures FPGA design
#* projects.
#* 
#* Copyright (c) 2011-2016 Michael Roland <michael.roland@fh-hagenberg.at>
#* 
#* This program is free software: you can redistribute it and/or modify
#* it under the terms of the GNU General Public License as published by
#* the Free Software Foundation, either version 3 of the License, or
#* (at your option) any later version.
#* 
#* This program is distributed in the hope that it will be useful,
#* but WITHOUT ANY WARRANTY; without even the implied warranty of
#* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#* GNU General Public License for more details.
#* 
#* You should have received a copy of the GNU General Public License
#* along with this program.  If not, see <http://www.gnu.org/licenses/>.
#*******************************************************************************

# Clock constraints
create_clock -name "SYSCLK" -period 20ns [get_ports {iClk}] -waveform {0.000ns 10.000ns}

# HPS inputs
#create_clock -name "HPS_I2C1_SCLK" -period 2500ns [get_ports {HPS_I2C1_SCLK}] -waveform {0.000ns 1250.000ns}
#create_clock -name "HPS_I2C2_SCLK" -period 2500ns [get_ports {HPS_I2C2_SCLK}] -waveform {0.000ns 1250.000ns}
#create_clock -name "HPS_USB_CLKOUT" -period 16ns [get_ports {HPS_USB_CLKOUT}] -waveform {0.000ns 8.000ns}

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty


# tsu/th constraints
#set_input_delay -clock "SYSCLK" -max ...ns [get_ports {myPort1}] 
#set_input_delay -clock "SYSCLK" -min ...ns [get_ports {myPort1}] 


# tco constraints
#set_output_delay -clock "SYSCLK" -max ...ns [get_ports {myPort2}] 
#set_output_delay -clock "SYSCLK" -min -...ns [get_ports {myPort2}] 


# Synchronizer inputs are asynchronous
set_false_path -to [get_keepers -no_case {Sync:*|Metastable[0]}]
