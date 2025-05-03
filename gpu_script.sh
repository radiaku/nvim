#!/bin/bash
# sudo pacman -S lm-sensors
# ln -s ~/.config/nvim/gpu_script.sh ~/.config/gpu_script.sh
# chmod +x ~/.config/gpu_script.sh



sensors | awk '/amdgpu-pci-0600/,/^$/' | awk '
/edge:/ { printf "NVIDIA-GPU: %.0f°C", $2 }
'
