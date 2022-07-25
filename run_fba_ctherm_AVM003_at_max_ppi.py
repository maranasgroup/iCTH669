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
output=open('FBA_results_ctherm_AVM003_at_max_ppi.txt','w',buffering=1)
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
    "PPDK":0.0,
    "BIOMASS":0.2243808,

    #AVM059 KO
    #"PPAKr":0.0,
    #"R00925":0.0,
    #"PACPT":0.0,
    #"ACADT":0.0,
    #"ACADCOAT":0.0,
    #"BIOMASS":0.258526183,
        
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

    #expore space around max and min global ppi production

    #maximum PPi
    "NA_biomass":0.22438080000000002,
    "PPA":3.9103134404645,
    "NADS2":0.004158865335479806,
    "GALU":0.056393947804394884,
    "UAGP2UAG":0.07392095964572216,
    "ASNS2":0.04379763236050831,
    "SADT":0.03587065897660059,
    "ATPPRT":0.012267918524630618,
    "GLUPRT":0.03256247659795168,
    "ANPRT":0.005614497641129207,
    "GMPS":0.011775428177995307,
    "ARGSS":0.032738847755240386,
    "TYRTRS":0.03053508939984121,
    "NNAT":0.004158865335479806,
    "ALATRS":0.10496145960218263,
    "NNDPR":0.0041588653354798066,
    "ARGTRS":0.03273884775524522,
    "ASNTRS":0.04379763236050831,
    "CYSTRS":0.013345563372630214,
    "GLNTRS":0.023587375380107183,
    "GLYTRS":0.13650206668699486,
    "HISTRS":0.012267918524630623,
    "ILETRS":0.08815159618965082,
    "LEUTRS":0.08991701407330842,
    "LYSTRS":0.08409317993344939,
    "METTRS":0.022525095603970383,
    "PHETRS":0.03392228264453656,
    "PROTRS":0.04099044723222983,
    "SERTRS":0.08046759126956061,
    "THRTRS":0.058583642462220115,
    "TRPTRS":0.00561449764112921,
    "VALTRS":0.08424401761404464,
    "PRATPP":0.012267918524630618,
    "ASPTRS":0.05868447631391403,
    "GLUTRS":0.07000283903438392,
    "ORPT":-0.034529134753651526,
    "CDGS":0.017243578149038877,
    "PGLS":0.0004744739891348474,
    "G3PCT":0.10289718267333596,
    "ALLAS":0.0003909837295629317,
    "ATAS":0.0005300722184418847,
    "PPAna":0.0007587699992852038,

   

}

#load fba
object = FBA(model)

#calcualte min for ethanol, we already know the max
#change the objective function
#this will be updated to each
objective = "EXCH_etoh_e"

#note that for some reason the "R_" gets dropped
#results = object.run("BIOMASS")
results = object.run(objective,"max", fixed_rates)

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

#report when finished and how much time things took
end_time = datetime.now()

print("ending time: ",end_time)

elapsed = end_time - start_time

print("elapsed time: ",elapsed)