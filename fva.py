#!/usr/bin/python

#try to specify that we will use python version 3.9
__author__ = "Wheaton Schroeder"
#latest version: 12/08/2021

#written to implement Flux Variability Analysis (FVA)

#These are the imports I have used in past for cobrapy, so will use them here as well, not sure the the necessity of any of these
#from __future__ import absolute_import

from optlang.interface import OPTIMAL, FEASIBLE, INFEASIBLE, ITERATION_LIMIT, NUMERIC, SUBOPTIMAL, TIME_LIMIT
from optlang.symbolics import Zero, add

import cobra
from fba import FBA
import os
import sys
import copy
import warnings
import re
from os.path import join
from datetime import datetime

from cobra.core import Model, Reaction, Metabolite, Solution
from cobra.util import fix_objective_as_constraint 

#now that we have defined the import library, let us create a class for the mintransfers algorithm
class FVA(object):

    #initialization of class:
    #self - needs to be passed itself
    #model - model which FVA will be applied to
    def __init__(self,model):

        #add the models to the self object
        self.model = model.copy()

        #try to make sure the model is good to go for solving
        self.model.solver.update()
        self.model.repair()

    #pass a string to set the solver to that string
    def set_solver(self,solver):

        #set the solver to the passed string
        try: 

            self.model.solver = solver

        #if an exception occurs, store as "e"
        except Exception as e:

            print("solver assignement unsuccessful, exception: "+str(e))

    #this will perform FVA
    #will use what is defined in the init to run FVA
    # fixed_rates - dictionary of fluxes which should be fixed during FBA and keys of the values 
    # tolerance - numerical tolerance for FBA
    def analyze(self,fixed_rates=dict(),tolerance=1E-3):

        #use a dictionary to report the results
        fva_results = { }

        #try to make sure the model is good to go for solving
        self.model.solver.update()
        self.model.repair()

        #initialize the FBA object 
        fba_object = FBA(self.model)

        #keep track of how long this takes
        start_time_fva = datetime.now()

        #get the total number of reactions for reporting progress
        num_rxns = len(self.model.reactions)

        #progress checks variables
        done_10 = False     #true if 10% done
        done_20 = False     #true if 20% done
        done_30 = False     #true if 30% done
        done_40 = False     #true if 40% done
        done_50 = False     #true if 50% done
        done_60 = False     #true if 60% done
        done_70 = False     #true if 70% done
        done_80 = False     #true if 80% done
        done_90 = False     #true if 90% done
        done_100 = False     #true if 100% done

        #counter for number of reactions done thus far
        num_rxns_done = 0

        #essentially, we need to run FBA with different
        for rxn in self.model.reactions:

            #initialize element to nest
            fva_results[rxn.id] = { }

            #try to make sure the model is good to go for solving
            self.model.solver.update()
            self.model.repair()

            #if the reaction is in the fixed rates dictionary, fix its rate
            if rxn.id in fixed_rates.keys():

                fva_results[rxn.id]['lb'] = fixed_rates[rxn.id]
                fva_results[rxn.id]['ub'] = fixed_rates[rxn.id]

            else:

                #we know bounds before solving FVA, so will define them here
                fva_results[rxn.id]['lb'] = rxn.lower_bound
                fva_results[rxn.id]['ub'] = rxn.upper_bound

            #try to make sure the model is good to go for solving
            self.model.solver.update()
            self.model.repair()
            
            #solve for minimizing the current reaction rate
            min_results = fba_object.run(str(rxn.id),"min",fixed_rates)

            #change how reporting happens based on wheter or not an exception happended
            if min_results['exception']:

                #here if an exception happened, report as "NaN" where it makes sense
                fva_results[rxn.id]['min'] = "NaN"

                #save that there is an exception
                fva_results[rxn.id]['exception'] = True

                #save what the exception is for later reporting
                fva_results[rxn.id]['exception_str'] = min_results['exception_str']

            else:

                #here then no exception occurs, we can use the numbers
                fva_results[rxn.id]['min'] = min_results['objective']

                #save that there is no exception
                fva_results[rxn.id]['exception'] = False

            #try to make sure the model is good to go for solving
            self.model.solver.update()
            self.model.repair()

            #repeat the above to get the maximum flux
            #solve for maximizing the current reaction rate
            max_results = fba_object.run(rxn.id,"max",fixed_rates)

            #change how reporting happens based on wheter or not an exception happended
            if max_results['exception']:

                #here if an exception happened, report as "NaN" where it makes sense
                fva_results[rxn.id]['max'] = "NaN"

            else:

                #here then no exception occurs, we can use the numbers
                fva_results[rxn.id]['max'] = max_results['objective']

            #decide if need to report on progress
            num_rxns_done += 1

            if num_rxns_done >= 0.1 * num_rxns and not done_10:

                done_10 = True

                print("10% complete")

            elif num_rxns_done >= 0.2 * num_rxns and not done_20:

                done_20 = True

                print("20% complete")

            elif num_rxns_done >= 0.3 * num_rxns and not done_30:

                done_30 = True

                print("30% complete")

            elif num_rxns_done >= 0.4 * num_rxns and not done_40:

                done_40 = True

                print("40% complete")    

            elif num_rxns_done >= 0.5 * num_rxns and not done_50:

                done_50 = True

                print("50% complete")    

            elif num_rxns_done >= 0.6 * num_rxns and not done_60:

                done_60 = True

                print("60% complete")    

            elif num_rxns_done >= 0.7 * num_rxns and not done_70:

                done_70 = True

                print("70% complete")    

            elif num_rxns_done >= 0.8 * num_rxns and not done_80:

                done_80 = True

                print("80% complete")    

            elif num_rxns_done >= 0.9 * num_rxns and not done_90:

                done_90 = True

                print("90% complete")    

            elif num_rxns_done >= 1 * num_rxns and not done_100:

                done_100 = True

                print("100% complete")   

        #keep track of how long this takes
        end_time_fva = datetime.now()

        #total time
        total_time_fva = end_time_fva - start_time_fva

        #keep track of how long it took
        fva_results['total_time'] = total_time_fva

        #return our dictionary
        return fva_results




