#!/bin/bash
set -e 

if [[ ! -f kali-linux-2019.3-amd64.iso ]]; then
	echo "Downloading kali"
	wget -O kali-linux-2019.3-amd64.iso https://cdimage.kali.org/kali-2019.3/kali-linux-2019.3-amd64.iso
fi

if ! command -v qemu-system-x86_64 >/dev/null 2>/dev/null; then
	echo "No qemu available, install it:"
	echo "$ brew install qemu"
fi

if [[ ! -f kali.qcow2 ]]; then
	qemu-img create -f qcow2 kali.qcow2 30G
fi

exec qemu-system-x86_64 -cdrom kali-linux-2019.3-amd64.iso -hda kali.qcow2 -usb -m 1024 -boot d -net nic -net user  -accel hvf
