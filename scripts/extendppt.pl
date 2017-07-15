
# create a ptt file for the forward strand, using a full .ptt


use strict;
use warnings;


# infile is the full .ptt, created using makeptt.pl

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
    
    my $end = $2;
   

   my $new = $1 . $end . $3 . $4 .$5;

   print OUTFILE $new . "\n";

       
  }


}

close(INFILE);
close(OUTFILE);
