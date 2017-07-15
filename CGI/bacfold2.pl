#!/usr/bin/perl

# This script filters the output produced by SwiSpot for the intergenic regions scanned for the presence
# of a transcription terminator using Transtermhp_v2.09

use strict;
use warnings;
use Bio::SeqIO;
use CGI;
use utf8;



my $cgi = new CGI;
print $cgi->header();


print <<__EOF;
<html>
<head>
<style type='text/css'>
<!--
body {  background: lightgrey;
        color: black; 
	font-family: Courier;
        margin:20px; }

h1   {  color: black;
	font-family: Verdana;
        font-size: 130%; }

h2   {  color:red; 
	font-family: Courier;
        font-size: 100%;
        width: 30em; }


.terminator  {  color: mediumblue; }

.tail {  color: deeppink; }


-->
</head>	
</style>

<h1>
<i>Bacillus subtilis strain 168 </i> intergenic regions above 70 nucleotides showing a degree of <span class="terminator">termin</span><span class="tail">ator </span> sequestration in 2 alternative structures calculated using SwiSpot (Barsacchi et al., 2016): </h1>
<p> <span class="terminator"> Hairpin </span>  <span class="tail">  Tail </span> </p>


<p> <b> Please select a sequence and submit to show the 2 folded conformations calculated with SwiSpot (Barsacchi et al., 2016). </b> </p>
<body>
<form method="post" action="http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/ng001/fold2.pl">

__EOF



# this script uses bioperl; it takes the fasta file with the filtered
# intergenic sequences above 80 nucleotides in length;
# it creates an hash storing the ID of the intergenic sequences as key
# and the actual nucleotide sequences as value.



# file.fasta is the file produced using myparser.pl with all the intergenic regions of the organism of interest

my $seqio = Bio::SeqIO->new(-file => "file.fasta", 
                             -format => "fasta" ); 


my %hash;

while (my $seq = $seqio->next_seq) {
   
       my $string = $seq->seq;
       my $name = $seq->primary_id;
       $hash{$name} = $string
}


sub wrap {
    my ($lines, $pos, $markup) = @_;
    my $idx = int($pos / 50);
    substr $lines->[$idx], $pos % 50, 0, $markup;
}

#  Import the forward strand terminators into an array;


open(INFILE, "forward.tt")
     or die "Can't open file\n";

my @array;

while (my $line = <INFILE>)  {

       if ($line =~ /TERM/) {
           push @array, $line;

      }

}

close(INFILE);

my $size = scalar @array;


# Loop over all the intergenic sequences in my hash; in each check if
# they contain a terminator from the output;
# For this I check wether the terminator coordinates are within the intergenic coordinates.
# If they are contained, I check at which position in the intergenic sequence the terminator
# starts; if that is after 120 I accept the terminator;
# Note: we are only interested in 1 terminator, possibly the one closest to the end of the sequence;
# In the output there can be more than 1 terminator per intergenic sequence, and they are all given in 
# order of position.
# By capturing this information in an array, the data keeps the order of the ouput file.
# This was for each intergenic region I only capture the coordinates of the last terminator.
# This because my hash %all, which contain all terminators positions and length, and where keys
# are the sequences id, only accept 1 value per key; therefore the previous terminator is overwritten
# if another is found after it.


my $start;
my $end;
my $tstart;
my $tend;


my %all;

foreach my $key (keys %hash)   {

     if ($key =~ /\w+\(\+\):(\d+)\-(\d+)/)   {
 
        $start = $1;
        $end = $2;
        for (my $i = 0; $i < $size; $i ++)  {

            if ($array[$i] =~ /.+?(\d+)\s\-\s(\d+).+?(\d{1,3})/)  {
              my $score = $3;
               $tstart = $1;
               $tend= $2;
            #   print $score . "\n";
               if ($tstart > $start && $tend < $end)  {

                   if ($all{$key}) {
                      if ($all{$key} =~ /score=(\d{1,3})/)  {
                          my $min = $1;
                          if ($score >= $min)  {
                              $tstart = $tstart - $start - 1;
                              $tend = $tend - $start - 1;
                                  if ($tstart > 60)  {

                                      $all{$key} = "$tstart-$tend score=$score";
                                 }
                          }
                     }
                 }
                 else {
                         $tstart = $tstart - $start - 1;
                         $tend = $tend - $start - 1;
                               if ($tstart > 60)  {

                                  $all{$key} = "$tstart-$tend score=$score";
                              }
                  }


                   }
              
              }


           }
          
       }
   }




 

# Here I repeat the exact procedure I did for the Forward Strand, this time for the 
# Reverse Strad Terminators output.

