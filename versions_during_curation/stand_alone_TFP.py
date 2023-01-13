#!/usr/bin/python

#Written by: Wheaton L Schroeder
__author__ = "Wheaton Schroeder"
#latest version: 12/08/2021

#Note that this version of the TFP that is the stand-alone (e.g. no database)

#don't know if I need all these, gapfill used them or they are required for things
#that I am trying to do here, so importing them for now
#from __future__ import absolute_import

from optlang.interface import OPTIMAL, FEASIBLE, INFEASIBLE, ITERATION_LIMIT, NUMERIC, OPTIMAL, SUBOPTIMAL, TIME_LIMIT
from optlang.symbolics import Zero, add

import cobra
import sys
import warnings
import time
import re
import copy

from cobra.core import Model, Reaction, Metabolite, Solution
from cobra.util import fix_objective_as_constraint

#so I think how this needs to go is that I define a class to perform optfill
#since OptFill is four seperate problems (1 tic-finding, 3 connecting), probably need four seperate classes
#in programming, classes are defined as something which creates an object

#class for solving the TIC Finding Problem
class stand_alone_TFP(object):

    def __init__(self,model,exchange_rxns):
    
        self.model = model.copy()                           #stores the input, unfilled model
        self.solution_numbers = list()                      #list of TFP solution numbers
        self.objective_values = list()                      #list of TFP objective values
        self.exchange_rxns = exchange_rxns                  #list of reaction identiers which are exchange reactions
        self.alphas = dict()                                #stores alpha variable, referenced by variable name
        self.betas = dict()                                 #stores alpha variable, referenced by variable name
        
        #need to save solutions so that can pass the results to the connecting problems
        self.prev_alphas = dict()                           #stores forward parts of solution
        self.prev_betas = dict()                            #stores backward parts of solution

        #update model pointers to make sure copied model works
        self.model.solver.update()
        self.model.repair()
        
        #add attribute of "origin" to all reactions indicating that they are part of an original model, not a database
        for rxn in self.model.reactions:
        
            #add origin attribute
            setattr(rxn,'origin','model')
        
        
    #this should actually solve the TIC finding problem
    #note that for how this is defined, before "find" is called, the user needs to create a list of reactions which are forced to be off for this to work
    def find(self,off_rxns=dict(),epsilon=0.001,M=1000,tolerance=1E-6):
    
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
        output=open('saTFP_results.txt','w',buffering=1)
        output.write("Stand-Alone TIC-Finding Problem Solutions\n")
        output.write("Model: "+self.model.name+"\n\n")
        
        #need to start by turning off all exchange reactions
        for rxn in self.model.reactions:
        
            #note that max_phi should also be the index of the reaction in the exchange_rxns and reactions lists
            #so long as we are not in the list of reactions originating in the database
        
            #if the reaction is exchange, then fix it as having zero flux
            if rxn.id in self.exchange_rxns:
                
                #if it is an exchange reaction, force both bounds to zero
                self.model.reactions[max_phi].lower_bound = 0.0
                self.model.reactions[max_phi].upper_bound = 0.0
        
            #check if irreversible backwards
            elif (rxn.reversibility == True) and (rxn.upper_bound == 0):
                
                #if here an irreversible backward non-exchange reaction
                self.model.reactions[max_phi].lower_bound = -1.0
                self.model.reactions[max_phi].upper_bound = 0.0  
            
            #check if irreversible forward
            elif rxn.reversibility == False:
                
                #if here an irreversible forward non-exchange reaction
                self.model.reactions[max_phi].lower_bound = 0.0
                self.model.reactions[max_phi].upper_bound = 1.0
        
            #otherwise must be reversible
            else:
                
                #otherwise not an exchange reaction
                #for all other reactions (e.g. reversible non-exchange), force bounds to be -1 to +1
                #the epsilon part will be taken care of by constraints
                self.model.reactions[max_phi].lower_bound = -1.0
                self.model.reactions[max_phi].upper_bound = 1.0

            #override above assignments if we have a fixed reaction
            #check if it is an off reaction defined in the passed off_rxns dictionary
            if rxn.id in off_rxns:

                self.model.reactions[max_phi].lower_bound = 0
                self.model.reactions[max_phi].upper_bound = 0

            #by this point have defined reaction bounds as used in OptFill
            #could increment a value of max phi
            max_phi = max_phi + 1
        
        #initialize a list of constraints 
        constraints = list()

        #update model pointers to make sure copied model works
        self.model.solver.update()
        self.model.repair()
        
        #dummy objective: maximize # of participating reactions
        #objective is summation of eta
        self.model.objective = self.model.problem.Objective(Zero, direction='max')
        
        #force number of etas to be at most phi
        const_6 = self.model.problem.Constraint(Zero,lb=0,ub=0,name="const_6",sloppy=False)
        self.model.add_cons_vars([const_6], sloppy=False)
        self.model.solver.update()
        
        #Note the constraint on eta is updated so that it requires at least one reaction to be in the TIC, instead of at minimum one from the database
        const_7 = self.model.problem.Constraint(Zero,lb=1,name="const_7",sloppy=False)
        self.model.add_cons_vars([const_7], sloppy=False)
        self.model.solver.update()
        
        #update model pointers to make sure copied model works
        self.model.solver.update()
        self.model.repair()

        #build a list of coefficients for the integer cuts that will be used?
        
        #need to iterate constraint definition over reactions
        for rxn in self.model.reactions:
        
            #add variables 
            alpha = self.model.problem.Variable(name='alpha_{}'.format(rxn.id), lb=0, ub=1, type='binary')
            beta = self.model.problem.Variable(name='beta_{}'.format(rxn.id), lb=0, ub=1, type='binary')
            eta = self.model.problem.Variable(name='eta_{}'.format(rxn.id), lb=0, ub=1, type='binary')
            
            self.model.add_cons_vars([alpha,beta,eta], sloppy=False)
            
            #define a way to reference the variables
            alpha.rxn_id = rxn.id
            beta.rxn_id = rxn.id
            eta.rxn_id = rxn.id
            
            #define constraints on the combined model
            
            #upper bound of flux based on beta
            #if I understand things right, self.model.reactions.flux is the same as v_j
            const_1 = self.model.problem.Constraint(rxn.flux_expression - ((1 - beta) * rxn.upper_bound - epsilon * beta), ub = 0, name='const_1_{}'.format(rxn.id))
            
            #upper boound of flux based on eta
            const_2 = self.model.problem.Constraint(rxn.flux_expression - (eta * rxn.upper_bound), ub = 0, name='const_2_{}'.format(rxn.id))
            
            #lower bound of flux based on beta
            const_3 = self.model.problem.Constraint(rxn.flux_expression - (beta * rxn.lower_bound + epsilon * eta), lb = 0, name='const_3_{}'.format(rxn.id))
            
            #lower bound of flux based on eta
            const_4 = self.model.problem.Constraint(rxn.flux_expression - (eta * rxn.lower_bound), lb = 0, name='const_4_{}'.format(rxn.id))
            
            #mass balance should be automatically built into the model, this is constraint 5 (const_5)
            
            #define alpha based on eta
            const_8 = self.model.problem.Constraint(alpha - eta, ub=0, name='const_8_{}'.format(rxn.id))
            
            #define alpha based on beta
            const_9 = self.model.problem.Constraint(alpha - (1 - beta), ub=0, name='const_9_{}'.format(rxn.id))
            
            #define alpha based on eta and beta
            const_10 = self.model.problem.Constraint(alpha - (eta + (1 - beta) - 1), lb=0, name='const_10_{}'.format(rxn.id))
            
            #add the new constraints to the list of constraints
            constraints.extend([const_1,const_2,const_3,const_4,const_8,const_9,const_10])
            
            #set coefficients for constraint equations
            const_6.set_linear_coefficients({eta: 1})
            self.model.objective.set_linear_coefficients({eta: 1})

            #add current reaction to the sum for constraint 7
            const_7.set_linear_coefficients({eta: 1})
            
            self.alphas.update({alpha.name: alpha})
            self.betas.update({beta.name: beta})
            
        #add constraints to the model
        self.model.add_cons_vars(constraints, sloppy=False)
        
        #give the problem a name
        self.model.problem.name = "Stand-Alone TIC Finding Problem (TFP)"
        
        #write out the problem expression for debugging purposes
        #output.write("problem: "+str(const_7.problem)+"\n")
        
        #try to make sure that the model is good to go for solving
        self.model.solver.update()
        self.model.repair()
        
        #iterate over each phi, solving
        for phi in range(max_phi):
        
            #since multiple solutions possible at each value of phi, have while loop to try to capture each
            found_all = False
            
            #update constraints based on new reaction number
            #need to figure on what this is for syntax
            const_6.ub = int(phi)
            const_6.lb = int(phi)
            print("Working on phi = "+str(phi))
            
            self.model.tolerance = tolerance
            self.model.solver.update()
            self.model.repair()
            
            while not found_all:
                
                #try, errors might occur if infeasible enough who knows
                try: 
                
                    #ignore warnings since "infeasible" is a warning but a normal part of this tool
                    with warnings.catch_warnings():
                    
                        #ignores "infeasible" warnings since will probably happen frequently
                        warnings.simplefilter('ignore',category=UserWarning)
                        
                        #attempt to find a solution
                        self.model.repair()
                        self.model.solver.update()
                        
                        print("attempting to solve TFP...")
                        
                        #time how long the solution takes
                        start_time = time.time()
                        
                        tfp_solution = self.model.optimize()
                        
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
                    sum_alpha = 0
                    sum_beta = 0
                    
                    for rxn in self.model.reactions:
                        
                        #report the optimal results
                        #this is the only                         
                        if self.model.solver.primal_values.get('alpha_{}'.format(rxn.id)) == 1.0:
                        
                            #write all the details to the reporting file
                            output.write(str(rxn.id)+"\t"+str(rxn.origin)+"\t->\t\t"+str(rxn.flux)+"\n")
                            
                            #give a less detailed output to the command line
                            print(str(rxn.id)+"\t->")
                            sum_alpha = sum_alpha + 1
                            
                        elif self.model.solver.primal_values.get('beta_{}'.format(rxn.id)) == 1.0:
                        
                            #write all the details to the reporting file
                            output.write(str(rxn.id)+"\t"+str(rxn.origin)+"\t<-\t\t"+str(rxn.flux)+"\n")
                            #give a less detailed output to the command line
                            print(str(rxn.id)+"\t<-")
                            sum_beta = sum_beta + 1
                            
                        elif self.model.solver.primal_values.get('eta_{}'.format(rxn.id)) == 1.0:
                        
                            #if there is an eta value yet not an alpha or beta something went wrong
                            #hence the question marks in the report
                            output.write(str(rxn.id)+"\t"+str(rxn.origin)+"\t??\t\t"+str(rxn.flux)+"\n")
                            
                            #write to the command line that no direction was found for one of the reactions
                            print(str(rxn.id)+"\tXX")
                            
                        #also need to save the solutions for later referencing
                        #will use nested dictonaries to call first solution number then reaction id
                        #note that ronding because sometimes the values are imprecise, therefore we round to nearest integer so that we have not issues later
                        self.prev_alphas.update({"{}_{}".format(solution_number,rxn.id): round(self.model.solver.primal_values.get('alpha_{}'.format(rxn.id)))})
                        self.prev_betas.update({"{}_{}".format(solution_number,rxn.id): round(self.model.solver.primal_values.get('beta_{}'.format(rxn.id)))})
                    
                    #if a solution has been found, need to add an integer cut precluding that
                    #solution from being found in future
                    #some constraints also iterate over solutions
                    
                    #the binary variable gamma ensures that at minimum one of the integer cuts defiend below applies
                    gamma = self.model.problem.Variable(name='gamma_{}'.format(solution_number), lb=0, ub=1, type='binary')
                    gamma.soln_id = solution_number
                    
                    self.model.add_cons_vars([gamma], sloppy=False)
                    
                    #integer cut 1: ensure that all the alphas in a following solution are not the same as in any previous solution
                    #need to define constraint first
                    int_cut_1 = self.model.problem.Constraint(Zero,ub=sum_alpha)
                    self.model.add_cons_vars([int_cut_1], sloppy=False)
                    self.model.solver.update()
                    int_cut_1.set_linear_coefficients({gamma: 1})
                    
                    #OR
                    
                    #integer cut 2: ensure that all the betas are not the same as in any previous solution
                    int_cut_2 = self.model.problem.Constraint(Zero,ub=(sum_beta-1))
                    self.model.add_cons_vars([int_cut_2], sloppy=False)
                    self.model.solver.update()
                    int_cut_2.set_linear_coefficients({gamma: -1})
                    
                    #need to loop over all reactions to define coefficients for summation 
                    for rxn in self.model.reactions:
                        
                        #check to see if there is a coefficient for the 
                        if self.model.solver.primal_values.get('alpha_{}'.format(rxn.id)) == 1:
                            
                            #if there is a previous value of alpha then need to have a coefficient of 1
                            int_cut_1.set_linear_coefficients({self.alphas['alpha_{}'.format(rxn.id)]: 1})
                            
                        #check to see if there is a coefficient for the 
                        if self.model.solver.primal_values.get('beta_{}'.format(rxn.id)) == 1:
                        
                            #if there is a previous value of alpha then need to have a coefficient of 1
                            int_cut_2.set_linear_coefficients({self.betas['beta_{}'.format(rxn.id)]: 1})
                        
                    #write the time to get the solution
                    output.write("time to get solution: "+str(total_time)+" s\n")
                    
                    #update the solution number
                    solution_number = solution_number + 1
                    
                    #add another newline to space reported solutions
                    output.write("\n\n")
                
            #if here, then phi will be updated
            
        alg_end = time.time()
        total_alg_time = alg_end - alg_start
        output.write("total TFP runtime: "+str(total_alg_time)+" s")
            
        #return itself so can 
        return self