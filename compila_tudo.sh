#!/bin/sh
ghdl --remove
ghdl -a registrador.vhd
ghdl -e reg8bits
ghdl -a banco_registradores.vhd
ghdl -e banco_registradores
ghdl -a banco_registradores_tb.vhd
ghdl -e banco_registradores_tb
ghdl -r banco_registradores_tb --wave=banco_registradores_tb.ghw
