#!/bin/sh
ghdl --remove

ghdl -a maquina_estados.vhd
ghdl -e maquina_estados

ghdl -a maquina_estados_tb.vhd
ghdl -e maquina_estados_tb

ghdl -r maquina_estados_tb --wave=maquina_estados_tb.ghw
