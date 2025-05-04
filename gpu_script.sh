#!/bin/bash
# sudo pacman -S lm-sensors
# ln -s ~/.config/nvim/gpu_script.sh ~/.config/gpu_script.sh
# chmod +x ~/.config/gpu_script.sh



#!/bin/bash

# Extract AMD GPU Temp (from amdgpu)
gpu_temp=$(sensors | awk '/amdgpu-pci-0600/,/^$/' | awk '/edge:/ { gsub(/\+|°C/, "", $2); printf "%.0f°C", $2 }')

# Extract Dell CPU temp, Processor Fan and Motherboard Fan (from dell_smm)
cpu_temp=$(sensors | awk '/dell_smm-isa-0000/,/^$/' | awk '/CPU:/ { gsub(/\+|°C/, "", $2); printf "%.0f°C", $2 }')
proc_fan=$(sensors | awk '/dell_smm-isa-0000/,/^$/' | awk '/Processor Fan:/ { print $3 " RPM" }')
mobo_fan=$(sensors | awk '/dell_smm-isa-0000/,/^$/' | awk '/Motherboard Fan:/ { print $3 " RPM" }')

# Output in one line
echo "GPU: $gpu_temp | CPU: $cpu_temp | CPU Fan: $proc_fan | MB Fan: $mobo_fan"
