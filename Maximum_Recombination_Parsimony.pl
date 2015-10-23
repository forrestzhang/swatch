#!/usr/bin/perl
# Maximum_Recombination_Parsimony
# Author: Alexandre Marand
# Date of Last Edit: 10/13/15
# version:0.0.3
#--------------------------

#Run distance_matrix_haplotype_clustering.pl
#Run H_cluster_haplotypes.pl
#Run fix_H_clust_output.pl
#Optimize Window Size to maximize parsimony of recombination

use strict;
use warnings;
use IPC::System::Simple qw(system capture);
use Getopt::Long qw(GetOptions);
use POSIX qw (strftime);

die "usage: Best_Window.pl <file.loc> <starting_window_size>  <build_window_by_size> <threshold_#recombinations_per_individual> STDOUT\n" unless @ARGV == 6;
my $test = 0;
my $window = $ARGV[1];
my $step = $ARGV[2];
my $recomb = $ARGV[4];
my $iterations = 0;
while($test == 0){
	
	my $time = strftime "%H:%M:%S", localtime(); 
	$iterations++;
	print STDERR "Time: $time-----Number of Iterations:\t$iterations\tCurrent Window Size:\t$window\n";
	my $temp1 = 'temp_1.txt';
	my $distmatrix = capture("D.M.H.C.sw.pl $ARGV[0] $window $ARGV[3] $ARGV[5]");
	open (my $t1, '>', $temp1) or die;
	print $t1 "$distmatrix";
	close $t1;
	my $unorder_clusters = capture("H_cluster_haplotypes.pl temp_1.txt");
	unlink($temp1);
	my $temp2 = 'temp_2.txt';
	open (my $t2, '>', $temp2) or die;
	print $t2 "$unorder_clusters";
	close $t2;
	my $ready_clust = capture("fix_H_clust_output.pl temp_2.txt");
	unlink($temp2);
	my @lines = split("\n", $ready_clust);
	my $length = @lines;
	my %pro;
	my @head;
	my @first;
	for (my $i = 0; $i < $length; $i++){

		if($i == 0){
			@head = split("\t", $lines[$i]);
			next;
		}
		if($i == 1){
			@first = split("\t", $lines[$i]);
			my $last = $#first -1;
			for (my $x = 0; $x < $#first; $x++){

				my $marker = $x + 1; 
				push( @{ $pro{$x} }, $first[$marker]);

			} 
		}
		if($i > 1){
			my @second = split("\t", $lines[$i]);
			for (my $t = 0; $t < $#second; $t++){

				my $marker = $t + 1;
				push( @{ $pro{$t} }, $second[$marker]);

			}	
		}
	}
#-----------------------------------------------------------------------
#Count the number of flips from one genotype to the other. Allowing for
#only one per individual
#
	my $pro = \%pro;
	my @keys = sort keys %pro;
	my $num_keys = @keys;
	my @flip = (0) x $num_keys;
	for (my $pros = 0; $pros < $#keys +1; $pros++){

		my $num = @{$pro{$pros}};
		for(my $value = 1; $value < $num; $value++){
			
			my $next = $value -1;
			if($$pro{$pros}[$value] ne $$pro{$pros}[$next]){
				$flip[$pros]++;
			} 
		}
	}
#------------------------------------------------------------------------
#Save the number of times and individuals genotype goes from 0->1 or 1->0 
#for a particular individual the length of the entire scaffold
#
	my $number_flips = 0;
	my $badpro = 0;
	for (my $z = 0;$z < $#keys +1;$z++){
		if($flip[$z] == 1){
			if($$pro{$z}[0] ne $$pro{$z}[1]){
				$badpro++;
			}
			my $num_index = @{$pro{$z}};
			my $last_pro = $num_index -1;
			my $second_last_pro = $last_pro -1;
			if($$pro{$z}[$last_pro] ne $$pro{$z}[$second_last_pro]){
				$badpro++;
			}
		}
		if($flip[$z] > $recomb){
			$badpro++;
		}
	}
	if($badpro > 0){
		$window = $window + $step;
	}
	if($badpro == 0){
		$test++;
	}
	
	if($test > 0){
		print STDERR "Best Window Size: $window\n";
		print "$window\n$ready_clust";
	}
}
