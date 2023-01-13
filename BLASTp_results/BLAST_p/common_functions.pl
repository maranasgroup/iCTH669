#Below are the subroutines used in this code to save space and to allow other programs to use these subroutines
#Thes subroutines are used frequenty throughout the script above. Unfortunately in Perl there is no way to define the 
#number and type of inputs to a function, so it is not "fool-proof", so before using please read the comments and or 
#documentation.

#This subroutine pulls the text from between two delimiters, which is a very common operation in this code
#inputs:
#	$_[0] = string from which to pull the text
#	$_[1] = string which defines the beginning index (this string will not be pulled, will be skipped) beginning delimiter
#	$_[2] = string which defines the end index, as previous, will not be returned in pulled string
#outputs:
#	$soughtString = the string contained in $_[0] which lies between the delimiters $_[1] and $_[2]
sub getDelimitedText {
	$beginIndex = index($_[0], $_[1]) + length($_[1]); #gives index of beginning of string then adds # characters so not capturing delimiter
	$endIndex = index($_[0], $_[2], $beginIndex); #gives index of end delimiter
	$stringLength = $endIndex - $beginIndex;
	$soughtString = substr($_[0], $beginIndex, $stringLength); #pulls substring
	return $soughtString; #returns substring
}

#This subroutine takes in a string that is a chemical formula and breaks it down into individual atomic symbols
#and subscripts, where the subscripts and atomic symbols are in the same order. That is for the formula C6H12O6,
#$AtomicSym[1] = H, $Subscript[1]=12.
#inputs:
#	$_[0] = string that is the chemical formula, e.g. [C6H12O6]
#outputs:
#	\@AtomicSym = reference to store of atomic symbols found, e.g. [C, H, O]
#	\@Subscript = reference of store of substripts for found atomic symbols, if no subscript provided the default is 1, e.g. [6, 12, 6]
sub breakdownCF {
	#define arrays to work with
	my @AtomAndSub = ( );
	my @AtomicSym = ( );
	my @Subscript = ( );
	$CF = $_[0];
	while($CF =~ /[A-z][a-z]?[0-9]*/g) { #match pattern to single atomic symbol, while optionally capturing subscript
		#for C6H12O6, the first interation should capture $& = "C6"
		push(@AtomAndSub, $&); #add the match to the atom and sub array
	}
	#now that the atomic symbol/subscript pairs have been split from the rest, split the symbol from the subscript
	for (my $i = 0; $i <= $#AtomAndSub; $i++) { #for each item in @AtomAndSub
		if ($AtomAndSub[$i] =~ /n/g) {
			next;
		}
		while ($AtomAndSub[$i] =~ /[A-z][a-z]?/g) { #for each atomic symbol
			#add each symbol to the @AtomicSym array
			push @AtomicSym, $&;
		}
		$tempSub = 1; #set default subscript to 1
		#if there is a subscript other than one
		while ($AtomAndSub[$i] =~ /[0-9]+/g) {
			#then use that as the subscript value
			$tempSub = $&;
		}
		push @Subscript, $tempSub; #add substript to @Subscript
	}
	#now the atomic symbols and subscripts are broken up, return them as arrays
	return (\@AtomicSym, \@Subscript); #return the two arrays
	#this is actually a little complex in that it is not possible to return more than one array, so we are simply returning
	#an array of array references.
}

#This subroutine takes the atomic symbols and subscripts from breakdownCF and does two important things: 1) it adds new atomic symbols
#to the header for the metabolites document @MetLabels, and to the hash %AtomicSym and 2) formats the row of subscripts for the present species
#inputs:
#	$_[0] = \@MetLabels = reference to array of column labels for metabolite document. Will push new atomic symbols into it
#	$_[1] = \%AtomicSymbols = reference to hash of atomic symbols, key is symbol, value is number order. Will add new atomic symbols
#	$_[2] = \@AtomicSyms = array of atomic symbols present in the current species
# 	$_[3] = \@Subscripts = array of subscripts present in current species related to the atomic symbols
#outputs:
#	\@newMetLabels = reference to updated @MetLabels array
#	\%newAtomicSymbols = reference to updated %AtomicSymbols hash
#	$formattedSubs = string of subscripts formatted so that it is ready to append to the current metabolite row being generated
sub updateSymsAndSubs {
	$MetLabelsRef = $_[0]; #get the met labels reference
	$AtomicSymbolsRef = $_[1]; #get the atomic symbols reference
	$AtomicSymsRef = $_[2]; #get atomic syms for this species reference
	$SubscriptsRef = $_[3]; #get subscripts for this species reference
	my @newMetLabels = @$MetLabelsRef; #get array from reference
	my %newAtomicSymbols = %$AtomicSymbolsRef; #get symbols has from reference
	my @copyAtomicSyms = @$AtomicSymsRef;
	my @copySubscripts = @$SubscriptsRef;
	#creates an array in whic hto store what atoms are currently present
	my @PresentAtoms = ( );
	#output string defined here
	$formattedSubs = "";
	for (my $i = 0; $i <= $#copyAtomicSyms; $i++) { #foreach atomic symbol in the species
		$TempAtomicSym = $copyAtomicSyms[$i];
		#1) check to see if it exists the the atomic symbol hash, if not add it to the hash, and the the labels
		if (! exists $newAtomicSymbols{$TempAtomicSym}) { #if the atomic symbol does not exist in the hash
			$numberofKeys = keys %newAtomicSymbols;
			$newAtomicSymbols{$TempAtomicSym} = $numberofKeys; #add new key to hash at the current number of keys
			#indexing begins at 0 as usual		
			push @newMetLabels, $copyAtomicSyms[$i]; #add new atomic symbol to end of metabolic labels
		}
		
		#add the subscript to the present symbols array at the index specified by the atomic symbol hash key
		#any species not present in the species will be undef, or in otherwords will not exist
		$PresentAtoms[$newAtomicSymbols{$copyAtomicSyms[$i]}] = $copySubscripts[$i]; 
	}
	
	
	#2) format the row for the metabolites document
	for (my $i = 0; $i <= $#PresentAtoms; $i++) {
		#if the element in the present atoms array exists/is defined
		if (exists $PresentAtoms[$i]) {
			#then that atom is present and needs a subscript
			$formattedSubs = $formattedSubs.$PresentAtoms[$i].",";
		} else { #if it is not defined
			#it does not have any atoms of that symbol
			$formattedSubs = $formattedSubs.",";
		}
	}

	#now the meat of the program is done, all that needs to be done is to return references to the updated hash and array
	#and to return the formatted string.
	return (\@newMetLabels, \%newAtomicSymbols, $formattedSubs);
}

