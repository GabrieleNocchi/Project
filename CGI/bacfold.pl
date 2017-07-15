#!/usr/bin/perl
use strict;
use warnings;
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


.sd  {  color: red; }



-->
</head>	
</style>

<h1>
<i>Bacillus subtilis strain 168 </i> intergenic regions above 80 nucleotides showing some degree of <span class="sd">SD</span> sequence sequestration in 1 of the 2 alternative conformations calculated using SwiSpot : </h1>

<p> <b> Please select a sequence and submit to show the 2 folded conformations calculated with SwiSpot (Barsacchi et al., 2016). </b> </p>


<body>
<form method="post" action="http://student.cryst.bbk.ac.uk/cgi-bin/cgiwrap/ng001/fold2.pl">

__EOF




my $seqio = Bio::SeqIO->new(-file => "final.fasta", 
                             -format => "fasta" ); 


my %hash;

while (my $seq = $seqio->next_seq) {
   
       my $string = $seq->seq;
       my $name = $seq->primary_id;
       $hash{$name} = $string
}

open(INFILE, "bac_sd_out.fasta")
    or die "Can't open file\n";

my @array;

while (my $line = <INFILE>) {
      push @array, $line;
}

close(INFILE);

print "<p> Total number of sequences: " . scalar @array;
print "</p>";

my %hash2;


foreach my $value (@array)  {
       
       chop $value;

       $hash2{$value} = $hash{$value};
       

}
      



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
    my $captured = $hash2{$key} . "NAME=$key";
    print "<p> <b>$key</b> <input type='radio' name='selected_intergenic' value='$captured'/> </p>";
    my @lines = unpack '(A50)*', $hash2{$key};
    for my $pos (sort { $b <=> $a } keys %{ $highlight{$key} }) {
        my $class = $highlight{$key}{$pos};
        wrap(\@lines, $pos + 5, '</span>');
        wrap(\@lines, $pos, "<span class='sd'>");
    }
    print join "<br />", @lines;
}


#print "<p>$_</p>\n" for unpack '(A50)*', $gene;

#system("/d/in7/s/C-cmdline-SwiSpot-0.2.3/SwiSpot -s '$gene'");


print <<__EOF;


<br />

<br />
<p> <b> Please select a sequence and submit to show the 2 folded conformations calculated with SwiSpot (Barsacchi et al., 2016). </b> </p>
<input type='submit' value='SUBMIT' />
</form>
</body>
</html>
__EOF
