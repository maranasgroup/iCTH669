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
output=open('FBA_results_ctherm_AVM056_at_min_ppi.txt','w',buffering=1)
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
    "PPA":0.0,
    "PPAna":0.0,
    "PPDK":0.0,
    "GLGC":0.0,
    "BIOMASS":0.207269625,

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

    #exporing space around max and min PPi production

    #max PPi production
    #"NA_biomass":0.207269625,
    #"ADPT":0.03053421060528914,
    #"NADS2":0.003841712207282341,
    #"GALU":0.05209337168628281,
    #"UAGP2UAG":0.06828378179138449,
    #"NTPP2":4.022107141378062,
    #"ASNS2":0.04045764537480781,
    #"SADT":0.03313517927818824,
    #"ATPPRT":0.011332372788297202,
    #"GLUPRT":0.030079277341818773,
    #"ANPRT":0.005186338673553198,
    #"GMPS":0.01087743952496598,
    #"ARGSS":0.030242198517726138,
    #"DUTPDP":0.005750203236049981,
    #"TYRTRS":0.028206497745092932,
    #"NNAT":0.003841712207282341,
    #"ALATRS":0.09695714772022325,
    #"NNDPR":0.003841712207282342,
    #"ARGTRS":0.030242198517685278,
    #"ASNTRS":0.04045764537448876,
    #"CYSTRS":0.012327836943485833,
    #"GLNTRS":0.02178861315123949,
    #"GLYTRS":0.12609248284130678,
    #"HISTRS":0.011332372788264277,
    #"ILETRS":0.0814291966396751,
    #"LEUTRS":0.08305998458014839,
    #"LYSTRS":0.0776802733114929,
    #"METTRS":0.02080734233464197,
    #"PHETRS":0.03133538521509949,
    #"PROTRS":0.037864534872861844,
    #"SERTRS":0.07433117034560653,
    #"THRTRS":0.05411608125236191,
    #"TRPTRS":0.0051863386735381285,
    #"VALTRS":0.07781960818102196,
    #"PRATPP":0.011332372788297204,
    #"ASPTRS":0.05420922556162497,
    #"GLUTRS":0.06466445522781805,
    #"ORPT":-0.03189595906570895,
    #"CDGS":0.015928590933847225,
    #"PGLS":0.00043829082434963687,
    #"G3PCT":0.09505029158534947,
    #"ALLAS":0.00036116749297448016,
    #"ATAS":0.0004896491586564728,

    #min PPi production
    "NA_biomass":0.207269625,
    "ADK2":0.07714933232763185,
    "ADPT":0.03053421060541647,
    "NADS2":0.0038417122074156733,
    "GALU":0.05209337168641573,
    "UAGP2UAG":0.06828378179153169,
    "NTPP2":3.29973982834812,
    "ASNS2":0.04045764537448188,
    "SADT":0.033135179278157616,
    "ATPPRT":0.011332372788262341,
    "GLUPRT":0.030079277342202684,
    "ANPRT":0.005186338673537243,
    "GPAR":0.07714933232763185,
    "GMPS":0.010877439525048103,
    "ARGSS":0.030242198517680133,
    "DUTPDP":0.16938997524920296,
    "TYRTRS":0.028206497745088127,
    "NNAT":0.0038417122074156733,
    "ALATRS":0.09695714772020676,
    "NNDPR":0.0038417122074156746,
    "ARGTRS":0.030242198517680133,
    "ASNTRS":0.04045764537448188,
    "CYSTRS":0.01232783694351923,
    "GLNTRS":0.02178861315123579,
    "GLYTRS":0.12609248284128532,
    "HISTRS":0.011332372788262348,
    "ILETRS":0.08142919663966125,
    "LEUTRS":0.08305998458013426,
    "LYSTRS":0.07768027331147968,
    "METTRS":0.02080734233463843,
    "PHETRS":0.03133538521509416,
    "PROTRS":0.037864534872855404,
    "SERTRS":0.07433117034559389,
    "THRTRS":0.054116081252352705,
    "TRPTRS":0.005186338673537246,
    "VALTRS":0.07781960818100872,
    "PRATPP":0.011332372788262343,
    "ASPTRS":0.054209225561615754,
    "GLUTRS":0.06466445522780705,
    "ORPT":-0.19553573107918965,
    "CDGS":0.015928590933846715,
    "PGLS":0.0004382908243496265,
    "G3PCT":0.09505029158582118,
    "ALLAS":0.0003611674929744681,
    "ATAS":0.0004896491586596359,

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