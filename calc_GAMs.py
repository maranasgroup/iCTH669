#!/usr/bin/python
#! python 3.9
#try to specify that we will use python version 3.9
__author__ = "Wheaton Schroeder"
#latest version: 01/05/2022
#run pFBA, with the requirement of forcing certain ratios between carbon-based fermentation products that are seen in literatures

#imports, again, these are used previously, not sure of their necessity
import cobra
from fba import FBA
from datetime import datetime
from cobra import Model, Reaction, Metabolite
import re
import os
import warnings
import copy

#get the current time and date for tracking solution time
start_time = datetime.now()
print("Starting time: ",start_time)

#get the current directory to use for importing things
curr_dir = os.getcwd()

#import the ctherm model
model = cobra.io.read_sbml_model(curr_dir + "/iCTH669_no_GAM.sbml")

#write a file to put the FBA results
output=open('maintenance_calc_results.txt','w',buffering=1)
output.write("model: "+model.name+"\n\n")

object = FBA(model)

#note that for some reason the "R_" gets dropped
#with new way of putting things together, have to pass the objective for the first step of pfba

#maximize maintenance
objective = "ATPM"

#fixed rates dictionary, if we want it
#these make fixed versions of the strains, rather than knockouts so same list of reactions still
fixed_rates_LL1004A = {

    #LL1004
    "BIOMASS":0.4016,
    "EXCH_cellb_e":-4.3059,

}

fixed_rates_LL1004B = {

    #LL1004
    "BIOMASS":0.4049,
    "EXCH_cellb_e":-4.4702,

}

fixed_rates_LL1004C = {

    #LL1004
    "BIOMASS":0.4014,
    "EXCH_cellb_e":-4.3093,

}

fixed_rates_AVM008A = {
        
    #AVM008 KO
    "PPA":0.0,
    "R_PPAna":0.0,
    "BIOMASS":0.3566,
    "EXCH_cellb_e":-3.9725,

}
fixed_rates_AVM008B = {
        
    #AVM008 KO
    "PPA":0.0,
    "R_PPAna":0.0,
    "BIOMASS":0.4009,
    "EXCH_cellb_e":-4.3776,

}

fixed_rates_AVM008C = {
        
    #AVM008 KO
    "PPA":0.0,
    "R_PPAna":0.0,
    "BIOMASS":0.4278,
    "EXCH_cellb_e":-4.4545,

}

fixed_rates_AVM051A = {

    #AVM051 KO
    "GLGC":0.0,
    "BIOMASS":0.3681,
    "EXCH_cellb_e":-4.9595,

}

fixed_rates_AVM051B = {

    #AVM051 KO
    "GLGC":0.0,
    "BIOMASS":0.3578,
    "EXCH_cellb_e":-4.7033,

}

fixed_rates_AVM051C = {

    #AVM051 KO
    "GLGC":0.0,
    "BIOMASS":0.3568,
    "EXCH_cellb_e":-4.7120,

}

fixed_rates_AVM003A = {

    #AVM003 KO
    "PPDK":0.0,
    "BIOMASS":0.3929,
    "EXCH_cellb_e":-5.0077,

}

fixed_rates_AVM003B = {

    #AVM003 KO
    "PPDK":0.0,
    "BIOMASS":0.3893,
    "EXCH_cellb_e":-4.8600,

}

fixed_rates_AVM003C = {

    #AVM003 KO
    "PPDK":0.0,
    "BIOMASS":0.4081,
    "EXCH_cellb_e":-4.9136,

}

fixed_rates_AVM059A = {

    #AVM059 KO
    "PPAKr":0.0,
    "R00925":0.0,
    "R_PACPT":0.0,
    "R_ACADT":0.0,
    "R_ACADCOAT":0.0,
    "BIOMASS":0.3912,
    "EXCH_cellb_e":-4.0469,

}

fixed_rates_AVM059B = {

    #AVM059 KO
    "PPAKr":0.0,
    "R00925":0.0,
    "R_PACPT":0.0,
    "R_ACADT":0.0,
    "R_ACADCOAT":0.0,
    "BIOMASS":0.3836,
    "EXCH_cellb_e":-3.9310,

}

