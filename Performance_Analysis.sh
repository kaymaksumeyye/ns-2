#!/bin/bash

rm -f avgDelay_1.txt
rm -f avgDelay_2.txt	
rm -f temptr
rm -f temptr1
ns AODV_DSDV.tcl -tr temptr -rp 1; #DSDV
ns AODV_DSDV.tcl -tr temptr1 -rp 2; #AODV 
perl avgdelay.pl temptr 1
perl avgdelay.pl temptr1 2
xgraph avgDelay_1.txt -t "${j}" -x "Pouse(Second)" -y "AVERAGE DELAY DSDV" -m
xgraph avgDelay_2.txt -t "${j}" -x "Pouse(Second)" -y "AVERAGE DELAY AODV" -m
	
