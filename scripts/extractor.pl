use strict;
use warnings;


# This script filters the outputs of SwiSpot and produces a file
# with the name of the sequences which passed the filtering.
# the file is then read by bacfold.pl and bacfold2.pl
# Note this script is used separately on the output of SwiSpot for the sequences
# filtered by SD and those filtered by Terminators

my $fname = $ARGV[0];

open(INFILE, "$fname")
    or die "Can't open file\n";

open(OUTFILE, ">out.fasta")
     or die "Can't open file\n";



my $score;

while (my $line = <INFILE>) {

# filtering by iTot above 0.45 

    if ($line =~ /iTot: (\d\.\d+)/)  {
       $score = $1;
       if ($score > 0.45)  {
           $line = <INFILE>;
           chomp $line;
           
           print OUTFILE $line . "\n";
      }
       
    }  

}

close(INFILE);
close(OUTFILE);