fixed_rates_AVM059C = {

    #AVM059 KO
    "PPAKr":0.0,
    "R00925":0.0,
    "R_PACPT":0.0,
    "R_ACADT":0.0,
    "R_ACADCOAT":0.0,
    "BIOMASS":0.3848,
    "EXCH_cellb_e":-3.7157,

}

fixed_rates_AVM053A = {
        
    #AVM053 KOs
    "PPA":0.0,
    "R_PPAna":0.0,
    "GLGC":0.0,
    "BIOMASS":0.3542,
    "EXCH_cellb_e":-4.7994,

}

fixed_rates_AVM053B = {
        
    #AVM053 KOs
    "PPA":0.0,
    "R_PPAna":0.0,
    "GLGC":0.0,
    "BIOMASS":0.3611,
    "EXCH_cellb_e":-4.8531,

}

fixed_rates_AVM053C = {
        
    #AVM053 KOs
    "PPA":0.0,
    "R_PPAna":0.0,
    "GLGC":0.0,
    "BIOMASS":0.3243,
    "EXCH_cellb_e":-4.7275,

}

fixed_rates_AVM052A = {

    #AVM052 KOs
    "PPDK":0.0,
    "GLGC":0.0,
    "BIOMASS":0.4091,
    "EXCH_cellb_e":-5.7508,

}

fixed_rates_AVM052B = {

    #AVM052 KOs
    "PPDK":0.0,
    "GLGC":0.0,
    "BIOMASS":0.4048,
    "EXCH_cellb_e":-5.4947,

}

fixed_rates_AVM052C = {

    #AVM052 KOs
    "PPDK":0.0,
    "GLGC":0.0,
    "BIOMASS":0.3934,
    "EXCH_cellb_e":-5.3380,

}

fixed_rates_AVM060A = {

    #AVM060 KOs
    "PPAKr":0.0,
    "R00925":0.0,
    "R_PACPT":0.0,
    "R_ACADT":0.0,
    "R_ACADCOAT":0.0,
    "GLGC":0.0,
    "BIOMASS":0.3768,
    "EXCH_cellb_e":-4.8848,

}

fixed_rates_AVM060B = {

    #AVM060 KOs
    "PPAKr":0.0,
    "R00925":0.0,
    "R_PACPT":0.0,
    "R_ACADT":0.0,
    "R_ACADCOAT":0.0,
    "GLGC":0.0,
    "BIOMASS":0.3709,
    "EXCH_cellb_e":-4.8000,

}

fixed_rates_AVM060C = {

    #AVM060 KOs
    "PPAKr":0.0,
    "R00925":0.0,
    "R_PACPT":0.0,
    "R_ACADT":0.0,
    "R_ACADCOAT":0.0,
    "GLGC":0.0,
    "BIOMASS":0.2978,
    "EXCH_cellb_e":-4.2257,

}

fixed_rates_AVM056A = {

    #AVM056 KOs
    "PPA":0.0,
    "R_PPAna":0.0,
    "PPDK":0.0,
    "GLGC":0.0,
    "BIOMASS":0.3774,
    "EXCH_cellb_e":-5.2798,

}

fixed_rates_AVM056B = {

    #AVM056 KOs
    "PPA":0.0,
    "R_PPAna":0.0,
    "PPDK":0.0,
    "GLGC":0.0,
    "BIOMASS":0.3877,
    "EXCH_cellb_e":-5.1659,

}

fixed_rates_AVM056C = {

    #AVM056 KOs
    "PPA":0.0,
    "R_PPAna":0.0,
    "PPDK":0.0,
    "GLGC":0.0,
    "BIOMASS":0.3810,
    "EXCH_cellb_e":-4.9511,

}

fixed_rates_AVM061A = {

    #AVM061 KOs
    "PPA":0.0,
    "R_PPAna":0.0,
    "PPDK":0.0,
    "GLGC":0.0,
    "PPAKr":0.0,
    "R00925":0.0,
    "R_PACPT":0.0,
    "R_ACADT":0.0,
    "R_ACADCOAT":0.0,
    "BIOMASS":0.2437,
    "EXCH_cellb_e":-3.9910,

}

