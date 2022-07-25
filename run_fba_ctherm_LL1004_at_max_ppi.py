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
output=open('FBA_results_ctherm_LL1004_at_max_ppi.txt','w',buffering=1)
output.write("FBA results\n")
output.write("model: "+model.name+"\n\n")

#fixed rates dictionary, if we want it
#these make fixed versions of the strains, rather than knockouts so same list of reactions still
fixed_rates = {

    #LL1004
    "BIOMASS":0.281979407,
        
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

    #min PPI production
    #"NA_biomass":0.281979407,
    #"PPDK":3.4151747024731094,
    #"NADS2":0.005226447098131165,
    #"GALU":0.07087028818992058,
    #"UAGP2UAG":0.09289648831705982,
    #"ASNS2":0.055040495447959685,
    #"SADT":0.04507866603074952,
    #"ATPPRT":0.015417096251981852,
    #"GLUPRT":0.04092127241412588,
    #"ANPRT":0.007055740577835336,
    #"GMPS":0.01479818351073537,
    #"ARGSS":0.04114291809227622,
    #"TYRTRS":0.038373454420573536,
    #"NNAT":0.005226447098131165,
    #"ALATRS":0.13190509230938,
    #"NNDPR":0.005226447098131167,
    #"ARGTRS":0.041142918092276215,
    #"ASNTRS":0.05504049544795967,
    #"CYSTRS":0.016771372799686782,
    #"GLNTRS":0.029642260489147552,
    #"GLYTRS":0.17154218105399507,
    #"HISTRS":0.015417096251981859,
    #"ILETRS":0.11078013279050561,
    #"LEUTRS":0.11299873388266918,
    #"LYSTRS":0.10567992007497087,
    #"METTRS":0.028307293231062677,
    #"PHETRS":0.04263014101110526,
    #"PROTRS":0.05151270520115377,
    #"SERTRS":0.10112364190202378,
    #"THRTRS":0.0736220780092712,
    #"TRPTRS":0.007055740577835339,
    #"VALTRS":0.10586947782557816,
    #"PRATPP":0.015417096251981852,
    #"ASPTRS":0.07374879593569875,
    #"GLUTRS":0.08797258517313024,
    #"ORPT":-0.04339277220708482,
    #"CDGS":0.021670008935809195,
    #"PGLS":0.0005962715798016818,
    #"G3PCT":0.12931091498114208,
    #"ALLAS":0.0004913493498944695,
    #"ATAS":0.0006661418883587028,

    #max PPI production
    "NA_biomass":0.281979407,
    "NADS2":0.005226447098375831,
    "GALU":0.07087028819023544,
    "UAGP2UAG":0.09289648831705982,
    "ASNS2":0.05504049544785842,
    "SADT":0.32905393373648306,
    "GLGC":13.00017341874987,
    "ATPPRT":0.01541709625186411,
    "GLUPRT":0.04092127258792833,
    "ANPRT":0.007055740577783355,
    "GMPS":0.014798183510881604,
    "ARGSS":0.041142918092191394,
    "TYRTRS":0.03837345442050292,
    "NNAT":0.005226447098375831,
    "ALATRS":0.13190509230913725,
    "NNDPR":0.005226447098375831,
    "ARGTRS":0.041142918092200505,
    "ASNTRS":0.05504049544785838,
    "CYSTRS":0.016771372799609094,
    "GLNTRS":0.029642260489093002,
    "GLYTRS":0.17154218105367938,
    "HISTRS":0.015417096251953486,
    "ILETRS":0.11078013279030173,
    "LEUTRS":0.11299873388246122,
    "LYSTRS":0.10567992007477638,
    "METTRS":0.02830729323101058,
    "PHETRS":0.04263014101102681,
    "PROTRS":0.05151270520105897,
    "SERTRS":0.10112364190183767,
    "THRTRS":0.0736220780091357,
    "TRPTRS":0.007055740577822354,
    "VALTRS":0.10586947782538333,
    "PRATPP":0.01541709625186411,
    "ASPTRS":0.07374879593556301,
    "GLUTRS":0.08797258517296833,
    "ORPT":-0.04339277220708071,
    "CDGS":0.021670008935809195,
    "PGLS":0.0005962715798016818,
    "G3PCT":0.12931091498114208,
    "ALLAS":0.0004913493498944695,
    "ATAS":0.0006661418883587028,
    "PPAna":0.0009535464462550262,

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