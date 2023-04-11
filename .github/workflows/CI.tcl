vivado -mode tcl
open_project mycpu.xpr
-source script.tcl mycpu.xpr
update_compile_order -fileset SampleCPU
set simulations [get_fileset $env(SIMULATION)]
if { [llength simulations] != 0} {
 foreach sim $simulations {
                update_compile_order -fileset $sim
                launch_simulation -simset $sim
                # make simulation complete
                run all
 }
}
update_compile_order -fileset sources_1
if { [llength [get_ips]] != 0} {
    upgrade_ip [get_ips]
    foreach ip [get_ips] {
        create_ip_run [get_ips $ip]
    }
    set ip_runs [get_runs -filter {SRCSET != sources_1 && IS_SYNTHESIS && STATUS != "synth_design Complete!"}]
    if { [llength $ip_runs] != 0} {
        launch_runs -quiet -jobs 2 {*}$ip_runs
        foreach r $ip_runs {
            wait_on_run $r
        }
    }
}
update_compile_order -fileset sources_1
reset_run impl_1
reset_run synth_1
launch_runs -jobs 2 impl_1 -to_step write_bitstream
wait_on_run impl_1
