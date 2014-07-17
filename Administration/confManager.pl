#!/usr/bin/perl
#This script takes two argument the first one is the file to read and the second one the file in witch to write 

#Warning balise inside balise doesn't work
use strict;
use File::Find;
use File::Copy;
use Getopt::Std;
my %options=();
getopts('f',\%options);


sub prompt {
  my ($query) = @_; # take a prompt string as argument
  local $| = 1; # activate autoflush to immediately show the prompt
  print $query;
  chomp(my $answer = <STDIN>);
  return $answer;
}

sub prompt_yn {
	if(defined($options{f})){
		return 1;
	}else{
	  my ($query) = @_;
	  my $answer = prompt("$query (Y/N): ");
	  return lc($answer) eq 'y';
	}
}

sub changeFile {
	if (@_ != 3) { die "please specify three argument\n";}
	my ($confMap,$src,$dest) = @_;
	if(-e $dest){
		if($dest eq $src){
			die "Error the source file is the same as the input file\n";
		}
		print "Warning a file named $dest allready exist\n";
		if (!prompt_yn("do you want to continue")) {print "Abording\n"; return;};
	}

	open(FILE_R,"<",$src) or die "can not open ${src} please verify that this file existe";
	open(FILE_W,">${dest}") or die "can not creat ${dest}";

	my $balise="conf";
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
			my $value = $confMap->{$key};
			$_ =~ s/^(.*)<${balise}.*\/>(.*)/\1${value}\2/s;
			$insideBalise = 0;
		}

		#if we are in a big balise
		if ($_ =~ /<${balise}.*<\/${balise}>/s) {
			my ($key) = ($_ =~ /key="(\w+)"/sg);
			if(defined($confMap->{$key})){
				if($confMap->{$key} eq "true"){
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

}

#Read it's argument as a conf file and retun a hash reference corresponding to this file
sub readConfig {
	my ($file) = @_;
	open(CONFIG, "<" , "$file") or die "can not open ${file}\n";
	my $confMap = {};
	while (<CONFIG>) {
		#try to implement comment in the file
		chomp($_);
		my ($key,$value) = split(":");
		$confMap->{$key} = $value;
	}
	close(CONFIG);
	return $confMap;
}
my $map = &readConfig("cloudPrint.conf");
sub find_file{
	my $F = $File::Find::name;
	my $destFile = $F;
	$destFile =~s/^\.\.\/src(.*)/\.\.\/bin\1/;
	
	print $destFile."\n";
	if ($_ =~ /\.php$/ or $_ =~ /\.html$/ or $_ =~ /\.coffee$/ or $_ =~ /\.js$/ or $_ =~ /\.css$/){
		&changeFile($map,$F,$destFile);
	}else{
		if(-e $destFile){
		print "Warning a file named $destFile allready exist in \n";
		if (!prompt_yn("do you want to continue")) {print "Abording\n"; return;};
		}
		if(-d $F){
			mkdir($destFile)
		}else{
			copy($F,$destFile) or die "couldn't copy $F";
		}
	}
}



my $location = "../src";
find({ wanted => \&find_file, no_chdir=>1}, $location);
