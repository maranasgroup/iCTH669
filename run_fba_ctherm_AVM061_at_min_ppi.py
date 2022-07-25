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
output=open('FBA_results_ctherm_AVM061_at_min_ppi.txt','w',buffering=1)
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
    "PPA":0.0,
    "PPAna":0.0,
    "PPDK":0.0,
    "GLGC":0.0,
    "PPAKr":0.0,
    "R00925":0.0,
    "PACPT":0.0,
    "ACADT":0.0,
    "ACADCOAT":0.0,
    "BIOMASS":0.176268057,

    #ensure overflow metabolism by requiring full cellbiose uptake
    "EXCH_cellb_e":-2.92144383597262,

    #explore the space around maximum and minimum total PPi production

    #min PPi
    "NA_biomass":0.176268057,
    "ADPT":0.025967171868264825,
    "NADS2":0.003267102675340904,
    "GALU":0.04430170320298302,
    "UAGP2UAG":0.058070494125733396,
    "NTPP2":3.342053149085639,
    "ASNS2":0.03440634652064881,
    "SADT":0.028179110517074148,
    "ATPPRT":0.009637376111365462,
    "GLUPRT":0.02558028352236485,
    "ANPRT":0.00441061173786737,
    "GMPS":0.00925048776546549,
    "ARGSS":0.025718836380968575,
    "DUTPDP":0.3223535830805868,
    "TYRTRS":0.023987617830164586,
    "NNAT":0.003267102675340904,
    "ALATRS":0.08245515010172227,
    "NNDPR":0.003267102675340905,
    "ARGTRS":0.02571883638096858,
    "ASNTRS":0.03440634652064867,
    "CYSTRS":0.010483947491326504,
    "GLNTRS":0.018529663981844663,
    "GLYTRS":0.10723267798037955,
    "HISTRS":0.009637376111365384,
    "ILETRS":0.0692497334076033,
    "LEUTRS":0.0706366024273461,
    "LYSTRS":0.0660615410668272,
    "METTRS":0.017695163025747414,
    "PHETRS":0.02664851382449856,
    "PROTRS":0.03220109068681392,
    "SERTRS":0.06321336747414752,
    "THRTRS":0.04602187365759101,
    "TRPTRS":0.004410611737867335,
    "VALTRS":0.06618003545173397,
    "PRATPP":0.009637376111365462,
    "ASPTRS":0.04610108626008595,
    "GLUTRS":0.054992514604920786,
    "ORPT":-0.34458868665115006,
    "CDGS":0.01354613236096191,
    "PGLS":0.00037273513670436025,
    "G3PCT":0.08083350474106721,
    "ALLAS":0.00030714723509616895,
    "ATAS":0.00041641174295858815,

    #max PPi
    #"NA_biomass":0.176268057,
    #"ADPT":0.025967171868384292,
    #"NADS2":0.0032671026753338366,
    #"GALU":0.04430170320324578,
    #"UAGP2UAG":0.05807049412573353,
    #"NTPP2":4.294443483135553,
    #"ASNS2":0.034406346520871454,
    #"SADT":0.02817911051702005,
    #"ATPPRT":0.009637376111430049,
    #"GLUPRT":0.025580283522249638,
    #"ANPRT":0.004410611737870065,
    #"GMPS":0.009250487765432974,
    #"ARGSS":0.025718836381088295,
    #"DUTPDP":0.004890138397141612,
    #"TYRTRS":0.023987617830164284,
    #"NNAT":0.0032671026753338366,
    #"ALATRS":0.08245515010172123,
    #"NNDPR":0.003267102675333837,
    #"ARGTRS":0.025718836380968252,
    #"ASNTRS":0.03440634652064822,
    #"CYSTRS":0.0104839474912617,
    #"GLNTRS":0.018529663981844424,
    #"GLYTRS":0.10723267798037818,
    #"HISTRS":0.009637376111365262,
    #"ILETRS":0.0692497334076024,
    #"LEUTRS":0.0706366024273452,
    #"LYSTRS":0.06606154106682635,
    #"METTRS":0.017695163025747185,
    #"PHETRS":0.026648513824498215,
    #"PROTRS":0.032201090686813504,
    #"SERTRS":0.0632133674741467,
    #"THRTRS":0.04602187365759041,
    #"TRPTRS":0.004410611737867279,
    #"VALTRS":0.06618003545173314,
    #"PRATPP":0.00963737611143005,
    #"ASPTRS":0.04610108626008536,
    #"GLUTRS":0.05499251460492007,
    #"ORPT":-0.02712524196763245,
    #"CDGS":0.013546132360962375,
    #"PGLS":0.00037273513670437055,
    #"G3PCT":0.08083350474106801,
    #"ALLAS":0.0003071472350961796,
    #"ATAS":0.0004164117429585893,

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