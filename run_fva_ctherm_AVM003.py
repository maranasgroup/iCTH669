#!/usr/bin/python
#! python 3.9
#try to specify that we will use python version 3.9
__author__ = "Wheaton Schroeder"
#latest version: 12/03/2021

#imports, again, these are used previously, not sure of their necessity
import cobra
from fva import FVA
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
output=open('FVA_results_ctherm_AVM003.txt','w',buffering=1)
output.write("FVA results\n")
output.write("model: "+model.name+"\n\n")

#this model's biomass weight is not 1, this is important for yield calculations
biomass_weight = 1

#set what rates are fixed
#fixed rates dictionary, if we want it
fixed_rates = {

    "PPDK":0.0,
    #"PPA":0.0,
    #"ACS":0.0,
    #"GLGC":0.0,

    #turn off necessary reactions for growth for checking TICs
    #"EXCH_cellb_e":0.0,
    #"BIOMASS":0.0,
    #"ATPM":0.0,

    #force full uptake of cellobiose
    "EXCH_cellb_e":-2.92144383597262,

}

#maximum biomass rate for this strain
in_vivo_yield = 0.2243808
in_vivo_sd = 0.00566864

#set biomass growth bounds to within 10% of the maximum
model.reactions[model.reactions.index("BIOMASS")].lower_bound = (in_vivo_yield - 1.96 * in_vivo_sd) / biomass_weight
model.reactions[model.reactions.index("BIOMASS")].upper_bound = (in_vivo_yield + 1.96 * in_vivo_sd)  / biomass_weight
 
object = FVA(model)

#allow for rates to be fixed
results = object.analyze(fixed_rates)

#write how long this took to solve
output.write("solve time: "+str(results['total_time'])+"\n\n")

#write a header
output.write("model: "+model.name+"\n\n")

#format output for each reaction
for rxn in model.reactions:

    #check if an exception occured
    if results[rxn.id]['exception']:

        #if here, an exception occured, make sure we report that 
        output.write(str(rxn.id)+"\t"+str(results[rxn.id]['lb'])+"\t"+str(results[rxn.id]['min'])+"\t"+str(results[rxn.id]['max'])+"\t"+str(results[rxn.id]['ub'])+"\texception: "+str(results[rxn.id]['exception_str'])+"\n")

    else:

        #report FVA with greater decimal precision
        #create a formatted string to report a large number of decimal places
        formatted_min = "{:.8f}".format(results[rxn.id]['min'])
        formatted_max = "{:.8f}".format(results[rxn.id]['max'])

        #if here then a solution was found, report as normal
        output.write(str(rxn.id)+"\t"+str(results[rxn.id]['lb'])+"\t"+formatted_min+"\t"+formatted_max+"\t"+str(results[rxn.id]['ub'])+"\n")

#report when finished and how much time things took
end_time = datetime.now()

print("ending time: ",end_time)

elapsed = end_time - start_time

print("elapsed time: ",elapsed)