#!/usr/bin/python
#! python 3.9
#try to specify that we will use python version 3.9
__author__ = "Wheaton Schroeder"
#latest version: 12/08/2021

#written to run the stand-alone TFP on a selected model for debugging

import cobra
from cobra import Model, Reaction, Metabolite
from stand_alone_TFP import stand_alone_TFP
import re
from datetime import datetime
import os

#get the current time and date for tracking solution time
start_time = datetime.now()
print("Starting time: ",start_time)

#get the current directory to use for importing things
curr_dir = os.getcwd()

#import the tsacch model
model = cobra.io.read_sbml_model(curr_dir + "/iCTH775.sbml")

#before initializing the stand-alone TFP, need to identify all exchange reactions
#string that identifies an exchange is an identifier beginning with "R_EXCH"
#create a list for storing reaction ids for exchange reactions
ex_rxns = list()
off_rxns = list()

#check each reaction for the string tag indicating exchange
for rxn in model.reactions:

    #check if the reaction id has the exchange tag
    if bool(re.search('^R_EXCH',rxn.id)):

        #if so add to the list of exchange reactions
        ex_rxns.extend([rxn.id])

    #figure out which reactions are supposed to be off
    if (rxn.upper_bound) == 0 and (rxn.lower_bound == 0):

        #add the reaction id to the list of off reactions
        off_rxns.extend([rxn.id])

#initialize the stand alone TIC-Finding Problem object
object = stand_alone_TFP(model,ex_rxns)

#now solve the finding problem
#note that the writing of an output file will be handeled inside the TFP class as it spends a lot of time there
TFP_solution = object.find(off_rxns)

#get the current time and date for tracking solution time
end_time = datetime.now()
print("ending time: ",end_time)