#this subroutine is written to search the KEGG database for a specifica name. It also holds contingencies such as 
#a hash for amino acids (since they are commonly listed by their three letter designation), and a contingency for 
#protons (charge +1, formula hydrogen), proteins, polymers with a designated n-value, and finally a hash for common
#acronyms (as part of the amino acid hash)
#inputs:
#	$speciesName = chemical species name
#outputs:
#	$KEGGID = KEGG ID+ for chemical compound, format C[0-9]+ OR $speciesName if KEGGID is passed
#	$speciesCharge = formal charge of chemical species
#	$CF = chemical formula of the named compound
#call looks like: ($KEGGID, $speciesCharge, $CF) = &searchKEGGforCF($speciesName);
sub searchKEGGforCF {

	#first, create a hash for 3 letter protein codes that often appear in chemical species,
	#this will allow for easy lookup of amino acids. For most, a specific chirality is noted so that
	#search parameters may fit more exactly, since chirality does not affect the molecular formula
	#this hash gives KEGG ID, charge and molecular formula, allowing us to forgo a KEGG search
	#the return string may be split using the split function with delimeter :
	my %commonSpecies = (
		"Ala" => "L-Alanine:C00041:0:C2H7NO2",
		"Ile" => "L-Isoleucine:C00407:0:C6H13NO2",
		"Leu" => "L-Leucine:C00123:0:C6H12NO2",
		"Val" => "L-Valine:C00183:0:C5H11NO2",
		"Phe" => "L-Phenylalanine:C00079:0:C9H11NO2",
		"Trp" => "L-Tryptophan:C00078:0:C11H12N2O2",
		"Tyr" => "L-Tyrosine:C00082:0:C9H11NO3",
		"Asn" => "L-Asparagine:C00152:0:C4H8N203",
		"Cys" => "L-Cysteine:C00097:0:C3H7NO2S",
		"Gln" => "L-Glutamine:C00064:0:C5H10N2O3",
		"Met" => "L-Methionine:C00073:0:C5H11NO2S",
		"Ser" => "L-Serine:C00065:0:C3H7N03",
		"Thr" => "L-Threonine:c00188:0:C4H9NO3",
		"Asp" => "L-Aspartic Acid:C00049:0:C4H7NO4",
		"Glu" => "L-Glutamic Acid:C00025:0:C5H9NO4",
		"Arg" => "L-Arginine:C00062:0:C6H14N4O2",
		"His" => "L-Histidine:C00135:0:C6H9N3O2",
		"Lys" => "L-Lysine:C00047:0:C6H14N2O2",
		"Gly" => "Glycine:C00037:0:C2H5N02",
		"Pro" => "L-Proline:C00148:0:C5H9NO2",
		"ATP" => "Adenosine 5'-triphosphate:C00002:0:C10H16N5O13P3",
		"ADP" => "Adenosine 5'-diphosphate:C00008:0:C10H15N5O10P2",
		"AMP" => "Adenosine 5'-monophosphate:C00020:0:C10H14N5O7P1",
		"NADP+" => "NADP+:C00006:+1:C21H29N7O17P3",
		"NADPH" => "NADPH:C00005:0:C21H30N7O17P3",
		"H2O" => "Water:C00001:0:H2O",
		"Ammonium" => "Ammonium:C01342:1:NH3",
		"H+" => "Proton:C00080:1:H",
		"H" => "Proton:C00080:1:H",
		"H2SO4" => "Sulfuric acid:C00059:0:H2SO4",
		"fa6" => "fa6:UNKNOWN:-1:C16H31O2",
		"fa6coa" => "fa6:UNKNOWN:-1:C37H63N7O17P3S",
		"HYXN" => "Hypoxanthine:C00262:0:C5H4N4O",
		
	);
	
	chomp($_[0]);
	$speciesName = $_[0];
	$KEGGID = "";
	$speciesCharge = "0";
	$CF = "";
	
	#format the species name to something that is searchable
	$searchName = &formatName($speciesName);
	#give an output so the user does not become impatient and terminate early
	printf "Searching KEGG for chemical species |%s|\n", $searchName;
	
	#now before we get too involved, let us see if we can forgo a KEGG search, by avoiding searches on
	#the provided chemical species by way of it being a proton, protein, or in common species hash
	if ($searchName =~ /protein/i) { #if the species is named as a protien
		#then it will not be able to be found in KEGG compound, or even have a meaningful molecular
		#formula, as it may well vary on a species to species basis
		$KEGGID = "PROTEIN";
		$speciesCharge = "0";
		$CF = "AA POLYMER";
		return ($KEGGID, $speciesCharge, $CF);
	} else { #check if in common species hash
		#for each element in common species hash
		foreach $key (sort keys %commonSpecies) {
			#search to see if the name contains the hash key, but need to be careful so we just
			#pick up those instances where a protien or a form of ATP was intended
			#ATP/AMP/ADP will stand alone, however, it is possible that the two bound
			#if AAs stand alone will likely be full name such as "L-Leucine"
			#there are more sophisticated names with alternations of AA codes and molecule names,
			#but I have to be realistic and stop looking for specialized occurances at some point
			$hashOut = $commonSpecies{$key};
			#if species contains just a three letter code for an AA
			if ($searchName =~ /^$key$/) {
				($speciesName, $KEGGID, $speciesCharge, $CF) = split /:/, $hashOut;
				return ($KEGGID, $speciesCharge, $CF);
				
			} elsif ($hashOut =~ /^$searchName$/i) { #if the hash value for the key contains the search name
				#then the name fed must have been a full amino acid name, return the hash information
				($speciesName, $KEGGID, $speciesCharge, $CF) = split /:/, $hashOut;
				return ($KEGGID, $speciesCharge, $CF);
			}
			
			#otherwise, doesn't look like any common species are in here
		
		}
	
	}
	
	#added section to handle if KEGGID is directly passed to this fuction
	if ($searchName =~ /^C[0-9][0-9][0-9][0-9][0-9]$/) {
		#we now know what page to go to, will save runtime
		$UserAgent = LWP::UserAgent->new; #creates new user agent
		$compoundURL = "http://rest.kegg.jp/get/".$&;
		$compoundResults = $UserAgent->get($compoundURL);
		$compoundResults = $compoundResults->content;
		#if there is a chemical formula given, get everything on the formula line after formula followed by spaces (or a tab)
		#see example page http://rest.kegg.jp/get/C00002 to see how I chose the regular expressions
		#recall that the metacharacter '.' matches everything but newline characters
		if ($compoundResults =~ /FORMULA\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$CF = $1;
			chomp($CF);
		}
		
		if ($compoundResults =~ /ENTRY\s+(.+?)\s+/) {
			#what is captured by the parentheses is the desired info
			$KEGGID = $1;
			chomp($KEGGID);
		}
		
		if ($compoundResults =~ /NAME\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$speciesName = $1;
			#remove trailing semi-colon if has more than one name
			$speciesName =~ s/;$//ig;
			#replace commas, which could mess up the formatting
			$speciesName =~ s/,/;/ig;
			chomp($speciesName);
		}
		return ($speciesName, $speciesCharge, $CF);
	}
	
	#alright, since we've gotten here, we haven't got it anywhere convenient, so we are looking it up 
	#in the KEGG database
	$searchResPage = "http://rest.kegg.jp/find/compound/".$searchName;
	#create a new user agent which pulls the html source code for the KEGG search page
	$UserAgent = LWP::UserAgent->new; #creates new user agent
	$searchResponse = $UserAgent->get($searchResPage);
	$searchResponse = $searchResponse->content; 
	
	#if the search result page contains the species name we are looking for, go to the page indicated by the compound ID and get all the
	#necessary info. Multiple formats, hence the multiple conditions. The (+|-|) line allows for finding ions. ions from Model seed lack +/id
	#symbol, but has number for charge still.
	if ($searchResponse =~ /cpd:(C[0-9]+)\s+$searchName(\+|-|);/ig) { #first item in list
		#get the compound name to access the KEGG API page
		$compoundURL = "http://rest.kegg.jp/get/".$1;
		$compoundResults = $UserAgent->get($compoundURL);
		$compoundResults = $compoundResults->content;
		#if there is a chemical formula given, get everything on the formula line after formula followed by spaces (or a tab)
		#see example page http://rest.kegg.jp/get/C00002 to see how I chose the regular expressions
		#recall that the metacharacter '.' matches everything but newline characters
		if ($compoundResults =~ /FORMULA\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$CF = $1;
			chomp($CF);
		}
		
		if ($compoundResults =~ /ENTRY\s+(.+?)\s+/) {
			#what is captured by the parentheses is the desired info
			$KEGGID = $1;
			chomp($KEGGID);
		}
		
		if ($compoundResults =~ /NAME\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$speciesName = $1;
			chomp($speciesName);
		}
		return ($KEGGID, $speciesCharge, $CF);
	} elsif ($searchResponse =~ /cpd:(C[0-9]+)\s+.+?;\s$searchName(\+|-|);/ig) { #middle item in list
		#get the compound name to access the KEGG API page
		$compoundURL = "http://rest.kegg.jp/get/".$1;
		$compoundResults = $UserAgent->get($compoundURL);
		$compoundResults = $compoundResults->content;
		#if there is a chemical formula given, get everything on the formula line after formula followed by spaces (or a tab)
		#see example page http://rest.kegg.jp/get/C00002 to see how I chose the regular expressions
		#recall that the metacharacter '.' matches everything but newline characters
		if ($compoundResults =~ /FORMULA\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$CF = $1;
			chomp($CF);
		}
		
		if ($compoundResults =~ /ENTRY\s+(.+?)\s+/) {
			#what is captured by the parentheses is the desired info
			$KEGGID = $1;
			chomp($KEGGID);
		}
		
		if ($compoundResults =~ /NAME\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$speciesName = $1;
			chomp($speciesName);
		}
		return ($KEGGID, $speciesCharge, $CF);
	} elsif ($searchResponse =~ /cpd:(C[0-9]+)\s+.+?;\s$searchName(\+|-|)(\r|\n|$)/ig) { #last item in list
		#get the compound name to access the KEGG API page
		$compoundURL = "http://rest.kegg.jp/get/".$1;
		$compoundResults = $UserAgent->get($compoundURL);
		$compoundResults = $compoundResults->content;
		#if there is a chemical formula given, get everything on the formula line after formula followed by spaces (or a tab)
		#see example page http://rest.kegg.jp/get/C00002 to see how I chose the regular expressions
		#recall that the metacharacter '.' matches everything but newline characters
		if ($compoundResults =~ /FORMULA\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$CF = $1;
			chomp($CF);
		}
		
		if ($compoundResults =~ /ENTRY\s+(.+?)\s+/) {
			#what is captured by the parentheses is the desired info
			$KEGGID = $1;
			chomp($KEGGID);
		}
		
		if ($compoundResults =~ /NAME\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$speciesName = $1;
			chomp($speciesName);
		}
		return ($KEGGID, $speciesCharge, $CF);
	} elsif ($searchResponse =~ /cpd:(C[0-9]+)\s+$searchName(\+|-|)\n/ig) { #only item in list
		#get the compound name to access the KEGG API page
		$compoundURL = "http://rest.kegg.jp/get/".$1;
		$compoundResults = $UserAgent->get($compoundURL);
		$compoundResults = $compoundResults->content;
		#if there is a chemical formula given, get everything on the formula line after formula followed by spaces (or a tab)
		#see example page http://rest.kegg.jp/get/C00002 to see how I chose the regular expressions
		#recall that the metacharacter '.' matches everything but newline characters
		if ($compoundResults =~ /FORMULA\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$CF = $1;
			chomp($CF);
		}
		
		if ($compoundResults =~ /ENTRY\s+(.+?)\s+/) {
			#what is captured by the parentheses is the desired info
			$KEGGID = $1;
			chomp($KEGGID);
		}
		
		if ($compoundResults =~ /NAME\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$speciesName = $1;
			chomp($speciesName);
		}
		return ($KEGGID, $speciesCharge, $CF);
	}
	
	#if we have made it to this point, we have been unable to find the KEGG page, so make a return that indicates this
	$KEGGID = "NO PAGE FOUND";
	$speciesCharge = " ";
	$CF = " ";
	return ($KEGGID, $speciesCharge, $CF);

}

