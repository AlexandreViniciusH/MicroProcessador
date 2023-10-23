#!/bin/sh
ghdl --remove

ghdl -a registrador7b.vhd
ghdl -e registrador7b

ghdl -a maquina_estados.vhd
ghdl -e maquina_estados

ghdl -a PC.vhd
ghdl -e PC

ghdl -a rom.vhd
ghdl -e rom

ghdl -a PC_tb.vhd
ghdl -e PC_tb

ghdl -a LAB_4.vhd
ghdl -e LAB_4

ghdl -a LAB_4_tb.vhd
ghdl -e LAB_4_tb

ghdl -a unidade_controle.vhd
ghdl -e unidade_controle

ghdl -a unidade_controle_tb.vhd
ghdl -e unidade_controle_tb

ghdl -r unidade_controle_tb --wave=unidade_controle_tb.ghw
