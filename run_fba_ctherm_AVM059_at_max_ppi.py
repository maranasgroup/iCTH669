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
output=open('FBA_results_ctherm_AVM059_at_max_ppi.txt','w',buffering=1)
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

    #fix PPi production rates
    #min PPi
    #"NA_biomass":0.258526183,
    #"PPDK":3.604328488628198,
    #"NADS2":0.004791745018922831,
    #"GALU":0.06497575581414762,
    #"UAGP2UAG":0.08516995902014068,
    #"ASNS2":0.05046258288846552,
    #"SADT":0.041329314036225244,
    #"ATPPRT":0.014134801861488772,
    #"GLUPRT":0.03751770554122635,
    #"ANPRT":0.006468889693864918,
    #"GMPS":0.013567366280630213,
    #"ARGSS":0.03772091616558657,
    #"TYRTRS":0.035181798576755505,
    #"NNAT":0.00479174501892283,
    #"ALATRS":0.12093407953360871,
    #"NNDPR":0.004791745018922831,
    #"ARGTRS":0.03772091616558658,
    #"ASNTRS":0.05046258288846552,
    #"CYSTRS":0.015376438441724153,
    #"GLNTRS":0.027176808906987118,
    #"GLYTRS":0.15727441150107377,
    #"HISTRS":0.01413480186148879,
    #"ILETRS":0.10156615756886932,
    #"LEUTRS":0.10360022976604999,
    #"LYSTRS":0.09689014757274167,
    #"METTRS":0.025952875594501056,
    #"PHETRS":0.03908444149733063,
    #"PROTRS":0.047228211426259464,
    #"SERTRS":0.09271283116063492,
    #"THRTRS":0.06749866954734401,
    #"TRPTRS":0.006468889693864921,
    #"VALTRS":0.0970639391351962,
    #"PRATPP":0.014134801861488772,
    #"ASPTRS":0.06761484789591739,
    #"GLUTRS":0.08065559430526965,
    #"ORPT":-0.03978364196120765,
    #"CDGS":0.019867637695084046,
    #"PGLS":0.000546677564853198,
    #"G3PCT":0.11855566910356753,
    #"ALLAS":0.00045048208767865355,
    #"ATAS":0.0006107365128751674,

    #max PPi
    "NA_biomass":0.258526183,
    "NADS2":0.004791745018668957,
    "GALU":0.0649757558140891,
    "UAGP2UAG":0.08516995902014068,
    "ASNS2":0.05046258288840618,
    "SADT":0.3016853547945606,
    "GLGC":13.376823906783333,
    "ATPPRT":0.014134801861430093,
    "GLUPRT":0.037517705543142245,
    "ANPRT":0.006468889693818765,
    "GMPS":0.013567366280958039,
    "ARGSS":0.037720916165540075,
    "TYRTRS":0.035181798576714135,
    "NNAT":0.004791745018668956,
    "ALATRS":0.12093407953346652,
    "NNDPR":0.004791745018668957,
    "ARGTRS":0.037720916165542226,
    "ASNTRS":0.05046258288840619,
    "CYSTRS":0.015376438441660274,
    "GLNTRS":0.027176808906955164,
    "GLYTRS":0.15727441150088883,
    "HISTRS":0.01413480186147217,
    "ILETRS":0.1015661575687499,
    "LEUTRS":0.10360022976592818,
    "LYSTRS":0.09689014757262775,
    "METTRS":0.025952875594470542,
    "PHETRS":0.039084441497284676,
    "PROTRS":0.04722821142620394,
    "SERTRS":0.09271283116052591,
    "THRTRS":0.06749866954726465,
    "TRPTRS":0.006468889693857315,
    "VALTRS":0.09706393913508207,
    "PRATPP":0.014134801861430093,
    "ASPTRS":0.06761484789583788,
    "GLUTRS":0.08065559430517483,
    "ORPT":-0.03978364196099614,
    "CDGS":0.019867637695084046,
    "PGLS":0.000546677564853198,
    "G3PCT":0.11855566910356753,
    "ALLAS":0.00045048208767865355,
    "ATAS":0.0006107365128751674,
    "PPAna":0.0008742366177950243,
    

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