#this subroutine is written to search the KEGG database for a specifica name to get out the KEGG ID. Pretty much a carbon
#copy of searchKEGGforCF, but only returns one variable, the KEGG ID
#inputs:
#	$speciesName = chemical species name
#outputs:
#	$KEGGID = KEGG ID+ for chemical compound, format C[0-9]+
#call looks like: $KEGGID = &searchKEGGforCF($speciesName);
sub searchKEGGforID {

	#first, create a hash for 3 letter protein codes that often appear in chemical species,
	#this will allow for easy lookup of amino acids. For most, a specific chirality is noted so that
	#search parameters may fit more exactly, since chirality does not affect the molecular formula
	#this hash gives KEGG ID, charge and molecular formula, allowing us to forgo a KEGG search
	#the return string may be split using the split function with delimeter :
	my %commonSpecies = (
		"Ala" => "L-Alanine:C00041:0:C2H7NO2",
		"Ile" => "L-Isoleucine:C00407:0:C6H13NO2",
		"Leu" => "L-Leucine:C00123:0:C6H12NO2",
		"Val" => "L-Valine:C00183:0:C5H11NO2",
		"Phe" => "L-Phenylalanine:C00079:0:C9H11NO2",
		"Trp" => "L-Tryptophan:C00078:0:C11H12N2O2",
		"Tyr" => "L-Tyrosine:C00082:0:C9H11NO3",
		"Asn" => "L-Asparagine:C00152:0:C4H8N203",
		"Cys" => "L-Cysteine:C00097:0:C3H7NO2S",
		"Gln" => "L-Glutamine:C00064:0:C5H10N2O3",
		"Met" => "L-Methionine:C00073:0:C5H11NO2S",
		"Ser" => "L-Serine:C00065:0:C3H7N03",
		"Thr" => "L-Threonine:c00188:0:C4H9NO3",
		"Asp" => "L-Aspartic Acid:C00049:0:C4H7NO4",
		"Glu" => "L-Glutamic Acid:C00025:0:C5H9NO4",
		"Arg" => "L-Arginine:C00062:0:C6H14N4O2",
		"His" => "L-Histidine:C00135:0:C6H9N3O2",
		"Lys" => "L-Lysine:C00047:0:C6H14N2O2",
		"Gly" => "Glycine:C00037:0:C2H5N02",
		"Pro" => "L-Proline:C00148:0:C5H9NO2",
		"ATP" => "Adenosine 5'-triphosphate:C00002:0:C10H16N5O13P3",
		"ADP" => "Adenosine 5'-diphosphate:C00008:0:C10H15N5O10P2",
		"AMP" => "Adenosine 5'-monophosphate:C00020:0:C10H14N5O7P1",
		"NADP+" => "NADP+:C00006:+1:C21H29N7O17P3",
		"NADPH" => "NADPH:C00005:0:C21H30N7O17P3",
		"H2O" => "Water:C00001:0:H2O",
		"Ammonium" => "Ammonium:C01342:1:NH3",
		"H\+" => "Proton:C00080:1:H",
		"H" => "Proton:C00080:1:H",
		"H2SO4" => "Sulfuric acid:C00059:0:H2SO4",
		"fa6" => "fa6:UNKNOWN:-1:C16H31O2",
		"fa6coa" => "fa6:UNKNOWN:-1:C37H63N7O17P3S",
		"HYXN" => "Hypoxanthine:C00262:0:C5H4N4O",
	);
	
	chomp($_[0]);
	$speciesName = $_[0];
	$KEGGID = "";
	$speciesCharge = "";
	$CF = "";
	
	#format the species name to something that is searchable
	$searchName = &formatName($speciesName);
	#give an output so the user does not become impatient and terminate early
	printf "Searching KEGG for chemical species |%s|\n", $searchName;
	
	#now before we get too involved, let us see if we can forgo a KEGG search, by avoiding searches on
	#the provided chemical species by way of it being a proton, protein, or in common species hash
	if ($searchName =~ /protein/i) { #if the species is named as a protien
		#then it will not be able to be found in KEGG compound, or even have a meaningful molecular
		#formula, as it may well vary on a species to species basis
		$KEGGID = "PROTEIN";
		$speciesCharge = "0";
		$CF = "AA POLYMER";
		return $KEGGID;
	} else { #check if in common species hash
		#for each element in common species hash
		foreach $key (sort keys %commonSpecies) {
			#search to see if the name contains the hash key, but need to be careful so we just
			#pick up those instances where a protien or a form of ATP was intended
			#ATP/AMP/ADP will stand alone, however, it is possible that the two bound
			#if AAs stand alone will likely be full name such as "L-Leucine"
			#there are more sophisticated names with alternations of AA codes and molecule names,
			#but I have to be realistic and stop looking for specialized occurances at some point
			$hashOut = $commonSpecies{$key};
			#if species contains just a three letter code for an AA
			if ($searchName =~ /^$key$/) {
				($speciesName, $KEGGID, $speciesCharge, $CF) = split /:/, $hashOut;
				return $KEGGID;
				
			} elsif ($hashOut =~ /^$searchName$/i) { #if the hash value for the key contains the search name
				#then the name fed must have been a full amino acid name, return the hash information
				($speciesName, $KEGGID, $speciesCharge, $CF) = split /:/, $hashOut;
				return $KEGGID;
			}
			
			#otherwise, doesn't look like any common species are in here
		
		}
	
	}
	
	#alright, since we've gotten here, we haven't got it anywhere convenient, so we are looking it up 
	#in the KEGG database
	$searchResPage = "http://rest.kegg.jp/find/compound/".$searchName;
	#create a new user agent which pulls the html source code for the KEGG search page
	$UserAgent = LWP::UserAgent->new; #creates new user agent
	$searchResponse = $UserAgent->get($searchResPage);
	$searchResponse = $searchResponse->content; 
	
	#if the search result page contains the species name we are looking for, go to the page indicated by the compound ID and get all the
	#necessary info. Multiple formats, hence the multiple conditions. The (+|-|) line allows for finding ions. ions from Model seed lack +/id
	#symbol, but has number for charge still.
	if ($searchResponse =~ /cpd:(C[0-9]+)\s+$searchName(\+|-|);/ig) { #first item in list
		#get the compound name to access the KEGG API page
		$compoundURL = "http://rest.kegg.jp/get/".$1;
		$compoundResults = $UserAgent->get($compoundURL);
		$compoundResults = $compoundResults->content;
		#if there is a chemical formula given, get everything on the formula line after formula followed by spaces (or a tab)
		#see example page http://rest.kegg.jp/get/C00002 to see how I chose the regular expressions
		#recall that the metacharacter '.' matches everything but newline characters
		if ($compoundResults =~ /FORMULA\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$CF = $1;
			chomp($CF);
		}
		
		if ($compoundResults =~ /ENTRY\s+(.+?)\s+/) {
			#what is captured by the parentheses is the desired info
			$KEGGID = $1;
			chomp($KEGGID);
		}
		
		if ($compoundResults =~ /NAME\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$speciesName = $1;
			chomp($speciesName);
		}
		return $KEGGID;
	} elsif ($searchResponse =~ /cpd:(C[0-9]+)\s+.+?;\s$searchName(\+|-|);/ig) { #middle item in list
		#get the compound name to access the KEGG API page
		$compoundURL = "http://rest.kegg.jp/get/".$1;
		$compoundResults = $UserAgent->get($compoundURL);
		$compoundResults = $compoundResults->content;
		#if there is a chemical formula given, get everything on the formula line after formula followed by spaces (or a tab)
		#see example page http://rest.kegg.jp/get/C00002 to see how I chose the regular expressions
		#recall that the metacharacter '.' matches everything but newline characters
		if ($compoundResults =~ /FORMULA\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$CF = $1;
			chomp($CF);
		}
		
		if ($compoundResults =~ /ENTRY\s+(.+?)\s+/) {
			#what is captured by the parentheses is the desired info
			$KEGGID = $1;
			chomp($KEGGID);
		}
		
		if ($compoundResults =~ /NAME\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$speciesName = $1;
			chomp($speciesName);
		}
		return $KEGGID;
	} elsif ($searchResponse =~ /cpd:(C[0-9]+)\s+.+?;\s$searchName(\+|-|)(\r|\n|$)/ig) { #last item in list
		#get the compound name to access the KEGG API page
		$compoundURL = "http://rest.kegg.jp/get/".$1;
		$compoundResults = $UserAgent->get($compoundURL);
		$compoundResults = $compoundResults->content;
		#if there is a chemical formula given, get everything on the formula line after formula followed by spaces (or a tab)
		#see example page http://rest.kegg.jp/get/C00002 to see how I chose the regular expressions
		#recall that the metacharacter '.' matches everything but newline characters
		if ($compoundResults =~ /FORMULA\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$CF = $1;
			chomp($CF);
		}
		
		if ($compoundResults =~ /ENTRY\s+(.+?)\s+/) {
			#what is captured by the parentheses is the desired info
			$KEGGID = $1;
			chomp($KEGGID);
		}
		
		if ($compoundResults =~ /NAME\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$speciesName = $1;
			chomp($speciesName);
		}
		return $KEGGID;
	} elsif ($searchResponse =~ /cpd:(C[0-9]+)\s+$searchName(\+|-|)\n/ig) { #only item in list
		#get the compound name to access the KEGG API page
		$compoundURL = "http://rest.kegg.jp/get/".$1;
		$compoundResults = $UserAgent->get($compoundURL);
		$compoundResults = $compoundResults->content;
		#if there is a chemical formula given, get everything on the formula line after formula followed by spaces (or a tab)
		#see example page http://rest.kegg.jp/get/C00002 to see how I chose the regular expressions
		#recall that the metacharacter '.' matches everything but newline characters
		if ($compoundResults =~ /FORMULA\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$CF = $1;
			chomp($CF);
		}
		
		if ($compoundResults =~ /ENTRY\s+(.+?)\s+/) {
			#what is captured by the parentheses is the desired info
			$KEGGID = $1;
			chomp($KEGGID);
		}
		
		if ($compoundResults =~ /NAME\s+(.+)/) {
			#what is captured by the parentheses is the desired info
			$speciesName = $1;
			chomp($speciesName);
		}
		return $KEGGID;
	}
	
	#if we have made it to this point, we have been unable to find the KEGG page, so make a return that indicates this
	$KEGGID = "NO PAGE FOUND";
	$speciesCharge = " ";
	$CF = " ";
	return $KEGGID;

}

