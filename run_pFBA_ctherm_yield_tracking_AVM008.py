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
model = cobra.io.read_sbml_model(curr_dir + "/iCTH669_w_GLGC.sbml")

#write a file to put the FBA results
output=open('pFBA_results_ctherm_yield_tracking_AVM008.txt','w',buffering=1)
output.write("pFBA knockout results\n")
output.write("model: "+model.name+"\n\n")

object = FBA(model)

#note that for some reason the "R_" gets dropped
#with new way of putting things together, have to pass the objective for the first step of pfba

#here are some objectives I am likely to use
#objective = "BIOMASS"
objective = "EXCH_etoh_e"
#objective = "SINK_TEST"
#objective = "NDPK9"

#fixed rates dictionary, if we want it
#these make fixed versions of the strains, rather than knockouts so same list of reactions still
fixed_rates = {

    #LL1004
    #"BIOMASS":0.281979407,
        
    #AVM008 KO
    "PPA":0.0,
    "PPAna":0.0,
    "BIOMASS":0.258388141,

    #AVM051 KO
    #"GLGC":0.0,
    #"BIOMASS":0.214335986,

    #AVM003 KO
    #"PPDK":0.0,
    #"BIOMASS":0.2243808,

    #AVM059 KO
    #"PPAKr":0.0,
    #"R00925":0.0,
    #"PACPT":0.0,
    #"ACADT":0.0,
    #"ACADCOAT":0.0,
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
    #"PPAKr":0.0,
    #"R00925":0.0,
    #"PACPT":0.0,
    #"ACADT":0.0,
    #"ACADCOAT":0.0,
    #"GLGC":0.0,
    #"BIOMASS":0.198452575,

    #AVM056 KOs
    #"PPA":0.0,
    #"PPDK":0.0,
    #"GLGC":0.0,
    #"BIOMASS":0.207269625,
    #"BIOMASS":0.1976465, #maximum biomass that can be produced w/o cofactors

    #AVM061 KOs
    #"PPA":0.0,
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

#alternative, for other objectives and fixed rates
results = object.run_pFBA(objective,"max",fixed_rates) #runs pfba#

#check if an exception occured
if results['exception']:

    #if here, an exception occured, we have no solution
    output.write("time to solve: "+str(results['total_time'])+"\n")
    output.write("exception occured, no solution exception: \n"+results['exception_str']+"\n")

else:

    #create a formatted string to report a large number of decimal places
    formatted_string_1 = "{:.8f}".format(results['objective'])
    formatted_string_2 = "{:.8f}".format(results[objective]['flux'])

    
    #calculate yeild on cellobiose

    #get the uptake of cellobiose
    cellb_mol_up = -results['EXCH_cellb_e']['flux']

    #calculate the mass of cellobiose uptake
    cellb_mass_up = cellb_mol_up * 342.2965 / 1000

    print("cellobiose uptake (g): "+str(cellb_mass_up))

    #calculate the various yields of interest so we can write it to the output
    base_bio_yield = results['BIOMASS']['flux'] / cellb_mass_up
    base_etoh_yield = results['EXCH_etoh_e']['flux'] / cellb_mol_up
    base_ac_yield = results['EXCH_ac_e']['flux'] / cellb_mol_up
    base_for_yield = results['EXCH_for_e']['flux'] / cellb_mol_up
    base_lac_yield = results['EXCH_lac__L_e']['flux'] / cellb_mol_up
    base_pyr_yield = results['EXCH_pyr_e']['flux'] / cellb_mol_up
    base_mal_yield = results['EXCH_mal__L_e']['flux'] / cellb_mol_up

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

#calculate minimum and maximum
#calculate mas yield for biomass
objective = "BIOMASS"

fixed_rates_2 = {

    #LL1004
    #"BIOMASS":0.281979407,
        
    #AVM008 KO
    "PPA":0.0,
    "PPAna":0.0,
    #"BIOMASS":0.258388141,

    #AVM051 KO
    #"GLGC":0.0,
    #"BIOMASS":0.214335986,

    #AVM003 KO
    #"PPDK":0.0,
    #"BIOMASS":0.2243808,

    #AVM059 KO
    #"PPAKr":0.0,
    #"R00925":0.0,
    #"PACPT":0.0,
    #"ACADT":0.0,
    #"ACADCOAT":0.0,
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
    #"PPAKr":0.0,
    #"R00925":0.0,
    #"PACPT":0.0,
    #"ACADT":0.0,
    #"ACADCOAT":0.0,
    #"GLGC":0.0,
    #"BIOMASS":0.198452575,

    #AVM056 KOs
    #"PPA":0.0,
    #"PPDK":0.0,
    #"GLGC":0.0,
    #"BIOMASS":0.207269625,
    #"BIOMASS":0.1976465, #maximum biomass that can be produced w/o cofactors

    #AVM061 KOs
    #"PPA":0.0,
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

object = FBA(model)

results = object.run(objective,"max",fixed_rates_2) #runs fba#

max_bio_yield = results['BIOMASS']['flux'] / cellb_mass_up

#require yields to be within 95% CI to get 95% CI for fermentation products
#biomass yield statistics for this strain
in_vivo_yield = 0.25839
in_vivo_sd = 0.01256

#store the biomass weight for this C. therm model
biomass_weight = 1

#set biomass growth bounds to within 1.96 stdev of the maximum (95% confidence interval assuming a normal distribution)
#need to divide by biomass weight to have the yield calculations come out correctly
model.reactions[model.reactions.index("BIOMASS")].lower_bound = (in_vivo_yield - 1.96 * in_vivo_sd) / biomass_weight
model.reactions[model.reactions.index("BIOMASS")].upper_bound = (in_vivo_yield + 1.96 * in_vivo_sd)  / biomass_weight

object = FBA(model)

#calcualte min for ethanol, we already know the max
#change the objective function
objective = "EXCH_etoh_e"

#run FBA to find the min ethanol rate
results = object.run(objective,"min",fixed_rates_2) #runs fba#

#get the yield 
max_etoh_yield = base_etoh_yield
min_etoh_yield = results['EXCH_etoh_e']['flux'] / cellb_mol_up

#find min and max acetate
#set objective
objective = "EXCH_ac_e"

#run FBA to find the min rate
results = object.run(objective,"min",fixed_rates_2) #runs fba#

min_ac_yield = results['EXCH_ac_e']['flux'] / cellb_mol_up

#run FBA to find the max rate
results = object.run(objective,"max",fixed_rates_2) #runs fba#

max_ac_yield = results['EXCH_ac_e']['flux'] / cellb_mol_up

#find min and max formate
#set objective
objective = "EXCH_for_e"

#run FBA to find the min rate
results = object.run(objective,"min",fixed_rates_2) #runs fba#

min_for_yield = results['EXCH_for_e']['flux'] / cellb_mol_up

#run FBA to find the max rate
results = object.run(objective,"max",fixed_rates_2) #runs fba#

max_for_yield = results['EXCH_for_e']['flux'] / cellb_mol_up

#find min and max lactate
#set objective
objective = "EXCH_lac__L_e"

#run FBA to find the min rate
results = object.run(objective,"min",fixed_rates_2) #runs fba#

min_lac_yield = results['EXCH_lac__L_e']['flux'] / cellb_mol_up

#run FBA to find the max rate
results = object.run(objective,"max",fixed_rates_2) #runs fba#

max_lac_yield = results['EXCH_lac__L_e']['flux'] / cellb_mol_up

#find min and max pyruvate
#set objective
objective = "EXCH_pyr_e"

#run FBA to find the min rate
results = object.run(objective,"min",fixed_rates_2) #runs fba#

min_pyr_yield = results['EXCH_pyr_e']['flux'] / cellb_mol_up

#run FBA to find the max rate
results = object.run(objective,"max",fixed_rates_2) #runs fba#

max_pyr_yield = results['EXCH_pyr_e']['flux'] / cellb_mol_up

#find min and max malate
#set objective
objective = "EXCH_mal__L_e"

#run FBA to find the min rate
results = object.run(objective,"min",fixed_rates_2) #runs fba#

min_mal_yield = results['EXCH_mal__L_e']['flux'] / cellb_mol_up

#run FBA to find the max rate
results = object.run(objective,"max",fixed_rates_2) #runs fba#

max_mal_yield = results['EXCH_mal__L_e']['flux'] / cellb_mol_up

#write our results in an easy machine-readable format to the output
output.write("\n\nbiomass yield base: "+str(base_bio_yield)+"\n")
output.write("biomass yield max: "+str(max_bio_yield)+"\n")
output.write("ethanol yield pFBA: "+str(base_etoh_yield)+"\n")
output.write("ethanol yield max: "+str(max_etoh_yield)+"\n")
output.write("ethanol yield min: "+str(min_etoh_yield)+"\n")
output.write("acetate yield pFBA: "+str(base_ac_yield)+"\n")
output.write("acetate yield max: "+str(max_ac_yield)+"\n")
output.write("acetate yield min: "+str(min_ac_yield)+"\n")
output.write("formate yield pFBA: "+str(base_for_yield)+"\n")
output.write("formate yield max: "+str(max_for_yield)+"\n")
output.write("formate yield min: "+str(min_for_yield)+"\n")
output.write("lactate yield pFBA: "+str(base_lac_yield)+"\n")
output.write("lactate yield max: "+str(max_lac_yield)+"\n")
output.write("lactate yield min: "+str(min_lac_yield)+"\n")
output.write("pyruvate yield pFBA: "+str(base_pyr_yield)+"\n")
output.write("pyruvate yield max: "+str(max_pyr_yield)+"\n")
output.write("pyruvate yield min: "+str(min_pyr_yield)+"\n")
output.write("malate yield pFBA: "+str(base_mal_yield)+"\n")
output.write("malate yield max: "+str(max_mal_yield)+"\n")
output.write("malate yield min: "+str(min_mal_yield)+"\n")

#report when finished and how much time things took
end_time = datetime.now()

print("ending time: ",end_time)

elapsed = end_time - start_time

print("elapsed time: ",elapsed)