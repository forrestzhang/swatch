#!/usr/bin/perl

use strict;
use warnings;

open F, $ARGV[0] or die "could not open file\n";
my @lines = <F>;
close F;
my $counter = -1;
my %final;
open F, $ARGV[0] or die;
while(<F>){
	chomp;
	my @geno = split("\t", $_);
#	print "$#geno\n";
	for (my $ind = 1; $ind < $#geno; $ind++){
		push(@{$final{$geno[0]}}, $geno[$ind]);
	}
}
close F;
my @keys = sort keys %final;
for (my $y = 0; $y < $#keys; $y++){
	$counter++;
	my $num = @{$final{$keys[$counter]}};
	for (my $i = $counter; $i < $#keys; $i++){
		my $diff = 0;
		my $t = $i + 1;
		for (my $pro = 1; $pro < $num -1; $pro++){
			my $final = \%final;
			if($$final{$keys[$counter]}[$pro] ne $$final{$keys[$t]}[$pro]){
				$diff++;
			}
		}
		my $num_pro = $num -1;
		my $ratio = $diff / $num_pro;
		if($ratio > 0.89){
			foreach my $values (values @{$final{$keys[$t]}}){
				$values =~ tr/01/10/;
			}
		}
	}
}
close F;
for my $scaffold (sort keys %final) {
	print "$scaffold\t";
	for my $x (0..$#{$final{$scaffold}}){
		
		print "$final{$scaffold}[$x]\t";
	}
	print "\n";
}

