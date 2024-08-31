#!/bin/bash

# Variables
WINDOWS_ISO_URL="https://go.microsoft.com/fwlink/p/?LinkID=2206317&clcid=0x409&culture=en-us&country=US"
VIRTIO_ISO_URL="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"
WINDOWS_ISO="windows_server_2022.iso"
VIRTIO_ISO="virtio-drivers.iso"
WINDOWS_IMG="windows_server_2022.img"
DISK_DEVICE="/dev/vda" # This may vary depending on your droplet configuration

# Step 1: Update and install necessary tools
echo "Updating package lists and installing necessary tools..."
apt-get update
apt-get install -y qemu-utils wget

# Step 2: Download Windows Server 2022 ISO
echo "Downloading Windows Server 2022 ISO..."
wget -O $WINDOWS_ISO $WINDOWS_ISO_URL

# Step 3: Download Virtio drivers ISO
echo "Downloading Virtio drivers ISO..."
wget -O $VIRTIO_ISO $VIRTIO_ISO_URL

# Step 4: Convert Windows ISO to IMG format
echo "Converting Windows ISO to IMG format..."
qemu-img convert -f raw -O raw $WINDOWS_ISO $WINDOWS_IMG

# Step 5: Mount the Windows IMG (for reference, not mandatory)
echo "Mounting Windows IMG..."
mkdir -p /mnt/windows
mount -o loop $WINDOWS_IMG /mnt/windows

# Step 6: Boot the Windows installer using QEMU
echo "Booting Windows installer using QEMU..."
qemu-system-x86_64 -m 4096 -cdrom $WINDOWS_ISO -drive file=$DISK_DEVICE,format=raw -net nic -net user -boot d &

# Note: The QEMU process will start, and you need to manually proceed with the Windows installation through the console.

echo "Please proceed with the Windows installation in the QEMU window."
echo "During the installation, load the Virtio drivers when prompted to install the disk or network drivers."
echo "You may need to use the following command to attach the Virtio drivers ISO in another QEMU session if required:"

echo "qemu-system-x86_64 -m 4096 -cdrom $VIRTIO_ISO -drive file=$DISK_DEVICE,format=raw -net nic -net user -boot d"

echo "Once the installation is complete, you should be able to reboot the droplet into Windows Server 2022."

# Optional: You can stop the script here or keep the console open to monitor the installation
wait
