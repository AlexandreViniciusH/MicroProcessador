#!/bin/sh
ghdl --remove

ghdl -a registrador.vhd
ghdl -e reg8bits

ghdl -a ULA.vhd
ghdl -e ULA

ghdl -a banco_registradores.vhd
ghdl -e banco_registradores

# ghdl -a banco_registradores_tb.vhd
# ghdl -e banco_registradores_tb
# ghdl -r banco_registradores_tb --wave=banco_registradores_tb.ghw

ghdl -a top_level.vhd
ghdl -e top_level

ghdl -a top_level_tb.vhd
ghdl -e top_level_tb
ghdl -r top_level_tb --wave=top_level_tb.ghw