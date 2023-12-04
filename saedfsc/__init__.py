import os
from pandas import read_csv, read_excel, DataFrame
import sae
import gurobipy as gp
from gurobipy import GRB

import sys
sys.path.append('../')
import saedfsc

# directory path
SAE_DFSCdir: str = os.path.dirname(__file__)

# read data into dataframes
products: DataFrame = read_csv(SAE_DFSCdir + "/resources/products.csv")

#class COSTSCarFramework():
#    pass

class ProductFamilyGurobipyModel():    
    
    def __init__(self):
        car = sae.COTSCar()
        self.m = gp.Model()
        self.parttypes = [sae.materials, sae.tires, sae.motors, sae.brakes, 
                     sae.suspension]
        sae.materials.name = 'materials'
        sae.tires.name = 'tires'
        sae.motors.name = 'motors'
        sae.brakes.name = 'brakes'
        sae.suspension.name = 'suspension'
        self.names = [parttype.name for parttype in self.parttypes]
        self.prodIndices = saedfsc.products.index.values
        self._create_vars()
        self._addConstrs()
        
    def _create_vars(self):
        self._create_discrete_vars()
        self._create_continuous_vars()
    
    def _create_continuous_vars(self):
        names = sae.params['variable'].tolist()
        self.y = self.m.addVars(self.prodIndices, names, 
                                         name="y")
        
    def _create_discrete_vars(self): 
        self.x = {}
        for df in self.parttypes:
            self.x[df.name] = self.m.addVars(self.prodIndices, df.index.values, 
                                   vtype=GRB.BINARY, name="x[" + df.name + "]")
            
    def _addConstrs(self):
        self._addChoiceConstrs()
        
    def _addChoiceConstrs(self):
        self.m.addConstrs((self.x[name].sum(p, '*') == 1 for name in self.names 
                                                    for p in self.prodIndices))
