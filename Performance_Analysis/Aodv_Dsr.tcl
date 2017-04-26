set val(chan)	        Channel/WirelessChannel
set val(prop)	        Propagation/TwoRayGround
set val(netif)	        Phy/WirelessPhy
set val(mac)	        Mac/802_11
set val(ifq)	        CMUPriQueue
set val(ll)		LL
set val(ant)            Antenna/OmniAntenna
set val(x)		500   
set val(y)		500   
set val(ifqlen)	        50	      
set val(seed)		0.0   
set val(rp)   		AODV
set val(nn)             50         
set val(scen)		"movement/scen-25-0" 
set val(tfc)		"home/sumeyye/cbr-gen" 
set val(stop)		100.0		

	if { $argc != 8 } {
		puts "Wrong no. of cmdline args."
		puts "Usage: ns compare.tcl -scen <scen> -tfc <tfc> -tr <tr> -rpr <rpr>"
		exit 0
	}


 
        for {set i 0} {$i < $argc} {incr i} {
                set arg [lindex $argv $i]
                if {[string range $arg 0 0] != "-"} continue
                set name [string range $arg 1 end]
                set val($name) [lindex $argv [expr $i+1]]
        }
	set val(scen) [lindex $argv 1]
	set val(tfc) [lindex $argv 3]
       
        if {$val(rpr) == 1} {
	set val(rp)   DSR
	set val(ifq)  CMUPriQueue
        } else {
	set val(rp)   AODV
	set val(ifq)  Queue/DropTail/PriQueue
        }

	set deger $val(scen)

	# create simulator instance
	set ns_		[new Simulator]

	# set wireless channel, radio-model and topography objects
	set wtopo	[new Topography]

	# create trace object for ns and nam
	set tracefd	[open $val(tr) w]
	$ns_ trace-all $tracefd
	# use new trace file format
	$ns_ use-newtrace 

	# define topology
	$wtopo load_flatgrid $val(x) $val(y)

	# Create God
	set god_ [create-god $val(nn)]

	#global node setting
	$ns_ node-config -adhocRouting $val(rp) \
		 -llType $val(ll) \
		 -macType $val(mac) \
		 -ifqType $val(ifq) \
		 -ifqLen $val(ifqlen) \
		 -antType $val(ant) \
		 -propType $val(prop) \
		 -phyType $val(netif) \
		 -channelType $val(chan) \
		 -topoInstance $wtopo \
		 -agentTrace ON \
                 -routerTrace ON \
                 -macTrace OFF 


	for {set i 0} {$i < $val(nn) } {incr i} {
		set node_($i) [$ns_ node]	
		$node_($i) random-motion 0	
	}

	# Define node movement model
	source $val(scen)
	 
	# Define traffic model
	source $val(tfc)

	# Define node initial position in nam
	for {set i 0} {$i < $val(nn)} {incr i} {
	   $ns_ initial_node_pos $node_($i) 20
	}

	# Tell nodes when the simulation ends
	for {set i 0} {$i < $val(nn) } {incr i} {
	    $ns_ at $val(stop).000000001 "$node_($i) reset";
	}


	$ns_ at  $val(stop).000000001 "puts \"NS EXITING...\" ; $ns_ halt"

	$ns_ run
