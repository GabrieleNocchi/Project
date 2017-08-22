# Project
Prediction of riboswitch regulation in B. subtilis strain 168


This is an HTML/CGI filtering and visualization pipeline; this pipepline searches the intergenic regions of B.subtilis to select only those more likely to host riboswitches. Few stages of filtering are carried out, the outcome of each is displayed by a separate CGI page. This pipeline is extendable to all prokaryotes, however few addition in the GenBank parser should be considered.

To run this pipeline live WWW and cgi-bin directories are required.


In addition 5 extra files need to be pre-calculated and placed within the cgi-bin directory; some of these files are pre-calculated using external programs, namely SwiSpot and TransTermHPv2.09, which can take long depending on sample size.

To create these files follow the instructions available in the "scripts" directory.
The files required are:
- A FASTA with the intergenic regions extracted from the organism of interest.
- 2 output files (1 per strand) produced with TransTermHP with the terminators output.
- 2 output files produced by SwiSpot and slightly re-formatted (using swis.pl and extractor.pl, available in "scripts"). 1 output for the sequences filtered by SD motif and 1 for the sequences filtered for terminator presence using TransTermHP_v2.09.


To Begin follow the instructions in the "scripts" directory.
