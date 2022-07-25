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
output=open('FBA_results_ctherm_AVM053_at_min_ppi.txt','w',buffering=1)
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
    "PPA":0.0,
    "PPAna":0.0,
    "PPAna":0.0,
    "GLGC":0.0,
    "BIOMASS":0.207158858,

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

    #fix PPi production to investigate solution space
    #maximum PPi production
    #"NA_biomass":0.207158858,
    #"ADPT":0.030517892811537873,
    #"NADS2":0.003839659157222206,
    #"GALU":0.05206553245761825,
    #"UAGP2UAG":0.06824729024262566,
    #"NTPP2":5.374139268405041,
    #"ASNS2":0.04043602439654053,
    #"SADT":0.033117471500814136,
    #"ATPPRT":0.011326316652770277,
    #"GLUPRT":0.030063202669229683,
    #"ANPRT":0.005183567041279277,
    #"GMPS":0.010871626510599702,
    #"NTPP6":2.6934036673809976,
    #"ARGSS":0.03022603677868574,
    #"TYRTRS":0.02819142390518112,
    #"NNAT":0.003839659157222206,
    #"ALATRS":0.09690533283216986,
    #"NNDPR":0.003839659157222206,
    #"ARGTRS":0.030226036778530113,
    #"ASNTRS":0.040436024396404376,
    #"CYSTRS":0.01232124882179757,
    #"GLNTRS":0.021776969094273957,
    #"GLYTRS":0.1260250977331799,
    #"HISTRS":0.011326316652732139,
    #"ILETRS":0.08138568004695995,
    #"LEUTRS":0.08301559647773478,
    #"LYSTRS":0.07763876018161817,
    #"METTRS":0.020796222678803194,
    #"PHETRS":0.031318639265830076,
    #"PROTRS":0.037844299679461846,
    #"SERTRS":0.07429144701049513,
    #"THRTRS":0.05408716106692009,
    #"TRPTRS":0.005183567041285169,
    #"VALTRS":0.07777802058917267,
    #"PRATPP":0.011326316652770277,
    #"ASPTRS":0.05418025559891482,
    #"GLUTRS":0.06462989788380116,
    #"ORPT":-0.03187891354021472,
    #"CDGS":0.01592007853251531,
    #"PGLS":0.00043805659726624686,
    #"G3PCT":0.09499949574129217,
    #"ALLAS":0.0003609744813853812,
    #"ATAS":0.0004893874851589868,

    #minimum PPi
    "NA_biomass":0.207158858,
    "PPDK":3.680831140393252,
    "NADS2":0.0038396591572593436,
    "GALU":0.052065532457676575,
    "UAGP2UAG":0.06824729024262564,
    "ASNS2":0.04043602439646735,
    "SADT":0.03311747150065231,
    "ATPPRT":0.011326316652749779,
    "GLUPRT":0.03006320267121191,
    "ANPRT":0.005183567041293239,
    "GMPS":0.010871626510549777,
    "ARGSS":0.030226036778577187,
    "TYRTRS":0.028191423905225034,
    "NNAT":0.0038396591572593436,
    "ALATRS":0.0969053328323208,
    "NNDPR":0.0038396591572593436,
    "ARGTRS":0.030226036778577197,
    "ASNTRS":0.04043602439646736,
    "CYSTRS":0.012321248821816762,
    "GLNTRS":0.021776969094307878,
    "GLYTRS":0.12602509773337622,
    "HISTRS":0.01132631665274978,
    "ILETRS":0.08138568004708673,
    "LEUTRS":0.08301559647786409,
    "LYSTRS":0.07763876018173911,
    "METTRS":0.020796222678835588,
    "PHETRS":0.031318639265878856,
    "PROTRS":0.03784429967952079,
    "SERTRS":0.07429144701061086,
    "THRTRS":0.05408716106700434,
    "TRPTRS":0.005183567041293243,
    "VALTRS":0.07777802058929383,
    "PRATPP":0.011326316652749779,
    "ASPTRS":0.05418025559899921,
    "GLUTRS":0.06462989788390183,
    "ORPT":-0.031878913540140275,
    "CDGS":0.01592007853251528,
    "PGLS":0.00043805659726624686,
    "G3PCT":0.09499949574129213,
    "ALLAS":0.0003609744813853804,
    "ATAS":0.0004893874851589868,

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