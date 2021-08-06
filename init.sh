#!/bin/bash

GREEN="\033[1;32m"
NC="\033[0m"

echo -e "\n\n${GREEN}1. Init & update git submoduler${NC}\n"
git submodule update --init --recursive

echo -e "\n\n${GREEN}2. create local docker image of ubuntu ${NC}\n"
# github workflow(action) will use this and it will reduce build time consumption.
# act option : "-P ubuntu-latest=ubuntu-local-action"
docker build -t ubuntu-local-action .
