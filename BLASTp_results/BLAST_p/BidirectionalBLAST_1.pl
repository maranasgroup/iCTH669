#!usr/bin/perl -w

#Written by: Wheaton Schroeder
#READ ME!
#In order to perform a bi-directional blast to determine if EC numbers are present in the Exophiala dermatitidis genome.
#Using KEGG, EC numbers are translated to an AA sequence for an organism closely related to Exophiala dermatitidis (uses
#closest available organism from a defined heirarch). Then this AA sequence is blasted against the E. dermatitidis genome
#to determine if that enzyme is present in E. dermatitidis. Then, the blast direction is reversed to confirm the match.
#there are identical identity and e-value cutoffs in both directions. Technically storing protein gene accession numbers 
#because not all E. dermatitidis genes have a name. This program does require the installation of the LWP package for perl
#does require a file structure in the directory in which the code is contained:
#must have folder "BackwardBLASTs"
#must have folder "ForwardBLASTs"
#must have folder "blastResults"
#must have folder "FASTAs" with subfolder "Target"
#must edit "require" line for correct filepath for common_functions.pl
#must have file "BlastSpecs.txt", check file already given, formatting and line order is important!
#	the first line is always the scientific name of the target organism
#	the second line is always your filepath to where this code resides, and where the appropriate file structure is
#	the third line is always a header and is essentially ignored
#	the fourth line onward is the KEGG organism code [space] scientific name of that organism, the order here denotes
#		the prefered order to check for those as the related organism, so usually the closest organism phylogenetically
#		is at line 4, the second closest at line 5,  and so on and so forth

#Latest version: 10/23/19

#make a requirement LWP and the common_functions library
use LWP::UserAgent;	#imports package for web-based queries
use strict;

require "C:/Users/wls5190/Documents/ppi_tracking/BLAST_p/common_functions.pl";	#require our script of useful functions
my $userAgent = LWP::UserAgent->new; #create a user agent for the search

#organism which to direct all blast queries against, defined in BlastInput
my $queryOrg = " ";
#blast cutoffs, default, will be redefined by BlastSpecs.txt file
my $eCutOff = 1;
my $perPosSubCutOff = 0;
#stores home folder filepath, defined in BlastInput
my $filepath = " ";

#read the EC list
if (! open ECLIST, "<EClist.txt") {

	die "could not open/read EClist.txt, reason $!";
	
}

#have a dedicated abbreviated log
open(ABBLOG, ">AbbreviatedLog_1.log") or die "could not open AbbreviatedLog.log, reason $!";

#have an error log
open(ERRORLOG, ">error_1.log") or die "could not open error.log, reason $!";

#have a dedicated full log
open(FULLLOG, ">FullLog_1.log") or die "could not open FullLog.log, reason $!";

select ABBLOG;

#make the perl unbuffered, forces it to write to files realtime
$| = 1;

printf "Start time: %s\n", &timestamp;

select ERRORLOG;

#make the perl unbuffered, forces it to write to files realtime
$| = 1;

printf "Start time: %s\n", &timestamp;

select FULLLOG;

#make the perl unbuffered, forces it to write to files realtime
$| = 1;

printf "Start time: %s\n", &timestamp;

select STDOUT;

#output file for all matches which meet the cutoff
open(ECBLASTOUT, ">ECBlastInfo_1.csv") or die "could not create/write ECBlastInfo.csv, reason $!";

#chomp and store the EC list, will need to remove the comma later, if present
chomp(my @EC = <ECLIST>);

#stores hash of EC to matched genes in target, each match seperated by a comma
my %ECtoMatches = ( );

#creates a hash to get AA sequence from accession
my %accToAAseq = ( );

#creates a hash to get name from accession
my %accToName = ( );

#creates hash get organism from accession
my %accToOrg = ( );

#hash to store EC number to match numbers, forward
my %AcctoMatchNum = ( );

#hash to store EC number to match numbers, backward
#match number counter forward
my $matchNum = 0;

#array to hold blast information of good matches. Element format:
#organism used,acession used,acession matched,protein name,e-value,%ID
my @goodMatchInfo = ( );

