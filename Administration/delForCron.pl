#!/usr/bin/perl 
#I order to work with cron we need to specify the full path for every commandes
open(LP,"/usr/bin/lpstat -p -l -|") || die "Failed : $!\n"; #-| look for a better way to do it 
$minutes=1;
while(<LP>){
	if($_ =~ /^printer./){
		($printer) = ($_ =~ /^printer (\S*)/g );
		if(length($printer) != 0){
			($time) = ($printer =~ /^Pool1-.*-(\d*)$/g);
			if(length($time)!=0){
				$deltaTime = time()- $time;
				if($deltaTime>60*$minutes){
					print "del printer : $printer\n";
					system("/usr/sbin/lpadmin -x $printer");
				}
			}
		}
	}
}