#this subroutine is written to search the KEGG database with a KEGG ID to get out the name. Pretty much a barebones
#copy of searchKEGGforCF, only returning one variable, the name
#inputs:
#	$compoundID = chemical species KEGG ID
#outputs:
#	$compoundName = chemical species name
#call looks like: $compoundName = &searchKEGGforName($compoundID);
sub searchKEGGforName {
	no warnings 'uninitialized';
	chomp($_[0]);
	$KEGGID  = $_[0];
	if ($KEGGID eq 'C00080') {
		return "proton";
	}
	$speciesName = "";
	$searchResPage = "http://rest.kegg.jp/get/".$KEGGID."/";
	printf "search url: %s\n", $searchResPage;
	#create a new user agent which pulls the html source code for the KEGG search page
	$UserAgent = LWP::UserAgent->new; #creates new user agent
	$searchResponse = $UserAgent->get($searchResPage);
	$searchResponse = $searchResponse->content; 
	
	#search KEGG for species name
	if ($searchResponse =~ /NAME\s+(.+)/) {
		$speciesName = $1;
		$speciesName =~ s/\t//g;
		$speciesName =~ s/^\s//;
		$speciesName =~ s/\s$//;
		$speciesName =~ s/;$//;
	}
	
	#had to add a recursive call to this if there was a search page and the subroutine
	#did not give back a name, for some reason this call kept timing out
	if ((length $speciesName == 0) && (length $searchResponse != 0)) {
		$speciesName = &searchKEGGforName($KEGGID);
	}	
	
	return $speciesName;

}

#this subroutine was created to combat slow internet by making a recursive subroutine to perform internet searches
#to prevent timeout problems by running the request against
#inputs:
#	$_[0] = url to query
#outputs:
#	$page = page content results of internet search
sub queryInternet {
	my $UserAgent = LWP::UserAgent->new; #creates new user agent
	$url = $_[0]; #links to page
	$page = $UserAgent->get($url); #gets all information
	printf "query: %s\n", $url;
	$page = $page->content; #filters information to just page contents
	if ($page =~ /A connection attempt failed because the connected host has failed to respond/) {
		$page = queryInternet($url);
	}
	return $page;
}

#this subroutine takes a line from an NCBI output from a protein details page. This is downloaded as is from the link "Download table",
#and then two operations are performed on it for ease of reading. 1) replace all commas with semicolons. 2)replace all tabs (\t) with
#commas then finally 3) save the table as a .csv. This transformation should make it easy to read the file, manually and by program 
#table for E dermatitidis downloaded from URL: https://www.ncbi.nlm.nih.gov/genome/proteins/2962?genome_assembly_id=34221&gi=-1
#
#Additionally, it also works with UniProt data downloaded from the following URL
#http://www.uniprot.org/uniprot/?query=taxonomy%3A%22Exophiala+dermatitidis+%28strain+ATCC+34100+%2F+CBS+525.76+%2F+NIH%2FUT8656%29+%28Black+yeast%29+%28Wangiella+dermatitidis%29+%5B858893%5D%22&sort=score
#with the following provisos:
#1) before downloading table, ensure that a column is present for EC number (can be added by selecting
#	the "columns" button above the table)
#2)Once downloaded, replace all commas with semicolons (necessary for csv formatting not to be thrown off)
#3)replace all tabs (\t) with commas (easily done in notepad ++)
#4) save the resultant file as a .csv
#this allows for easy of manual reading (as it may be opened in Excel) and ease of programmatic
#reading
#any organism should ideally have a similar page and table in both databases
#in both cases returns all EC numbers which are returned by the Brenda search, as they are returned in 
#numerical order and therefore there is no way in which to establish a "best" result
#inputs:
#	$_[0] = single line from NCBI csv file (after above transformation), from which the protein name will be taken
#	$_[1] = column number of protein name
#output:
#	$ECno = enzyme classification number for said protein, if available, or "not found" if unavailable
sub searchBrendaProtein {
	$ECno = "unknown"; #establish default value of $ECno
	@ECnos = ( ); #stores array of EC numbers if multiple search results
	$line = $_[0]; #give the input a useful handle
	chomp($line);
	@cells = split /,/, $line; #split the cells into an array where individual cells may be accessed
	#get the protien name, which should be present in the fourth cell (recall indexing begins at 0)
	$proteinName = $cells[$_[1]];
	#next code line is to replace all spaces with a plus sign for use in the url
	#if it is a "hypothetical protein" (NCBI nomenclature) or a "putative uncharacterized protein" (UniProt Nomenclature)
	if ($proteinName =~ /hypothetical protein/ig || $proteinName =~ /putative uncharacterized protein/ig) {
		#return a value to indicate that we do not know the EC number. This is necessary because the serch string
		#hypothetical protien 
		return $ECno;
	}
	$_ = $proteinName;
	s/\s+/+/ig;
	s/;/,/ig;
	$searchName = $_;
	#url for search result page with the correct protein added as search string. Now this URL does specify the 
	#number of results, but this seems to make no difference.
	$url = "http://www.brenda-enzymes.org/search_result.php?quicksearch=1&noOfResults=10&a=9&W[2]=".$searchName."&T[2]=2";
	#have an output that user can see, so that the user can track progress
	printf "Searching Brenda for |%s|...", $proteinName;
	$UserAgent = LWP::UserAgent->new; #creates new user agent
	$searchResponse = $UserAgent->get($url);
	$searchResponse = $searchResponse->content;
	#search for return string which indicates no result from the Brenda search. The unique string is "Sorry, no results could be 
	#found for your query!" To save space in coding, I simply will search for the word "sorry, no results" as it is unique to no search results
	if ($searchResponse =~ /Sorry, no results/ig) {
		#no search results have been found, return unknown
		printf "EC: %s\n", $ECno;
		return $ECno;
	}
	#otherwise, we have an EC number!
	#we need to get each EC returned by the Brenda search
	#this line captures all instances in the HTML code of digit(s).digit(s).digit(s).digit(s) which is the format for EC numbers
	#as far as I have seen, no other area of the Brenda HTML code has the same formatting. Unfortunately, there is significant 
	#redundancy in the HTML code, so there needs to be a system to only add unique EC numbers
	while($searchResponse =~ /[0-9]+\.([0-9]+|-)\.([0-9]+|-)\.([0-9]+|-)/ig) {
		#for each match, check if the matched EC number is already present in the array
		no warnings;
		if ($& ~~ @ECnos) {
			#if it is already present, do nothing
		} else {
			#otherwise, add the new EC number to the array
			push @ECnos, $&;
		}
		use warnings; 
	}
	$ECno = join "|", @ECnos;
	#now we have an array of EC numbers, which is difficult to pass, and would leave a file with an unknown number of columns
	#we will join all EC numbers with a verticle bar for easy reading and so that we know that these are possible ec numbers
	#as confirmed complexes of EC numbers are usually annotated with colons or semicolons
	#shows the user the EC number found
	printf "EC: %s\n", $ECno;
	#return the EC number found
	return $ECno;
	
}