#stores just the target organism accessions
my @matchAccession = ( );

#stores backwards match information, should be same size as @goodMatchInfo
my @backMatchInfo = ( );

#allows use of files accross the program, will be redefined frequently
my $file = " ";
my $file2 = " ";
my $file3 = " ";
my $file4 = " ";

#stores organism name that gene that was found 
my $orgName = " ";

#stores match accession that was found
my $matchAcc = " ";

#stores related organims accession that was found,this is the protein accession, the hash is for the uniprot id 
#(because for some reason the uniprot ID is occassionally given in blast reports).
my $NCBIID = " ";
my %NCBItoUniProt = ( );

#stores lines to write in an array, first element is header
my @writeLines = ("EC,Related Organism Used,Relate Protein Name,Related Accession,Related Length,Match Protein Name,Match Accession,Match Length,Forward e-val,Forward %ID, Forward %+ subs, Forward % gaps,Backward e-val,Backward %ID,Backward %+ subs,Backward % gaps,Weigted sum");

select ECBLASTOUT;

#make the perl unbuffered, forces it to write to files realtime

$| = 1;
printf "%s\n", $writeLines[$#writeLines];

select STDOUT;

#hash with keys "$EC[$i].$matchAcc", and element is the writeLines for that match
my %ECandMatchtoLine = ( );

#stores a numerical counter to create a unique filename for files which are unable to be opened/edited
my $errFiles = 0;

#stores current value of sum used to determine significance of a match
my $sum = 0;

#create a hash to store organism code to scientific name of related organism. Note, that this does not store in a fixed
#order, so an array must also be created to give order preference to these species. This is crafted using the KEGG organism
#catalog and selecting all fungi in the same family first, then using "The Ascomycota Tree of Life: A Phylum-Wide Phylogeny
#Clarifies the Origin and Evolution of Fundamental Reproductive and Ecological Traits" by Schoch et. al. 2009 selected to 
#order in which to include the orders (each order in same order as KEGG)
#this hash is necessary for the backwards blast
#so far just ascomycetes
my %prefOrgtoName = ( );

#array to keep order of preferred species
my @prefOrg = ( );

#write the prefOrg and prefOrgtoName array and hash respectively from the input file
open(BLASTIN, "<BlastSpecs_1.txt") or die "could not open/read BlastSpecs.txt, necessary file for calibrating this program for the target organism, reason: $!";

chomp(my @specs = <BLASTIN>);
#for each line of input file
for (my $u = 0; $u <= $#specs; $u++) {

	#if first line, has target organism
	if ($u == 0) {
	
		#remove "Target: " in front
		$specs[$u] =~ s/^Target:\s//;
		#name query organism
		$queryOrg = $specs[$u];
		
		#go to next line
		next;
		
	} elsif ($u == 1) { #if on second line, has filepath
		
		#remove the "Filepath: " in front
		$specs[$u] =~ s/^Filepath:\s//;
		#define the filepath
		$filepath = $specs[$u];
		
		#go to next line
		next;
		
	} elsif ($u == 2) { #if on the Expect cut-off line
		
		my ($label, $cutOff) = split /:/, $specs[$u];
		$eCutOff = $cutOff;
		
		printf "Expect Cut-Off: %s\n", $eCutOff;
		
		select FULLLOG;
		
		printf "Expect Cut-Off: %s\n", $eCutOff;
		
		select STDOUT;
		
		next;
		
	} elsif ($u == 3) { #if on the percent positive substitution cut-off line
		
		my ($label, $cutOff) = split /:/, $specs[$u];
		$perPosSubCutOff = &percenttoDecimal($cutOff);
		
		printf "Percent Positive Substitution Cut-Off: %s\n", $perPosSubCutOff;
		
		select FULLLOG;
		
		printf "Percent Positive Substitution Cut-Off: %s\n", $perPosSubCutOff;
		
		select STDOUT;
		
		next;
		
	} elsif ($u == 4) { #if on third line, has header for related species in order
		
		#don't do anything with this line
		next;
		
	}
	
	#now we are in the part where the related organism codes and scientific names are given
	my ($orgCode, $genusName, $speciesName) = split /\s/, $specs[$u];
	#add organism code to end of prefOrg array
	push @prefOrg, $orgCode;
	#define hash element to go from code to scientific name
	$prefOrgtoName{$orgCode} = $genusName." ".$speciesName;
	
}

for (my $i = 0; $i <= $#EC; $i++) {
	
	select ABBLOG;
	
	#make the perl unbuffered, forces it to write to files realtime
	$| = 1;
	
	printf "Begin EC %s at %s----------------------------------------------------------------------\n", $EC[$i], &timestamp;
	
	select STDOUT;
	
	$EC[$i] =~ s/,//g;
	
	printf "\n\n%s-------------------------------------------------------------------------------------\n",$EC[$i];
	printf "Searching %s genome for probable %s genes\n", $queryOrg, $EC[$i];
	
	select FULLLOG;
	
	#make the perl unbuffered, forces it to write to files realtime
	$| = 1;
	
	printf "\n\n%s-------------------------------------------------------------------------------------\n",$EC[$i];
	printf "Searching %s genome for probable %s genes\n", $queryOrg, $EC[$i];
	
	select STDOUT;
	
	#go to the EC page, get its conent
	my $ECurl = "http://rest.kegg.jp/get/".$EC[$i];
    printf "EC url: %s\n", $ECurl;
	my $ECpage = $userAgent->get($ECurl);
	$ECpage = $ECpage->content;
	
	#split page by \n character, so that each line is a new element in the array, allows us to split a line by \s into an array later
	my @ECpage = split /\n/, $ECpage;
	#need to get protein name
	my $protName = "";
	
	if ($ECpage =~ /NAME\s+(.+)/) {
	
		$protName = $1;
		$protName =~ s/;$//g; #remove trailing semi-colon if present
		$protName =~ s/,/;/g; #replace all commas with semi-colons for now, to avoid errors
	
	} #should not have a protein without a name
	
	#for each organism, in the order of preference, determine if that EC corresponds to a gene in that organism
	for (my $y = 0; $y <= $#prefOrg; $y++) {
		
		printf "\nUsing Organism: %s (%s)\n",$prefOrgtoName{$prefOrg[$y]},$prefOrg[$y];
		
		select FULLLOG;
		
		#make the perl unbuffered, forces it to write to files realtime
		$| = 1;
		
		printf "\nUsing Organism: %s (%s)\n",$prefOrgtoName{$prefOrg[$y]},$prefOrg[$y];
		
		select STDOUT;

        printf "search string: |(GENES)?\s+%s:\\s|\n", $prefOrg[$y];
		
		#for each line in the EC page, check if that organism code is there with associated genes
		for (my $t = 0; $t <= $#ECpage; $t++) {
			
			#search page for proper organism code
			if ($ECpage[$t] =~ /(GENES)?\s+$prefOrg[$y]:\s/i) {

                printf "match found!";
				
				#remove "GENES" if the organism is the first gene listed
				$ECpage[$t] =~ s/^GENES//ig;
				#remove excess spaces
				$ECpage[$t] =~ s/^\s+//;
				$ECpage[$t] =~ s/\s+$//;
				
				printf "Found gene for related organism %s:%s\n", $prefOrg[$y], $prefOrgtoName{$prefOrg[$y]};
				
				select FULLLOG;
				
				#make the perl unbuffered, forces it to write to files realtime
				$| = 1;
				printf "Found gene for related organism %s:%s\n", $prefOrg[$y], $prefOrgtoName{$prefOrg[$y]};
				
				select STDOUT;
				#then @prefOrg[$y] has a gene for EC[$i], get the list of genes by splitting into an array for each gene
				
				my @gene = split /\s/, $ECpage[$t];
				
				shift @gene; #remove first element of gene, which is the organism code
				
				#for each gene, get the amino acid sequence
				for (my $e = 0; $e <= $#gene; $e++) {
					
					#remove the gene name from behind the gene code
					$gene[$e] =~ s/\(.+\)//ig;
					printf "%s-------------------------------------------------------------------------------------\n",$gene[$e];
					
					select FULLLOG;
					
					#make the perl unbuffered, forces it to write to files realtime
					$| = 1;
					printf "%s-------------------------------------------------------------------------------------\n",$gene[$e];
					
					select STDOUT;
					
					#get connected to the gene page
					my $AAurl = "http://rest.kegg.jp/get/".lc($prefOrg[$y]).":".$gene[$e];
                    printf "url: %s\n", $AAurl;
					my $AApage = $userAgent->get($AAurl);
					$AApage = $AApage->content;
					
########################################################################################################################################
					#GET THE AMINO ACID SEQUENCE!
					#do this by matching all text between AASEQ and NTSEQ, capturing all intevening alphabetical characters
					if ($AApage =~ /AASEQ\s+[0-9]+\n\s+(([A-Z]+\s+)+)NTSEQ/) {
						
						#so we have an AA sequence, build the fasta
						my $AAseq = $1;
						
						#remove spaces from AAsequence, leave newlines
						$AAseq =~ s/\s//ig;
						
						#need to grab NCBI protein ID
						$NCBIID = "";
						
						if ($AApage =~ /NCBI-ProteinID:\s+(\w+)/) {
							
							$NCBIID = $1;
						
						}
						
						if ($AApage =~ /UniProt:\s+(\w+?)(\s|$)/) {
							
							$NCBItoUniProt{$NCBIID} = $1;
						
						} else { #if it doesn't have a UniProt ID
							
							$NCBItoUniProt{$NCBIID} = $NCBIID;
						
						}
						
						printf "Building FASTA report for gene %s (Accession: %s)\n", $gene[$e], $NCBIID;
						
						select FULLLOG;
						
						#make the perl unbuffered, forces it to write to files realtime
						$| = 1;
						
						printf "Building FASTA report for gene %s (Accession: %s)\n", $gene[$e], $NCBIID;
						select STDOUT;
						
						$accToAAseq{$NCBIID} = $AAseq;
						my $origLenth = length($AAseq);
						#get the scientific name of the organism
						$orgName = $prefOrgtoName{$prefOrg[$y]};
						$accToOrg{$NCBIID} = $orgName;
						$accToName{$NCBIID} = $protName;
						
########################################################################################################################################
						#BUILD THE FASTA! first create the file. Note, .fasta files should open in notepad, or failing that
						#they will open in notepad++
						$file = $filepath."FASTAs\\".$NCBIID.".fasta";
						
						open(FASTA, ">".$file) or die "could not create/write $file, reason $!";
						
						#then write the header line
						select FASTA;
						
						#make the perl unbuffered, forces it to write to files realtime
						$| = 1;
						
						printf ">%s %s [%s]\n", $NCBIID, $accToName{$NCBIID}, $accToOrg{$NCBIID};
						printf "%s", $accToAAseq{$NCBIID};
						
						close FASTA;
						
						#need to return the output to the standard output to prevent errors
						select STDOUT;
						
########################################################################################################################################
						#DO THE BLAST AND WRITE THE RESULTS!
						#at this point I have the FASTAs built, so I have all the blast inputs, perform the forward blast
						#built FASTA to queryOrg looking for best match
						my $blastResults_f = &web_blast("blastp","nr",$queryOrg,$file);
						
						my @BlastLines = split /\n/, $blastResults_f;
						
						#print out the blast results
						$file2 = $filepath."ForwardBLASTs/".$NCBIID.".txt";
						
						if (! open BLASTRES, ">".$file2) {
							
							print ERRORLOG "could not create/write $file2, reason $!";
							open BLASTRES, ">ForwardBLASTs/".$NCBIID."num".$errFiles.".txt";
							$errFiles++;
							
						}
						
						select BLASTRES;
						#make the perl unbuffered, forces it to write to files realtime
						$| = 1;
						
						#basically clean the blast results of unnecessary spaces
						#at the end of the line
						for(my $zz = 0; $zz <= $#BlastLines; $zz++) {
						
							$BlastLines[$zz] =~ s/\s+$//g;
							printf "%s\n", $BlastLines[$zz];
						
						}
						
						close BLASTRES;
						
						select STDOUT;
						
#########################################################################################################################################
						#GET THE MATCHES, GET MATCHED GENES FASTAS!
						#get the best forward matches (based on e-value cut offs). 
						#split blast results into seperate lines
						
						#for each line of the forward blast
						for (my $p = 0; $p <= $#BlastLines; $p++) {
							
							#read in alignment information, if there
							#split by spaces, if accession is there, 
							my @line = split /\s+/, $BlastLines[$p];
							
							#get the first element of the 
							my $startLine = shift @line;
							
							if (defined $startLine) {
							
								chomp($startLine);
								
							}
							
							#if the line starts with a valid accession
							#Accession numbers are RefSeq accession numbers, of the pattern shown below
							if ((defined $startLine) && ($startLine =~ /^[A-Z][A-Z]_/)) {
								
								#then we must be in the "Sequences producing significant alignments" table, get the significant alignment
								#name fragment (use to find name), accession number, E-value, lose score, keep only if significant
								$matchAcc = $startLine;
								
								#get identity percentage
								my $id_per = pop @line;
								
								#get expect value
								my $eVal = pop @line;
								$eVal =~ s/\s+//g;
								
								#pop score without saving it, we won't use it
								pop @line;
								
								#put together name fragment
									my $name = join " ", @line;
									
								#remove spaces at either end
								$name =~ s/^\s//;
								$name =~ s/\s$//;
									
								#remove commas, replace with semicolons
								$name =~ s/,/;/g;
									
								#remove "..." indicating a long name, and everything after the three dots, as that indicates the end of the name
								$name =~ s/\.\.\..+$//;
									
								#check if full name (don't include organism name in protein name)
								#right square bracket indicates start of organism
								if ($name =~ /(.+)\[/) {
									
									#remove organism by getting only everything before the square bracket
									$name = $1;
									$name =~ s/\s$//;
										
								} else { #otherwise missing part of name, need to search rest of document for full name
										
									#get all results matching the name fragment
									#need to do a reformat to the name to use it as a search string
									$name = &readyForMatch($name);
									my @nameFragMatch = ($blastResults_f =~ /$name.+/g);
									#second match to name fragment will be full name
									$name = $nameFragMatch[1];
									#remove organism name
									$name =~ s/\[.+\]//ig;
										
								}
								
								if ((($eVal =~ /^(\d|e|-|\.)+$/) || ($eVal =~ /^(\d+\.\d+)$/)) && ($eVal < $eCutOff)) {
									
									printf "matched e val\n";
									
									my $perPosSub = 0;
									my $latestAcc = " ";
									
									for (my $z = $p + 1; $z <= $#BlastLines; $z++) {
										
										#record the latest accession, if changed
										if ($BlastLines[$z] =~ /^>(.+?)\s/) {
										
											$latestAcc = $1;
											
										}
										
										#find and turn the percent positive substitution into a decimal
										#make sure we are in the correct accession alignment report
										if (($latestAcc eq $matchAcc) && ($BlastLines[$z] =~ /Positives\s=\s[0-9]+\/[0-9]+\s\(([0-9]+\%)\)/)) {
											
											$perPosSub = &percenttoDecimal($1);
											
											printf "accession: %s, fraction positive substitution: %s\n", $matchAcc, $perPosSub;
											
											select FULLLOG;
											
											printf "accession: %s, fraction positive substitution: %s\n", $matchAcc, $perPosSub;
											
											select STDOUT;
											
											$z = $#BlastLines + 1;
											
										}
										
									}
									
									if ($perPosSub < $perPosSubCutOff) {
									
										next;
									
									}
									
									$sum = 0;
									
									printf "Found a significant match, eval: %s\n", $eVal;
									
									select FULLLOG;
									
									#make the perl unbuffered, forces it to write to files realtime
									$| = 1;
									
									printf "Found a significant match, eval: %s\n", $eVal;
									
									select STDOUT;
									
									#fill hashes with this matched accession
									$accToName{$matchAcc} = $accToName{$NCBIID};
									$accToOrg{$matchAcc} = $queryOrg;
									$AcctoMatchNum{$matchAcc} = $matchNum;
									$matchNum++;
									
									#time the capture the fasta of the match
									my $MatchURL = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=protein&id=".$matchAcc."&rettype=fasta&retmode=text";
									my $MatchFasta = $userAgent->get($MatchURL);
									$MatchFasta = $MatchFasta->content;
									
									#get AA sequence
									my @fasta = split /\n/, $MatchFasta;
									shift @fasta;
									my $matchAAseq = join "", @fasta;
									$accToAAseq{$matchAcc} = $matchAAseq;
									my $length = length($matchAAseq);
									push @goodMatchInfo, $orgName.",".$accToName{$NCBIID}.",".$NCBIID.",".$origLenth.",".$name.",".$matchAcc.",".$length.",".$eVal.",";
									
									#BUILD THE FASTA! first create the file. Note, .fasta files should open in notepad, or failing that
									#they will open in notepad++
									printf "building FASTA report for %s gene %s\n", $queryOrg, $matchAcc;
									
									select FULLLOG;
									
									#make the perl unbuffered, forces it to write to files realtime
									$| = 1;
									
									printf "building FASTA report for %s gene %s\n", $queryOrg, $matchAcc;
									
									select STDOUT;
									
									$file3 = $filepath."FASTAs\\Target\\".$matchAcc.".fasta";
									
									if (! open FASTA, ">".$file3) {
									
										die "could not create/write $file3, reason $!\n";
										
									}
									
									#then write the header line
									select FASTA;
									
									#make the perl unbuffered, forces it to write to files realtime
									$| = 1;
									printf "%s", $MatchFasta;
									
									close FASTA;
									
									#need to return the output to the standard output to prevent errors
									select STDOUT;
									
									#search for the % identity in the accession section
									for (my $n = $p + 1; $n <= $#BlastLines; $n++) {
									
										#get new search line
										my @line2 = split /s+/, $BlastLines[$n];
										#get new start line
										my $startLine2 = shift @line2;
										
										if ((defined $startLine2) && ($startLine2 =~/^>$matchAcc/)) {
										
											#advance to percent identity and store it
											my $percentID = "";
											
											while (! ($BlastLines[$n] =~ /Identities\s=/)) {
											
												$n++;
												
											}
											
											if ($BlastLines[$n] =~ /Identities\s=\s[0-9]+\/[0-9]+\s\(([0-9]+\%)\)/) { #note should not fail, just trying to capture text
												
												$percentID = $1;
											
											}
											
											my $posSubs = " ";
											
											#get percentage of positive substitutions
											if ($BlastLines[$n] =~ /Positives\s=\s[0-9]+\/[0-9]+\s\(([0-9]+\%)\)/) {
												
												$posSubs = $1;
											
											}
											
											my $gapsPer = " ";
											
											#get percentage of positive substitutions
											if ($BlastLines[$n] =~ /Gaps\s=\s[0-9]+\/[0-9]+\s\(([0-9]+\%)\)/) {
												
												$gapsPer = $1;
											
											}
											
											#append to goodMatchInfo, if the accession is a good match (will filter out bad matches caught earlier
											if (exists $AcctoMatchNum{$matchAcc}) {
												
												$goodMatchInfo[$AcctoMatchNum{$matchAcc}] = $goodMatchInfo[$AcctoMatchNum{$matchAcc}].$percentID.",".$posSubs.",".$gapsPer.",";
											
											}
											
#########################################################################################################################################################################################
											#DO THE BACKWARDS BLAST AND WRITE THE RESULTS! to confirm acceptable by blasting best forward match sequences 
											#against original organism
											#at this point I have the FASTAs built, so I have all the blast inputs, perform the backward blast using
											#retrieved FASTA against the original organism
											printf "confirming match significance for %s gene %s\n",  $queryOrg, $matchAcc;
											
											my $blastResults_b = &web_blast("blastp","nr",$orgName,$file3);
											#print out the blast results
											$file4 = $filepath."BackwardBLASTs\\".$matchAcc."on".$NCBIID.".txt";
											
											if (! open BLASTRES, ">".$file4) {
												
												print ERRORLOG "could not create/write $file4, reason $!\n";
												open BLASTRES, ">BackwardBLASTs\\".$matchAcc."on".$NCBIID."num".$errFiles.".txt";
												$errFiles++;
												
											}
											
											select BLASTRES;
											
											#make the perl unbuffered, forces it to write to files realtime
											$| = 1;
											
											#split lines and loop to remove trailing spaces
											my @BlastLines_b = split /\n/, $blastResults_b;
											
											for (my $aa = 0; $aa <= $#BlastLines_b; $aa++) {
											
												$BlastLines_b[$aa] =~ s/\s+$//g;
												printf "%s\n", $BlastLines_b[$aa];
											
											}
											
											close BLASTRES;
											
											select STDOUT;
											
											#Search for accession number of related organism
											my $confirmedMatch = 0;
											
											for ($b = 0; $b <= $#BlastLines_b; $b++) {
											
												#split the blast line into words
												my @search = split /\s+/, $BlastLines_b[$b];
												
												#the accession is always the first element in the line, so check to see if it is the accession we are looking for
												my $first = shift @search;
												
												#get the percent identity and e-value
												my $id_per2 = pop @search;
												my $eVal2 = pop @search;
												
												#don't save the score
												pop @search;
												
												my $UniProt = $NCBItoUniProt{$NCBIID};
												
												#if first element is defined, is a legal ID for the related protein, and we don't have a confirmed match
												if ((defined $first) && (($first =~ /^$NCBIID/) || ($first =~ /^$UniProt/)) && ($confirmedMatch == 0)) { #should only be true once
													
													#found a match, this means we are in the "sequences producing significant alignments" table
													#the last element of this line should be the e-value
													
													if (($eVal2 =~ /^(\d|e|-|\.)+$/) && ($eVal2 < $eCutOff)) {
														
														my $perPosSubb = 0;
														my $latestAccb = " ";
														
														for (my $x = $b + 1; $x <= $#BlastLines_b; $x++) {
															
															#record the latest accession, if changed
															if ($BlastLines_b[$x] =~ /^>(.+?)\s/) {
																
																$latestAcc = $1;
																
															}
															
															#find and turn the percent positive substitution into a decimal
															#make sure we are in the correct accession alignment report
															if ((($latestAcc eq $NCBIID) || ($latestAcc eq $UniProt)) && ($BlastLines_b[$x] =~ /Positives\s=\s[0-9]+\/[0-9]+\s\(([0-9]+\%)\)/)) {
																
																$perPosSub = &percenttoDecimal($1);
																
																printf "accession: %s, fraction positive substitution: %s\n", $matchAcc, $perPosSub;
																
																select FULLLOG;
																
																#make the perl unbuffered, forces it to write to files realtime
																$| = 1;
																
																printf "accession: %s, fraction positive substitution: %s\n", $matchAcc, $perPosSub;
																
																select STDOUT;
																
																$x = $#BlastLines_b + 1;
															
															}
														
														}
														
														if ($perPosSub < $perPosSubCutOff) {
														
															printf "match not confirmed.\n";
															
															select FULLLOG;
															
															#make the perl unbuffered, forces it to write to files realtime
															$| = 1;
															
															printf "match not confirmed.\n";
															
															select STDOUT;
															
															next;
														
														}
														
														#we have a good backwards and forwards match
														push @backMatchInfo, $eVal2.",";
														
														#search for percent identity, iterate through the lines after the current one
														#since alignment reports after the sequences table
														for (my $r = $b + 1; $r <= $#BlastLines_b; $r++) {
															
															my @findID = split /\s+/, $BlastLines_b[$r];
															my $findAcc = shift @findID;
															
															if ((defined $findAcc) && (($findAcc =~ /^>$NCBIID/) || ($findAcc =~ /^>$UniProt/))) {
																
																$findAcc =~ s/^>//;																
																
																#match is confirmed!
																printf "match confirmed! E-value: %s\n",$eVal2;
																printf "For gene: %s onto gene: %s\n", $findAcc, $matchAcc;
																
																select FULLLOG;
																
																#make the perl unbuffered, forces it to write to files realtime
																$| = 1;
																
																printf "match confirmed! E-value: %s\n",$eVal2;
																printf "For gene: %s onto gene: %s\n", $findAcc, $matchAcc;
																
																select STDOUT;
																
																$confirmedMatch = 1;
																
																while (! ($BlastLines_b[$r] =~ /Identities\s=/)) {
																	
																	$r++;
																	
																}
																
																my $percentIDb = " ";
																
																if ($BlastLines_b[$r] =~ /Identities\s=\s[0-9]+\/[0-9]+\s\(([0-9]+\%)\)/g) { #note should not fail, just trying to capture text
																	
																	$percentIDb = $1;
																	
																}
																
																my $posSubsb = " ";
																
																if ($BlastLines_b[$r] =~ /Positives\s=\s[0-9]+\/[0-9]+\s\(([0-9]+\%)\)/g) { #note should not fail, just trying to capture text
																	
																	$posSubsb = $1;
																	
																}
																
																my $gapsPerb = " ";
																
																if ($BlastLines_b[$r] =~ /Gaps\s=\s[0-9]+\/[0-9]+\s\(([0-9]+\%)\)/g) { #note should not fail, just trying to capture text
																	
																	$gapsPerb = $1;
																	
																}
																
																#remove parentheses
																$percentIDb =~ s/\(//g;
																$percentIDb =~ s/\)//g;
																
																#append to goodMatchInfo
																$backMatchInfo[$#backMatchInfo] = $backMatchInfo[$#backMatchInfo].$percentIDb.",".$posSubsb.",".$gapsPerb.",";
																
																#have confirmed a good matchand got percent identity, add to writeLines
																push @writeLines,$EC[$i].",".$goodMatchInfo[$AcctoMatchNum{$matchAcc}].$backMatchInfo[$#backMatchInfo];
																
																#since this is a long program, write to the output file while running so that can check periodically
																select ECBLASTOUT;
																
																#make the perl unbuffered, forces it to write to files realtime
																$| = 1;
																printf "%s\n", $writeLines[$#writeLines];
																
																select ABBLOG;
																
																#make the perl unbuffered, forces it to write to files realtime
																$| = 1;
																
																printf "\n%s: Match Report:\n%s\n", &timestamp, $writeLines[$#writeLines];
																
																select FULLLOG;
																
																#make the perl unbuffered, forces it to write to files realtime
																$| = 1;
																
																printf "\n\n%s: Match Report:\n%s\n\n", &timestamp, $writeLines[$#writeLines];
																
																select STDOUT;
																
																printf "\n\n%s: Match Report:\n%s\n\n", &timestamp, $writeLines[$#writeLines];
															
															}
														
														}
														
													} else {
													
														printf "match not confirmed.\n";
														
														select FULLLOG;
														
														#make the perl unbuffered, forces it to write to files realtime
														$| = 1;
														
														printf "match not confirmed.\n";
														
														select STDOUT;
													
													}
													
												} #otherwise keep searching for related accession 
											
											}
											
										} #otherwise go to next line 
									
									}
									
								} #otherwise don't bother, not a significant match
							
							}
							
						}	
						
					} else {
					
						#there is no AA sequence so nothing to blast, don't build FASTA, etc.
					
					}
					
				}
				
			}
			
		}
		
	}
	
	select ABBLOG;
	
	#make the perl unbuffered, forces it to write to files realtime
	$| = 1;
	
	printf "finished EC %s\n", $EC[$i];
	
	select STDOUT;

}

select ERRORLOG;

#make the perl unbuffered, forces it to write to files realtime
$| = 1;

printf "end time: %s\n", &timestamp;

select ABBLOG;

#make the perl unbuffered, forces it to write to files realtime
$| = 1;

printf "end time: %s\n", &timestamp;

select FULLLOG;

#make the perl unbuffered, forces it to write to files realtime
$| = 1;

printf "end time: %s\n", &timestamp;

select STDOUT;