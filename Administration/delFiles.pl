#!/usr/bin/perl 
use strict;

my $minutes=2;
my $dir = "/tmp/CloudPrintUpload/";

opendir (DIR, $dir) or die $!;

while(my $file = readdir(DIR)){
	my ($time) = ($file =~ /.*-(\d*)-\d*.pdf$/g);
	if($time != 0){
		if(time() - $time > 60*$minutes){
			unlink $dir.$file;
		}
	}
}

closedir(DIR);