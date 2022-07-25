#!/usr/bin/python

#Written by; Wheaton L Schroeder
#Latest Version: 11/23/2021

#Note that this version of the TFP that is the stand-alone (e.g. no database)

#don't know if I need all these, gapfill used them or they are required for things
#that I am trying to do here, so importing them for now
from __future__ import absolute_import

from optlang.interface import OPTIMAL, FEASIBLE, INFEASIBLE, ITERATION_LIMIT, NUMERIC, OPTIMAL, SUBOPTIMAL, TIME_LIMIT
from optlang.symbolics import Zero, add

import cobra
import sys
import warnings
import time
import re

from cobra.core import Model, Reaction, Metabolite, Solution
from cobra.util import fix_objective_as_constraint
from copy import copy, deepcopy

#so I think how this needs to go is that I define a class to perform optfill
#since OptFill is four seperate problems (1 tic-finding, 3 connecting), probably need four seperate classes
#in programming, classes are defined as something which creates an object

#class for solving the TIC Finding Problem
class TICFindingProblem(object):

    def __init__(self,model,database,exchange_rxns):
    
        self.original_model = model.copy()                  #stores the input, unfilled model
        self.database = database.copy()                     #stores the input database
        self.solution_numbers = list()                      #list of TFP solution numbers
        self.objective_values = list()                      #list of TFP objective values
        self.exchange_rxns = exchange_rxns                  #list of reaction identiers which are exchange reactions
        self.alphas = dict()                                #stores alpha variable, referenced by variable name
        self.betas = dict()                                 #stores alpha variable, referenced by variable name
        
        #need to save solutions so that can pass the results to the connecting problems
        self.prev_alphas = dict()                           #stores forward parts of solution
        self.prev_betas = dict()                            #stores backward parts of solution
        
        self.combined_model = self.original_model.copy()    #combination of the model and the database
        
        #make the combined model with additional attribute of "origin"
        for rxn in self.combined_model.reactions:
        
            #add origin attribute
            setattr(rxn,'origin','model')
            
        #add database reactions
        self.combined_model.merge(self.database.copy())    #add the database reactions to the combination model 1
        
        #all model reactions already have the 'origin' attribute, so reactions that  do not yet have this attribute are database reactions
        for rxn in self.combined_model.reactions:
        
            if not hasattr(rxn,'origin'):
            
                #we found a database reaction
                setattr(rxn,'origin','database')
        
    #this should actually solve the TIC finding problem
    def find(self,epsilon=0.001,M=1000,tolerance=1E-6):
    
        #solving the TIC-finding problem using the information from the initialization
        #Unconstrained variables
        #   objective value
        #
        #Constrainted discrete variables - note that the (j) indicates that these should be defined for each reaction
        #   v_j - flux rate for reaction j in the current solution, constrained to values between -1 and -epsilon and epsilon and 1
        #
        #Binary variables - note that the (j) indicates that these should be defined for each reaction
        #   eta(j) - value of 1 if reaction j participates in TIC 
        #   alpha(j) - value of 1 if v_j is positive and eta is 1
        #   beta(j) - value of 1 if v_j is negative and eta is 1
        #   gamma(p) - used in integer cuts to prevent duplicate solutions (where p is the set of past solutions)
        
        #the max phi value will be defined on the number of reactions
        max_phi = 0
        
        #counter for the number of solutions
        solution_number = 0
        
        #helps keeps track of the time to solve the full algorithm
        alg_start = time.time()
        
        #create a file to write the output to
        output=open('TFP_results.txt','w',buffering=1)
        output.write("TIC-Finding Problem Solutions\n")
        output.write("Model: "+self.original_model.name+"\n")
        output.write("Database: "+self.database.name+"\n\n")
        
        #need to start by turning off all exchange reactions
        for rxn in self.combined_model.reactions:
        
            #note that max_phi should also be the index of the reaction in the exchange_rxns and reactions lists
            #so long as we are not in the list of reactions originating in the database
        
            #if the reaction is exchange, then fix it as having zero flux
            if rxn.id in self.exchange_rxns:
                
                #if it is an exchange reaction, force both bounds to zero
                self.combined_model.reactions[max_phi].lower_bound = 0.0;
                self.combined_model.reactions[max_phi].upper_bound = 0.0;
        
            #check if irreversible backwards
            elif (rxn.reversibility == True) and (rxn.upper_bound == 0):
                
                #if here an irreversible forward non-exchange reaction
                self.combined_model.reactions[max_phi].lower_bound = -1.0;
                self.combined_model.reactions[max_phi].upper_bound = 0.0;            
            
            #check if irreversible forward
            elif rxn.reversibility == False:
                
                #if here an irreversible forward non-exchange reaction
                self.combined_model.reactions[max_phi].lower_bound = 0.0;
                self.combined_model.reactions[max_phi].upper_bound = 1.0;
        
            #otherwise must be reversible
            else:
                
                #otherwise not an exchange reaction
                #for all other reactions (e.g. reversible non-exchange), force bounds to be -1 to +1
                #the epsilon part will be taken care of by constraints
                self.combined_model.reactions[max_phi].lower_bound = -1.0;
                self.combined_model.reactions[max_phi].upper_bound = 1.0;
                
            #by this point have defined reaction bounds as used in OptFill
            #could increment a value of max phi
            max_phi = max_phi + 1
        
        #initialize a list of constraints 
        constraints = list()
        
        #dummy objective: maximize # of participating reactions
        #objective is summation of eta
        self.combined_model.objective = self.combined_model.problem.Objective(Zero, direction='max')
        
        #force number of etas to be at most phi
        const_6 = self.combined_model.problem.Constraint(Zero,lb=0,ub=0,name="const_6",sloppy=False)
        self.combined_model.add_cons_vars([const_6], sloppy=False)
        self.combined_model.solver.update()
        
        #constraint to force number of etas from the database to be at least one
        #ensures that we are not simply finding inherent TICs
        const_7 = self.combined_model.problem.Constraint(Zero,lb=1,name="const_7",sloppy=False)
        self.combined_model.add_cons_vars([const_7], sloppy=False)
        self.combined_model.solver.update()
        
        #build a list of coefficients for the integer cuts that will be used?
        
        #need to iterate constraint definition over reactions
        for rxn in self.combined_model.reactions:
        
            #add variables 
            alpha = self.combined_model.problem.Variable(name='alpha_{}'.format(rxn.id), lb=0, ub=1, type='binary')
            beta = self.combined_model.problem.Variable(name='beta_{}'.format(rxn.id), lb=0, ub=1, type='binary')
            eta = self.combined_model.problem.Variable(name='eta_{}'.format(rxn.id), lb=0, ub=1, type='binary')
            
            self.combined_model.add_cons_vars([alpha,beta,eta], sloppy=False)
            
            #define a way to reference the variables
            alpha.rxn_id = rxn.id
            beta.rxn_id = rxn.id
            eta.rxn_id = rxn.id
            
            #define constraints on the combined model
            
            #upper bound of flux based on beta
            #if I understand things right, self.combined_model.reactions.flux is the same as v_j
            const_1 = self.combined_model.problem.Constraint(rxn.flux_expression - ((1 - beta) * rxn.upper_bound - epsilon * beta), ub = 0, name='const_1_{}'.format(rxn.id))
            
            #upper boound of flux based on eta
            const_2 = self.combined_model.problem.Constraint(rxn.flux_expression - (eta * rxn.upper_bound), ub = 0, name='const_2_{}'.format(rxn.id))
            
            #lower bound of flux based on beta
            const_3 = self.combined_model.problem.Constraint(rxn.flux_expression - (beta * rxn.lower_bound + epsilon * eta), lb = 0, name='const_3_{}'.format(rxn.id))
            
            #lower bound of flux based on eta
            const_4 = self.combined_model.problem.Constraint(rxn.flux_expression - (eta * rxn.lower_bound), lb = 0, name='const_4_{}'.format(rxn.id))
            
            #mass balance should be automatically built into the model, this is constraint 5 (const_5)
            
            #define alpha based on eta
            const_8 = self.combined_model.problem.Constraint(alpha - eta, ub=0, name='const_8_{}'.format(rxn.id))
            
            #define alpha based on beta
            const_9 = self.combined_model.problem.Constraint(alpha - (1 - beta), ub=0, name='const_9_{}'.format(rxn.id))
            
            #define alpha based on eta and beta
            const_10 = self.combined_model.problem.Constraint(alpha - (eta + (1 - beta) - 1), lb=0, name='const_10_{}'.format(rxn.id))
            
            #add the new constraints to the list of constraints
            constraints.extend([const_1,const_2,const_3,const_4,const_8,const_9,const_10])
            
            #set coefficients for constraint equations
            const_6.set_linear_coefficients({eta: 1})
            self.combined_model.objective.set_linear_coefficients({eta: 1})
            
            #since const_7 is a sum across database reactions, noeed to check if in database
            if bool(re.search('^database$',rxn.origin)):
                
                #give this eta a coefficient of 1
                const_7.set_linear_coefficients({eta: 1})
                
            else:
            
                #otherwise give this eta a coefficient of 1
                const_7.set_linear_coefficients({eta: 0})
            
            self.alphas.update({alpha.name: alpha})
            self.betas.update({beta.name: beta})
            
        #add constraints to the model
        self.combined_model.add_cons_vars(constraints, sloppy=False)
        
        #give the problem a name
        self.combined_model.problem.name = "TIC Finding Problem (TFP)"
        
        #write out the problem expression for debugging purposes
        #output.write("problem: "+str(const_7.problem)+"\n")
        
        #try to make sure that the model is good to go for solving
        self.combined_model.solver.update()
        self.combined_model.repair()
        
        #iterate over each phi, solving
        for phi in range(max_phi):
        
            #since multiple solutions possible at each value of phi, have while loop to try to capture each
            found_all = False
            
            #update constraints based on new reaction number
            #need to figure on what this is for syntax
            const_6.ub = int(phi)
            const_6.lb = int(phi)
            print("Working on phi = "+str(phi))
            
            self.combined_model.tolerance = tolerance;
            self.combined_model.solver.update()
            self.combined_model.repair()
            
            while not found_all:
                
                #try, errors might occur if infeasible enough who knows
                try: 
                
                    #ignore warnings since "infeasible" is a warning but a normal part of this tool
                    with warnings.catch_warnings():
                    
                        #ignores "infeasible" warnings since will probably happen frequently
                        warnings.simplefilter('ignore',category=UserWarning)
                        
                        #attempt to find a solution
                        self.combined_model.repair()
                        self.combined_model.solver.update()
                        
                        print("attempting to solve TFP...")
                        
                        #time how long the solution takes
                        start_time = time.time()
                        
                        tfp_solution = self.combined_model.optimize()
                        
                        end_time = time.time()
                        
                        total_time = end_time - start_time
                        
                        print("complete\n")
                    
                except:
                
                    #output to command line that error occurred
                    print("error occurred: "+str(sys.exec_info()[0]))
                    print("End of solutions for phi = "+str(phi)+"\n\n")
                    
                    #some kind of error got thrown in solution, move to next phi 
                    output.write("End of solutions for phi = "+str(phi)+"\n")
                    output.write("Solution time: "+str(total_time)+" s\n\n")
                    
                    #if solution is not optimal, then 
                    found_all = True
                    
                    #define an empty solution so errors don't get thrown later1
                    tfp_solution = cobra.core.Solution(objective_value=0,status=INFEASIBLE,fluxes=None)
                
                #tfp_solution will be a solution object, which has property "status" anything but infeasible is good enough
                if tfp_solution.status == INFEASIBLE:
                
                    #state that no more solutions to be had at this value of phi
                    output.write("End of solutions for phi = "+str(phi)+"\n")
                    output.write("Solution time: "+str(total_time)+" s\n\n")
                    print("End of solutions for phi = "+str(phi)+"\n")
                
                    #if solution is not optimal, then 
                    found_all = True
                
                else:
                    
                    #need to add results to the class properties
                    #looks like the command is ".append()"
                    self.solution_numbers.append(solution_number)
                    self.objective_values.append(tfp_solution.objective_value)
                    
                    #found all is still so far false
                    found_all = False
                    
                    print("Solution #"+str(solution_number)+" identified\n")
                    
                    #write the solution
                    output.write("TFP SOLUTION #"+str(solution_number)+"\n")
                    output.write("PHI = "+str(phi)+"\n")
                    output.write("OBJECTIVE VALUE: "+str(tfp_solution.objective_value)+"\n")
                    output.write("REACTION\tSOURCE\t\tDIR\t\tFLUX\n") 
                    output.write("-------------------------------------------------------------\n")
                    
                    #need to make sum of alphas and betas
                    sum_alpha = 0;
                    sum_beta = 0;
                    
                    for rxn in self.combined_model.reactions:
                        
                        #report the optimal results
                        #this is the only                         
                        if self.combined_model.solver.primal_values.get('alpha_{}'.format(rxn.id)) == 1.0:
                        
                            output.write(str(rxn.id)+"\t"+str(rxn.origin)+"\t->\t\t"+str(rxn.flux)+"\n")
                            sum_alpha = sum_alpha + 1
                            
                        elif self.combined_model.solver.primal_values.get('beta_{}'.format(rxn.id)) == 1.0:
                        
                            output.write(str(rxn.id)+"\t"+str(rxn.origin)+"\t<-\t\t"+str(rxn.flux)+"\n")
                            sum_beta = sum_beta + 1
                            
                        elif self.combined_model.solver.primal_values.get('eta_{}'.format(rxn.id)) == 1.0:
                        
                            #if there is an eta value yet not an alpha or beta something went wrong
                            #hence the question marks in the report
                            output.write(str(rxn.id)+"\t"+str(rxn.origin)+"\t??\t\t"+str(rxn.flux)+"\n")
                            
                        #also need to save the solutions for later referencing
                        #will use nested dictonaries to call first solution number then reaction id
                        #note that ronding because sometimes the values are imprecise, therefore we round to nearest integer so that we have not issues later
                        self.prev_alphas.update({"{}_{}".format(solution_number,rxn.id): round(self.combined_model.solver.primal_values.get('alpha_{}'.format(rxn.id)))})
                        self.prev_betas.update({"{}_{}".format(solution_number,rxn.id): round(self.combined_model.solver.primal_values.get('beta_{}'.format(rxn.id)))})
                    
                    #if a solution has been found, need to add an integer cut precluding that
                    #solution from being found in future
                    #some constraints also iterate over solutions
                    
                    #the binary variable gamma ensures that at minimum one of the integer cuts defiend below applies
                    gamma = self.combined_model.problem.Variable(name='gamma_{}'.format(solution_number), lb=0, ub=1, type='binary')
                    gamma.soln_id = solution_number
                    
                    self.combined_model.add_cons_vars([gamma], sloppy=False)
                    
                    #integer cut 1: ensure that all the alphas in a following solution are not the same as in any previous solution
                    #need to define constraint first
                    int_cut_1 = self.combined_model.problem.Constraint(Zero,ub=sum_alpha)
                    self.combined_model.add_cons_vars([int_cut_1], sloppy=False)
                    self.combined_model.solver.update()
                    int_cut_1.set_linear_coefficients({gamma: 1})
                    
                    #OR
                    
                    #integer cut 2: ensure that all the betas are not the same as in any previous solution
                    int_cut_2 = self.combined_model.problem.Constraint(Zero,ub=(sum_beta-1))
                    self.combined_model.add_cons_vars([int_cut_2], sloppy=False)
                    self.combined_model.solver.update()
                    int_cut_2.set_linear_coefficients({gamma: -1})
                    
                    #need to loop over all reactions to define coefficients for summation 
                    for rxn in self.combined_model.reactions:
                        
                        #check to see if there is a coefficient for the 
                        if self.combined_model.solver.primal_values.get('alpha_{}'.format(rxn.id)) == 1:
                            
                            #if there is a previous value of alpha then need to have a coefficient of 1
                            int_cut_1.set_linear_coefficients({self.alphas['alpha_{}'.format(rxn.id)]: 1})
                            
                        #check to see if there is a coefficient for the 
                        if self.combined_model.solver.primal_values.get('beta_{}'.format(rxn.id)) == 1:
                        
                            #if there is a previous value of alpha then need to have a coefficient of 1
                            int_cut_2.set_linear_coefficients({self.betas['beta_{}'.format(rxn.id)]: 1})
                        
                    #write the time to get the solution
                    output.write("time to get solution: "+str(total_time)+" s\n")
                    
                    #update the solution number
                    solution_number = solution_number + 1
                    
                    #add another newline to space reported solutions
                    output.write("\n")
                
            #if here, then phi will be updated
            
        alg_end = time.time()
        total_alg_time = alg_end - alg_start
        output.write("total TFP runtime: "+str(total_alg_time)+" s")
            
        #return itself so can 
        return self