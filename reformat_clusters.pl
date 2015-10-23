#!/usr/bin/perl

use strict;
use warnings;

open F, $ARGV[0] or die;

while(<F>){

	if ($_ =~ /^Haplotype_Block/) {
		next;
	}
	elsif($_ =~ /^\d+/){
		next;
	}
	chomp;
	$_ =~ s/^\s+|\s+$//;
	my @col = split("\t", $_);
	my @sites = split("-", $col[0]);
	$sites[0] =~ s/scaffold_\d+_//;
	$sites[1] =~ s/scaffold_\d+_//;
	$sites[1] =~ s/:\d+$//;
	print "$sites[0]\t$sites[1]\t";
	my $len = @col;
	my $less = $len -1;
	my $last = $less -1;
	foreach(@col[1..$last]) {

		if($_ =~ /0/) {
			print "red\t";
		}
		elsif($_ =~ /1/) {
			print "blue\t";
		}

	}
	if($col[$less] =~ /0/) {
		print "red\n";
	}
	if($col[$less] =~ /1/) {
		print "blue\n";
	}


}

		
