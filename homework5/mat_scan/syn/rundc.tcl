set search_path "$search_path \
				/opt/smic40/sc9mc_base_rvt_c40/r1p1/db \
                "

set synthetic_library dw_foundation.sldb

set target_library 	"sc9mc_logic0040ll_base_rvt_c40_tt_typical_max_1p10v_25c.db"
set link_library 	"sc9mc_logic0040ll_base_rvt_c40_tt_typical_max_1p10v_25c.db \
					dw_foundation.sldb"
set symbol_library 	"sc9mc_logic0040ll_base_rvt_c40.sdb"

set top             mat_scan
set RTL_PATH        "../design/${top}"


if { [file exists output ] == 0 } {
   file mkdir output
}
if { [file exists report ] == 0 } {
   file mkdir report
}
if { [file exists log ] == 0 } {
   file mkdir log
}




analyze -format sverilog -vcs "-f ${RTL_PATH}/../filelist/${top}.lst"
elaborate           $top 
current_design      $top
set_svf             ${top}.svf

link 
uniquify
check_design



compile_ultra -no_autoungroup
optimize_netlist -area

check_timing    > ./report/check_timing.rpt
check_design    > ./report/check_design.rpt
report_timing   > ./report/timing.rpt
report_area -hierarchy > ./report/area.rpt
report_power -hierarchy > ./report/power.rpt

write -format ddc -hierarchy -output ./output/${top}.ddc
write -hierarchy -output ./output/${top}.db ${top}
write -hierarchy -format verilog -output ./output/${top}.v 
write_sdf -version 2.1 ./output/${top}.sdf
write_sdc ./output/${top}.sdc

set_svf off
