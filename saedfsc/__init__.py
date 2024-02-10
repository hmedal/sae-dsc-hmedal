import os
from pandas import read_csv, read_excel, DataFrame
import sae
from sae import COTSCar
import gurobipy as gp
from gurobipy import GRB
from gurobipy import quicksum as qsum
import numpy as np

from typing import List

import sys
sys.path.append('../')
import saedfsc

import sys
sys.path.append('../')
import saedfsc

# directory path
SAE_DFSCdir: str = os.path.dirname(__file__)

# read data into dataframes
suppliers: DataFrame = read_csv(SAE_DFSCdir + "/resources/suppliers.csv")
customers: DataFrame = read_csv(SAE_DFSCdir + "/resources/customers.csv")
qtyDiscountSchedule: DataFrame = read_csv(SAE_DFSCdir + "/resources/FullQuantityDiscountSchedule.csv")
procurementInfo: DataFrame = read_csv(SAE_DFSCdir + "/resources/procurementInfo.csv")
    
customersNames = saedfsc.customers['Name'].to_list()
cQty = dict(zip(saedfsc.customers['Name'], saedfsc.customers['Quantity'])) # customer quantities
cPriceFocus = dict(zip(saedfsc.customers['Name'], saedfsc.customers['PriceFocus']))
name_weights_dict = saedfsc.customers.set_index('Name')['PerformanceUtilityWeights'].to_dict()
cWts = {c : np.fromstring(name_weights_dict[c].strip('[]'), sep=',') for c in name_weights_dict}

maxProductPrice = 400000

seed = 1

def getCustomersDF(numCustomersTypes : int = 3):
    return read_csv(SAE_DFSCdir + "/resources/customers-{}.csv".format(numCustomersTypes))

def getCompetitorsDF(numCompetitors : int = 3):
    return read_csv(SAE_DFSCdir + "/resources/competitors-{}.csv".format(numCompetitors))

def getPartsDataFromWithRandomSuppliers(df):
    num_rows = df.shape[0]
    random_suppliers = [np.random.choice(suppliers['Name'], size = np.random.randint(low=1, high=4), replace=False) for _ in range(num_rows)]
    df['Suppliers'] = random_suppliers
    return df

def getPartOptionsWithSuppliers():
    parts = {}
    samples = 20
    np.random.seed(seed)

    wingparts = getPartsDataFromWithRandomSuppliers(sae.materials.merge(sae.wings, how='cross').sample(n=samples, random_state=seed))
    parts['wings'] = wingparts
    #parts['frontwing'] = wingparts
    #parts['sidewing'] = wingparts

    tireOptions = getPartsDataFromWithRandomSuppliers(sae.pressure.merge(sae.tires, how='cross'))
    parts['tires'] = tireOptions
    #parts['fronttire'] = tireOptions

    parts['engine'] = getPartsDataFromWithRandomSuppliers(sae.motors)
    parts['cabin'] = getPartsDataFromWithRandomSuppliers(sae.materials.merge(sae.cabins, how='cross').sample(n=samples, random_state=seed))
    parts['impactattenuator'] = getPartsDataFromWithRandomSuppliers(sae.materials.merge(sae.attenuators, how='cross').sample(n=samples, random_state=seed))
    parts['brakes'] = getPartsDataFromWithRandomSuppliers(sae.brakes)

    suspensionParts = getPartsDataFromWithRandomSuppliers(sae.suspension)
    parts['suspension'] = suspensionParts
    #parts['frontsuspension'] = suspensionParts
    return parts

def getTotalUtilityForCustomer(car : COTSCar, c : str, utilFn = 'partworth'):
    total_utility = 0
    pricePerf = (maxProductPrice - car.price) / maxProductPrice # Normalized price (0 is best, 1 is worst)
    if utilFn == 'partworth':
        product_utility = car.partworth_objectives(weights=cWtsPartworth[c])[0]
        total_utility += (1-cPriceFocus[c])*product_utility - cPriceFocus[c]*pricePerf
    elif utilFn == 'performance':
        product_utility = car.objectives(weights=cWtsPerf[c])[0]
        total_utility += (1-cPriceFocus[c])*product_utility + cPriceFocus[c]*pricePerf
    return total_utility

def getMarketShare(car : COTSCar, c : str, competitors : List[COTSCar], utilFn = 'partworth'): # based on logit model of demand
    carUtility = getTotalUtilityForCustomer(car, c, utilFn)
    totalCompetitorUtility = sum([getTotalUtilityForCustomer(competitorCar, c, utilFn) for competitorCar in competitors])
    return carUtility / (totalCompetitorUtility + carUtility)

