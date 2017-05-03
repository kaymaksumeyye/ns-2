#!/usr/bin/perl
#use strict;
use warnings;
$openFile=$ARGV[1];
open(Trace, $ARGV[0]);
@sendTime=(0,0,0);
@recvTime=(0,0,0);
@packet_id=(0,0,0);
$delay = 0;
$count=0;
open (AVGDELAY, ">>avgDelay_$openFile.txt");

while(<Trace>)
{
	@line = split; 
	if(($line[0] eq 's') && ($line[18] eq 'AGT')){
		$sendTime[$count] = $line[2];
		$packet_id[$count] = $line[40];	# printf("$packet_id[$count] ");	
	        $count++;  
        }
 	if(($line[0] eq 'r') && ($line[18] eq 'AGT')){
	      for($i=0;$i<$count-1;$i++){
		      if(($line[40] == $packet_id[$i])){
			    $recvTime[$i] = $line[2]; #printf("$packet_id[$i] $line[40]\n");
			    last; 
		      }
              }
        }
}
for($i=0;$i<$count;$i++){
     if(defined $recvTime[$i]){
	$delay = $recvTime[$i] - $sendTime[$i];
	print AVGDELAY ("$sendTime[$i] $delay\n");
     }
}

close(Trace);
close(AVGDELAY);
exit(0);
