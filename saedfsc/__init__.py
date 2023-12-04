import os
from pandas import read_csv, read_excel, DataFrame

# directory path
SAE_DFSCdir: str = os.path.dirname(__file__)

# read data into dataframes
products: DataFrame = read_csv(SAE_DFSCdir + "/resources/products.csv")
