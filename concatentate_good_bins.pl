#!/usr/bin/perl
#Remove Scaffolds that have less than 4 lines
#These are the scaffolds that have no clustering
my $pwd = $ARGV[0];
opendir my $dir, "$pwd" or die "Cannot Open Directory\n";
my @filenames = readdir $dir;
closedir $dir;
foreach my $names (@filenames) {
	if($names =~ /\w{1,}\.hcf/){
		open F, $names or die;
		my $counter = 0;
		while(<F>){
			$counter++;
			if($counter < 3){
				next;
			}
			else{
				print "$_";
			}
		}
		close F;
	}
	else{
		next;
	}
}

