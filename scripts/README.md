
This directory containts the scripts necessary to create the files needed by the CGI pages to filter and display the sequences; the use of SwiSpot, TransTermHP and RNAfold is necessary to produce some of the files.

- myparser.pl is used to create a file with the intergenic regions of an organism. It takes a GenBank file and Fasta file as Input. This file is used by all of the CGI scripts.
- makeptt.pl is used to create a .ptt annotation file from a GenBank file. It takes a GenBak file as Input. 
- extendppt.pl & extendppt2.pl are scripts which extract the forward and reverse strand information respectively from a full .ptt file (created with makeptt.pl); these 2 scripts take a full .ptt file as input; each script produces a single .ptt file (relative to one strand).
This 2 output files are then scanned for the presence of rho-independent terminators using TransTermHP from the command line; the 2 resulting outputs are those which are read and filtered live by  cgi2.pl and bacfold2.pl.
- swis.pl is used to feed a file with sequences to SwiSpot; it takes a Fasta file with intergenic regions as input; it produces an output file with the raw output of SwisSpot for each of the sequences.
- extractor.pl is used to filter the output file created by swis.pl; this script creates a simpler file which is then read on the fly by bacfold.pl and bacfold2.pl


4 files required: intergenic regions fasta, transtermhp forward strand output, transtermhp reverse strand output, swispot output for region scanned by SD, swisspot output for region scanned by terminators with transterm.