def make_nominal_part_prices(broad_part_names, part_options):
    nominalPartPrices = {}
    for broad_part in broad_part_names:
        broad_part_price_dict = {}
        for specific_parts in range(len(part_options[broad_part])):
            if broad_part == 'wings':
                
                broad_part_price_dict[part_options['wings'].index[specific_parts]] = round(part_options['wings'].iloc[specific_parts]['length'] * 
                                                                                     part_options['wings'].iloc[specific_parts]['width'] * 
                                                                                     part_options['wings'].iloc[specific_parts]['height'] * 
                                                                                     part_options['wings'].iloc[specific_parts]['q'] * 
                                                                                     part_options['wings'].iloc[specific_parts]['cost_per_kilogram'], 2)
            
            elif broad_part == 'tires':
                
                broad_part_price_dict[part_options['tires'].index[specific_parts]] = round(part_options['tires'].iloc[specific_parts]['cost'] * 
                                                                                     (1 + (part_options['tires'].iloc[specific_parts]['pressure'] - 0.758) / 2), 2)
                                            
                
            elif broad_part == 'engine':
                
                broad_part_price_dict[part_options['engine'].index[specific_parts]] = round(part_options['engine'].iloc[specific_parts]['Cost'], 2)
                
            elif broad_part == 'cabin':
                
                broad_part_price_dict[part_options['cabin'].index[specific_parts]] = round(2 * 
                                                                                     part_options['cabin'].iloc[specific_parts]['thickness'] * 
                                                                                     (part_options['cabin'].iloc[specific_parts]['length'] * 
                                                                                      part_options['cabin'].iloc[specific_parts]['width'] + 
                                                                                      part_options['cabin'].iloc[specific_parts]['length'] * 
                                                                                      part_options['cabin'].iloc[specific_parts]['height'] + 
                                                                                      part_options['cabin'].iloc[specific_parts]['width'] * 
                                                                                      part_options['cabin'].iloc[specific_parts]['height']  
                                                                                     ) *
                                                                                     part_options['cabin'].iloc[specific_parts]['q'] * 
                                                                                     part_options['cabin'].iloc[specific_parts]['cost_per_kilogram'], 2)
                
            elif broad_part == 'brakes':
                
                broad_part_price_dict[part_options['brakes'].index[specific_parts]] = round(part_options['brakes'].iloc[specific_parts]['lbrk'] * 
                                                                                      part_options['brakes'].iloc[specific_parts]['wbrk'] * 
                                                                                      part_options['brakes'].iloc[specific_parts]['hbrk'] * 
                                                                                      part_options['brakes'].iloc[specific_parts]['qbrk'] * 
                                                                                      1000 * 
                                                                                      25, 2)
                                            
                
            elif broad_part == 'impactattenuator':
                
                broad_part_price_dict[part_options['impactattenuator'].index[specific_parts]] = round(part_options['impactattenuator'].iloc[specific_parts]['length'] * 
                                                                                                part_options['impactattenuator'].iloc[specific_parts]['width'] * 
                                                                                                part_options['impactattenuator'].iloc[specific_parts]['height'] * 
                                                                                                part_options['impactattenuator'].iloc[specific_parts]['q'] * 
                                                                                                part_options['impactattenuator'].iloc[specific_parts]['cost_per_kilogram'], 2)
                
                
            elif broad_part == 'suspension':
                
                broad_part_price_dict[part_options['suspension'].index[specific_parts]] = 0 # Assuming suspension has fixed cost and is "tuned" (Comment from Dr. McComb's code)
            
            
        nominalPartPrices[broad_part] = broad_part_price_dict
        
    return nominalPartPrices

def handleStatus(m : gp.Model):
    status = m.status
    if status == GRB.Status.INFEASIBLE:
        print("The model is infeasible. Computing IIS.")
        m.computeIIS()
        m.write('iismodel.ilp')
    elif status == GRB.Status.UNBOUNDED:
        print("The model is unbounded.")
    elif status == GRB.Status.OPTIMAL:
        print("The model is optimal.")
    elif status == GRB.Status.INF_OR_UNBD:  
        print("The model status is infeasible or unbounded. Set DualReductions parameter to 0 and reoptimize.")
    else:
        print("The model status is neither infeasible nor unbounded.")
