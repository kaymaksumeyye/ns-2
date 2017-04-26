#!/usr/bin/perl
#use strict;
use warnings;
$openFile=$ARGV[2];
$oneLine=$ARGV[1];
open(Trace, $ARGV[0]);
$sendTime = 0;
$recvTime = 0;
$packet_id = 0;
$delay = 0;
$recvPacketCount = 0;
$totalDelay = 0;
$avgDelay = 0;

open (AVGDELAY, ">>avgDelay_$openFile.txt");

while(<Trace>)
{
	@line = split; 
	if(($line[0] eq 's') && ($line[18] eq 'AGT'))
	{
		$sendTime = $line[2];
		$packet_id = $line[40];
		while(<Trace>)
		{
         	    @line=split;
		    if(($line[0] eq 'r') && ($line[18] eq 'AGT'))
		    {
			if(($line[40] == $packet_id))
			{
				$recvTime = $line[2];
				$recvPacketCount++;
				$delay = ($recvTime - $sendTime)/1000;
				$totalDelay = $totalDelay + $delay;
				#print AVGDELAY ("$sendTime $delay\n");
				last;
			}
		   }
	      }
	}
}

if($recvPacketCount != 0 )
{
	$avgDelay = $totalDelay / $recvPacketCount;
	$avgDelay = $avgDelay * 1000;
	#print("\navgDelay = $avgDelay milisecond");
	print AVGDELAY ("$oneLine $avgDelay\n");
}
else
{
	#print("\n Package not received");
}
close(Trace);
close(AVGDELAY);
exit(0);
