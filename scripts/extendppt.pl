
# extended ppt forward strands of 120.


use strict;
use warnings;



my $fname = $ARGV[0];
my $fname2 = $ARGV[1];

open(INFILE, "$fname")
     or die "Can't open file $fname\n";

open(OUTFILE, ">$fname2")
     or die "Can't open file $fname2\n";



my $start;
my $end;


while (my $line = <INFILE>)  {

    if ($line =~ /^(\d+\.\.)(\d+)(\s)(\+)(.+)/)  {
    
    my $end = $2 + 120;
   

   my $new = $1 . $end . $3 . $4 .$5;

   print OUTFILE $new . "\n";

       
  }


}

