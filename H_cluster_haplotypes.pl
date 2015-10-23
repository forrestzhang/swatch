#!/usr/bin/perl

use strict;
#use warnings;
use Algorithm::Cluster;
use Data::Dumper;

die "usage: data_cluster.pl <distance.matrix> STDOUT" unless @ARGV == 1;
open F, $ARGV[0] or die;
my @lines = <F>;
close F;
my $line_number = @lines;
print "$lines[0]";
my @progeny = split("\t", $lines[1]);
#my $sec = $#progeny -1;
#foreach my $ele (@progeny[0..$sec]){
#	$ele =~ s/\s+$//;
#	print "$ele\t";
#}
#print "$progeny[$#progeny]";
my $window = $#progeny - 1;
#print "$window";
for (my $i = 2; $i < $line_number - $window + 2; $i += $window){

	my @columns = split("\t", $lines[$i]);
	my $number = @columns;
        my @matrix = ();
	$matrix[0] = [];
        for (my $x = $i; $x < $i + $window -1; $x++){

		if ($x == $i) {
			print "$columns[0]\t";	
		}
                my @distances = split("\t", $lines[$x]);
                my $colss = @distances;
		my $y = $x - $i + 1;
		$matrix[$y] = [@distances[1..$y]];

        }
        my $data = \@matrix;
#	print Dumper $data;
        my %param = (
		data => $data,
		npass => 100,		
                method => 'a',
        );
        my $clusters = Algorithm::Cluster::treecluster(%param);
	my $clusterids = $clusters->cut(2);	
	my $last = $window -2;	
	foreach my $ids (@$clusterids[0..$last]) {

		print "$ids\t";

	}
	my $final = $last +1;
	print "@$clusterids[$final]\n";
}
