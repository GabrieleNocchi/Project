#!/usr/bin/perl

# This is the CGI which filters the intergenic sequences by SD motif

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


.sd  {  color:red; }

.terminator {  color: royalblue; }


-->
</head>	
</style>

<h1>
<i>Bacillus subtilis strain 168 </i> intergenic regions above 70 nucleotides with <span class="sd"> SD sequence</span> present : </h1>
<p> <b> Click submit to show only sequences exhibiting some degree of SD sequestering using SwiSpot (Barsacchi et al., 2016). </b> </p>
<body>
<form method="post" action="http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/ng001/bacfold.pl">

__EOF



# this script uses bioperl; it takes the fasta file with the filtered
# intergenic sequences above 70 nucleotides in length;
# it creates an hash storing the ID of the intergenic sequences as key
# and the actual nucleotide sequences as value.

# file.fasta is the fasta with the intergenic regions created using myparser.pl

my $seqio = Bio::SeqIO->new(-file => "file.fasta", 
                             -format => "fasta" ); 


my %hash;

while (my $seq = $seqio->next_seq) {
   
       my $string = $seq->seq;
       my $name = $seq->primary_id;
       $hash{$name} = $string
}




#  Filter the first hash and make a second hash with only the sequences with
#  either 1 of the SD patterns.

my %hash2;

foreach my $key (keys %hash)  {
      
        
        if ($hash{$key} =~ /(aggag|agaag|aaagg|ggagg|gaaga|ggaga|aaggt|aggaa|aagga|gtgga).{0,15}$/i)  {  
            
                  $hash2{$key} = $hash{$key};
       }


}

print "<p> Total number of sequences: " . scalar keys %hash2;
print "</p>";

# The code below is to highlight the patterns in the sequences;
# first it records the position of the patterns to highlight;
# then it adds the tags starting from the bottom of sequences.


sub wrap {
    my ($lines, $pos, $markup) = @_;
    my $idx = int($pos / 50);
    substr $lines->[$idx], $pos % 50, 0, $markup;
}



my %class =(AGGAG => { name => 'sd' },
            AGAAG => { name => 'sd' },
            AAAGG => { name => 'sd' },
            GGAGG => { name => 'sd' },
            GAAGA => { name => 'sd' },
            GGAGA => { name => 'sd' },
            AAGGT => { name => 'sd' },
            AGGAA => { name => 'sd' },
            AAGGA => { name => 'sd' },
            GTGGA => { name => 'sd' });



my %sd;

foreach my $key (keys %class)  {

   my $full = $key . ".{0,15}\$";
   $sd{$full} = 1;

}








my $regex = join '|', keys %sd;

$regex = qr/((?i:$regex))/;


my %highlight;


for my $name (keys %hash2)  {
    while ($hash2{$name} =~ /($regex)/g) {  

         $class{$1}{length} = length($1);
        $highlight{$name}{ pos($hash2{$name}) - $class{$1}{length}  } = $class{$1};
    }
}



for my $key (keys %highlight)  {
    print "<p> <b>$key</b> </p>";
    my @lines = unpack '(A50)*', $hash2{$key};
    for my $pos (sort { $b <=> $a } keys %{ $highlight{$key} }) {
        my $class = $highlight{$key}{$pos};
        wrap(\@lines, $pos + 5, '</span>');
        wrap(\@lines, $pos, "<span class='sd'>");
    }
    print join "<br />", @lines;
}







print <<__EOF;

<br />
<p> <b> Please submit to filter by SD sequestering using SwiSpot (Barsacchi et al., 2016). </b> </p>
<input type='submit' value='SUBMIT' />
</form>
</body>
</html>
__EOF
