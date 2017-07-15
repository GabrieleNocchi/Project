#!/usr/bin/perl
use strict;



use Bio::SeqIO;
use CGI;
use utf8;



my $cgi = new CGI;
print $cgi->header();
my $gene = $cgi->param('selected_intergenic');



print <<__EOF;
<html>
<head>
<style type='text/css'>
<!--
body {  background: lightgrey;
        color:lightgrey; 
	font-family: Courier New;
        margin:20px; }

h1   {  color: black;
	font-family: Courier;
        font-size: 80%; }

h2   {  color:black; 
	font-family: Courier;
        font-size: 120%;
         }

casual { color:black; 
	 font-family: Consolas;
         font-size: 120%;
       }


.sd  {  color: red; }



-->
</head>	
</style>

<h2> <b> Folded using SwiSpot (Barsacchi et al., 2016) :</b> </h2>
</ br>



<body>


__EOF
my $name;

if ($gene =~ /(.+)NAME=(.+)/) {
   $gene = $1;
   $name =  $2;
}

# print "<h1> $name </h1>";
   

chomp $gene;

system("/d/in7/s/C-cmdline-SwiSpot-0.2.3/SwiSpot -s '$gene' -o 'temp.txt' > /dev/null 2>&1");


print "<h2> $name </h2>";
   

open(IN, "temp.txt");
   my $line = <IN>;
   my $seq = <IN>;
   
# print "<p><b2>$_</b2></p>\n" for unpack '(A50)*', $seq;



my $start;
my $len;

my $con;
my $con2;

while ($line = <IN>)  {
 
    #print "<p><b2> $line </b2></p>";
   
   print "<p><h1>$_</h1></p>\n" for unpack '(A60)*', $line;
    if ($line =~ /\[(\d+)\,(\d+)\]/) {
        $start = $1;
        $len = $2;
    }
    if ($line =~ /Structure Up:(.+)/)  {
       $con = <IN>;
       print "<p><h1>$_</h1></p>\n" for unpack '(A60)*', $con;

    }
   
    if ($line =~ /Structure Down:(.+)/)  {
       $con2 = <IN>;
       print "<p><h1>$_</h1></p>\n" for unpack '(A60)*', $con2;
      
    }
}

close(IN);

sub wrap {
    my ($lines, $pos, $markup) = @_;
    my $idx = int($pos / 50);
    substr $lines->[$idx], $pos % 50, 0, $markup;
}



my @lines = unpack '(A50)*', $seq;
print "<h2> Sequence: </h2>";
print "<h1> <span class='sd'> Switch Sequence </span> </h1>";
print "<casual>";

wrap(\@lines, $start + $len, '</span>');

wrap(\@lines, $start, '<span class="sd">');
     

#print "<h2> $seq </h2>";

#print "<h2> $con </h2>";

#print "<h2> $con2 </h2>";



   
print join "<br />", @lines;

print "</casual>";


open(IN2, ">temp2.txt");
chomp $seq;
chomp $con;
# Substitue all dots with x
$con =~ s/\./x/g;
print IN2 ">a1\n$seq\n$con";

close(IN2);


system("/d/in12/u/ng001/ViennaRNA-2.3.5/src/bin/RNAfold -C < temp2.txt > /dev/null 2>&1");


open(IN3, ">temp3.txt");
chomp $seq;
chomp $con2;
$con2 =~ s/\./x/g;

print IN3 ">a2\n$seq\n$con2";

close(IN3);

system("/d/in12/u/ng001/ViennaRNA-2.3.5/src/bin/RNAfold -C < temp3.txt > /dev/null 2>&1");

system('convert a1_ss.ps -quality 100 a1.jpg');
system('mv a1.jpg /d/user6/ng001/WWW/');

system('convert a2_ss.ps -quality 100 a2.jpg');
system('mv a2.jpg /d/user6/ng001/WWW/');
print <<__EOF;





<br />

<br />

<h2> Putative OFF Structure </h2>
<img src =  http://student.cryst.bbk.ac.uk/~ng001/a1.jpg />
<br />

<br />

<h2> Putative On Structure </h2>
<img src =  http://student.cryst.bbk.ac.uk/~ng001/a2.jpg />
</body>
</html>
__EOF
