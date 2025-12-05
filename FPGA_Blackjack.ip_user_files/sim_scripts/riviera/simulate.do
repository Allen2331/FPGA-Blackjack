transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+vga_core  -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.vga_core xil_defaultlib.glbl

do {vga_core.udo}

run 1000ns

endsim

quit -force
