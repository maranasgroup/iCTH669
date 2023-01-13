##!/usr/bin/python

#try to specify that we will use python version 3.9
__author__ = "Wheaton Schroeder"
#latest version: 09/15/2022

#written to implement OptStoich
#algorithm based on:
#Title: Designing overall stoichiometric conversions and intervening metabolic reactions
#Authors: Chowdhury, Anupam; Maranas, Costas D.
#Journal: Scientific Reports
#Year: 2015

#These are the imports I have used in past for cobrapy, so will use them here as well, not sure the the necessity of any of these
#from __future__ import absolute_import

from optlang.interface import OPTIMAL, FEASIBLE, INFEASIBLE, ITERATION_LIMIT, NUMERIC, SUBOPTIMAL, TIME_LIMIT
from optlang.symbolics import Zero, add

import os
import sys
import warnings
import re
import cobra
import time
from datetime import datetime

import copy

from cobra import Model, Reaction, Metabolite, Solution
from sympy import proper_divisors

#now that we have defined the import library, let us create a class for the mintransfers algorithm
class OptStoic(object):

  #initialization of class:
  #self - needs to be passed itself
  #model - model which OptStoich will be applied to
  #database - database which can be used with OptStoic to identify
  def __init__(self,bigM=10000):

    #not much to initialize here for the object
    self.bigM = bigM                                    #set the bigM value

    #initialize the model
    self.OptStoic_model = Model(name = "OptStoich Model")

    #initialize dummy objective
    self.OptStoic_model.objective = self.OptStoic_model.problem.Objective(Zero, direction='max')

  #set up OptStoich
  #reacts - list of reaction IDs (generally exchange or demand reactions) to act as "reactants"
  #prods - list of product IDs (generally exchange or sink reactions) to act as "products"
  #atoms - list of atomic species to consider
  #n_mq - dictionary of dictionaries, first index is molecular species, second is atomic species
  #e_m - dictionary containing charges of molecular species
  #DGf_m - dictionary containg standard energy of formation for molecular species
  #DGf_min - minimum allowed energy of formation for the reaction stoichiometry
  #basis - ID of the reactant or product to use as the basis of calculation for the coefficients, basis will always have a coefficient of 1
  #note: can't think of a good way to pass an objective, objectives will need to be defined in the calling script
  def setup(self,reacts,prods,atoms,n_mq,e_m,DGf_m,DGf_min,basis):
  
    #create a model to use for OptStoic, particularly for adding constraints
    self.OptStoic_model.solver.update()
    self.OptStoic_model.repair()

    self.model_instance = self.OptStoic_model.copy()

    self.model_instance.solver.update()
    self.model_instance.repair()

    #save the data passed in so we don't lose it
    self.reacts = reacts
    self.prods = prods
    self.atoms = atoms
    self.n_mq = n_mq
    self.e_m = e_m
    self.DGf_m = DGf_m
    self.basis = basis
    self.DGf_min = DGf_min

    #create dictionaries of variable references for reactants and products
    atom_const = []

    #initialize the atom balance constraints
    #there will be one constraint for each atom to ensure balance 
    for atom in atoms:

      #create a constraint to the model for this atom
      atom_const.append(self.model_instance.problem.Constraint(Zero,lb=0,ub=0,name='atom_bal_{}'.format(atom),sloppy=False))

    #add the atomic balance constraints to the model
    self.model_instance.add_cons_vars(atom_const, sloppy=False)

    #repair model and pointers
    self.model_instance.solver.update()
    self.model_instance.repair()

    #next add the overall energy balance constraint, same setup, subtract reactants, add products
    #create a constraint to the model for this atom
    charge_const = self.model_instance.problem.Constraint(Zero,lb=0,ub=0,name='charge_bal',sloppy=False)

    #add the constraint to the model
    self.model_instance.add_cons_vars([charge_const])

    #repair model and pointers
    self.model_instance.solver.update()
    self.model_instance.repair()

    #next, build the thermodynamic constraint
    #now build the energy of formation
    thermo_const = self.model_instance.problem.Constraint(Zero,lb=0-self.bigM,ub=-self.DGf_min,name='thermo_const',sloppy=False)

    #add the constraint to the model
    self.model_instance.add_cons_vars([thermo_const])

    #repair model and pointers
    self.model_instance.solver.update()
    self.model_instance.repair()

    #build variables for the product and reactant coefficients
    #while building variables, add them to the appropraite constraints
    for react in reacts:

      #create the variable
      reac_var = self.model_instance.problem.Variable(name='R_{}'.format(react),lb=0,ub=self.bigM,sloppy=False)

      #add the new variable to the model
      self.model_instance.add_cons_vars(reac_var, sloppy=False)

      #repair model and pointers
      self.model_instance.solver.update()
      self.model_instance.repair()
      
      #if the variable is the basis, fix the value
      if re.match(basis, react):

        #set basis to have a coefficient of 1
        #this is my "h" equation in the OptStoich paper
        reac_var.set_bounds(1,1)

      #this variable will appear in in each atom constraint
      for atom in atoms:

        #set coefficient in atomic constraints
        atom_const[self.atoms.index(atom)].set_linear_coefficients({reac_var: -self.n_mq[react][atom]})

      #each species appears in the single charge constraint once
      charge_const.set_linear_coefficients({reac_var: -self.e_m[react]})

      #repair model and pointers
      self.model_instance.solver.update()
      self.model_instance.repair()

      #each species appears in the thermo constraint once
      thermo_const.set_linear_coefficients({reac_var: -self.DGf_m[react]})

      #repair model and pointers
      self.model_instance.solver.update()
      self.model_instance.repair()

    #build variables for the product and reactant coefficients
    for prod in prods:

      prod_var = self.model_instance.problem.Variable(name='P_{}'.format(prod),lb=0,ub=self.bigM,sloppy=False)

      #add the new variable to the model
      self.model_instance.add_cons_vars(prod_var, sloppy=False)

      #repair model and pointers
      self.model_instance.solver.update()
      self.model_instance.repair()

      #if the variable is the basis, fix the value
      if re.match(basis, prod):

        #set basis to have a coefficient of 1
        #this is my "h" equation in the OptStoich paper
        prod_var.set_bounds(1,1)

      #this variable will appear in in each atom constraint
      for atom in atoms:

        #set coefficient in atomic constraints
        atom_const[self.atoms.index(atom)].set_linear_coefficients({prod_var: self.n_mq[prod][atom]})
        
      #each species appears in the single charge constraint
      charge_const.set_linear_coefficients({prod_var: self.e_m[prod]})

      #repair model and pointers
      self.model_instance.solver.update()
      self.model_instance.repair()

      #each species appears in the thermo constraint once
      thermo_const.set_linear_coefficients({prod_var: self.DGf_m[prod]})

      #repair model and pointers
      self.model_instance.solver.update()
      self.model_instance.repair()

  #set objective of optstoic 
  #obj_var - variable to use for objective
  #dir - objective direction
  #obj_coeff - coefficient of objective variable
  #note: later can probably generalize this to be a linear equation
  def set_objective(self,obj_var,dir="max",obj_coeff=1):

    #obj_var will be the name of the variable to maximize
    self.model_instance.objective.set_linear_coefficients({self.model_instance.variables[obj_var]: obj_coeff})    
    
    #set the direction
    self.model_instance.objective.direction = dir

  #sove the problem
  def solve(self):

    #put in try except structure, in case of errors
    try:

      print("attempting to solve OptStoic...")
                        
      #time how long the solution takes
      start_time = time.time()
                        
      OptStoic_soln = self.model_instance.optimize()
                        
      end_time = time.time()
                        
      total_time = end_time - start_time
                        
      print("complete, total time: "+str(total_time)+"\n")

      if re.search("infeasible",OptStoic_soln.status):

        #if no errors, return true so we can say it worked
        return False

      else:

        #return
      
        #return false to say we have no solution
        return OptStoic_soln

    except:

      #report an error has happended
      print("error occured!\n")

      #if there was errors, return false to say it didn't work
      return False

  #allow certain variables to have custom bounds
  def set_bounds(self,var,lb=-10000,ub=10000):

    #obj_var will be the name of the variable to maximize
    self.model_instance.variables[var].lb = lb
    self.model_instance.variables[var].lb = lb

  #create a neat way to display the problem being solved, useful for debugging
  def display_problem(self):

    print(self.model_instance.objective)

    print("\nsubject to:\n")

    for const in self.model_instance.constraints:

      print(const)

    print("\n variable bounds:\n")

    for var in self.model_instance.variables:

      print(var)