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
output=open('FBA_results_ctherm_AVM052_at_min_ppi.txt','w',buffering=1)
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
    "PPDK":0.0,
    "GLGC":0.0,
    "BIOMASS":0.190249249,

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

    #set PPi production to explore solution space around min and max production

    #min production
    "NA_biomass":0.190249249,
    "PPA":3.410960409283,
    "NADS2":0.003526242025743043,
    "GALU":0.047815616211101586,
    "UAGP2UAG":0.06267651714388461,
    "ASNS2":0.03713538174637745,
    "SADT":0.030414215170939077,
    "ATPPRT":0.010401791446069092,
    "GLUPRT":0.027609254973163973,
    "ANPRT":0.00476045169522605,
    "GMPS":0.009984215973195338,
    "ARGSS":0.027758797537736427,
    "TYRTRS":0.0258902625646339,
    "NNAT":0.003526242025743043,
    "ALATRS":0.08899531004097389,
    "NNDPR":0.003526242025743043,
    "ARGTRS":0.027758797537736433,
    "ASNTRS":0.03713538174637744,
    "CYSTRS":0.011315510993465573,
    "GLNTRS":0.019999395901710775,
    "GLYTRS":0.11573813657017955,
    "HISTRS":0.010401791446069083,
    "ILETRS":0.07474246893324996,
    "LEUTRS":0.07623934133292379,
    "LYSTRS":0.07130139623509109,
    "METTRS":0.0190987041774735,
    "PHETRS":0.028762214937656027,
    "PROTRS":0.0347552099025366,
    "SERTRS":0.06822731181928032,
    "THRTRS":0.04967222677747921,
    "TRPTRS":0.004760451695226046,
    "VALTRS":0.07142928933224614,
    "PRATPP":0.010401791446069092,
    "ASPTRS":0.0497577223482167,
    "GLUTRS":0.05935439910254293,
    "ORPT":-0.4259394575510669,
    "CDGS":0.014620581586871125,
    "PGLS":0.00040229966246192473,
    "G3PCT":0.0872450393608538,
    "ALLAS":0.0003315094737186333,
    "ATAS":0.00044944060041833143,
    "PPAna":0.0006433501553063329,

    #max production
    #"NA_biomass":0.190249249,
    #"PPA":4.199007798823951,
    #"NADS2":0.0035262420257237297,
    #"GALU":0.04781561621109631,
    #"UAGP2UAG":0.06267651714388459,
    #"ASNS2":0.037135381746754216,
    #"SADT":0.030414215171349533,
    #"ATPPRT":0.010401791446174624,
    #"GLUPRT":0.02760925497323035,
    #"ANPRT":0.004760451695274347,
    #"GMPS":0.009984215973113433,
    #"ARGSS":0.0277587975381266,
    #"DUTPDP":0.005278013347377259,
    #"TYRTRS":0.025890262564864194,
    #"NNAT":0.0035262420257237297,
    #"ALATRS":0.08899531004176552,
    #"NNDPR":0.0035262420257237297,
    #"ARGTRS":0.02775879753798335,
    #"ASNTRS":0.03713538174670776,
    #"CYSTRS":0.011315510993580375,
    #"GLNTRS":0.01999939590188867,
    #"GLYTRS":0.11573813657120904,
    #"HISTRS":0.010401791446161608,
    #"ILETRS":0.07474246893391479,
    #"LEUTRS":0.07623934133360194,
    #"LYSTRS":0.07130139623572532,
    #"METTRS":0.01909870417764338,
    #"PHETRS":0.028762214937911867,
    #"PROTRS":0.034755209902845745,
    #"SERTRS":0.0682273118198872,
    #"THRTRS":0.04967222677792105,
    #"TRPTRS":0.0047604516952683895,
    #"VALTRS":0.0714292893328815,
    #"PRATPP":0.010401791446174624,
    #"ASPTRS":0.04975772234865929,
    #"GLUTRS":0.05935439910307088,
    #"ORPT":-0.02927675610166784,
    #"CDGS":0.014620581586870993,
    #"PGLS":0.00040229966246192473,
    #"G3PCT":0.08724503936085361,
    #"ALLAS":0.0003315094737186301,
    #"ATAS":0.00044944060041833143,
    #"PPAna":0.0006433501553063329,

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