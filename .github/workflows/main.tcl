# Set the project name and design file name
set project_name mycpu
set design_file C:/Users/19361/Desktop_mycpu.v

# Check if the project is already open
if { [get_projects] eq "" } {
  # If the project is not open, open it
  open_project $project_name.xpr
}

# Set the output file name
set output_file mycpu.xpr

# Set the refresh interval in seconds
set refresh_interval 5



# Loop forever, refreshing every $refresh_interval seconds
while {1} {
  # Get the last modified time of the design file
  set last_modified_time [file mtime $design_file]

  # Check if the design file has been modified
  if { $last_modified_time > [get_property last_modified [get_files $design_file]] } {
    # If the design file has been modified, run the Vivado operations
    puts "Design file modified, running Vivado operations..."

    # Synthesize the design
    synth_design -top my_top_module

    # Implement the design
    place_design
    route_design

    # Generate the bitstream file
    write_bitstream -force $output_file

    puts "Vivado operations complete."
  }

  # Wait for the refresh interval
  after [expr { $refresh_interval * 1000 }]
}
