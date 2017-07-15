
#!/usr/bin/perl -w


# THIS SCRIPT WAS NOT WRITTEN BY THE AUTHOR
# REFERENCED BELOW

use strict;
use Bio::SeqIO;

my $fname2 = $ARGV[0];

open(OUTFILE, ">$fname2")
     or die "Can't open file $fname2\n";

# This script takes a GenBank file as input, and produces a
# NCBI PTT file (protein table) as output. A PTT file is
# a line based, tab separated format with fixed column types.
#
# Written by Torsten Seemann
# 18 September 2006


 #  sequence.gb is the genbank file, saved locally;
 
my $gbk = Bio::SeqIO->new(-file=>"sequence.gb", -format=>'genbank');
my $seq = $gbk->next_seq;
my @cds = grep { $_->primary_tag eq 'CDS' } $seq->get_SeqFeatures;

print $seq->description, " - 0..",$seq->length,"\n";
print scalar(@cds)," proteins\n";
print join("\t", qw(Location Strand Length PID Gene Synonym Code COG 
Product)),"\n";

for my $f (@cds) {
   my $gi = '-';
   $gi = $1 if tag($f, 'db_xref') =~ m/\bGI:(\d+)\b/;
   my $cog = '-';
   $cog = $1 if tag($f, 'product') =~ m/^(COG\S+)/;
   my @col = (
     $f->start.'..'.$f->end,
     $f->strand >= 0 ? '+' : '-',
     ($f->length/3)-1,
     $gi,
     tag($f, 'gene'),
     tag($f, 'locus_tag'),
     $cog,
     tag($f, 'product'),
   );
   print OUTFILE join("\t", @col), "\n";
}

sub tag {
   my($f, $tag) = @_;
   return '-' unless $f->has_tag($tag);
   return join(' ', $f->get_tag_values($tag));
}


close(OUTFILE);