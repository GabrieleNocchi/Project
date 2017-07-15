use strict;
use warnings;


open(INFILE, "temp.txt")
    or die "Can't open file\n";

open(OUTFILE, ">bac_ter_out.fasta")
     or die "Can't open file\n";



my $score;

while (my $line = <INFILE>) {


    if ($line =~ /iT: (\d\.\d+)/)  {
       $score = $1;
       if ($score > 0)  {
           $line = <INFILE>;
           chomp $line;
           
           print OUTFILE $line . "\n";
      }
       
    }  

}

