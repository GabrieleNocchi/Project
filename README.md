# Project
Prediction of riboswitch regulation in B. subtilis strain 168


This is an HTML/CGI visualization tool; this pipepline searches the intergenic regions of B.subtilis to select only those more likely to host riboswitches. Few stages of filtering are carried out, the outcome of each is displayed by a separate CGI page. This pipeline is extendable to all prokaryotes, however few addition in the GenBank parser should be considered.

To Install and use this application a WWW and cgi-bin directories are required; the scripts found in the directory cgi of this repository should be saved within the cgi-bin directory; the same goes for the file found in the WWW directory.


In addition 5 extra files are pre-calculated and placed within the cgi-bin directory, and then read by the cgi scripts found in this directory; some of these file are pre-calculated using external programs, namely SwiSpot and TransTermHPv2.09, which can be a lengthy process.

To create these files follow the instructions in the scripts directory.
The files required are:
- A FASTA with the intergenic regions extracted from the organism of interest.
- 2 output files (1 per strand) produced with TransTermHP with the terminators output.
- 2 output files produced by SwiSpot and slightly edited (using swis.pl and extractor.pl, available in scripts). 1 output for the sequences filtered by SD motif and 1 for the sequences filtered for terminator presence using TransTermHP_v2.09.
