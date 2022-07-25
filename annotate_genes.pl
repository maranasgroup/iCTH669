#!usr/bin/perl -w
#Written by: Wheaton Schroeder
#Latest Version: 11/02/2021
#written to automatically annotate a list of genes

use strict;
use LWP::UserAgent; #enable use of the library for the world wide web for perl, bring in the user agent

#written by: Wheaton Schroeder
#Latest version: 10/25/2021
#written to create annotations for gene

open(MODEL, "<new_genes.txt") or die "Can't open/read new_genes.txt, reason: $!\n";

#get the lines
chomp(my @lines = <MODEL>);

#create a file to write to gene annotation data to
open(GENEOUT, ">gene_annotations.txt") or die "could not write to/create gene_annotations.txt, reason: $!\n";

#hopefully real-time writing
$| = 0;

#initialize a user agent for reading gene data from the KEGG API
my $agent = LWP::UserAgent->new;

#keep a list of genes which have been annotated
my %genes = ( );

#total gene counter
my $total_genes = 0;

#unique gene counter
my $unique_genes = 0; 

#for each line of the model
for(my $a = 0; $a <= $#lines; $a++) {

    #see if the line has a has a gene
    while($lines[$a] =~ /(Clo1313_\d+)/g) {

        #save the identifier
        my $id = $1;

        printf "working on gene: %s\n", $id;

        #found another gene
        $total_genes++;

        if(!(exists $genes{$id})) {

            #found another unique gene
            $unique_genes++;

            #a space to store the name of the gene
            my $name = "";

            #a space to store the label in, label will be name with special characters (except "_") and spaces removed
            my $label = "";

            #initiate a string for the gene information
            #this is all we can say before going to the website
            my $gene_info = "<fbc:geneProduct metaid=\"".$id."\" sboTerm=\"SBO:0000243\" fbc:id=\"".$id."\" fbc:label=\"";
            
            #if here, then a gene was found, look it up in the kegg API
            #go to the KEGG API and get the content to parse for desired data
            my $geneURL = "http://rest.kegg.jp/get/ctx:".$id;
            my $gene_page = $agent->get($geneURL);
            $gene_page = $gene_page->content;

            printf "retrieved url %s\n", $geneURL;

            #now that we have gone to kegg, we can get a label and name for the gene
            #search the string for the word "NAME", this will be the basis of both
            if($gene_page =~ /NAME\s+(.+)\n/) {

                #store the name
                $name = $1;

                #determine the label
                $label = $name;

                #format the label
                $label =~ s/\(//g;
                $label =~ s/\)//g;
                $label =~ s/\-/__/g;
                $label =~ s/\s+/_/g;

            }

            #add the label and name to the gene info string
            #labels must be unique so adding on ID to the label
            $gene_info = $gene_info.$label."_".$id."\" fbc:name=\"".$name."\">\n  <sbml:annotation>\n    <rdf:RDF>\n      <rdf:Description rdf:about=\"#".$id."\">\n        <bqbiol:is>\n          <rdf:Bag>\n            <rdf:li rdf:resource=\"http://identifiers.org/kegg.gene/".$id."\" />";

            #get the NCBI protein ID and uniprot ID from the gene page
            if($gene_page =~ /NCBI-ProteinID:\s+(.+)\s*\n/) {

                $gene_info = $gene_info."\n            <rdf:li rdf:resource=\"http://identifiers.org/ncbiprotein/".$1."\" />";

            }

            if($gene_page =~ /UniProt:\s+(.+)\s*\n/) {

                $gene_info = $gene_info."\n            <rdf:li rdf:resource=\"http://identifiers.org/uniprot/".$1."\" />";

            }

            #finish the annotation framework
            $gene_info = $gene_info."\n          </rdf:Bag>\n        </bqbiol:is>\n      </rdf:Description>\n    </rdf:RDF>\n  </sbml:annotation>\n</fbc:geneProduct>";

            #now write the output
            printf GENEOUT "%s\n", $gene_info;
            printf "written text:\n%s\n\n", $gene_info;

            #add this to the list of genes
            $genes{$id} = 1;

        }
    
    } #repeat for each gene

    

}

#print out the number of genes found
printf "found a total of %d gene entries of which %d were unique!\n", $total_genes, $unique_genes;