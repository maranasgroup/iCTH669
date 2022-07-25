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
model = cobra.io.read_sbml_model(curr_dir + "/iCTH669_wo_GLGC.sbml")

#write a file to put the FBA results
output=open('FBA_results_ctherm_AVM060_at_max_ppi.txt','w',buffering=1)
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
    "PPAKr":0.0,
    "R00925":0.0,
    "PACPT":0.0,
    "ACADT":0.0,
    "ACADCOAT":0.0,
    "GLGC":0.0,
    "BIOMASS":0.198452575,

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

    #fix PPi production to explore these solution spaces

    #fix PPi production to explore these solution spaces
    #min global PPi production
    #"NA_biomass":0.198452575,
    #"PPDK":3.670051110522536,
    #"NADS2":0.0036782894742566734,
    #"GALU":0.049877369882836385,
    #"UAGP2UAG":0.06537905555272673,
    #"SADT":0.03172564070030533,
    #"ASNS1":0.03873661614914758,
    #"ATPPRT":0.010850304576421124,
    #"GLUPRT":0.02879973388722347,
    #"ANPRT":0.004965716826985864,
    #"GMPS":0.010414723735580927,
    #"ARGSS":0.0289557245519926,
    #"TYRTRS":0.02700662052746239,
    #"NNAT":0.0036782894742566734,
    #"ALATRS":0.09283268414139505,
    #"NNDPR":0.0036782894742566734,
    #"ARGTRS":0.028955724551992617,
    #"ASNTRS":0.03873661614914759,
    #"CYSTRS":0.01180342264633093,
    #"GLNTRS":0.020861746556166176,
    #"GLYTRS":0.12072863019844982,
    #"HISTRS":0.010850304576421133,
    #"ILETRS":0.07796527712790582,
    #"LEUTRS":0.07952669292178212,
    #"LYSTRS":0.07437582938342709,
    #"METTRS":0.019922218053974417,
    #"PHETRS":0.03000240814133939,
    #"PROTRS":0.03625381406800659,
    #"SERTRS":0.07116919402853526,
    #"THRTRS":0.05181403533411428,
    #"TRPTRS":0.004965716826985868,
    #"VALTRS":0.07450923708195178,
    #"PRATPP":0.010850304576421124,
    #"ASPTRS":0.051903217374270186,
    #"GLUTRS":0.06191369165129968,
    #"ORPT":-0.0305391357209146,
    #"CDGS":0.015251004033724983,
    #"PGLS":0.0004196463552778649,
    #"G3PCT":0.09100694382839727,
    #"ALLAS":0.00034580377605778227,
    #"ATAS":0.0004688199555655746,

    #max global PPi production
    "NA_biomass":0.198452575,
    "PPA":14.34158481503696,
    "NADS2":0.003678289474344279,
    "GALU":0.04987736988289271,
    "UAGP2UAG":0.0653790555527267,
    "SADT":0.23158287026860408,
    "ASNS1":0.03873661614899784,
    "ATPPRT":0.01085030457631823,
    "GLUPRT":0.028799733886114398,
    "ANPRT":0.004965716826969161,
    "GMPS":0.010414723735547814,
    "ARGSS":0.02895572455202,
    "TYRTRS":0.02700662052741568,
    "NNAT":0.003678289474344279,
    "ALATRS":0.09283268414123451,
    "NNDPR":0.003678289474344279,
    "ARGTRS":0.028955724551942532,
    "ASNTRS":0.03873661614908059,
    "CYSTRS":0.011803422646310516,
    "GLNTRS":0.02086174655613009,
    "GLYTRS":0.12072863019824104,
    "HISTRS":0.010850304576402367,
    "ILETRS":0.07796527712777097,
    "LEUTRS":0.07952669292164456,
    "LYSTRS":0.07437582938329845,
    "METTRS":0.01992221805393996,
    "PHETRS":0.0300024081412875,
    "PROTRS":0.03625381406794388,
    "SERTRS":0.07116919402841217,
    "THRTRS":0.051814035334024656,
    "TRPTRS":0.004965716826977279,
    "VALTRS":0.07450923708182292,
    "PRATPP":0.01085030457631823,
    "ASPTRS":0.05190321737418042,
    "GLUTRS":0.0619136916511926,
    "ORPT":-0.030539135720918046,
    "CDGS":0.015251004033724926,
    "PGLS":0.0004196463552778649,
    "G3PCT":0.09100694382839719,
    "ALLAS":0.00034580377605778086,
    "ATAS":0.0004688199555655746,
    "PPAna":0.0006710906645796622,

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