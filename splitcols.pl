#!/usr/bin/perl

use strict;
use warnings;

open F, $ARGV[0] or die;

while(<F>){

	chomp;
	my @cols = split("\t", $_);
	my $scaf = $cols[0];
	$scaf =~ s/scaffold_\d+//g;
	print "$&\t";
	my $num = @cols;
	my $last = $num -1;
	my $second = $last -1;
	foreach (@cols[0..$second]){
		print "$_\t";
	}
	print "$cols[$last]\n";

}

close F;
