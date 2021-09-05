#!/bin/bash 
updates=$(pacman -Qu | wc -l) 

if [ -z "$updates" ]; then 
	echo "Fully Updated" 
else 
	echo "$updates" 
fi 

