#/**************************************************/
#/* Compile Script for Synopsys                    */
#/*                                                */
#/* dc_shell-t -f compile_dc.tcl                   */
#/*                                                */
#/* OSU FreePDK 45nm                               */
#/**************************************************/

#/* All verilog files, separated by spaces         */
set my_verilog_files [list mux.sv top.sv ]
#set my_verilog_files [list mux.v top.v ]



#/* Top-level Module                               */
set my_toplevel top_level

#/* The name of the clock pin. If no clock-pin     */
#/* exists, pick anything                          */
#set my_clock_pin clk

#/* Target frequency in MHz for optimization       */
#set my_clk_freq_MHz 200

#/* Delay of input signals (Clock-to-Q, Package etc.)  */
#set my_input_delay_ns 0.1

#/* Reserved time for output signals (Holdtime etc.)   */
#set my_output_delay_ns 0.1


#/**************************************************/
#/* No modifications needed below                  */
#/**************************************************/
#set PDK_DIR ~/ece/FreePDK45
set PDK_DIR /ubc/ece/home/ta/grads/taylerh/FreePDK45/FreePDK45/
set OSU_FREEPDK [format "%s%s"  $PDK_DIR "/osu_soc/lib/files"]
set search_path [concat  $search_path $OSU_FREEPDK]
set alib_library_analysis_path $OSU_FREEPDK

set link_library [set target_library [concat  [list gscl45nm.db] [list dw_foundation.sldb]]]
set target_library "gscl45nm.db"

define_design_lib WORK -path ./WORK


#set verilogout_show_unconnected_pins "true"
#set_ultra_optimization true
#set_ultra_optimization -force


analyze -format sverilog $my_verilog_files
#analyze -format verilog $my_verilog_files

#elaborate $my_toplevel -architecture RTL
elaborate $my_toplevel

current_design $my_toplevel

link
uniquify


#set my_period [expr 1000 / $my_clk_freq_MHz]

#set find_clock [ find port [list $my_clock_pin] ]
#if {  $find_clock != [list] } {
#   set clk_name $my_clock_pin
#   create_clock -period $my_period $clk_name
#} else {
#   set clk_name vclk
#   create_clock -period $my_period -name $clk_name
#}

#set_switching_activity -static_probability 0.5 -toggle_rate 0.5 -base_clock $my_clock_pin i_inputs
#set_switching_activity -static_probability 0.5 -toggle_rate 0.5 -base_clock $my_clock_pin i_synapses
#set_switching_activity -static_probability 0.5 -toggle_rate 0.5 -base_clock $my_clock_pin i_nbout_to_nfu2


set_switching_activity -static_probability 0.5 -toggle_rate 0.5 -period 1.02 i_inputs
set_switching_activity -static_probability 0.5 -toggle_rate 0.5 -period 1.02 i_sel

#set_driving_cell  -lib_cell INVX1  [all_inputs]
#set_switching_activity -static_probability 0.5 -toggle_rate 1 -period 62.5 in_colors
#set_switching_activity -static_probability 0.5 -toggle_rate 1 -period 62.5 din_0
#set_switching_activity -static_probability 0.5 -toggle_rate 1 -period 62.5 sel

#set_switching_activity "" "" -base_clock $my_clock_pin signal
#set_switching_activity -static_probability 0.5 -toggle_rate 0.5 -period 2 data_in
#set_switching_activity -static_probability 0 rst
#set_switching_activity -static_probability 0 new_frame
#set_input_delay $my_input_delay_ns -reference_pin clk [remove_from_collection [all_inputs] clk]
#set_output_delay $my_output_delay_ns -reference_pin clk [all_outputs]

compile_ultra
#compile_ultra -no_autoungroup
#compile -power_effort high
#-map_effort medium 
#compile -ungroup_all -map_effort medium

#compile -incremental_mapping -map_effort medium

check_design
report_constraint -all_violators

set filename [format "%s%s"  $my_toplevel ".vh"]
write -f verilog -output $filename

set filename [format "%s%s"  $my_toplevel ".sdc"]
write_sdc $filename

set filename [format "%s%s"  $my_toplevel ".db"]
write -f db -hier -output $filename -xg_force_db

redirect timing.rep { report_timing }
redirect cell.rep { report_cell }
redirect power.rep { report_power }

quit
