#!/usr/bin/perl

use :strict;
$oneLine=$ARGV[1];
$openFile=$ARGV[2];
open(Trace, $ARGV[0]);
$sendPacketCount = 0; 
$recvPacketCount = 0;
$routingControlPacket = 0;
open (PACKETDELIVERY, ">>packetDelivery_$openFile.txt");
#open (ROUTINGLOAD, ">>routingLoad_$openFile.txt");
while(<Trace>){ 
	@line = split; 
	if($line[18] eq "AGT" && $line[34] eq "cbr"){ 
		if($line[0] eq "s"){ 
			$sendPacketCount++;
		}
		if($line[0] eq "r"){ 
			$recvPacketCount++;
		}
	}
	
	if($line[18] eq "RTR"){ 
		if($line[0] eq "f")
		{
			$routingControlPacket++;
		}
	}
}
close(Trace); 

if($recvPacketCount > 0)
{

	#printf("Gönderilen Paket Sayısı: %d \n",$gonderilenPaketSayisi);
	#print OUTFILE ("Gönderilen Paket Sayısı: %d \n",$gonderilenPaketSayisi);
	#printf("Alınan Paket Sayısı: %d\n",$alinanPaketSayisi);
	#printf OUTFILE ("Alınan Paket Sayısı: %d\n",$alinanPaketSayisi);100.0
	#printf("Düşen Paket Sayısı:%d\n",$gonderilenPaketSayisi-$alinanPaketSayisi);
	#printf OUTFILE ("Düşen Paket Sayısı:%d\n",$gonderilenPaketSayisi-$alinanPaketSayisi);
	#printf("Yönledirme Control Paketleri:%d\n",$yonlendirilenControlPaketleri);
	#printf OUTFILE ("Yönledirme Control Paketleri:%d\n",$yonlendirilenControlPaketleri);
	#printf O("Yönlendirme Yükü: %f\n",$yonlendirilenControlPaketleri/$gonderilenPaketSayisi*100);
	#printf("Paket Teslim Oranı: %f\n",$alinanPaketSayisi/$gonderilenPaketSayisi);
	printf PACKETDELIVERY ("%f %f\n",$oneLine,($recvPacketCount/$sendPacketCount)*100);
	#printf ROUTINGLOAD ("%f %f\n",$oneLine,$routingControlPacket/100);
}
#close(ROUTINGLOAD);
close(PACKETDELIVERY);
