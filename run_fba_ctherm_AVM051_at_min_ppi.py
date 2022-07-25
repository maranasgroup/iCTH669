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
output=open('FBA_results_ctherm_AVM051_at_min_ppi.txt','w',buffering=1)
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
    "GLGC":0.0,
    "BIOMASS":0.214335986,

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
    #"NA_biomass":0.214335986,
    #"PPA":13.509006232189437,
    #"NADS2":0.003972686175832481,
    #"GALU":0.053869370316533605,
    #"UAGP2UAG":0.07061175364261442,
    #"SADT":0.8276145247260959,
    #"ASNS1":0.04183695180923425,
    #"ATPPRT":0.011718722872733945,
    #"GLUPRT":0.031104758197397494,
    #"ANPRT":0.005363154458017518,
    #"GMPS":0.011248279750254903,
    #"ARGSS":0.03127323378021174,
    #"TYRTRS":0.029168130669663738,
    #"NNAT":0.003972686175832481,
    #"ALATRS":0.10026266924802311,
    #"NNDPR":0.00397268617583248,
    #"ARGTRS":0.03127323378015674,
    #"ASNTRS":0.04183695180927955,
    #"CYSTRS":0.01274812499206833,
    #"GLNTRS":0.022531443685406525,
    #"GLYTRS":0.1303913037774216,
    #"HISTRS":0.011718722872744404,
    #"ILETRS":0.0842053298986753,
    #"LEUTRS":0.08589171564468702,
    #"LYSTRS":0.08032859601646221,
    #"METTRS":0.021516718792599736,
    #"PHETRS":0.03240369005745417,
    #"PROTRS":0.03915543542125191,
    #"SERTRS":0.07686531341335594,
    #"THRTRS":0.05596103931668146,
    #"TRPTRS":0.00536315445802583,
    #"VALTRS":0.08047268117435698,
    #"PRATPP":0.011718722872733947,
    #"ASPTRS":0.056057359157885185,
    #"GLUTRS":0.06686903481648122,
    #"ORPT":-0.03298337532946696,
    #"CDGS":0.016471638057900837,
    #"PGLS":0.0004532332993400896,
    #"G3PCT":0.09829080342397242,
    #"ALLAS":0.00037348063286086347,
    #"ATAS":0.0005063425729427983,
    #"PPAna":0.0007248022822988172,

    #minimum PPi
    "NA_biomass":0.214335986,
    "PPDK":3.6263579407171846,
    "NADS2":0.003972686175819302,
    "GALU":0.05386937031643186,
    "UAGP2UAG":0.07061175364261445,
    "ASNS2":0.04183695180891994,
    "SADT":0.034264843784373195,
    "ATPPRT":0.011718722872643495,
    "GLUPRT":0.031104758196973767,
    "ANPRT":0.005363154457979646,
    "GMPS":0.011248279750380025,
    "ARGSS":0.03127323377988794,
    "TYRTRS":0.029168130669413025,
    "NNAT":0.003972686175819302,
    "ALATRS":0.10026266924716132,
    "NNDPR":0.003972686175819302,
    "ARGTRS":0.03127323377988795,
    "ASNTRS":0.04183695180891995,
    "CYSTRS":0.012748124991958754,
    "GLNTRS":0.022531443685212857,
    "GLYTRS":0.13039130377630084,
    "HISTRS":0.011718722872643682,
    "ILETRS":0.08420532989795142,
    "LEUTRS":0.08589171564394867,
    "LYSTRS":0.08032859601577165,
    "METTRS":0.0215167187924148,
    "PHETRS":0.032403690057175666,
    "PROTRS":0.03915543542091537,
    "SERTRS":0.07686531341269527,
    "THRTRS":0.055961039316200466,
    "TRPTRS":0.005363154457979733,
    "VALTRS":0.0804726811736653,
    "PRATPP":0.011718722872643497,
    "ADPT2":1.1368683772161603e-13,
    "ASPTRS":0.05605735915740336,
    "GLUTRS":0.06686903481590646,
    "ORPT":-0.03298337532964979,
    "CDGS":0.016471638057900972,
    "PGLS":0.0004532332993400896,
    "G3PCT":0.09829080342397263,
    "ALLAS":0.00037348063286086656,
    "ATAS":0.0005063425729427983,

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