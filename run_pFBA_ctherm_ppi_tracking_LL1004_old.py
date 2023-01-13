#!/usr/bin/python
#! python 3.9
#try to specify that we will use python version 3.9
__author__ = "Wheaton Schroeder"
#latest version: 01/05/2022
#run pFBA, with the requirement of forcing certain ratios between carbon-based fermentation products that are seen in literatures

#imports, again, these are used previously, not sure of their necessity
import cobra
from fba import FBA
from datetime import datetime
from cobra import Model, Reaction, Metabolite
import re
import os
import warnings
import copy

#get the current time and date for tracking solution time
start_time = datetime.now()
print("Starting time: ",start_time)

#get the current directory to use for importing things
curr_dir = os.getcwd()

#import the ctherm model
model = cobra.io.read_sbml_model(curr_dir + "/iCBI655_cellobiose_batch.sbml")

#write a file to put the FBA results
output=open('pFBA_results_ctherm_ppi_tracking_LL1004_old.txt','w',buffering=1)
output.write("pFBA knockout results\n")
output.write("model: "+model.name+"\n\n")

object = FBA(model)

#note that for some reason the "R_" gets dropped
#with new way of putting things together, have to pass the objective for the first step of pfba

#here are some objectives I am likely to use
objective = "BIOMASS_CELLOBIOSE"

#this model's biomass weight is not 1, this is important for yield calculations
biomass_weight = 10.247910703070335

#fixed rates dictionary, if we want it

fixed_rates = {

    #LL1004
    "BIOMASS_CELLOBIOSE":0.281979407 / biomass_weight,
        
    #AVM008 KO
    #"PPA":0.0,
    #"PPAna":0.0,
    #"BIOMASS_CELLOBIOSE":0.258388141 / biomass_weight,

    #AVM051 KO
    #"GLGC":0.0,
    #"BIOMASS_CELLOBIOSE":0.214335986 / biomass_weight,

    #AVM003 KO
    #"PPDK":0.0,
    #"BIOMASS_CELLOBIOSE":0.2243808 / biomass_weight,

    #AVM059 KO
    #"PPAKr":0.0,
    #"ACS":0.0,
    #"PACPT":0.0,
    #"ACADT":0.0,
    #"ACADCOAT":0.0,
    #"BIOMASS_CELLOBIOSE":0.258526183 / biomass_weight,
        
    #AVM053 KOs
    #"PPA":0.0,
    #"PPAna":0.0,
    #"GLGC":0.0,
    #"BIOMASS_CELLOBIOSE":0.207158858 / biomass_weight,

    #AVM052 KOs
    #"PPDK":0.0,
    #"GLGC":0.0,
    #"BIOMASS_CELLOBIOSE":0.190249249 / biomass_weight,

    #AVM060 KOs
    #"PPAKr":0.0,
    #"ACS":0.0,
    #"PACPT":0.0,
    #"ACADT":0.0,
    #"ACADCOAT":0.0,
    #"GLGC":0.0,
    #"BIOMASS_CELLOBIOSE":0.198452575 / biomass_weight,

    #AVM056 KOs
    #"PPA":0.0,
    #"PPAna":0.0,
    #"PPDK":0.0,
    #"GLGC":0.0,
    #"BIOMASS_CELLOBIOSE":0.207269625 / biomass_weight,

    #AVM061 KOs
    #"PPA":0.0,
    #"PPAna":0.0,
    #"PPDK":0.0,
    #"GLGC":0.0,
    #"PPAKr":0.0,
    #"ACS":0.0,
    #"PACPT":0.0,
    #"ACADT":0.0,
    #"ACADCOAT":0.0,
    #"BIOMASS_CELLOBIOSE":0.176268057 / biomass_weight,

    #ensure overflow metabolism by requiring full cellbiose uptake
    "EX_cellb_e":-2.92144383597262,

}


#solve PFBA
results = object.run_pFBA(objective,"max",fixed_rates) #runs pfba

#alternative, for other objectives and fixed rates
#results = object.run_pFBA(objective,"max",fixed_rates) #runs pfba#

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
    output.write("objective value ("+objective+"): "+formatted_string_2+"\n")
    output.write("reaction\tlb\tlevel\tub\n")
    output.write("----------------------------------------------------------------------------------\n")

    print("objective value (flux sum): ",formatted_string_1)
    print("objective value ("+objective+"): ",formatted_string_2)

    #for each reaction in the model
    for rxn in model.reactions:

        #write the FBA results
        output.write(rxn.id+"\t"+str(results[rxn.id]['lb'])+"\t"+str(results[rxn.id]['flux'])+"\t"+str(results[rxn.id]['ub'])+"\n")

#track only PPi
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
    output.write(tracker+"\n shadow price ("+objective+"): "+str(results[tracker]['shadow_bio'])+"\n")
    output.write(tracker+" shadow price (flux): "+str(results[tracker]['shadow_flux'])+"\n")
    print("production flux through "+tracker+": "+str(total_production))
    print(tracker+" shadow price ("+objective+"): "+str(results[tracker]['shadow_bio']))
    print(tracker+" shadow price (flux): "+str(results[tracker]['shadow_flux'])+"\n")

#create a section of the report that reports on all shadow prices together
output.write("\n\n\nShadow price with respect to "+objective+"\n-----------------------------------------------------------------------------------------\n")

for tracker in mets_to_track:

    output.write(tracker+"\t"+str(results[tracker]['shadow_bio'])+"\n")

#create a section of the report that reports on all shadow prices together
output.write("\n\n\nShadow price with respect flux sum \n-----------------------------------------------------------------------------------------\n")

for tracker in mets_to_track:

    output.write(tracker+"\t"+str(results[tracker]['shadow_flux'])+"\n")

#report when finished and how much time things took
end_time = datetime.now()

print("ending time: ",end_time)

elapsed = end_time - start_time

print("elapsed time: ",elapsed)