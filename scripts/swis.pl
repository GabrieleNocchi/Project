use strict;
use warnings;

# This script takes a FASTA with multiple sequences and it runs each sequence
# using SwiSpot, installed locally; the output is slightly tweaked and redirected
# into a file.

my $fname = $ARGV[0];


# ARGV[0] is a fasta file with the intergenic regions to be analysed

open(INFILE, "$fname")
     or die "Can't open file\n";

# temp.txt is the cumulative output file produced using SwiSpot;

open(OUTFILE, ">>temp.txt");

my $seq;
my $name;

while (my $line = <INFILE> ) {

     if ($line =~ /^>(.+)/)  {
         $name = $1;
         $line = <INFILE>;
         $seq = $line;
         chomp $seq;
     
         system("/d/in7/s/C-cmdline-SwiSpot-0.2.3/SwiSpot -s '$seq' >> /d/user6/ng001/temp.txt");
         print OUTFILE $name . "\n";

    }
}


close(INFILE);
close(OUTFILE);

