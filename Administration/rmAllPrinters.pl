#!/usr/bin/perl 
open(LP,"/usr/bin/lpstat -l -p -|") || die "Failed : $!\n";
$minutes=1;
while(<LP>){
	if($_ =~ /^printer./){
		($printer) = ($_ =~ /^printer (\S*)/g );
		if(length($printer) != 0){
			system("/usr/sbin/lpadmin -x $printer");
		}
	}
}