fixed_rates_AVM061B = {

    #AVM061 KOs
    "PPA":0.0,
    "R_PPAna":0.0,
    "PPDK":0.0,
    "GLGC":0.0,
    "PPAKr":0.0,
    "R00925":0.0,
    "R_PACPT":0.0,
    "R_ACADT":0.0,
    "R_ACADCOAT":0.0,
    "BIOMASS":0.2486,
    "EXCH_cellb_e":-3.7306,

}

fixed_rates_AVM061C = {

    #AVM061 KOs
    "PPA":0.0,
    "R_PPAna":0.0,
    "PPDK":0.0,
    "GLGC":0.0,
    "PPAKr":0.0,
    "R00925":0.0,
    "R_PACPT":0.0,
    "R_ACADT":0.0,
    "R_ACADCOAT":0.0,
    "BIOMASS":0.2544,
    "EXCH_cellb_e":-3.6527,

}

#solve PFBA for each batch point to get max ATP hydrolysis rates

#establish the headings
output.write("strain&replicate\tcellobiose uptake (mmol/gDW*h)\tgrowth rate (h^-1)\tATPM flux (mmol/gDW*h)\n")

#get max ATP hydrolysis for LL1004A
results = object.run(objective,"max",fixed_rates_LL1004A) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("LL1004A\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for LL1004A
results = object.run(objective,"max",fixed_rates_LL1004B) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("LL1004B\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for LL1004A
results = object.run(objective,"max",fixed_rates_LL1004C) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("LL1004C\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM008A
results = object.run(objective,"max",fixed_rates_AVM008A) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM008A\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM008B
results = object.run(objective,"max",fixed_rates_AVM008B) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM008B\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM008C
results = object.run(objective,"max",fixed_rates_AVM008C) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM008C\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM051A
results = object.run(objective,"max",fixed_rates_AVM051A) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM051A\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM051B
results = object.run(objective,"max",fixed_rates_AVM051B) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM051B\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM051C
results = object.run(objective,"max",fixed_rates_AVM051C) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM051C\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM003A
results = object.run(objective,"max",fixed_rates_AVM003A) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM003A\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM003B
results = object.run(objective,"max",fixed_rates_AVM003B) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM003B\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM003C
results = object.run(objective,"max",fixed_rates_AVM003C) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM003C\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM059A
results = object.run(objective,"max",fixed_rates_AVM059A) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM059A\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM059B
results = object.run(objective,"max",fixed_rates_AVM059B) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM059B\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM059C
results = object.run(objective,"max",fixed_rates_AVM059C) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM059C\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM053A
results = object.run(objective,"max",fixed_rates_AVM053A) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM053A\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM053B
results = object.run(objective,"max",fixed_rates_AVM053B) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM053B\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM053C
results = object.run(objective,"max",fixed_rates_AVM053C) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM053C\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM052A
results = object.run(objective,"max",fixed_rates_AVM052A) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM052A\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM052B
results = object.run(objective,"max",fixed_rates_AVM052B) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM052B\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM052C
results = object.run(objective,"max",fixed_rates_AVM052C) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM052C\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM060A
results = object.run(objective,"max",fixed_rates_AVM060A) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM060A\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM060B
results = object.run(objective,"max",fixed_rates_AVM060B) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM060B\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM060C
results = object.run(objective,"max",fixed_rates_AVM060C) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM060C\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM056A
results = object.run(objective,"max",fixed_rates_AVM056A) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM056A\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM056B
results = object.run(objective,"max",fixed_rates_AVM056B) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM056B\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM056C
results = object.run(objective,"max",fixed_rates_AVM056C) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM056C\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM061A
results = object.run(objective,"max",fixed_rates_AVM061A) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM061A\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM061B
results = object.run(objective,"max",fixed_rates_AVM061B) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM061B\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

#get max ATP hydrolysis for AVM061C
results = object.run(objective,"max",fixed_rates_AVM061C) 

#need to write results to the file for each solution
cellobiose = results['EXCH_cellb_e']['flux']
biomass = results['BIOMASS']['flux']
ATPM = results['ATPM']['flux']

output.write("AVM061C\t"+str(cellobiose)+"\t"+str(biomass)+"\t"+str(ATPM)+"\n")

print("done!\n\n")