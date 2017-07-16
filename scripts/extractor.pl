use strict;
use warnings;


# This script filters the outputs of SwiSpot and produces a file
# with the name of the sequences which passed the filtering.
# the file is then read by bacfold.pl and bacfold2.pl
# Note this script is used separately on the output of SwiSpot for the sequences
# filtered by SD and those filtered by Terminators
# The filtering changes between the 2 runs, as explained in the next comment

open(INFILE, "temp.txt")
    or die "Can't open file\n";

open(OUTFILE, ">bac_ter_out.fasta")
     or die "Can't open file\n";



my $score;

while (my $line = <INFILE>) {

# the code below is to filter by degree of terminator sequestration; to filter by degree of
# SD sequestration "iT" must be replaced with "iSD";

    if ($line =~ /iT: (\d\.\d+)/)  {
       $score = $1;
       if ($score > 0)  {
           $line = <INFILE>;
           chomp $line;
           
           print OUTFILE $line . "\n";
      }
       
    }  

}

close(INFILE);
close(OUTFILE);
