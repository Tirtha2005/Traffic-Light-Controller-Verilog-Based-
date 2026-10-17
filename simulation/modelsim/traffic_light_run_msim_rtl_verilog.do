transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/VICTUS/Downloads/traffic_light {C:/Users/VICTUS/Downloads/traffic_light/traffic_light.v}

