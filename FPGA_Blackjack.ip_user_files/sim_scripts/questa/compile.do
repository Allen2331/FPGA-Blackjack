vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu  -sv "+incdir+../../../FPGA_Blackjack.gen/sources_1/ip/clk_wiz_0" "+incdir+../../../FPGA_Blackjack.gen/sources_1/ip/clk_wiz_1" \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm  -93  \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../FPGA_Blackjack.gen/sources_1/ip/clk_wiz_0" "+incdir+../../../FPGA_Blackjack.gen/sources_1/ip/clk_wiz_1" \
"../../../FPGA_Blackjack.gen/sources_1/ip/clk_wiz_0/clk_wiz_0_clk_wiz.v" \
"../../../FPGA_Blackjack.gen/sources_1/ip/clk_wiz_0/clk_wiz_0.v" \
"../../../FPGA_Blackjack.srcs/sources_1/new/vga_core.v" \

vlog -work xil_defaultlib \
"glbl.v"

