set val(chan)       Channel/WirelessChannel ;
set val(prop)       Propagation/TwoRayGround ;
set val(netif)      Phy/WirelessPhy ;
set val(mac)	      Mac/802_11 ;
set val(ifq)	      Queue/DropTail ;
set val(ll)	        LL ;
set val(ant)        Antenna/OmniAntenna ;
set val(ifqlen)	    50 ;
set val(nn)         5 ;
set val(rp)	        AODV ;
set val(x)          1000 ;
set val(y)	        1000 ;
set val(stop)       150 ;
set val(tr)         temptr
	

  for {set i 0} {$i < $argc} {incr i} {
      set arg [lindex $argv $i]
      if {[string range $arg 0 0] != "-"} continue
      set name [string range $arg 1 end]
      set val($name) [lindex $argv [expr $i+1]]
  }
       
  if {$val(rp) == 1} {
	set val(rp)     DSDV
	set val(ifq)	CMUPriQueue
  } else {
	set val(rp)   AODV
	set val(ifq) Queue/DropTail/PriQueue
  }

	set ns_		[new Simulator]
	set tracefd     [open $val(tr) w]
	set windowVsTime2 [open win.tr w]
        set namtrace  	[open tez2.nam w]

	$ns_ trace-all $tracefd
        $ns_ namtrace-all-wireless $namtrace $val(x) $val(y)
	set topo       [new Topography]
	$topo load_flatgrid $val(x) $val(y)
	# use new trace file format
	$ns_ use-newtrace 
 	global val node_ god_ chan topo


	set god_ [create-god $val(nn)]
	set chan [new $val(chan)]

	# configure node
	$ns_ node-config -adhocRouting $val(rp) \
			-llType $val(ll) \
			-macType $val(mac) \
			-ifqType $val(ifq) \
			-ifqLen $val(ifqlen) \
			-antType $val(ant) \
			-propType $val(prop) \
			-phyType $val(netif) \
			-topoInstance $topo \
			-agentTrace ON \
			-routerTrace ON \
			-macTrace OFF \
			-movementTrace OFF \
			-channel $chan

 	for {set i 0} {$i < $val(nn) } {incr i} {
		set node_($i) [$ns_ node]
		$node_($i) random-motion 0
	}

	$node_(0) set X_ 250.0
	$node_(0) set Y_ 50.0 
	$node_(0) set Z_ 0.0

	$node_(1) set X_ 250.0
	$node_(1) set Y_ 500.0 
	$node_(1) set Z_ 0.0

	$node_(2) set X_ 200.0
	$node_(2) set Y_ 350.0 
	$node_(2) set Z_ 0.0
	
	$node_(3) set X_ 380.0
	$node_(3) set Y_ 320.0 
	$node_(3) set Z_ 0.0

	$node_(4) set X_ 250.0
	$node_(4) set Y_ 180.0 
	$node_(4) set Z_ 0.0
	$ns_ at 50.0 "$node_(0) setdest 490.0 400.0 5.0"

	for {set i 0} {$i < $val(nn)} { incr i } {
	    $ns_ initial_node_pos $node_($i) 20
  }

	set tcp(0) [new Agent/TCP/Newreno]
	$tcp(0) set class_ 1
	set sink(0) [new Agent/TCPSink]
	$ns_ attach-agent $node_(0) $tcp(0)
	$ns_ attach-agent $node_(1) $sink(0)
	$ns_ connect $tcp(0) $sink(0)
	$tcp(0) set maxcwnd_ 15
	set ftp [new Application/FTP]
	$ftp attach-agent $tcp(0)
	$ns_ at 10.0 "$ftp start"
	$ns_ at 145.0 "$ftp stop"
	proc plotWindow {tcpSource file} {
		global ns_
		set time 0.1
		set now [$ns_ now]
		set cwnd [$tcpSource set maxcwnd_]
		puts $file "$now $cwnd"
		$ns_ at [expr $now+$time] "plotWindow $tcpSource $file" 
        }
	$ns_ at 0.01 "plotWindow $tcp(0) $windowVsTime2"

	for {set i 0} {$i < $val(nn) } {incr i} {
	    $ns_ at $val(stop) "$node_($i) reset";
	}

	$ns_ at $val(stop) " finish"

	proc finish {} {
		global tracefd ns_ namtrace
		exec nam tez2.nam &
		$ns_ flush-trace
		close $tracefd

 		close $namtrace
		exit 0
	}

	$ns_ run

