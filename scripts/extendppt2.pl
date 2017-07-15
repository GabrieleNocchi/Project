
# create a .ptt file for the reverse strand using the full .ptt file

use strict;
use warnings;


# INFILE is the .ptt file created with makeptt.pl

my $fname = $ARGV[0];
my $fname2 = $ARGV[1];

open(INFILE, "$fname")
     or die "Can't open file $fname\n";

open(OUTFILE, ">$fname2")
     or die "Can't open file $fname2\n";



my $start;
my $end;


while (my $line = <INFILE>)  {

    if ($line =~ /^(\d+)(\.\.\d+)(\s)(\-)(.+)/)  {
    
    my $start = $1;
   

   my $new = $start . $2 . $3 . $4 .$5;

   print OUTFILE $new . "\n";

       
  }


}

