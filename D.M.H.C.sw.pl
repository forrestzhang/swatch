#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

die "usage distance_matrix_haplotype.pl <file.loc> <window size> > distance.matrix" unless @ARGV == 4;
my $window = $ARGV[1];
my $initial = $window;
open F, $ARGV[0] or die "usage: script.pl <locfile> <window> > pdm";
my @lines = <F>;
my $line_len = @lines;
close F;
chomp($lines[0]);
my @progenies = split("\t", $lines[0]);
print "Haplotype_Block\t";
for (my $names = 1; $names < $#progenies -1; $names++){
	print "$names\t";
}
my $step = $window / $ARGV[2];
my $lastone = $#progenies - 1;
print "$lastone\n";

if($line_len <= $window){
	$window = $line_len -1;
}
if ($ARGV[3] =~ /no/){
	$step = $window / $ARGV[2];
}
elsif($ARGV[3] =~ /yes/){
	$step = $window;
}
for (my $i = 0; $i < $line_len - $window; $i += $step) {
	my @col = split ("\t", $lines[$i]);
	@col = grep defined, @col;
	my $precolnum = @col;
	my $colnum = $precolnum - 1;
	my %grandarray=();
	my $finalmarker = $i + $window -1;
        my @lastly = split("\t", $lines[$finalmarker]);
	@lastly = grep defined, @lastly;
	for (my $z = $i; $z < $i + $window; $z++ ){
		if($lines[$z] !~ /^scaffold/){
			next;
		}
		if($lines[$z] =~ /^name/) {
			next;
		}
		my @cols = split /\s+/, $lines[$z];
		for (my $t = 2; $t < $precolnum; $t++) {

			push( @{ $grandarray{$t} }, $cols[$t]);
		}
	}
	my $grandarray = \%grandarray;
	for (my $pro = 2; $pro < $colnum +1; $pro++) {
		print "$col[0]-$lastly[0]\t"; #remove :$starting from the end of $lastly;
		for (my $pairwise = 2; $pairwise < $precolnum; $pairwise++){
			my $array_length = @{$grandarray{$pro}};
			my $mismatch = 0;
			my $analyzed = 0;
			for (my $loc = 0; $loc < $array_length; $loc++){
				if($$grandarray{$pro}[$loc] eq "--"){
#					$mismatch = $mismatch + 0.25;
					next;
				}
				elsif($$grandarray{$pairwise}[$loc] eq "--"){
#					$mismatch = $mismatch + 0.25;
					next;
				}
				if(($$grandarray{$pairwise}[$loc] or $$grandarray{$pro}[$loc]) ne "--"){
					$analyzed++;
					if($$grandarray{$pro}[$loc] ne $$grandarray{$pairwise}[$loc]) {	
						$mismatch++;
					}
				}

			}		
			if($analyzed == 0){
				print "NA\t";
			}
			else{
			
				my $nonmissingratio = ($mismatch^2) / $analyzed;			
				print "$nonmissingratio\t";
			}		
		}
		print "\n";
	}
}









