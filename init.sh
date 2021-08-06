#!/bin/bash

GREEN="\033[1;32m"
NC="\033[0m"

echo -e "\n\n${GREEN}1. Init & update git submoduler${NC}\n"
git submodule update --init --recursive

echo -e "\n\n${GREEN}2. create local docker image of ubuntu ${NC}\n"
# github workflow(action) will use this and it will reduce build time consumption.
# act option : "-P ubuntu-latest=ubuntu-local-action"
docker build -t ubuntu-local-action .

echo -e "\n\n${GREEN}3. download RPi3 boot firmware${NC}\n"
# copy RPi3 boot firmware included into FD archive.
[ -d "rpi3-boot" ] && rm -rf rpi3-boot
mkdir rpi3-boot
cd rpi3-boot
curl -O -L https://github.com/raspberrypi/firmware/raw/master/boot/bootcode.bin
curl -O -L https://github.com/raspberrypi/firmware/raw/master/boot/fixup.dat
curl -O -L https://github.com/raspberrypi/firmware/raw/master/boot/start.elf
cd -
