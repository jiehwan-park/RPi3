# Feasibility Test  
## Build 
1. initialize build environment (customized to local build)
> ./init.sh
2. use github workflow yml file with act framework to build on local pc.
> act -P ubuntu-latest=ubuntu-local-action --bind
## Results : `Build/RPi3/Artifacts/`
1. Copy to RPi3 booting partition (FAT16, LBA)
2. Including :
    - RPi3 boot binaries
    - firmware image : RPI_EFI.fd
    - kernel binary and device tree
    - grub

## Update external binaries
1. ATF
  - copy (bl1.bin, fip.bin) into `edk2-non-osi/Platform/RaspberryPi/RPi3/TrustedFirmware/`
2. kernel
  - copy image file and dts into `/kernel` folder
3. grub
  - copy grub efi and cfg into `/grub` folder
## Build Output : RPI_EFI.fd 
memory map
```
1. Offset 0x0  
  Region Size = 0x10000  
  Region File Name = edk2-non-osi/Platform/RaspberryPi/RPi3/TrustedFirmware/bl1.bin  
3. Offset 0x20000  
  Region Size = 0x10000  
  Region File Name = edk2-non-osi/Platform/RaspberryPi/RPi3/TrustedFirmware/fip.bin  
2. Offset 0x30000
  Region Size = 0x1A0000
  Region Name = FV
```
trusted firmware map
```
    0x00000000 +-----------------+
               |       ROM       | BL1
    0x00010000 +-----------------+
               |     Nothing     |
    0x00020000 +-----------------+
               |       FIP       | BL2 + BL31
    0x00030000 +-----------------+
               |                 |
               |  UEFI PAYLOAD   |
               |                 |
    0x001f0000 +-----------------+
               |       DTB       | (Loaded by the VideoCore)
    0x00200000 +-----------------+
               |   Secure SRAM   | BL2, BL31
    0x00300000 +-----------------+
               |   Secure DRAM   | BL32 (Secure payload)
    0x00400000 +-----------------+
               |                 |
               |                 |
               | Non-secure DRAM | BL33
               |                 |
               |                 |
    0x01000000 +-----------------+
               |                 |
               |       ...       |
               |                 |
    0x3F000000 +-----------------+
               |       I/O       |
```

## Install to boot partition of SD Card
>├── boot  
>│   ├── aarch64  
>│   │   ├── initrd.img  
>│   │   └── kernel8.img  
>│   └── grub  
>│       ├── arm64-efi  
>│       ├── efi.img  
>│       ├── font.pf2  
>│       └── grub.cfg  
>├── EFI  
>│   ├── BOOT  
>│   │   └── bootaa64.efi  
>│   └── debian  
>│       └── grub.cfg  
>├── overlays  
>│   └── disable-bt.dtbo  
>├── bcm2710-rpi-3-b.dtb  
>├── bootcode.bin  
>├── config.txt  
>├── fixup.dat  
>├── RPI_EFI.fd  
>└── start.elf  


<br><br><br>

Raspberry Pi 3 UEFI Firmware Images
===================================

[![Build status](https://img.shields.io/github/workflow/status/pftf/RPi3/UEFI%20firmware%20-%20EDK2%20build.svg?style=flat-square)](https://github.com/pftf/RPi3/actions)
[![Github stats](https://img.shields.io/github/downloads/pftf/RPi3/total.svg?style=flat-square)](https://github.com/pftf/RPi3/releases)
[![Release](https://img.shields.io/github/release-pre/pftf/RPi3?style=flat-square)](https://github.com/pftf/RPi3/releases)

![Screenshot](https://raw.githubusercontent.com/pftf/RPi3/master/pics/Screenshot1.png)

![Screenshot](https://raw.githubusercontent.com/pftf/RPi3/master/pics/Screenshot2.png)

# Summary

This repository contains installable builds of the official
[EDK2 Raspberry Pi 3 UEFI firmware](https://github.com/tianocore/edk2-platforms/tree/master/Platform/RaspberryPi/RPi3).

The use of this firmware can __greatly simplify__ the installation of generic Linux
distributions such as [Debian](https://pete.akeo.ie/2019/07/installing-debian-arm64-on-raspberry-pi.html)
or [Ubuntu](https://github.com/tianocore/edk2-platforms/blob/master/Platform/RaspberryPi/RPi3/Systems.md#Ubuntu)
as well as [Windows 10](https://www.worproject.ml/) (in regular GUI mode, not IoT mode),
straight from their ISO images.

The original development of this firmware was carried out by
[Ard Biesheuvel](http://www.workofard.com/2017/02/uefi-on-the-pi/) and
[Andrei Warkentin](https://github.com/andreiw/RaspberryPiPkg).

# Installation

* Download the latest archive from the [Releases](https://github.com/pftf/RPi3/releases) repository.

* Create an SD card (or USB drive if you plan to use [USB Boot](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/msd.md))
  in `MBR` mode with a single partition of type `0x0c` (`FAT32 LBA`) or `0x0e`
  (`FAT16 LBA`). Then format this partition to `FAT32`.

  __Note:__ Do not try to use `GPT` for the partition scheme or `0xef` (`EFI System
  Partition`)  for the type, as these are unsupported by the CPU-embedded bootloader.

* Extract all the files from the archive onto the partition you created above.  
  Note that outside of this `Readme.md`, which you can safely remove, you should not
  change the name of the extracted files and directories.

# Usage

Insert the SD card/plug the USB drive and power up your Raspberry Pi. You should see a
multicoloured screen (which indicates that the CPU-embedded bootloader is reading the
data from the SD/USB partition) and then the Raspberry Pi black and white logo once the
UEFI firmware is ready.

At this stage, you can press <kbd>Esc</kbd> to enter the firmware setup, <kbd>F1</kbd>
to launch the UEFI Shell, or, provided you also have copied an UEFI bootloader in
`efi/boot/bootaa64.efi`, you can let the UEFI system run that (which it should do by
default if no action is taken).

# License

The firmware (`RPI_EFI.fd`) is licensed under the current EDK2 license, which is
[BSD-2-Clause-Patent](https://github.com/tianocore/edk2/blob/master/License.txt).

The other files at the root of the zip archives are licensed under the terms described in the
[Raspberry Pi boot files README](https://github.com/raspberrypi/firmware/blob/master/README.md).

The binary blobs in the `firmware/` directory are licensed under the Cypress wireless driver
license that is found there.
