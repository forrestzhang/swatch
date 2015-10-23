#!/usr/bin/perl
#Remove Scaffolds that have less than 4 lines
#These are the scaffolds that have no clustering
my $pwd = $ARGV[0];
opendir my $dir, "$pwd" or die "Cannot Open Directory\n";
my @filenames = readdir $dir;
closedir $dir;
my $badscaff = "Scaffolds_insufficient_markers.txt";
open (G, '>', $badscaff) or die;
foreach my $names (@filenames) {
	if($names =~ /\w{1,}\.col.txt/){
		open F, $names or die;
		my $counter = 0;
		while(<F>){
			 $counter++;
		}
		if ($counter < $ARGV[1]){
			print G "$names\n";
			unlink ($names);
		}
		close F;
	}
	else{
		next;
	}
}
close $write;

