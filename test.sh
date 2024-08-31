#!/bin/bash

# Step 1: Update package lists and install necessary tools
echo "Updating package lists and installing necessary tools..."
sudo apt-get update
sudo apt-get install -y qemu-system-x86 qemu-utils wget

# Step 2: Download Windows Server 2022 ISO
echo "Downloading Windows Server 2022 ISO..."
wget -O windows_server_2022.iso "https://go.microsoft.com/fwlink/p/?LinkID=2206317&clcid=0x409&culture=en-us&country=US"

# Step 3: Download Virtio drivers ISO
echo "Downloading Virtio drivers ISO..."
wget -O virtio-drivers.iso "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"

# Step 6: Boot the Windows installer using QEMU with the Virtio drivers attached
echo "Booting Windows installer using QEMU with Virtio drivers attached..."
qemu-system-x86_64 -m 4096 \
-cdrom windows_server_2022.iso \
-drive file=/dev/vda1,format=raw \
-net nic -net user \
-boot d \
-device virtio-scsi-pci,id=scsi \
-drive file=virtio-drivers.iso,id=virtiocd,media=cdrom &

# Note: The QEMU process will start, and you need to manually proceed with the Windows installation through the console.

echo "Please proceed with the Windows installation in the QEMU window."
echo "When prompted to install drivers, browse to the Virtio CD-ROM drive in the installer to load the necessary drivers."

echo "Once the installation is complete, you should be able to reboot the droplet into Windows Server 2022."

# Optional: You can stop the script here or keep the console open to monitor the installation
wait
