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

#this model's biomass weight is not 1, this is important for yield calculations
biomass_weight = 1

#fixed rates dictionary, if we want it
#these make fixed versions of the strains, rather than knockouts so same list of reactions still
fixed_rates = {

    #LL1004
    #"BIOMASS_CELLOBIOSE":0.281979407,
        
    #AVM008 KO
    #"PPA":0.0,
    #"PPAna":0.0,
    #"BIOMASS_CELLOBIOSE":0.258388141,

    #AVM051 KO
    #"GLGC":0.0,
    #"BIOMASS_CELLOBIOSE":0.214335986,

    #AVM003 KO
    #"PPDK":0.0,
    #"BIOMASS_CELLOBIOSE":0.2243808,

    #AVM059 KO
    #"PPAKr":0.0,
    #"ACS":0.0,
    #"PACPT":0.0,
    #"ACADT":0.0,
    #"ACADCOAT":0.0,
    #"BIOMASS_CELLOBIOSE":0.258526183,
        
    #AVM053 KOs
    #"PPA":0.0,
    #"PPAna":0.0,
    #"GLGC":0.0,
    #"BIOMASS_CELLOBIOSE":0.207158858,

    #AVM052 KOs
    #"PPDK":0.0,
    #"GLGC":0.0,
    #"BIOMASS_CELLOBIOSE":0.190249249,

    #AVM060 KOs
    "PPAKr":0.0,
    "ACS":0.0,
    "PACPT":0.0,
    "ACADT":0.0,
    "ACADCOAT":0.0,
    "GLGC":0.0,
    #"BIOMASS_CELLOBIOSE":0.198452575,

    #AVM056 KOs
    #"PPA":0.0,
    #"PPAna":0.0,
    #"PPDK":0.0,
    #"GLGC":0.0,
    #"BIOMASS_CELLOBIOSE":0.207269625,

    #AVM061 KOs
    #"PPA":0.0,
    #"PPAna":0.0,
    #"PPDK":0.0,
    #"GLGC":0.0,
    #"PPAKr":0.0,
    #"ACS":0.0,
    #"PACPT":0.0,
    #"ACADT":0.0,
    #"ACADCOAT":0.0,
    #"BIOMASS_CELLOBIOSE":0.176268057,

    #ensure overflow metabolism by requiring full cellbiose uptake
    "EXCH_cellb_e":-2.92144383597262,

}

#require
#biomass yield statistics for this strain
in_vivo_yield = 0.19845
in_vivo_sd = 0.01467

#set biomass growth bounds to within 1.96 stdev of the maximum (95% confidence interval assuming a normal distribution)
#need to divide by biomass weight to have the yield calculations come out correctly
model.reactions[model.reactions.index("BIOMASS")].lower_bound = (in_vivo_yield - 1.96 * in_vivo_sd) / biomass_weight
model.reactions[model.reactions.index("BIOMASS")].upper_bound = (in_vivo_yield + 1.96 * in_vivo_sd)  / biomass_weight

#produce a list of reactions involving ppi

object = FBA(model)

#this is where the list is written to
output_prod=open('ppi_producing_rxns_AVM060.txt','w',buffering=1)
output_con=open('ppi_consuming_rxns_AVM060.txt','w',buffering=1)

for rxn in model.reactions:

  #check if reaction has ppi in its products or reactants
  participant_species = rxn.reactants + rxn.products

  participant_ids = [ ]

  #clean up participant species to just ids
  for met in participant_species:

    if(met.id == 'ppi_c'):

      ppi_stoich = rxn.get_coefficient('ppi_c') 

      #line for debugging purposes
      # print('found ppi in reaction '+rxn.id+' with stoichiometry of '+str(ppi_stoich)+'\n')

      #if coefficient is greater than zero and upper bound is greater than zero
      #or if coefficient is less than zero and lower bound is less than zero
      if (ppi_stoich > 0 and rxn.upper_bound > 0) or (ppi_stoich < 0 and rxn.lower_bound < 0):

        #then we have a potential ppi-producing reaction

        #minimize flux through this reaction
        results = object.run(rxn.id,"min", fixed_rates)

        #ppi production is coefficient times flux
        ppi_prod_min = ppi_stoich * results['objective']

        #maximize flux through this reaction
        results = object.run(rxn.id,"max", fixed_rates)

        #ppi production is coefficient times flux
        ppi_prod_max = ppi_stoich * results['objective']

        #determine which is larger, this weeds out the problem of switching signs
        #also weeds out issues of switching between consumer and producer states so that
        #our results file is reaction\tmin production (or max consumption)\tmax production
        if(ppi_prod_max > ppi_prod_min):

          #make formatted strings, record the results
          formatted_string_max = "{:.8f}".format(ppi_prod_max)
          formatted_string_min = "{:.8f}".format(ppi_prod_min)

          #record reaction ID as well as min and max
          output_prod.write(rxn.id + "\t" + formatted_string_min+"\t" + formatted_string_max + "\t" + str(ppi_stoich) + "\n")

        else:

          #make formatted strings, record the results
          formatted_string_max = "{:.8f}".format(ppi_prod_min)
          formatted_string_min = "{:.8f}".format(ppi_prod_max)

          #record reaction ID as well as min and max
          output_prod.write(rxn.id + "\t" + formatted_string_max + "\t" + formatted_string_min + "\t" + str(ppi_stoich) + "\n")

      #if we have a negative coefficient and positive upper bound or a positive coefficient and a negative lower bound, then
      #we have potential consumer reaction
      #note that we can have reactions that are both potential consumers and produceres
      if (ppi_stoich < 0 and rxn.upper_bound > 0) or (ppi_stoich > 0 and rxn.lower_bound < 0):

        #we have a consuming or potential consuming reaction

        #minimize flux through this reaction
        results = object.run(rxn.id,"min", fixed_rates)

        #ppi production is coefficient times flux
        ppi_prod_min = ppi_stoich * results['objective']

        #maximize flux through this reaction
        results = object.run(rxn.id,"max", fixed_rates)

        #ppi production is coefficient times flux
        ppi_prod_max = ppi_stoich * results['objective']

        #determine which is larger, this weeds out the problem of switching signs
        #also weeds out issues of switching between consumer and producer states so that
        #our results file is reaction\tmin production (or max consumption)\tmax production
        if(ppi_prod_max > ppi_prod_min):

          #make formatted strings, record the results
          formatted_string_max = "{:.8f}".format(ppi_prod_max)
          formatted_string_min = "{:.8f}".format(ppi_prod_min)

          #record reaction ID as well as min and max
          output_con.write(rxn.id + "\t" + formatted_string_min+"\t" + formatted_string_max + "\t" + str(ppi_stoich) + "\n")

        else:

          #make formatted strings, record the results
          formatted_string_max = "{:.8f}".format(ppi_prod_min)
          formatted_string_min = "{:.8f}".format(ppi_prod_max)

          #record reaction ID as well as min and max
          output_con.write(rxn.id + "\t" + formatted_string_max + "\t" + formatted_string_min + "\t" + str(ppi_stoich) + "\n")

#report when finished and how much time things took
end_time = datetime.now()

print("ending time: ",end_time)

elapsed = end_time - start_time

print("elapsed time: ",elapsed)