#!/bin/sh

if [ $(id -u) -eq 1 ]
then 
	echo "ERROR: Script cannot be run as root"
	exit 1
fi

sudo pacman -S fish

fish ./full_setup.fish
