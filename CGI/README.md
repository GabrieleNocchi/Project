This is the CGI folder of the visualization pipeline developed.
In this folder there are 5 cgi scripts.

- cgi.pl is connected to bacfold.pl
- cgi2.pl is connected to bacfold2.pl
- Both bacfold.pl and bacfold2.pl are connected to fold2.pl



Requirements:

- cgi.pl requires a Fasta file with the intergenic regions. (Created using myparser.pl)
- cgi2.pl requires a Fasta file with the intergenic regions and 2 output files (one per strand) produced
using TransTermHp_v2.09
- bacfold.pl requires a Fasta file with the intergenic regions  and the output file of SwiSpot for the sequences filtered by SD sequestration (created using the scripts swis.pl and extractor.pl).
- bacfold2.pl requires a Fasta file with the intergenic regions, the 2 output files (one per strand) produced using TransTerm_Hp_v2.09 and the output of SwiSpot for the sequences filtered by terminator sequestration (created using the scripts swis.pl and extractor.pl).


cgi.pl, cgi2.pl, bacfold.pl and bacfold2.pl are independent;
fold2.pl requires to be reached via bacfold.pl or bacfold2.pl, as it runs "on-the-fly" analysis of sequences selected by the user in those pages.
