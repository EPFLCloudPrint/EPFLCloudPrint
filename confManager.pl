#!/usr/bin/perl

#Warning balise inside balise doesn't work
use strict;
my $confFileName = "cloudPrint.conf";
my $balise="conf";

open(CONFIG, "<" , "$confFileName") or die "can not open ${confFileName}\n";

my %confMap;

while (<CONFIG>) {
	#try to implement comment in the file
	chomp($_);
	my ($key,$type,$value) = split(":");
		$confMap{$key} = $value;
}
close(CONFIG);

open(FILE_R,"<","index.php");
open(FILE_W,">index.php.bak");

#$/ = "</${balise}>";
my $insideBalise = 0;
my $ligne = "";
while(<FILE_R>){
	if($insideBalise){
		$_=$ligne.$_;
	}
	#if we are in a unique balise
	if($_ =~ /<${balise}/s){
		$insideBalise = 1;
	}
	if($_ =~ /<${balise}.*\/>/s){
		my ($key) = ($_ =~ /key="(\w+)"/sg);
		my $value = $confMap{$key};
		$_ =~ s/^(.*)<${balise}.*\/>(.*)/\1${value}\2/s;
		$insideBalise = 0;
	}

	#if we are in a big balise
	if ($_ =~ /<${balise}.*<\/${balise}>/s) {
		my ($key) = ($_ =~ /key="(\w+)"/sg);
		if(defined($confMap{$key})){
			if($confMap{$key} eq "true"){
				$_ =~ s/^(.*)<${balise}.*>(.*)<\/${balise}>(.*)/\1\2\3/s;
			}else{
				$_ =~ s/^(.*)<${balise}(.*)<\/${balise}>(.*)/\1\3/s;
			}
		}
		$insideBalise = 0;
	}


	if($insideBalise){
		$ligne = $_;
	}else{
		$ligne = "";
		print FILE_W $_;
	}

}

close(FILE_W);
close(FILE_R);