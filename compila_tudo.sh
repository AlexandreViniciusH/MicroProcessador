#!/bin/sh
ghdl --remove

ghdl -a ULA.vhd
ghdl -e ULA

ghdl -a registrador7b.vhd
ghdl -e registrador7b

ghdl -a registrador8b.vhd
ghdl -e registrador8b

ghdl -a banco_registradores.vhd
ghdl -e banco_registradores

ghdl -a maquina_estados.vhd
ghdl -e maquina_estados

ghdl -a PC.vhd
ghdl -e PC

# ghdl -a PC_tb.vhd
# ghdl -e PC_tb

ghdl -a rom.vhd
ghdl -e rom

ghdl -a unidade_controle.vhd
ghdl -e unidade_controle

# ghdl -a unidade_controle_tb.vhd
# ghdl -e unidade_controle_tb

ghdl -a processador.vhd
ghdl -e processador

ghdl -a processador_tb.vhd
ghdl -e processador_tb

ghdl -r processador_tb --wave=processador_tb.ghw
