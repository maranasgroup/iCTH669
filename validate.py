#!/usr/bin/python
#! python 3.9
#try to specify that we will use python version 3.9
__author__ = "Wheaton Schroeder"
#latest version: 01/11/2022
#attempts to validate a model

#imports, again, these are used previously, not sure of their necessity
import cobra
from fba import FBA
from datetime import datetime
from cobra import Model, Reaction, Metabolite
import re
import os
import warnings

#get the current directory to use for importing things
curr_dir = os.getcwd()

#import the ctherm model
validation = cobra.io.validate_sbml_model(curr_dir + "/iCBI655_cellobiose_batch.sbml")
#validation = cobra.io.validate_sbml_model(curr_dir + "/iCTH665_final.sbml")

#write a file to put the FBA results
output=open('model_validation.txt','w',buffering=1)
output.write("Validation results\n")
output.write(str(validation))