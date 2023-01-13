#!/usr/bin/python
#! python 3.9
#try to specify that we will use python version 3.9
__author__ = "Wheaton Schroeder"
#latest version: 12/03/2021

#imports, again, these are used previously, not sure of their necessity
import cobra
from fba import FBA
from datetime import datetime
from cobra import Model, Reaction, Metabolite
import re
import os
import warnings

#get the current time and date for tracking solution time
start_time = datetime.now()
print("Starting time: ",start_time)

#get the current directory to use for importing things
curr_dir = os.getcwd()

#import the ctherm model
model = cobra.io.read_sbml_model(curr_dir + "/iCTH665_05_31_22_w_GLGC.sbml")

#write a file to put the FBA results
output=open('pFBA_results_ctherm.txt','w',buffering=1)
output.write("pFBA results\n")
output.write("model: "+model.name+"\n\n")

#here are some objectives I am likely to use
objective = "BIOMASS"
#objective = "EXCH_ac_e"
#objective = "PPi_sink"
#objective = "ME2"

#fixed rates dictionary, if we want it
#these make fixed versions of the strains, rather than knockouts so same list of reactions still
fixed_rates = {

    #LL1004
    "BIOMASS":0.281979407,
        
    #AVM008 KO
    #"PPA":0.0,
    #"BIOMASS":0.258388141,

    #AVM051 KO
    #"GLGC":0.0,
    #"BIOMASS":0.214335986,

    #AVM003 KO
    #"PPDK":0.0,
    #"BIOMASS":0.2243808,
    #"BIOMASS":0.1976465,  #greatest that the non-GTP and non-ITP cofactor can obtain

    #AVM059 KO
    #"ACS":0.0,
    #"BIOMASS":0.258526183,
        
    #AVM053 KOs
    #"PPA":0.0,
    #"GLGC":0.0,
    #"BIOMASS":0.207158858,

    #AVM052 KOs
    #"PPDK":0.0,
    #"GLGC":0.0,
    #"BIOMASS":0.190249249,

    #AVM060 KOs
    #"ACS":0.0,
    #"GLGC":0.0,
    #"BIOMASS":0.198452575,

    #AVM056 KOs
    #"PPA":0.0,
    #"PPDK":0.0,
    #"GLGC":0.0,
    #"BIOMASS":0.207269625, #in vivo number 
    #"BIOMASS":0.1976465,  #greatest that the non-GTP cofactor can obtain

    #AVM061 KOs
    #"PPA":0.0,
    #"PPDK":0.0,
    #"GLGC":0.0,
    #"ACS":0.0,
    #"BIOMASS":0.176268057,

    #turn off necessary reactions for growth for checking TICs
    #"EXCH_cellb_e":0.0,
    #"BIOMASS":0.0,
    #"ATPM":0.0,

    #force full uptake of cellobiose
    "EXCH_cellb_e":-2.92144383597262,

}

object = FBA(model)

#note that for some reason the "R_" gets dropped
#results = object.run("BIOMASS")
results = object.run_pFBA(objective,"max", fixed_rates)

#check if an exception occured
if results['exception']:

    #if here, an exception occured, we have no solution
    output.write("time to solve: "+str(results['total_time'])+"\n")
    output.write("exception occured, no solution exception: \n"+results['exception_str']+"\n")

else:

    #create a formatted string to report a large number of decimal places
    formatted_string_1 = "{:.8f}".format(results['objective'])
    formatted_string_2 = "{:.8f}".format(results[objective]['flux'])

    #if here no exception, we have a solution to write about
    #write our results to the output file
    output.write("time to solve: "+str(results['total_time'])+"\n")
    output.write("objective value (flux sum): "+formatted_string_1+"\n")
    output.write("objective value ("+objective+"): "+formatted_string_2+"\n\n")
    output.write("ethanol maximization reaction flux profile\n\n")
    output.write("reaction\tlb\tlevel\tub\n")
    output.write("----------------------------------------------------------------------------------\n")

    print("objective value (flux sum): ",formatted_string_1)
    print("objective value ("+objective+"): ",formatted_string_2)

    #for each reaction in the model
    for rxn in model.reactions:

        #write the FBA results
        output.write(rxn.id+"\t"+str(results[rxn.id]['lb'])+"\t"+str(results[rxn.id]['flux'])+"\t"+str(results[rxn.id]['ub'])+"\n")

#report when finished and how much time things took
end_time = datetime.now()

print("ending time: ",end_time)

elapsed = end_time - start_time

print("elapsed time: ",elapsed)