onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib ufo_rom_opt

do {wave.do}

view wave
view structure
view signals

do {ufo_rom.udo}

run -all

quit -force
