#!/bin/bash

./make-scenario.sh
for i in 1 2 3;
do
    for j in 50 100 150
    do
	rm -f packetDelivery_1.txt
        rm -f packetDelivery_2.txt
	#rm -f routingLoad_1.txt
	#rm -f routingLoad_2.txt
	rm -f avgDelay_1.txt
	rm -f avgDelay_2.txt
	for k in 0 20 40 80 120 160 200
	do		
	    rm -f dsr
	    rm -f aodv
	    ns Aodv_Dsr.tcl -scen Scenario_${i}/scen_${j}_${k} -tfc cbr_gen -tr dsr -rpr 1;
	    ns Aodv_Dsr.tcl -scen Scenario_${i}/scen_${j}_${k} -tfc cbr_gen -tr aodv -rpr 2; 
	    perl perl_script.pl dsr ${k} 1
	    perl perl_script.pl aodv ${k} 2
	    perl avgdelay.pl dsr ${k} 1
	    perl avgdelay.pl aodv ${k} 2
	done
	xgraph packetDelivery_1.txt packetDelivery_2.txt -t "${j}" -x "Pause(Second)" -y "Packet Delivery Rate" -m
	xgraph avgDelay_1.txt avgDelay_2.txt -t "${j}" -x "Pause(Second)" -y "AVERAGE DELAY" -m
	#xgraph routingLoad_1.txt routingLoad_2.txt -t "${j}" -x "Pause(Second)" -y "ROUTING LOAD" -m
	done
done