#This fuction is designed to, given an EC number, search KEGG to get the reactions and metabolites associated with that EC number
#while the concept is simple, the application is long. This is basically a followup program to getting a list of unique enzyme classifications
#from an annotated genome, and turning that annotation into the beginnings of a model.
#inputs:
#	$_[0] = EC number of the enzyme
#outputs:
#	\@rxnInfo = a reference to an array of strings formatted for a CSV which contains reaction information
#	\@metIDs = a reference to an array of metabolite KEGG IDs, will be used to search for metabolite information in another function
sub SearchKEGGEC {
	$EC = $_[0];
	#create a user agent
	$UserAgent = LWP::UserAgent->new; #creates new user agent
	#go to to URL
	$url = "http://rest.kegg.jp/get/".$EC;
	$ECpage = $UserAgent->get($url);
	#get the HTML contents of the page
	$ECpage = $ECpage->content;
	#since this will take a while cumulatively, allow an output to the user to know this program is still running
	printf "searching for reaction associated with EC:%s\n",$EC;
	
	#okay, so now we have the source code for the page, pull all reaction IDs
	my @rxnIDs = ( ); #array to store reaction numbers we find
	my @metIDs = ( ); #array to store metabolite IDs
	
	my @rxnInfo = ( );
	
	#so, how this will work is we seach for all instances of R[0-9][0-9][0-9][0-9][0-9] (that is RXXXXX where X is a digit)
	#then, it will check that match against @rxnNumbers, if there is a match, then we will not add it (it is already there). If there
	#is not a match, we will push it into @rxnNumbers. We should also avoid general reactions that will have such generalities as "a primary alcohol"
	while($ECpage =~ /R[0-9][0-9][0-9][0-9][0-9](\s|;)/g) {
		if (grep(/^$&$/, @rxnIDs)) {
			#do nothing, reaction ID already present
		} else {
			#add reaction ID to the list, after formatting
			$tempRxn = $&;
			chomp($tempRxn);
			$tempRxn =~ s/;//ig;
			push @rxnIDs, $tempRxn;
		}		
	}
	
	#at this point we should have an array of reaction IDs. Now look them up, then use that information to create the written lines of 
	#information taht we are trying to return. Since this bit will take a while (cumulatively), allow an output to notify the user that
	#the program is still running
	for (my $i = 0; $i <= $#rxnIDs; $i++) {
		printf "Getting information for reaction ID %s\n", $rxnIDs[$i];
		$url = "http://rest.kegg.jp/get/".$rxnIDs[$i];
		$RxnPage = $UserAgent->get($url);
		$RxnPage = $RxnPage->content;
		$RxnWritten = " ";
		#while there are more compound IDs to find on the page (all compound IDs part of reaction line)
		#OR while there are more arrows (actually should only be one, but still make sure to grab it)
		#	note that &lt; is the html character for <
		#OR while there are more plus signs
		#OR while there are more stoichiometric coefficients
		if ($RxnPage =~ /EQUATION\s+(.*)/) {
			#what was captured is the equation
			$RxnWritten = $1;
			#now, we need to add 1's where appropriate for GAMS to be able to handle our output
			#first, if the compound is anchored at the front of the written reaction, add a "1 "
			if ($RxnWritten =~ /^C/) {
				$RxnWritten = "1 ".$RxnWritten;
			}
			#second, if there is a plus and a compound without a number between, add a 1
			while($RxnWritten =~ /\+\sC/) {
				#we need to add a 1 between the space and the plus
				#so, use indexing and substrings to split it
				$splitPoint = index($RxnWritten, "+ C") + 1;
				$RxnWritten = substr($RxnWritten, 0, $splitPoint)." 1".substr($RxnWritten, $splitPoint, length($RxnWritten));
			}
			#third, if the compount after the arrow does not have a 1
			if ($RxnWritten =~ /=>\sC/) {
				#split and add the 1
				$splitPoint = index($RxnWritten, "=> C") + 2;
				$RxnWritten = substr($RxnWritten, 0, $splitPoint)." 1".substr($RxnWritten, $splitPoint, length($RxnWritten));
			}
			#finally, push all compound id's found into @metIDs
			while($RxnWritten =~ /C[0-9][0-9][0-9][0-9][0-9]/ig) {
				push @metIDs, $&;
			}
		}
		chomp($RxnWritten);
		#now we have the reaction written. let's create the written line which is "EC number, Rxn ID, Rxn Written"
		$rxnIDs[$i] =~ s/\s$//ig;
		$writtenRxnLine = $EC.",".$rxnIDs[$i].",".$RxnWritten.",";
		push @rxnInfo, $writtenRxnLine;
	}
	
	#in here, we will not search for required info for metabolites. There will be a lot of overlap and redundancy if this is done, and personally
	#I'd rather not waste the CPU time to search for "C00001" (water) a thousand times
	
	#return the array references
	return \@rxnInfo, \@metIDs;
}

#This fuction is designed to, given an EC number, search KEGG to get the reactions and metabolites associated with that EC number
#while the concept is simple, the application is long. This is basically a followup program to getting a list of unique enzyme classifications
#from an annotated genome, and turning that annotation into the beginnings of a model.
#inputs:
#	$_[0] = EC number of the enzyme
#	#_[1] = compartment in which the reaction is occurning
#outputs:
#	\@rxnInfo = a reference to an array of strings formatted for a CSV which contains reaction information
#	\@metIDs = a reference to an array of metabolite KEGG IDs, will be used to search for metabolite information in another function
sub SearchKEGGECwCOMP {
	$EC = $_[0];
	$compartment = $_[1];
	#create a user agent
	$UserAgent = LWP::UserAgent->new; #creates new user agent
	#go to to URL
	$url = "http://rest.kegg.jp/get/".$EC;
	$ECpage = $UserAgent->get($url);
	#get the HTML contents of the page
	$ECpage = $ECpage->content;
	#since this will take a while cumulatively, allow an output to the user to know this program is still running
	printf "searching for reaction associated with EC:%s\n",$EC;
	
	#okay, so now we have the source code for the page, pull all reaction IDs
	my @rxnIDs = ( ); #array to store reaction numbers we find
	my @metIDs = ( ); #array to store metabolite IDs
	
	my @rxnInfo = ( );
	
	#so, how this will work is we seach for all instances of R[0-9][0-9][0-9][0-9][0-9] (that is RXXXXX where X is a digit)
	#then, it will check that match against @rxnNumbers, if there is a match, then we will not add it (it is already there). If there
	#is not a match, we will push it into @rxnNumbers. We should also avoid general reactions that will have such generalities as "a primary alcohol"
	while($ECpage =~ /R[0-9][0-9][0-9][0-9][0-9](\s|;)/g) {
		if (grep(/^$&$/, @rxnIDs)) {
			#do nothing, reaction ID already present
		} else {
			#add reaction ID to the list, after formatting
			$tempRxn = $&;
			chomp($tempRxn);
			$tempRxn =~ s/;//ig;
			push @rxnIDs, $tempRxn;
		}		
	}
	
	#at this point we should have an array of reaction IDs. Now look them up, then use that information to create the written lines of 
	#information taht we are trying to return. Since this bit will take a while (cumulatively), allow an output to notify the user that
	#the program is still running
	for (my $i = 0; $i <= $#rxnIDs; $i++) {
	
		printf "Getting information for reaction ID %s\n", $rxnIDs[$i];
		$url = "http://rest.kegg.jp/get/".$rxnIDs[$i];
		$RxnPage = $UserAgent->get($url);
		$RxnPage = $RxnPage->content;
		$RxnWritten = " ";
		#while there are more compound IDs to find on the page (all compound IDs part of reaction line)
		#OR while there are more arrows (actually should only be one, but still make sure to grab it)
		#	note that &lt; is the html character for <
		#OR while there are more plus signs
		#OR while there are more stoichiometric coefficients
		if ($RxnPage =~ /EQUATION\s+(.*)/) {
			#what was captured is the equation
			$RxnWritten = $1;
			#now, we need to add 1's where appropriate for GAMS to be able to handle our output
			#first, if the compound is anchored at the front of the written reaction, add a "1 "
			if ($RxnWritten =~ /^C/) {
				$RxnWritten = "1 ".$RxnWritten;
			}
			#second, if there is a plus and a compound without a number between, add a 1
			while($RxnWritten =~ /\+\sC/) {
			
				#we need to add a 1 between the space and the plus
				#so, use indexing and substrings to split it
				$splitPoint = index($RxnWritten, "+ C") + 1;
				$RxnWritten = substr($RxnWritten, 0, $splitPoint)." 1".substr($RxnWritten, $splitPoint, length($RxnWritten));
			
			}
			
			#third, if the compount after the arrow does not have a 1
			if ($RxnWritten =~ /=>\sC/) {
			
				#split and add the 1
				$splitPoint = index($RxnWritten, "=> C") + 2;
				$RxnWritten = substr($RxnWritten, 0, $splitPoint)." 1".substr($RxnWritten, $splitPoint, length($RxnWritten));
			
			}
			
			#finally, push all compound id's found into @metIDs
			while($RxnWritten =~ /C[0-9][0-9][0-9][0-9][0-9]/ig) {
			
				#add compartment information
				my $match = $&;
				my $match_w_comp = $match.$compartment;
				push @metIDs, $match_w_comp;
				
			}
			
		}
		
		my $temp_rxn_writ = $RxnWritten;
		
		#finally, add compartment to each metabolites
		while($RxnWritten =~ /C\d\d\d\d\d/g) {
		
			my $temp = $&;
			$temp_rxn_writ =~ s/$temp/$temp$compartment/g;
		
		}
		
		#reformat arrow
		$temp_rxn_writ =~ s/\=/\-/;
		
		$RxnWritten = $temp_rxn_writ;
		
		chomp($RxnWritten);
		#now we have the reaction written. let's create the written line which is "EC number, Rxn ID, Rxn Written"
		$rxnIDs[$i] =~ s/\s$//ig;
		$writtenRxnLine = $rxnIDs[$i].$compartment."\t".$RxnWritten;
		push @rxnInfo, $writtenRxnLine;
		
	}
	
	#in here, we will not search for required info for metabolites. There will be a lot of overlap and redundancy if this is done, and personally
	#I'd rather not waste the CPU time to search for "C00001" (water) a thousand times
	
	#return the array references
	return \@rxnInfo, \@metIDs;
	
}

#This function will remove redundant entires in an array, and return a reference to a non redundant array.
#inputs:
#	$_[0]=$@arrayRef = a reference to an array suspected of having redundancies
#outputs:
#	\@nr = reference to an array without those redundancies
sub RemoveRedundancies {
	$arrayRef = $_[0];
	@array = @$arrayRef; #input array
	%arrayKey = ( ); #allows us to check if a value exists in the array already. This is the inverse function of the non-redundant
	@nr = ( ); #this is the non-redundant array
	for (my $i=0; $i<=$#array; $i++) {
		if (! exists $arrayKey{$array[$i]}) { #if the value does not have a key in the array
			$arrayKey{$array[$i]} = $#nr + 1; #add the value and the key to the hash, so it is known that this value is now in the array
			push @nr, $array[$i];
		} #otherwise do nothing, already in the array
	}
	return \@nr;
}

