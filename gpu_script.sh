#!/bin/bash
# sudo pacman -S lm-sensors
# ln -s ~/.config/nvim/gpu_script.sh ~/.config/gpu_script.sh
# chmod +x ~/.config/gpu_script.sh




# Extract AMD GPU edge temperature
gpu_temp=$(sensors | awk '/amdgpu-pci-0600/,/^$/' | awk '/edge:/ { gsub(/\+|°C/, "", $2); printf "%.0f°C", $2 }')

# Extract Dell CPU temp, Processor Fan and Motherboard Fan
cpu_temp=$(sensors | awk '/dell_smm-isa-0000/,/^$/' | awk '/CPU:/ { gsub(/\+|°C/, "", $2); printf "%.0f°C", $2 }')
proc_fan=$(sensors | awk '/dell_smm-isa-0000/,/^$/' | awk '/Processor Fan:/ { print $3 " RPM" }')
mobo_fan=$(sensors | awk '/dell_smm-isa-0000/,/^$/' | awk '/Motherboard Fan:/ { print $3 " RPM" }')

# Extract NVIDIA GPU temperature
nvidia_raw=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null)
if [[ "$nvidia_raw" =~ ^[0-9]+$ && ${#nvidia_raw} -le 3 ]]; then
    nvidia_temp="${nvidia_raw}°C"
else
    nvidia_temp="N/A"
fi

# Output in one line
echo "RYZEN CPU: $cpu_temp | AMD GPU: $gpu_temp | NVIDIA GPU: $nvidia_temp | CPU Fan: $proc_fan | MB Fan: $mobo_fan"
