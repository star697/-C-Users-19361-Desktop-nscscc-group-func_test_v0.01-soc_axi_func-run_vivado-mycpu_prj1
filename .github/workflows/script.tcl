create_project myproject ./myproject
add_files ./src/mydesign.vhd
update_compile_order -fileset sources_1
create_clock -period 10.0 -name clk [get_ports {clk}]
set_input_delay -clock clk -max 2.0 [get_ports {data_in}]
set_output_delay -clock clk -min 1.5 [get_ports {data_out}]
synth_design -top mydesign
opt_design
place_design
route_design
report_timing_summary
