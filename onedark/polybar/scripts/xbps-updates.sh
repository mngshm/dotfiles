#!/bin/bash 

Updates=$(xbps-install -un | wc -l) 

if [ -z "$updates" ]; then 
	echo "Fully Updated" 
else 
	echo "$updates" 
fi 

