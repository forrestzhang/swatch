#!/usr/bin/perl

use strict;
use warnings;

open F, $ARGV[0] or die; 
my @lines = <F>;
close F;
my $len = @lines;
my @indiv = split("\t", $lines[0]);

print "name = W4xM6_pop\r\n";
print "popt = HAP\r\n";
print "nloc = $len\r\n";
print "nind = $#indiv\r\n";

open F, $ARGV[0] or die;
while(<F>){
	chomp;
	if($_ !~ /^scaffold/){
		print "$_\r\n";
		next;
	}
	my @cols = split("\t", $_);
	my $name = $cols[0];
	$name =~ s/-scaffold_\d+_\d+$//;
	print "$name\t";
	my $second = $#cols - 1;
	foreach(@cols[1..$second]){
		if($_ =~ /0/){
			print "a\t";
		}
		elsif($_ =~ /1/){
			print "b\t";
		}
	}
	if($cols[$#cols] =~ /0/){
		print "a\r\n";
	}
	elsif($cols[$#cols] =~ /1/){
		print "b\r\n";
	}
}
close F;
