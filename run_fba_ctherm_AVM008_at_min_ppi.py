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
output=open('FBA_results_ctherm_AVM008_at_min_ppi.txt','w',buffering=1)
output.write("FBA results\n")
output.write("model: "+model.name+"\n\n")

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

    #fix PPi-producing reactions to test effect on ETOH production of max/min PPi production

    #max PPI production
    #"NA_biomass":0.25838814100000007,
    #"NADS2":0.004789186430217784,
    #"GALU":0.06494106152058521,
    #"UAGP2UAG":0.0851244818799104,
    #"ASNS2":0.05043563801357655,
    #"SADT":0.3015242676303965,
    #"GLGC":13.379914582325087,
    #"ATPPRT":0.014127254477881275,
    #"GLUPRT":0.037497672679043845,
    #"ANPRT":0.006465435581632871,
    #"GMPS":0.01356012188367467,
    #"DMATT":7.763385966323661e-14,
    #"ARGSS":0.03770077479930478,
    #"TYRTRS":0.03516301299134235,
    #"NNAT":0.004789186430217784,
    #"ALATRS":0.12086950587417157,
    #"NNDPR":0.004789186430217785,
    #"ARGTRS":0.03770077479927909,
    #"ASNTRS":0.05043563801357655,
    #"CYSTRS":0.015368228076990238,
    #"GLNTRS":0.027162297645890985,
    #"GLYTRS":0.15719043364860238,
    #"HISTRS":0.014127254477943638,
    #"ILETRS":0.101511925556713,
    #"LEUTRS":0.10354491164577691,
    #"LYSTRS":0.0968384123512194,
    #"METTRS":0.02593901786178356,
    #"PHETRS":0.03906357206643807,
    #"PROTRS":0.04720299356828888,
    #"SERTRS":0.09266332644856448,
    #"THRTRS":0.06746262812611624,
    #"TRPTRS":0.006465435581659507,
    #"VALTRS":0.09701211111636472,
    #"PRATPP":0.014127254477881275,
    #"ASPTRS":0.0675787444403884,
    #"GLUTRS":0.08061252764531583,
    #"ORPT":-0.03976239918618161,
    #"CDGS":0.019857029220495977,
    #"PGLS":0.0005463856622554348,
    #"G3PCT":0.1184923654122954,
    #"ALLAS":0.0004502415493794927,
    #"ATAS":0.0006104104055202681,

    #minimum PPi production
    "NA_biomass":0.25838814100000007,
    "PPDK":3.604740884054536,
    "NADS2":0.004789186430627402,
    "GALU":0.06494106152059478,
    "UAGP2UAG":0.08512448187988886,
    "ASNS2":0.050435638012835377,
    "SADT":0.04130724593818422,
    "ATPPRT":0.014127254477736028,
    "GLUPRT":0.03749767268142462,
    "ANPRT":0.006465435581564493,
    "GMPS":0.013560121883353399,
    "ARGSS":0.03770077479872505,
    "TYRTRS":0.035163012990825616,
    "NNAT":0.004789186430627402,
    "ALATRS":0.12086950587237379,
    "NNDPR":0.004789186430627403,
    "ARGTRS":0.03770077479872506,
    "ASNTRS":0.05043563801283538,
    "CYSTRS":0.015368228076781827,
    "GLNTRS":0.027162297645491825,
    "GLYTRS":0.1571904336462924,
    "HISTRS":0.01412725447773603,
    "ILETRS":0.10151192555522123,
    "LEUTRS":0.10354491164425528,
    "LYSTRS":0.09683841234979632,
    "METTRS":0.025939017861402375,
    "PHETRS":0.03906357206586401,
    "PROTRS":0.04720299356759522,
    "SERTRS":0.09266332644720275,
    "THRTRS":0.06746262812512484,
    "TRPTRS":0.006465435581564494,
    "VALTRS":0.09701211111493908,
    "PRATPP":0.01412725447773603,
    "ASPTRS":0.0675787444393953,
    "GLUTRS":0.08061252764413118,
    "ORPT":-0.03976239918620195,
    "CDGS":0.019857029220495977,
    "PGLS":0.0005463856622554348,
    "G3PCT":0.1184923654122954,
    "ALLAS":0.0004502415493794927,
    "ATAS":0.0006104104055202681,


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