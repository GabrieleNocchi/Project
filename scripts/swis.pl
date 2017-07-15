use strict;
use warnings;



open(INFILE, "check2.txt")
     or die "Can't open file\n";


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