#This function will take a KEGG compound ID, and return the name and chemical formula
#inputs:
#	$_[0]=$nrMetsRef = This is a reference to an array of KEGG IDs of desired compounds (preferrably non-reduntant. see previous sub)
#outputs:
#	\@metInfo = reference to array of strings formatted for output to a csv. contains "KEGG ID, Name, Chemical Formula,"
sub MetInfoFromID {
	$MetsRef = $_[0];
	@Mets = @$MetsRef;
	#metabolites header
	my @MetLabels = ( "KEGG ID", "Name", "Chemical Formula"); #atomic symbols will be added as columns
	#however, for S, a sense of order is important (hash is more like a barrel than a linear array)
	#therefore a number to hash key is stored in this array
	my @MetKeys = ( );
	#stores atomic symbols order, the key is the atomic symbol, the value is the "place" of that symbol
	#in the column header order, for instance if the colums were C,H,N,O,P,S, then giving "O" to this hash
	#would result in "3" being returned (counting starts at 0)
	my %AtomSym = ( );
	my @metInfo = ( );
	my @tempMetInfo = ( );
	#open to KEGG API compound
	#create a user agent
	$UserAgent = LWP::UserAgent->new; #creates new user agent
	
	#earlier, we tackled the problem another way, name to KEGG ID and formula, and name to KEGG ID. This way is by far the simplest.
	for (my $i=0;$i<=$#Mets;$i++) {
	
		$TempMetInfo = " ";
		$CF = " ";
		$TempName = " ";
		#allow a printf so the user can know the program is still running well
		printf "Getting information for metabolite number %s: %s\n", $i, $Mets[$i];
		#go to the webpage for the compound, and get the HTML text
		$url = "http://rest.kegg.jp/get/".$Mets[$i];
		$MetPage = $UserAgent->get($url);
		$MetPage = $MetPage->content;
		#okay, now find the chemical formula, using the regular expression we used perviously
		if ($MetPage =~ /FORMULA\s+([A-Z][A-Za-z0-9]*)/) {
		
			#great so it has a chemical formula, and we have captured it.
			$CF = $1;
			chomp($CF);
			
		}
		
		my ($AtomicSymsRef, $SubscriptsRef) = &breakdownCF($CF); #get the returned references
		@AtomicSyms = @$AtomicSymsRef; #now get the arrays that are referenced
		@Subscripts = @$SubscriptsRef; 
		#now we have atomic symbols and subscripts, and we need to add new symbols to the header @MetLabels, and make sure we add subscripts
		#in the correct order. We will create a new sub for that.
		my ($MetLabelsRef, $AtomSymRef, $formattedSub) = &updateSymsAndSubs(\@MetLabels, \%AtomSym, \@AtomicSyms, \@Subscripts);
		@MetLabels = @$MetLabelsRef; #update metabolic labels
		%AtomSym = %$AtomSymRef;
		#finally, find the name. This bit I have to find the compound number in the kegg API. Note: can't find a way to get it to display chemical
		#formula unfortunately
		if($MetPage =~ /NAME\s+(.+)/) {
			$TempName = $1;
			#replace commas with semicolons so as not to throw off the formatting of the csv
			$TempName =~ s/,/;/ig;
			#remove the semicolon at the end, as this will match to the end of the line (greedy);
			$TempName =~ s/;$//ig;
		}
		#now that we have all the info we need, we will write the line for the metabolites document
		$TempMetInfo = $Mets[$i].",".$TempName.",".$CF.",".$formattedSub.",";
		push @tempMetInfo, $TempMetInfo;
	}
	
	$header = join ",", @MetLabels;
	push @metInfo, $header;
	push @metInfo, @tempMetInfo;
	
	#return met info reference
	return \@metInfo;
}

#this subroutine takes the input of @WriteLinesRxn, and combines those lines that have the same reaction, but catalyzed by
#different enzymes, by making a semi-colon delimited list of all enzymes that can catalyze a single reaction
#inputs:
#	$_[0]=$writeLinesRef = a reference to the @writeLinesRxn array
#outputs:
#	\@nrWriteLinesRxn = reference to a non-redundant @writeLinesRxn matrix
sub combineSameRxn {
	$rxnsRef = $_[0];
	my @rxns = @$rxnsRef;
	#array to store unique reactions
	my @IDs = ( );
	#hash to call a list of enzymes from an input of a reaction ID
	my %IDtoEnzyme = ( );
	#has to call the written reaction from an input of a reaction ID
	my %IDtoWrittenRxn = ( );
	#create an array to store the non-redundant write lines
	my @nrWriteLinesRxn =( );
	
	#fore each reaction line, starting at an index of 1 to skip the header
	for (my $i=1; $i<=$#rxns;$i++) {
		#split the reaction entry on the commas
		($tempEC, $tempID, $tempWrittenRxn) = split /,/, $rxns[$i];
		#there are three possible options for each reaction:
		#1) the reaction is new, and therefore we have to initialized elements in the array and hashes
		#2) the reaction is already in the arrays and hashes, and therefore the hash entry on enzymes must be appended
		#3) as sometimes happens, there are completely redundant entries. Do nothing if this is the case
		#Option 1:
		if (! exists $IDtoEnzyme{$tempID}) {
			#if we are here, this reaction is new, and therefore array and hash entries need to be made
			push @IDs, $tempID;
			$IDtoEnzyme{$tempID} = $tempEC;
			$IDtoWrittenRxn{$tempID} = $tempWrittenRxn;
		} else {
			#Options 2 & 3: some form of entry already exists. Now we have to check which option we are in
			#check if the current enzyme is already listed in the ID to enzyme array. If true, this is option 3
			#either it is the only enzyme listed, or it has a semi-colon behind it, or a semi-colon in front of it
			#the purpose of these multiple matching options is to prevent 1.1.1.1 matching 1.1.1.100 and similar
			if ($IDtoEnzyme{$tempID} =~ /^$tempEC$/ || $IDtoEnzyme{$tempID} =~ /$tempEC;/ || $IDtoEnzyme{$tempID} =~ /;$tempEC/) {
				#option 3: do nothing, we have a redundant entry
			} else {
				#otherwise, we are in option 2! update the enzyme hash
				$IDtoEnzyme{$tempID} = $IDtoEnzyme{$tempID}.";".$tempEC;
			}
		}
	}
	
	#add the header back in
	push @nrWriteLinesRxn, $rxns[0];
	#now we should have a non-redundant array of reaction IDs which may be used to pull the necessary information to reconstruct
	#the array @writeLinesRxn as a non-redundant version of itself: @nrWriteLinesRxn.
	for (my $i=0; $i<=$#IDs; $i++) {
		#reconstruc the written line
		$tempWriteLine = $IDtoEnzyme{$IDs[$i]}.",".$IDs[$i].",".$IDtoWrittenRxn{$IDs[$i]};
		push @nrWriteLinesRxn, $tempWriteLine;
	}
	#return the non-redundant lines
	return \@nrWriteLinesRxn;
}

#this subroutine takes the input of @WriteLinesRxn, and combines those lines that have the same reaction, but catalyzed by
#different enzymes, by making a semi-colon delimited list of all enzymes that can catalyze a single reaction
#inputs:
#	$_[0]=$writeLinesRef = a reference to the @writeLinesRxn array
#outputs:
#	\@nrWriteLinesRxn = reference to a non-redundant @writeLinesRxn matrix
sub combineSameRxn2 {
	$rxnsRef = $_[0];
	my @rxns = @$rxnsRef;
	#array to store unique reactions
	my @IDs = ( );
	#has to call the written reaction from an input of a reaction ID
	my @rxnWritten = ( );
	#create an array to store the non-redundant write lines
	my @nrWriteLinesRxn =( );
	
	#fore each reaction line, starting at an index of 1 to skip the header
	for (my $i=1; $i<=$#rxns;$i++) {
		#split the reaction entry on the commas
		($tempID, $tempWrittenRxn) = split /\t/, $rxns[$i];
		
		#ensure reaction isn't redundant, compare using reaction IDs
		if($tempID ~~ @IDs) {
		
			#if reaction ID already present, do nothing
		
		} else {
		
			#if not present, save the ID and stoichiometery
			push @IDs, $tempID;
			push @rxnWritten, $tempWrittenRxn;
		
		}
		
	}
	
	#now we should have a non-redundant array of reaction IDs which may be used to pull the necessary information to reconstruct
	#the array @writeLinesRxn as a non-redundant version of itself: @nrWriteLinesRxn.
	for (my $i=0; $i<=$#IDs; $i++) {
	
		#reconstruct the written line
		$tempWriteLine = $IDs[$i]."\t".$rxnWritten[$i];
		push @nrWriteLinesRxn, $tempWriteLine;
		
	}
	
	#return the non-redundant lines
	return \@nrWriteLinesRxn;
	
}

