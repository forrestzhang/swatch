#!/usr/bin/perl

use strict;
use warnings;

my $input = $ARGV[0];
die "Usage: vcf2phased.pl <vcf.file>\n" unless @ARGV == 1;
open F, $input or die "Could not open file '$input'\r\n";
my @lines = <F>;
my $firt = @lines;
my $loc = 0;

foreach(@lines) {

	if($_ !~ /^#/) {
		$loc ++;
	}

}

my $check = $loc -1;
my @cols = split("\t", $lines[$check]);
my $indv = @cols;
my $test = $indv - 9;
close F;
print "name = F1_pop_w4xm6\n";
print "popt = CP\n";
print "nind = $test\n";
print "nloc = $loc\n";
my $geno = $test + 2;
my $final = $geno + 1;
open F, $input or die "Could Not Open File '$input'\n";

while (<F>) {

	if($_ =~ /^#/) {
		next unless ($_ =~ /^#CHROM/);
	}
	chomp();
        my @fields = split("\t", $_);
	if($fields[0] =~ /#CHROM/){
		print ";\t";
		foreach(@fields[9..$#fields]){
			print "$_\t";
		}
		print "\n";
	}
	else{
        splice(@fields, 2, 1);
        splice(@fields, 4, 4);
	my $len = @fields;
	print "$fields[0]_$fields[1]\t";
	print "<lmxll>\t";
        foreach (@fields[4..$geno]) {

		if($_ =~ /(^0\/1|^0\|1|^1\|0)/) {
			print "lm\t";
		}
		elsif($_ =~ /(^\.\/\.|^\.\|\.)/) {
			print "--\t";
		}
		elsif($_ =~ /(^0\/0|^0\|0)/) {
			print "ll\t";
		}
		elsif($_ =~ /(^1\/1|^1\|1)/) {
			print "lm\t";
		}
		else {
			print "$_\t";
		}
	}
	foreach($fields[$final]) {
                if($_ =~ /(^0\/1|^0\|1|^1\|0)/) {
                        print "lm\n";
                }
                elsif($_ =~ /(^\.\/\.|^\.\|\.)/) {
                        print "--\n";
                }
                elsif($_ =~ /(^0\/0|^0\|0)/) {
                        print "ll\n";
                }
                elsif($_ =~ /(^1\/1|^1\|1)/) {
                        print "lm\n";
                }
                else {
                        print "$_\n";
                }
	}
	}
}
close F;


			
			
