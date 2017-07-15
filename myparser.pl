# This is script is to parse a Genbank File and Create a Fasta File with the Intergenic Regions Upstream of each gene

use strict;
use warnings;
use Bio::SeqIO;
my $fname = $ARGV[0];
my $fname2 = $ARGV[1];

open(INFILE, "$fname")
     or die "Can't open file $fname\n";

open(OUTFILE, ">$fname2")
     or die "Can't open file $fname2\n";


# Extracting genes

my @all_genes;



while (my $line =<INFILE>)  {

# This is in case the gene is in the reverse strand

    if ($line =~ /\s+(CDS|rRNA|tRNA)\s+complement\((\d+)\.\.(\d+)\)\n/)   {
         my $start = $2;
         my $end = $3;
         my $strand = -1;
         my $value = "START:" . $start . "END:" . $end . "STRAND:" . $strand;


         $line = <INFILE>;
        
         if ($line =~ /.+?gene="(.+)"/)  {
             $value = $value . "NAME:" . $1;
             push (@all_genes, $value);

        }
    }

# This for genes on the forward strand
    elsif ($line =~ /\s+(CDS|tRNA|rRNA)\s+(\d+)\.\.(\d+)\n/)   {
          my $start = $2;
          my $end = $3;
          my $strand = 1;
          my $value = "START:" . $start . "END:" . $end . "STRAND:" . $strand;


          $line = <INFILE>;
        
          if ($line =~ /.+?gene="(.+)"/)  {
              $value = $value . "NAME:" . $1;
              push (@all_genes, $value);

         }
    }



}




# I concatenated all data into array values so to preserve the order of extraction
# needed in the next loop;
my @all_intergenic;





# In the Loop below I use the array of genes to extract the intergenic region for each;
# Outout is an array of intergenic region coordinates.

my $max = scalar @all_genes;

for (my $i = 1; $i < $max; $i++)  {

     if ($all_genes[$i] =~ /START:(.+)END:(.+)STRAND:1NAME:(.+)/)  {

         my $name = $3;
         my $end = $1-1;
      
         if ($all_genes[$i-1] =~ /END:(.+)STRAND/ )   {
             my $start = $1 +1;
             my $len = $end - $start;
             my $value = "NAME:" . $name . "(+)" . ":$start-$end" . "START:" . $start . "LEN:" . $len . "STRAND:P";
             push (@all_intergenic, $value);
        }
    
         
   }


    elsif ($all_genes[$i] =~ /START:(.+)END:(.+)STRAND:-1NAME:(.+)/)  {

        
           my $name = $3;
           my $start = $2 + 1;
      
           if ($all_genes[$i+1] =~ /START:(.+)END/ )   {
               my $end = $1-1;
               my $len = $end - $start;
               my $value = "NAME:" . $name . "(-)" . ":$start-$end" . "START:" . $start . "LEN:" . $len . "STRAND:N";
               push (@all_intergenic, $value);
          }
    
         
   }




}

# Below I use Bioperl to read and extract the full DNA sequence of my organism into a string variable;




my $seqio = Bio::SeqIO->new(-file => "/d/user6/ng001/Project/sequence.fasta", 
                             -format => "fasta" ); 



my $string;

while (my $seq = $seqio->next_seq) {
   $string = $seq->seq;
}





# I create an hash of intergenic regions where keys=gene_names
# values=intergenic sequence upstream of gene.
# To do this I used the sequence imported with Bioperl
# and my array(@all_intergenic) with the intergenic coordinates.
# for the reverse strand genes the intergenic sequence is reversed-complemented.
# P=Forward Strand; N: Reverse Strand;


my %hash;

foreach my $value (@all_intergenic)  {
        if ($value =~ /NAME:(.+)START:(.+)LEN:(.+)STRAND:P/)  {
            my $sequence = substr($string, $2, $3);
            if ($3 >0)  {
          
                $hash{$1} = $sequence;
                
           }
       }

        elsif ($value =~ /NAME:(.+)START:(.+)LEN:(.+)STRAND:N/)  {

              my $sequence = substr($string, $2, $3);
              if ($3>0)  {
                 $sequence =~ tr/ATCG/TAGC/;
                 my $comp = reverse($sequence);
                 $hash{$1} = $comp;
              }
       }

}





# Filtering the intergenic sequence has by length;
# Only intergenic sequences above 80 nucleotides in length are retained in %hash2;

my %hash2;

foreach my $key (keys %hash)   {

     if (length($hash{$key}) > 80)   {
         $hash2{$key} = $hash{$key};

     }
}



# Create a Fasta File with the intergenic sequences above 80;

foreach my $key (keys %hash2)  {

    print OUTFILE ">$key\n$hash2{$key}\n";

}

   



