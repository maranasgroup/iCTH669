#!/usr/bin/python

#try to specify that we will use python version 3.9
__author__ = "Wheaton Schroeder"
#latest version: 12/08/2021

#written to implement Flux Balance Analysis (FBA) 

#These are the imports I have used in past for cobrapy, so will use them here as well, not sure the the necessity of any of these
#from __future__ import absolute_import

from optlang.interface import OPTIMAL, FEASIBLE, INFEASIBLE, ITERATION_LIMIT, NUMERIC, SUBOPTIMAL, TIME_LIMIT
from optlang.symbolics import Zero, add

import os
import sys
import warnings
import re
import cobra
from datetime import datetime

import copy

from cobra import Model, Reaction, Metabolite, Solution

#now that we have defined the import library, let us create a class for the mintransfers algorithm
class FBA(object):

    #initialization of class:
    #self - needs to be passed itself
    #model - model which FVA will be applied to
    def __init__(self,model,bigM=1000):

        #add the models to the self object
        self.model = model.copy()
        self.bigM = bigM

        #update model pointers to make sure copied model works
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

    #this will perform FBA
    #note that directions, reversibility, objective, and bounds should be defined in the SBML
    #we will allow playing aroudn with various settings later
    # objective - the reaction id of the reaction that is to be the objective
    # obj_dir - direction for optimization, must be "min" or "max"
    # fixed_rates - dictionary of fluxes which should be fixed during FBA and keys of the values 
    # tolerance - numerical tolerance for FBA
    #note that this only works for setting a single reaction as the objective
    def run(self,objective,obj_dir="max",fixed_rates=dict()):

        #repair the self model before copying
        self.model.solver.update()
        self.model.repair()
        
        #make a copy of the model for fba
        FBA_model = self.model.copy()

        #try to make sure the model is good to go for solving
        FBA_model.solver.update()
        FBA_model.repair()
        
        #give the problem a name
        FBA_model.problem.name = "flux balance analysis (FBA)"

        #try to make sure the model is good to go for solving
        FBA_model.solver.update()
        FBA_model.repair()

        #initialize an empty dictionary for returning with results
        fba_results = { }

        #change the objective if needed
        obj_eqn = FBA_model.problem.Objective(Zero, direction=obj_dir)

        #save a reaction index
        rxn_index = 0

        #go through each reaction, see which matches the identifier
        for rxn in FBA_model.reactions:

            #check if the reaction matches the objective id passed
            if bool(re.fullmatch(str(rxn.id),objective)):

                #set the linear coefficient
                obj_eqn = FBA_model.problem.Objective(rxn.flux_expression,direction=obj_dir)
            
            #if the reaction is in the fixed rates dictionary, fix its rate
            if rxn.id in fixed_rates.keys():

                #set dummy bounds
                FBA_model.reactions[FBA_model.reactions.index(rxn.id)].upper_bound = 10000
                FBA_model.reactions[FBA_model.reactions.index(rxn.id)].lower_bound = -10000
                
                #enforce bounds we want to enforce
                FBA_model.reactions[FBA_model.reactions.index(rxn.id)].lower_bound = fixed_rates[rxn.id]
                FBA_model.reactions[FBA_model.reactions.index(rxn.id)].upper_bound = fixed_rates[rxn.id]

                #fix the model
                FBA_model.solver.update()
                FBA_model.repair()

        FBA_model.objective = obj_eqn

        #solve, but put in a try/except framework in case there is an error
        try:

            start_time_fba = datetime.now()

            #last fix of the model
            FBA_model.solver.update()
            FBA_model.repair()

            #try to solve, here is where the error may get thrown
            fba_soln = FBA_model.optimize()

            end_time_fba = datetime.now()

            #get the total solve time
            total_time_fba = end_time_fba - start_time_fba

            #write and store the lower bound, flux, and upper bound for each reaction
            for rxn in FBA_model.reactions:

                #write the results to the output dictionary
                #I believe this would be most useful set up as a nested dictionary
                
                #initialize element to nest
                fba_results[rxn.id] = { }

                #add nestings
                fba_results[rxn.id]['lb'] = rxn.lower_bound
                fba_results[rxn.id]['flux'] = fba_soln.fluxes[rxn.id]
                fba_results[rxn.id]['ub'] = rxn.upper_bound
            
            #state that no exception occured
            fba_results['exception']=False

            fba_results['status'] = fba_soln.status

            #return the solution time in the dictionary
            fba_results['total_time'] = str(total_time_fba)

            #return the objective
            fba_results['objective'] = fba_soln.objective_value

        #if an exception occurs, store as "e"
        except Exception as e:

            #get the timein information
            end_time_fba = datetime.now()

            #print the total solve time
            total_time_fba = end_time_fba - start_time_fba
            
            #state that an exception occured
            fba_results['exception']=True

            fba_results['status'] = "exception occurred"

            #save the exception string to return
            fba_results['exception_str']=str(e)

            #return the solution time in the dictionary
            fba_results['total_time'] = str(total_time_fba)

            #return objective value of NaN since the problem was not solved
            fba_results['objective'] = "NaN"
        
        #return our dictionary
        return fba_results

    #this will perform parsimonious FBA
    #note that directions, reversibility, objective, and bounds should be defined in the SBML
    #we will allow playing aroudn with various settings later
    # objective - the reaction id of the reaction that is to be the objective
    # obj_dir - direction for optimization, must be "min" or "max"
    # fixed_rates - dictionary of fluxes which should be fixed during FBA and keys of the flux values
    # tolerance - numerical tolerance for FBA
    #note that this only works for setting a single reaction as the objective
    def run_pFBA(self,objective,obj_dir="max",fixed_rates=dict()):

        #repair the self model before copying
        self.model.solver.update()
        self.model.repair()
        
        pFBA_model = self.model.copy()

        #try to make sure the model is good to go for solving
        pFBA_model.solver.update()
        pFBA_model.repair()

        #give the problem a name
        pFBA_model.problem.name = "parsimonious flux balance analysis (FBA)"
        
        #change the objective if needed
        pFBA_model.objective = pFBA_model.problem.Objective(Zero, direction=obj_dir)

        #save a reaction index
        rxn_index = 0

        #try to make sure the model is good to go for solving
        pFBA_model.solver.update()
        pFBA_model.repair()

        #go through each reaction, see which matches the identifier
        for rxn in pFBA_model.reactions:

            #check if the reaction matches the objective id passed
            if bool(re.fullmatch(str(rxn.id),objective)):

                #set the linear coefficient
                pFBA_model.objective.set_linear_coefficients({rxn.forward_variable: 1})
                pFBA_model.objective.set_linear_coefficients({rxn.reverse_variable: -1})
            
            #if the reaction is in the fixed rates dictionary, fix its rate
            if rxn.id in fixed_rates.keys():

                #set dummy bounds
                pFBA_model.reactions[pFBA_model.reactions.index(rxn.id)].upper_bound = 10 * self.bigM
                pFBA_model.reactions[pFBA_model.reactions.index(rxn.id)].lower_bound = -10 * self.bigM

                #enforce the bounds we want
                pFBA_model.reactions[pFBA_model.reactions.index(rxn.id)].lower_bound = fixed_rates[rxn.id]
                pFBA_model.reactions[pFBA_model.reactions.index(rxn.id)].upper_bound = fixed_rates[rxn.id]

                #fix the model
                pFBA_model.solver.update()
                pFBA_model.repair()

        #try to make sure the model is good to go for solving
        pFBA_model.solver.update()
        pFBA_model.repair()

        #initialize an empty dictionary for returning with results
        pfba_results = { }

        #solve, but put in a try/except framework in case there is an error
        try:

            start_time_pfba = datetime.now()

            #try to make sure the model is good to go for solving
            pFBA_model.solver.update()
            pFBA_model.repair()

            #try to solve, here is where the error may get thrown
            #do a manual pFBA so that we can capture both shadow prices

            #this is the built-in pFBA command
            #fba_soln = cobra.flux_analysis.pfba(pFBA_model)

            print("solving first problem")

            #this does the "maximize objective" step
            fba_soln = pFBA_model.optimize()

            print("first problem solved")

            #return shadow prices
            for met in pFBA_model.metabolites:

                #initialize element to nest
                pfba_results[met.id] = { }
                
                pfba_results[met.id]['shadow_bio'] = pFBA_model.solver.shadow_prices[met.id]

            #next we fix the objective value, most of the time this will be fixing the biomas rate
            pFBA_model.reactions[pFBA_model.reactions.index(objective)].lower_bound = fba_soln.objective_value
            pFBA_model.reactions[pFBA_model.reactions.index(objective)].upper_bound = fba_soln.objective_value

            
            #go through each reaction, see which matches the identifier
            #create a new objective equation minimizing the sum of flux rates
            pFBA_model.objective = pFBA_model.problem.Objective(Zero, direction='min')

            #go through each reaction, see which matches the identifier
            for rxn in pFBA_model.reactions:

                #make a variable to store the absolute value of each reaction rate
                v_plus_rxn = pFBA_model.problem.Variable(name='v_+_{}'.format(rxn.id),lb=0,ub=2*self.bigM)

                #create two constraints to get back the absolute value
                v_plus_const_1 = pFBA_model.problem.Constraint(v_plus_rxn - rxn.flux_expression,lb=0,ub=2*self.bigM,name='v_+_1_{}'.format(rxn.id),sloppy=True)
                v_plus_const_2 = pFBA_model.problem.Constraint(v_plus_rxn + rxn.flux_expression,lb=0,ub=2*self.bigM,name='v_+_2_{}'.format(rxn.id),sloppy=True)

                #add these constraints to the model
                pFBA_model.add_cons_vars([v_plus_const_1, v_plus_const_2], sloppy=False)

                #set the objective so that we are minimizing the sum of absolute values
                pFBA_model.objective.set_linear_coefficients({v_plus_rxn: 1})

                #try to make sure the model is good to go for solving
                pFBA_model.solver.update()
                pFBA_model.repair()
            
            #minimize sum of fluxes for the objective being fixed
            print("solving second problem")

            pfba_soln  = pFBA_model.optimize()

            print("second problem solved")
            
            end_time_pfba = datetime.now()

            #get the total solve time
            total_time_fba = end_time_pfba - start_time_pfba

            #write and store the lower bound, flux, and upper bound for each reaction
            for rxn in pFBA_model.reactions:

                #write the results to the output dictionary
                #I believe this would be most useful set up as a nested dictionary
                
                #initialize element to nest
                pfba_results[rxn.id] = { }

                #add nestings
                pfba_results[rxn.id]['lb'] = rxn.lower_bound
                pfba_results[rxn.id]['flux'] = pfba_soln.fluxes[rxn.id]
                pfba_results[rxn.id]['ub'] = rxn.upper_bound

            #state that no exception occured
            pfba_results['exception']=False

            pfba_results['status1'] = fba_soln.status
            pfba_results['status2'] = pfba_soln.status

            #return the solution time in the dictionary
            pfba_results['total_time'] = str(total_time_fba)

            #return the objective
            pfba_results['objective'] = pfba_soln.objective_value

            #return shadow prices
            for met in self.model.metabolites:
                
                #now assign the shadow price based on the flux rates
                pfba_results[met.id]['shadow_flux'] = pFBA_model.solver.shadow_prices[met.id]

        #if an exception occurs, store as "e"
        except Exception as e:

            print("error: "+str(e))

            #get the timein information
            end_time_pfba = datetime.now()

            #print the total solve time
            total_time_fba = end_time_pfba - start_time_pfba
            
            #state that an exception occured
            pfba_results['exception']=True

            pfba_results['status'] = "exception occurred"

            #save the exception string to return
            pfba_results['exception_str']=str(e)

            #return the solution time in the dictionary
            pfba_results['total_time'] = str(total_time_fba)

            #return objective value of NaN since the problem was not solved
            pfba_results['objective'] = "NaN"
        
        #return our dictionary
        return pfba_results


    #this will perform FBA while minimizing PPi use
    #note that directions, reversibility, objective, and bounds should be defined in the SBML
    #we will allow playing aroudn with various settings later
    # objective - the reaction id of the reaction that is to be the objective
    # obj_dir - direction for optimization, must be "min" or "max"
    # fixed_rates - dictionary of fluxes which should be fixed during FBA and keys of the values 
    # tolerance - numerical tolerance for FBA
    #note that this only works for setting a single reaction as the objective
    def run_min_PPi(self,fixed_rates=dict()):

        #repair the self model before copying
        self.model.solver.update()
        self.model.repair()
        
        #make a copy of the model for fba
        FBA_model = self.model.copy()

        #try to make sure the model is good to go for solving
        FBA_model.solver.update()
        FBA_model.repair()
        
        #give the problem a name
        FBA_model.problem.name = "flux balance analysis (FBA)"

        #try to make sure the model is good to go for solving
        FBA_model.solver.update()
        FBA_model.repair()

        #initialize an empty dictionary for returning with results
        fba_results = { }

        #change the objective if needed
        FBA_model.objective = FBA_model.problem.Objective(Zero, direction="min")

        #go through each reaction, see which reactions involve PPi-generation
        for rxn in FBA_model.reactions:

            #check if reaction has ppi in its products or reactants
            participant_species = rxn.reactants + rxn.products

            #clean up participant species to just ids
            for met in participant_species:

                #if PPi participates in the reaction
                if(met.id == 'ppi_c'):

                    #get the stoichiometry of PPi
                    ppi_stoich = rxn.get_coefficient('ppi_c') 

                    #if coefficient is greater than zero and upper bound is greater than zero
                    if (ppi_stoich > 0 and rxn.upper_bound > 0):

                        #then we have a potential ppi-producing reaction

                        #add this to the objective
                        #forward reaction makes PPi, this will be what counts against objective
                        #the objective will be to minimize total PPi production
                        FBA_model.objective.set_linear_coefficients({rxn.forward_variable: ppi_stoich})
                        
                    
                    #or if coefficient is less than zero and lower bound is less than zero
                    elif (ppi_stoich < 0 and rxn.lower_bound < 0):

                        #then we have a potential ppi-producing reaction

                        #add this to the objective
                        #forward reaction makes PPi, this will be what counts against objective
                        #the objective will be to minimize total PPi production
                        FBA_model.objective.set_linear_coefficients({rxn.reverse_variable: ppi_stoich})

            #if the reaction is in the fixed rates dictionary, fix its rate
            if rxn.id in fixed_rates.keys():

                #set dummy bounds
                FBA_model.reactions[FBA_model.reactions.index(rxn.id)].upper_bound = 10 * self.bigM
                FBA_model.reactions[FBA_model.reactions.index(rxn.id)].lower_bound = -10 * self.bigM

                #enforce the bounds we want
                FBA_model.reactions[FBA_model.reactions.index(rxn.id)].lower_bound = fixed_rates[rxn.id]
                FBA_model.reactions[FBA_model.reactions.index(rxn.id)].upper_bound = fixed_rates[rxn.id]

                #fix the model
                FBA_model.solver.update()
                FBA_model.repair()

            #fix the model
            FBA_model.solver.update()
            FBA_model.repair()

        #solve, but put in a try/except framework in case there is an error
        try:

            start_time_fba = datetime.now()

            #last fix of the model
            FBA_model.solver.update()
            FBA_model.repair()

            #try to solve, here is where the error may get thrown
            fba_soln = FBA_model.optimize()

            end_time_fba = datetime.now()

            #get the total solve time
            total_time_fba = end_time_fba - start_time_fba

            #write and store the lower bound, flux, and upper bound for each reaction
            for rxn in FBA_model.reactions:

                #write the results to the output dictionary
                #I believe this would be most useful set up as a nested dictionary
                
                #initialize element to nest
                fba_results[rxn.id] = { }

                #add nestings
                fba_results[rxn.id]['lb'] = rxn.lower_bound
                fba_results[rxn.id]['flux'] = fba_soln.fluxes[rxn.id]
                fba_results[rxn.id]['ub'] = rxn.upper_bound
            
            #state that no exception occured
            fba_results['exception']=False

            fba_results['status'] = fba_soln.status

            #return the solution time in the dictionary
            fba_results['total_time'] = str(total_time_fba)

            #return the objective
            fba_results['objective'] = fba_soln.objective_value

        #if an exception occurs, store as "e"
        except Exception as e:

            #get the timein information
            end_time_fba = datetime.now()

            #print the total solve time
            total_time_fba = end_time_fba - start_time_fba
            
            #state that an exception occured
            fba_results['exception']=True

            fba_results['status'] = "exception occurred"

            #save the exception string to return
            fba_results['exception_str']=str(e)

            #return the solution time in the dictionary
            fba_results['total_time'] = str(total_time_fba)

            #return objective value of NaN since the problem was not solved
            fba_results['objective'] = "NaN"
        
        #return our dictionary
        return fba_results

    #this will perform FBA while minimizing PPi use
    #note that directions, reversibility, objective, and bounds should be defined in the SBML
    #we will allow playing aroudn with various settings later
    # objective - the reaction id of the reaction that is to be the objective
    # obj_dir - direction for optimization, must be "min" or "max"
    # fixed_rates - dictionary of fluxes which should be fixed during FBA and keys of the values 
    # tolerance - numerical tolerance for FBA
    #note that this only works for setting a single reaction as the objective
    def run_max_PPi(self,fixed_rates=dict()):

        #repair the self model before copying
        self.model.solver.update()
        self.model.repair()
        
        #make a copy of the model for fba
        FBA_model = self.model.copy()

        #try to make sure the model is good to go for solving
        FBA_model.solver.update()
        FBA_model.repair()
        
        #give the problem a name
        FBA_model.problem.name = "flux balance analysis (FBA)"

        #try to make sure the model is good to go for solving
        FBA_model.solver.update()
        FBA_model.repair()

        #initialize an empty dictionary for returning with results
        fba_results = { }

        #change the objective if needed
        FBA_model.objective = FBA_model.problem.Objective(Zero, direction="max")

        #go through each reaction, see which reactions involve PPi-generation
        for rxn in FBA_model.reactions:

            #check if reaction has ppi in its products or reactants
            participant_species = rxn.reactants + rxn.products

            #clean up participant species to just ids
            for met in participant_species:

                #if PPi participates in the reaction
                if(met.id == 'ppi_c'):

                    #get the stoichiometry of PPi
                    ppi_stoich = rxn.get_coefficient('ppi_c') 

                    #if coefficient is greater than zero and upper bound is greater than zero
                    if (ppi_stoich > 0 and rxn.upper_bound > 0):

                        #then we have a potential ppi-producing reaction

                        #add this to the objective
                        #forward reaction makes PPi, this will be what counts against objective
                        #the objective will be to minimize total PPi production
                        FBA_model.objective.set_linear_coefficients({rxn.forward_variable: ppi_stoich})
                        
                    
                    #or if coefficient is less than zero and lower bound is less than zero
                    elif (ppi_stoich < 0 and rxn.lower_bound < 0):

                        #add this to the objective
                        #forward reaction makes PPi, this will be what counts against objective
                        #the objective will be to minimize total PPi production
                        FBA_model.objective.set_linear_coefficients({rxn.reverse_variable: ppi_stoich})

            #if the reaction is in the fixed rates dictionary, fix its rate
            if rxn.id in fixed_rates.keys():

                #set dummy bounds
                FBA_model.reactions[FBA_model.reactions.index(rxn.id)].upper_bound = 10 * self.bigM
                FBA_model.reactions[FBA_model.reactions.index(rxn.id)].lower_bound = -10 * self.bigM

                #enforce the bounds we want
                FBA_model.reactions[FBA_model.reactions.index(rxn.id)].lower_bound = fixed_rates[rxn.id]
                FBA_model.reactions[FBA_model.reactions.index(rxn.id)].upper_bound = fixed_rates[rxn.id]

                #fix the model
                FBA_model.solver.update()
                FBA_model.repair()

            #fix the model
            FBA_model.solver.update()
            FBA_model.repair()

        #solve, but put in a try/except framework in case there is an error
        try:

            start_time_fba = datetime.now()

            #last fix of the model
            FBA_model.solver.update()
            FBA_model.repair()

            #try to solve, here is where the error may get thrown
            fba_soln = FBA_model.optimize()

            end_time_fba = datetime.now()

            #get the total solve time
            total_time_fba = end_time_fba - start_time_fba

            #write and store the lower bound, flux, and upper bound for each reaction
            for rxn in FBA_model.reactions:

                #write the results to the output dictionary
                #I believe this would be most useful set up as a nested dictionary
                
                #initialize element to nest
                fba_results[rxn.id] = { }

                #add nestings
                fba_results[rxn.id]['lb'] = rxn.lower_bound
                fba_results[rxn.id]['flux'] = fba_soln.fluxes[rxn.id]
                fba_results[rxn.id]['ub'] = rxn.upper_bound
            
            #state that no exception occured
            fba_results['exception']=False

            fba_results['status'] = fba_soln.status

            #return the solution time in the dictionary
            fba_results['total_time'] = str(total_time_fba)

            #return the objective
            fba_results['objective'] = fba_soln.objective_value

        #if an exception occurs, store as "e"
        except Exception as e:

            #get the timein information
            end_time_fba = datetime.now()

            #print the total solve time
            total_time_fba = end_time_fba - start_time_fba
            
            #state that an exception occured
            fba_results['exception']=True

            fba_results['status'] = "exception occurred"

            #save the exception string to return
            fba_results['exception_str']=str(e)

            #return the solution time in the dictionary
            fba_results['total_time'] = str(total_time_fba)

            #return objective value of NaN since the problem was not solved
            fba_results['objective'] = "NaN"
        
        #return our dictionary
        return fba_results