open(INFILE2, "reverse.tt")
     or die "Can't open file\n";

my @array2;

while (my $line = <INFILE2>)  {

       if ($line =~ /TERM/) {
           push @array2, $line;

      }

}


close(INFILE2);
# The function is similar to that of the forward strand;
# However there is a little tweak on how I record the position of the terminators
# within a sequence. This is because in my sequences, in %hash, for reverse strand
# genes I already reverse complemented each sequence. Therefore after I checked wether a terminator
# is contained in an intergenic sequence in the same way as for the forward strand,
# there is a difference in how you determine the start position in my reverse complemented strings.

my $size2 = scalar @array2;
my $len;
my $len2;

foreach my $key (keys %hash)   {

     if ($key =~ /\w+\(\-\):(\d+)\-(\d+)/)   {
        
        $start = $1;
        $end = $2;
        $len = $2 - $1;
  
        for (my $i = 0; $i < $size2; $i ++)  {

            if ($array2[$i] =~ /.+?(\d+)\s\-\s(\d+).+?(\d{1,3})/)  {
               my $score = $3;
               $tstart = $2;
               $tend= $1;
               $len2 = $tend - $tstart;
               
               if ($tstart > $start && $tend < $end)  {

                   if ($all{$key})  {
                       if ($all{$key} =~ /score=(\d{1,3})/)  {
                           my $minn = $1;
                            if ($score >= $minn)  {
                                 $tstart = $end - $tend;
                                 $tend = $tstart + $len2;
     

                  
                                     if ($tstart > 60)  {
                                         $all{$key} = "$tstart-$tend score=$score";
         
                                    
                                    }
                            }
                       }
                  }


                else {
                         $tstart = $end - $tend;
                         $tend = $tstart + $len2;
                               if ($tstart > 60)  {

                                  $all{$key} = "$tstart-$tend score=$score";
                              }
              }


           }
          
       }
   }
}


}

# In my %all hash I have the coordinates and intergenic ID of every terminator of
# interest for my project.




# Now I just create my highight hash and I record the position of the terminators.
# I record the length in another hash; keys are shared, and are those of %all;
# %all keys are only those with an interesting terminator.

my $reg;
my %highlight;
my %termlen;

foreach my $key (keys %all)  { 


    if ($all{$key} =~ /(\d+)\-(\d+)/)  {

        my $s = $1;
        my $l = $2-$1;

        $termlen{$key} = $l;
        $highlight{$key} = $s;

   }
}
    



# bac_ter_out.fasta has the names of all the sequences which passed SwiSpot filtering for
# terminator sequestration; this fil was created using swis.pl and extractor.pl

open(IN, "bac_ter_out.fasta")
    or die "Can't open file\n";

my @array3;

while (my $line = <IN>) {
      push @array3, $line;
}


close(IN);


print "<p> Total number of sequences: " . scalar @array3;
print "</p>";

my %hash2;


foreach my $value (@array3)  {
       
       chop $value;

       $hash2{$value} = $hash{$value};
       

}
   

# Now I use my function wrap to put the highlighting at the right spot in each sequence.
# I start from theend of the sequence so not to change the positioning.
# All tails have same length of 15, so i add a different tag for that too.



foreach my $key (keys %highlight)  {
     if ($hash2{$key})  {
    
     my @lines = unpack '(A50)*', $hash2{$key}; 
   
     my $pos = $highlight{$key};
     my $tot = $pos + $termlen{$key} + 15;
     my $exc = length($hash{$key});
     my $captured = substr($hash{$key}, 0, ($tot - 6));
     $captured = $captured . "NAME=$key";

     print "<p> <b>$key</b><input type='radio' name='selected_intergenic' value='$captured'/> </p>";

     if (length($hash2{$key}) > $tot)  {
         wrap(\@lines, $pos + $termlen{$key} + 16, '</span>');

         wrap(\@lines, $pos + $termlen{$key} + 1, '</span><span class="tail">');
     
         wrap(\@lines, $pos, "<span class='terminator'>");
    
         print join "<br />", @lines;
    }

# This else statement is necessary as it was having problems when the tail is short.

    else {


         wrap(\@lines, $exc, '</span>');

         wrap(\@lines, $pos + $termlen{$key} + 1, '</span><span class="tail">');
     
         wrap(\@lines, $pos, "<span class='terminator'>");
    
         print join "<br />", @lines;
  }
         
        
}


}



             

print <<__EOF;

<br />
<p> <b> Please select a sequence and submit to show the 2 folded conformations calculated with SwiSpot (Barsacchi et al., 2016). </b> </p>
<input type='submit' value='SUBMIT' />
</form>
</body>
</html>
__EOF
