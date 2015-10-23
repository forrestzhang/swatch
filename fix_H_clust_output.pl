#!/usr/bin/perl

use strict;
use warnings;

open F, $ARGV[0] or die; 
my @file = <F>;
close F;
my $len = @file;
print "$file[0]$file[1]";
my @first = split("\t", $file[1]);
for (my $i = 2; $i < $len; $i++){

	chomp($file[$i]);
	my $diff = 0;
	my @second = split("\t", $file[$i]);
	my $col = @second;	
	for (my $v = 1; $v < $col; $v++){

		if($first[$v] ne $second[$v]){
			$diff++;
		}
	}
	my $ratio = $diff / $col; 
	my $last = $col -1;
	print "$second[0]\t";
	if($ratio > 0.5) {
		foreach(@second[1..$last]) {

			$_ =~ tr/01/10/;
			print "$_\t";
			
		}
		print "\n";
	}
	else{
		foreach (@second[1..$last]){

			print "$_\t";

		}
		print "\n";
	}
}
	