#function designed to process chemical species name inputs, since they are usually not formatted properly enough to give any definite search
#results. Will use hueristics as best I can to do two things:
#1) remove the fluff that is commonly added to species names that makes finding the compound ID harder
#2) replace underscores with meaningful characters, particularly spaces, hyphens or commas depending on where the hyphen is
#inputs:
#	$_[0] => this is the chemical species name to be processed
#outputs:
#	$correctedName => this is the "bust guess" this function has for what the actual name of the chemical species is
sub formatName {
	#get teh name passed and assign it to a variable
	$givenName = $_[0];
	#first, we have to clear out "junk" words that are given in the name as descripttors
	#but will hinder the search in KEGG. Will also create two search strings, one with spaces and one
	#without spaces, since it does make a difference
	#to begin, remove qalifiers such as input/output, of, Artificial, Metabolite
	#also, replace semi-colons with commas for successful searching
	$givenName =~ s/input//ig; #case insensitive substitution, remove input descripter
	$givenName =~ s/output//ig; #case insensitive substitution, remove output descripter
	$givenName =~ s/ of //ig; #remove word of
	$givenName =~ s/_of_//ig; #remove word of
	$givenName =~ s/\///g; #remove / characters, yes those do get added
	$givenName =~ s/artificial//ig; #remove the word artificial 
	$givenName =~ s/metabolite//ig; #remove the word metabolite, a bit redundant isn't it?
	#for processing A. Nidulans data
	$givenName =~ s/\(mitochondrial\)//ig; #remove the compartment name from the chemical species, next few lines
	$givenName =~ s/\(glyoxysomal\)//ig;
	$givenName =~ s/\(extracellular\)//ig;
	#for processing A. oryzae data
	$givenName =~ s/\(mitochondria\)//ig;
	$givenName =~ s/\(peroxisome\)//ig;
	$givenName =~ s/\"//g; #remove quotation marks from the chemical species
	$givenName =~ s/;/,/g; #replace semicolons because for CSV file writing semicolons replace commas. But commas are proper. This is an edit my programs make
	$givenName =~ s/\.//g; #remove periods, these aren't part of chemical names
	#someone decided to use square brackets as well, so replacing square brackets as they mess up regular expressions
	$givenName =~ s/\[//g; #remove square brackets that interfere with KEGG searches
	$givenName =~ s/\]//g;
	$givenName =~ s/^_//g; #remove underscores at beginning or end of words
	$givenName =~ s/_$//g; #remove underscores at beginning or end of words
	chomp($givenName); #removes spaces at beginning and end
	$givenName =~ s/^of //ig; #case insensitive substitution, remove input description "of" from front of what is left of the species name
	$givenName =~ s/__/_/ig; #replaces instances of double underscores
	
	#okay, now we get to the good and predictive stuff. So, here are the general ground rules for replacing underscore characters. Written as regular expressions
	#1) \d_\d => \d,\d 									e.g. D_Glucose_1_6_bisphosphate => D_Glucose_1,6_bisphosphate
	#2) \d_[A-Za-z] => \d-[A-Za-z] 						e.g. D_Glucose_1,6_bisphosphate => D_Glucose_1,6-bisphosphate
	#3) D_[A-Za-z] => D-[A-Za-z] 						e.g. D_Glucose_1,6-bisphosphate => D-Glucose_1,6-bisphosphate
	#4) L_[A-Za-z] => L-[A-Za-z] 						similar purpose as above, e.g. L_serine => L-serine
	#5) [A-Za-z]_\d => [A-Za-z]\s\d 					e.g. D-Glucose_1,6-bisphosphate => D-Glucose 1,6-bisphosphate
	#6) [A-Za-z]+_N_[A-Za-z]+ => [A-Za-z]+-N-[A-Za-z]+ 	e.g. UDP_N_acetylglucosamine => UDP-N-acetylglucosamine
	#7) ^N_[A-Za-z]+ => ^N-[A-Za-z]+ 					e.g. N_Cyclopropylammeline => N-Cyclopropylammeline
	#8) [A-Za-z]+_[A-Za-z]+ => [A-Za-z]+\s[A-Za-z]+ 	e.g. 3-Amino-2-oxopropyl_phosphate => 3-Amino-2-oxopropyl phosphate (assuming previous rules already applied)
	#9) O_[A-Za-z] => O-[A-Za-z]						e.g.
	#10) R_[A-Za-z] => R-[A-Za-z]						e.g.
	#11) [A-Za-z][A-Za-z][A-Za-z]_[A-Za-z][A-Za-z][A-Za-z] => [A-Za-z][A-Za-z][A-Za-z]-[A-Za-z][A-Za-z][A-Za-z] 	e.g. CMP_KDO => CMP-KDO 
	#12) [A-Za-z](I|V|X)+ => [A-Za-z]\s(I|V|X)+ 		e.g. UroporphyrinogenIII => Uroporphyrinogen III (Roman numerals)
	#13) [A-Za-z]_CoA => [A-Za-z]-CoA					e.g.
	#14) [A-Z][A-Z]P_[A-Za-z] => [A-Z][A-Z]P-[A-Za-z]	e.g.
	#15) [A-Z][A-Z]P_\d => [A-Z][A-Z]P-\d				e.g.
	#16) R_\d => R-\d									e.g.
	#17) S_\d => S-\d									e.g.
	#18) S_[A-Za-z] => S-[A-Za-z]						e.g.
	#19) [A-Za-z]_[A-Z][A-Z]P => [A-Za-z]_[A-Z][A-Z]P	e.g.
	
	#note: order of substitutions is important! This proccess is not commutitive!
	
	#rule 1
	$givenName =~ s/(\d)_(\d)/$1,$2/g;
	#rule 2
	$givenName =~ s/(\d)_([A-Za-z])/$1-$2/g;
	#rule 11
	$givenName =~ s/^([A-Za-z][A-Za-z][A-Za-z])_([A-Za-z][A-Za-z][A-Za-z])$/$1-$2/g;
	#rule 28
	$givenName =~ s/yl_(\d)/yl-$1/ig;
	#rule 28
	$givenName =~ s/ol_(\d)/ol-$1/ig;
	#rule 28
	$givenName =~ s/yl_(\d)/yl-$1/ig;
	#rule 23
	$givenName =~ s/oxo_(\d)/oxo-$1/g;
	#rule 25
	$givenName =~ s/oxy_(\d)/oxy-$1/g;
	#rule 27
	$givenName =~ s/amino_(\d)/amino-$1/ig;
	#rule 21
	$givenName =~ s/([A-Za-z])_D_([A-Za-z])/$1-D-$2/g;
	#rule 3
	$givenName =~ s/^D_([A-Za-z])/D-$1/g;
	#rule 20
	$givenName =~ s/([A-Za-z])_L_([A-Za-z])/$1-L-$2/g;
	#rule 4
	$givenName =~ s/^L_([A-Za-z])/L-$1/g;
	#rule 9
	$givenName =~ s/^O_([A-Za-z])/O-$1/g;
	#rule 6
	$givenName =~ s/([A-Za-z])_N_([A-Za-z])/$1-N-$2/g;
	#rule 7
	$givenName =~ s/^N_([A-Za-z])/N-$1/g;
	#rule 13
	$givenName =~ s/([A-Za-z])_CoA/$1-CoA/g;
	#rule 14
	$givenName =~ s/([A-Z][A-Z])P_([A-Za-z])/$1P-$2/g;
	#rule 30+
	$givenName =~ s/d([A-Z][A-Z])P_([A-Za-z])/d$1P-$2/g;
	#rule 15
	$givenName =~ s/([A-Z][A-Z])P_(\d)/$1P-$2/g;
	#rule 16
	$givenName =~ s/^R_(\d)/R-$1/g;
	#rule 17
	$givenName =~ s/^S_(\d)/S-$1/g;
	#rule 19
	$givenName =~ s/([A-Za-z])_([A-Z][A-Z]P)/$1-$2/g;
	#rule 10
	$givenName =~ s/^R_([A-Za-z])/R-$1/g;
	#rule 18
	$givenName =~ s/^S_([A-Za-z])/S-$1/g;
	#rule 12
	$givenName =~ s/([A-HJ-UWY-Za-hj-uwy-z])((I|V|X)+)$/$1 $2/g;
	#rule 30+ 
	$givenName =~ s/alpha_([A-Za-z])/alpha-$1/g;
	#rule 30+ 
	$givenName =~ s/beta_([A-Za-z])/beta-$1/g;
	#rule 30+ 
	$givenName =~ s/gamma_([A-Za-z])/gamma-$1/g;
	#rule 8
	$givenName =~ s/([A-Za-z])_([A-Za-z])/$1 $2/g;
	#rule 5
	$givenName =~ s/([A-Za-z]+)_(\d)/$1 $2/g;
	#rule 21
	$givenName =~ s/([A-Za-z][A-Za-z][A-Za-z]+)(\d)/$1 $2/g;
	$correctedName = $givenName;
	return $correctedName;

}

#below is web_blast.pl converted into a subroutine so as I can make multiple calls using
#a single script. This allows me to search against a single organism and pull information on the
#blast against that organism, if the arguements are given correctly. note that original comments
#were left, but the program has been modified and I have given comments of my own
#original web_blast.pl code can be found at: https://blast.ncbi.nlm.nih.gov/web_blast.pl
#inputs:
#	$_[0] = blast program to run, we will be mainly concerned with "blastp"
#	$_[1] = database to use for query, we will mainly be concerned with "nr"
#	$_[2] = scientific name of organism to search for alignment match in
#	$_[3] = fasta file name and location to use for the queried amino acid sequece
#outputs:
#	$response = blast report

