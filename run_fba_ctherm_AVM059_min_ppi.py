#!/usr/bin/python
#! python 3.9
#try to specify that we will use python version 3.9
__author__ = "Wheaton Schroeder"
#latest version: 06/09/2022

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
model = cobra.io.read_sbml_model(curr_dir + "/iCTH669_w_GLGC.sbml")

#write a file to put the FBA results
output=open('FBA_results_ctherm_AVM059_ppi_min.txt','w',buffering=1)
output.write("FBA results\n")
output.write("model: "+model.name+"\n\n")

#fixed rates dictionary, if we want it
#these make fixed versions of the strains, rather than knockouts so same list of reactions still
fixed_rates = {

    #LL1004
    #"BIOMASS":0.281979407,
        
    #AVM008 KO
    #"PPA":0.0,
    #"PPAna":0.0,
    #"BIOMASS":0.258388141,

    #AVM051 KO
    #"GLGC":0.0,
    #"BIOMASS":0.214335986,

    #AVM003 KO
    #"PPDK":0.0,
    #"BIOMASS":0.2243808,

    #AVM059 KO
    "PPAKr":0.0,
    "R00925":0.0,
    "PACPT":0.0,
    "ACADT":0.0,
    "ACADCOAT":0.0,
    "BIOMASS":0.258526183,
        
    #AVM053 KOs
    #"PPA":0.0,
    #"PPAna":0.0,
    #"GLGC":0.0,
    #"BIOMASS":0.207158858,

    #AVM052 KOs
    #"PPDK":0.0,
    #"GLGC":0.0,
    #"BIOMASS":0.190249249,

    #AVM060 KOs
    #"PPAKr":0.0,
    #"R00925":0.0,
    #"PACPT":0.0,
    #"ACADT":0.0,
    #"ACADCOAT":0.0,
    #"GLGC":0.0,
    #"BIOMASS":0.198452575,

    #AVM056 KOs
    #"PPA":0.0,
    #"PPAna":0.0,
    #"PPDK":0.0,
    #"GLGC":0.0,
    #"BIOMASS":0.207269625,

    #AVM061 KOs
    #"PPA":0.0,
    #"PPAna":0.0,
    #"PPDK":0.0,
    #"GLGC":0.0,
    #"PPAKr":0.0,
    #"R00925":0.0,
    #"PACPT":0.0,
    #"ACADT":0.0,
    #"ACADCOAT":0.0,
    #"BIOMASS":0.176268057,

    #ensure overflow metabolism by requiring full cellbiose uptake
    "EXCH_cellb_e":-2.92144383597262,

}

#load fba
object = FBA(model)

#note that for some reason the "R_" gets dropped
results = object.run_min_PPi(fixed_rates)

#check if an exception occured
if results['exception']:

    #if here, an exception occured, we have no solution
    output.write("time to solve: "+str(results['total_time'])+"\n")
    output.write("exception occured, no solution exception: \n"+results['exception_str']+"\n")

else:

    #create a formatted string to report a large number of decimal places
    formatted_string = "{:.8f}".format(results['objective'])

    #if here no exception, we have a solution to write about
    #write our results to the output file
    output.write("time to solve: "+str(results['total_time'])+"\n")
    output.write("status: "+str(results['status'])+"\n")
    output.write("objective value: "+formatted_string+"\n\n")
    output.write("reaction\tlb\tlevel\tub\n")
    output.write("----------------------------------------------------------------------------------\n")

    print("objective value: ",formatted_string)
    print("model status: "+str(results['status']))

    #for each reaction in the model
    for rxn in model.reactions:

        #write the FBA results
        output.write(rxn.id+"\t"+str(results[rxn.id]['lb'])+"\t"+str(results[rxn.id]['flux'])+"\t"+str(results[rxn.id]['ub'])+"\n")

#track the minimized PPi
mets_to_track = ['ppi_c']

for tracker in mets_to_track:

    #create reaction arrays for producers and consumers
    producers = []
    consumers = []
    total_production = 0

    #report on production/consumption
    for rxn in model.reactions:

        #get the metabolites
        rxn_mets = rxn.metabolites

        #loop through the metabolites looking for tracker
        for met in rxn_mets:

            #if the metabolite is tracker
            #we don't care about the reaction if it has no flux
            if (met.id == tracker) and (results[rxn.id]['flux'] != 0):

                #determine if positive or negative coefficient
                if ((rxn.get_coefficient(met) > 0) and (results[rxn.id]['flux'] > 0)) or ((rxn.get_coefficient(met) < 0) and (results[rxn.id]['flux'] < 0)):

                    #if here then a product
                    producers.append(rxn)

                    #update the production
                    total_production = total_production + rxn.get_coefficient(tracker) * results[rxn.id]['flux']

                else:

                    #if here than a reactant
                    consumers.append(rxn)

    #create some space before writing tracker checks
    output.write("\n\n")
    output.write(tracker+" consuming reactions and rates of "+tracker+" consumption: \n")

    #now organize, list consumers and producers with flux
    for consumer in consumers:

        #calculate the percentage of consumption attributed to this reaction
        perc_of_conc = ((consumer.get_coefficient(tracker) * results[consumer.id]['flux']) / total_production) * 100

        output.write(consumer.id+"\t"+str(consumer.get_coefficient(tracker) * results[consumer.id]['flux'])+"\t("+str(perc_of_conc)+"%)\n")

    output.write("\n\n")
    output.write(tracker+" producing reactions and rates of "+tracker+" production: \n")
        
    #now organize, list consumers and producers with flux
    for producer in producers:

        #calculate the percentage of consumption
        perc_of_prod = ((producer.get_coefficient(tracker) * results[producer.id]['flux']) / total_production) * 100

        output.write(producer.id+"\t"+str(producer.get_coefficient(tracker) * results[producer.id]['flux'])+"\t("+str(perc_of_prod)+"%)\n")

    output.write("\nproduction flux through "+tracker+": "+str(total_production)+"\n")
    print("production flux through "+tracker+": "+str(total_production))

#report when finished and how much time things took
end_time = datetime.now()

print("ending time: ",end_time)

elapsed = end_time - start_time

print("elapsed time: ",elapsed)