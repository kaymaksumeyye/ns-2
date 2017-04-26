#!/bin/bash

setdest_loc="ns-allinone-2.35/ns-2.35/indep-utils/cmu-scen-gen/setdest/setdest";
cd ns-allinone-2.35/ns-2.35/indep-utils/cmu-scen-gen 
ns cbrgen.tcl -type tcp -nn 50 -seed 1.0 -mc 20 -rate 4.0 > cbr_gen
cd
# Create the scenarios

for dir_num in 1 2 3
do
dest_dir=Scenario_${dir_num}

if [ -d $dest_dir ]
then
	# Do nothing
	echo "'$dest_dir' is a directory"
else
	echo "Creating directory $dest_dir";
	mkdir --verbose $dest_dir
	for node_num in 50 100 150
	do
	  for pause_time in 0 20 40 80 120 160 200
	  do
	#-t simülasyon zamanı, -s max hareket hızı, -p duraklama zamanı, x y gidilebilecek koordinatlar,-n hareketli dügüm sayısı
	     $setdest_loc -v 1 -n ${node_num} -p ${pause_time} -M 20.0 -t 2000 -x 500 -y 500 > Scenario_${dir_num}/scen_${node_num}_${pause_time}
	  done
	done
fi
done