sub web_blast {
	# ORIGINAL COMMENT BLOCK
	# $Id: web_blast.pl,v 1.10 2016/07/13 14:32:50 merezhuk Exp $
	#
	# ===========================================================================
	#
	#                            PUBLIC DOMAIN NOTICE
	#               National Center for Biotechnology Information
	#
	# This software/database is a "United States Government Work" under the
	# terms of the United States Copyright Act.  It was written as part of
	# the author's official duties as a United States Government employee and
	# thus cannot be copyrighted.  This software/database is freely available
	# to the public for use. The National Library of Medicine and the U.S.
	# Government have not placed any restriction on its use or reproduction.
	#
	# Although all reasonable efforts have been taken to ensure the accuracy
	# and reliability of the software and data, the NLM and the U.S.
	# Government do not and cannot warrant the performance or results that
	# may be obtained by using this software or data. The NLM and the U.S.
	# Government disclaim all warranties, express or implied, including
	# warranties of performance, merchantability or fitness for any particular
	# purpose.
	#
	# Please cite the author in any work or product based on this material.
	#
	# ===========================================================================
	#
	# This code is for example purposes only.
	#
	# Please refer to https://ncbi.github.io/blast-cloud/dev/api.html
	# for a complete list of allowed parameters.
	#
	# Please do not submit or retrieve more than one request every two seconds.
	#
	# Results will be kept at NCBI for 24 hours. For best batch performance,
	# we recommend that you submit requests after 2000 EST (0100 GMT) and
	# retrieve results before 0500 EST (1000 GMT).
	#
	# ===========================================================================
	#
	# return codes:
	#     0 - success
	#     1 - invalid arguments
	#     2 - no hits found
	#     3 - rid expired
	#     4 - search failed
	#     5 - unknown error
	#
	# ===========================================================================

	#package requirement list, all but LWP appears standard with strawberry perl
	use URI::Escape;
	use LWP::UserAgent;
	use HTTP::Request::Common qw(POST);

	#initialize a user agent
	my $ua = LWP::UserAgent->new;

	#assign input variables
	my $program = $_[0];
	my $database = $_[1];
	my $entrez = $_[2];
	my $fasta = $_[3];
	#timer so that if wait too long past
	my $numWaits = 0;
	#stores 0 if search did not expire, 1 if it did
	my $expired = 0;

	#extra add-on code required for megablast
	if ($program eq "megablast") {
		$program = "blastn&MEGABLAST=on";
	}

	#extra add-on code required for rpsblast
	if ($program eq "rpsblast") {
		$program = "blastp&SERVICE=rpsblast";
    }

	# read and encode the fasta file
	#note this was originally supposed to handle multiple queries, but I have simplified this to 
	#using only a single fasta
	if (! open FASTA, "<".$fasta) {
		print ERRORLOG "could not open".$fasta." file, reason: $!";
		exit 1;
	}	

	#read the lines, put them in an array (seperated by newlines), remove excess whitespace
	my @lines = <FASTA>;
	#join the fasta into a single string line
	my $query = join "", @lines;
	$query = uri_escape($query);

	#build the request, ENTREZ_QUERY was added from original version to allow queries against a single organism
	my $args = "CMD=Put&PROGRAM=".$program."&DATABASE=".$database."&ENTREZ_QUERY=".$entrez."[Organism]&QUERY=".$query;
	my $req = new HTTP::Request POST => 'https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi';
	$req->content_type('application/x-www-form-urlencoded');
	$req->content($args);

	# get the response
	my $response = $ua->request($req);

	# parse out the request id
	$response->content =~ /^    RID = (.*$)/m;
	my $rid=$1;

	# parse out the estimated time to completion
	$response->content =~ /^    RTOE = (.*$)/m;
	my $rtoe=$1;
	if ($rtoe =~ /[0-9]+/) { #if time to completion is numerical
		#do nothing, sleep will not be a problem
	} else { #if $rtoe is not numeric
		#sometime the rid is returned for some reason (possibly no match in RTOE search
		#set $rtoe to 60
		$rtoe = 60;
	}
	printf "Making BLAST request %s, time to completion (estimated): %s seconds\n", $rid, $rtoe;
	$| = 1;
	# wait for search to complete
	sleep $rtoe;
	# poll for results
	printf "awaiting response";
	LOOP: while (1) {
		printf ".";
		$numWaits++;
		$req = new HTTP::Request GET => "https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_OBJECT=SearchInfo&RID=".$rid;
		$response = $ua->request($req);
		
		if ($response->content =~ /\s+Status=WAITING/m) { #if still waiting for blast results
			#failsafe just in case something goes really wrong, or simply to prevent an infinite loop
			if ($numWaits >= 100) {
				last LOOP;
				next;
			}
			sleep 60;
			next;
		}

		if ($response->content =~ /\s+Status=FAILED/m) { #if blast failed
			print STDERR "Search for fasta ".$fasta." on organism ".$entrez." failed; please report to blast-help\@ncbi.nlm.nih.gov.\n";
			last LOOP;
        }

		if ($response->content =~ /\s+Status=UNKNOWN/m) { #if query to blast has timed out
			print STDERR "Search $rid for fasta ".$fasta." on organism ".$entrez." expired.\n";
			$expired = 1;
			print "\n";
			last LOOP;
        }

		if ($response->content =~ /\s+Status=READY/m) { #if blast is complete
			if ($response->content =~ /\s+ThereAreHits=yes/m) { #if there are blast hits
				printf "\nSearch complete, retrieving results...\n";
				last; #last loop, breaks the while loop
			} else { #if has results but no blast matches
				print STDERR "No hits found for fasta ".$fasta." on organism ".$entrez."\n";
				last LOOP;
            }
        }

		# if we get here, something unexpected happened.
		last LOOP;
    } # end poll loop
	if (($numWaits >= 100) || ($expired == 1)) {
		#if need to start a new requestion
		printf "retrying blast request...\n";
		$response = &web_blast($program, $database,$entrez,$fasta);
		return $response;
	} else {
		#everything normal
		# retrieve and display results
		$req = new HTTP::Request GET => "https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_TYPE=Text&RID=".$rid;
		$response = $ua->request($req);
		$response = $response->content;
		#return blast results
		return $response;
	}
}

#created to turn a percentage into a decimal value
#input:
#	$_[0] = percent value as string w/ % sign
#output:
#	$decimal = decimal value
sub percenttoDecimal {
	$percent = $_[0];
	if ($percent =~ /([0-9]+)\%/) {
		$percent = $1;
		$decimal = $percent/100;
		return $decimal;
	} else { #wrong input format
		return $percent;
	}
}

#performs log base 10 calculation
sub log10 {
	$arg = $_[0];
	return log($arg)/log(10);
}

#subroutine to do string replacement needed for matching
#input:
#	$_[0] = string to prepare for matching
#output:
#	$process = string prepared for matching
sub readyForMatch {
	printf "argument: %s\n", $_[0];
	my $searchName = $_[0];
	#format brackets so they are not seen as an index call
	$searchName =~ s/\[/\\[/g;
	$searchName =~ s/\]/\\]/g;
	#format parenthesis so they are matched
	$searchName =~ s/\(/\\(/g;
	$searchName =~ s/\)/\\)/g;
	#make sure slashes (forward and back) are seen as part of the string
	$searchName =~ s/\\/\\\\/g;
	$searchName =~ s/\//\\\//g;
	#replace semi-colons with commas again
	$searchName =~ s/;/,/g;
}

#subroutine to provide a timestamp for program logs
sub timestamp {
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	my @months = ("Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec");
	#change this every year
	$year = $year + 1900;
	my $humanTime = $mday." ".$months[$mon]." ".$year." ".$hour.":".$min.":".$sec;
	return $humanTime;
}
#subroutine to return the maximum element of an array
#input:
#	$_[0] = array reference
#output:
#	$max = maximum element of the referenced array
sub maxArr {
	$arrRef = $_[0];
	@arr = @$arrRef;
	if ($#arr eq -1) {
		return 0;
	}
	#set the maximum the the first array element. Note that the array cannot be empty
	$max = $arr[0];
	if ($#arr == 1) { #if there is only one element, return that element as the max
		return $max;
	}
	#otherwise we get here, iteratively determine the max
	for (my $i = 1; $i <= $#arr; $i++) {
		if ($arr[$i] > $max) { #if the current element is bigger than the maximum element
			$max = $arr[$i]; #then update the max
		} #otherwise do nothing
	}
	#now should have the maximum element
	return $max;
}

#gives the modal value of an array (string or numerical)
#inputs:
#	$_[0] = array reference
#output:
#	@mode = reference to array of modal values of the array
sub modeArr {
	$ref = $_[0];
	@arr = @$ref;
	if ($#arr eq -1) {
		return 0;
	}
	#hash of counts
	%counts = ( );
	$maxCount = 0;
	for (my $i = 0; $i <= $#arr; $i++) { #for each element
		$currCount = 0; #rest the count
		#get the count of the number of times that element occurs
		for (my $j = 0; $j <= $#arr; $j++) {
			if ($arr[$j] eq $arr[$i]) { #if the element occurs in the array at current element
				$currCount++; #increase the count
			}
		}
		#should have full count of the occurances
		if ($currCount > $maxCount) { #store a maximum count
			$maxCount = $currCount;
		}
		if (! exists $counts{$arr[$i]}) {
			$counts{$arr[$i]} = $currCount;
		}
	}
	@modes = ( );
	#for each key
	while ( ($key, $value) = each %counts) {
		#push key onto array iff count matches the maximum count
		if ($value == $maxCount) {
			push @modes, $key;
		}
	}
	return \@modes;
}

#returns the number of occurences of a specified element in the array
#inputs:
#	$_[0] = value to search for
#	$_[1] = reference for array to search in
#outputs
#	$count = number of occurances of value in array
sub numOccurances {
	my $val = $_[0];
	my $ref = $_[1];
	my @arr = @$ref;
	if ($#arr eq -1) {
		return 0;
	}
	my $count = 0;
	for (my $i = 0; $i <= $#arr; $i++) {
		if ($arr[$i] eq $val) {
			$count++;
		}
	}
	return $count;
}
1; #required to return a true value from this document when required by scripts, basically returns a "true" value that this script exits