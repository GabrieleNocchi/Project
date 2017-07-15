
This directory containts the scripts necessary to create the files needed by the visualization applet to run.

- myparser.pl is used to create a file with the intergenic regions of an organism. It takes a GenBank file and Fasta file as Input.
- makeptt.pl is used to create a .ptt annotation file from a GenBank file. It takes a GenBak file as Input.
- extendppt.pl & extendppt2.pl are scripts which extract the forward and reverse strand information respectively from a full .ptt file; these 2 scripts take a full .ptt file as input; each script produces a single .ptt file (relative to one strand).
- swis.pl is used to feed a file with sequences to SwiSpot; it takes a Fasta file with intergenic regions as input; it produces an output file with the raw output of SwisSpot for each of the sequences.
- extractor.pl is used to filter the output file created by swis.pl; this script creates a simpler files which are read by bacfold.pl and bacfold2.pl
