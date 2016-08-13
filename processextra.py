################################################################################
# Copyright (C) 2016 Juho Kokkala
#
# This file is licensed under the MIT License.
################################################################################
"""Script for processing the results of the extra test about numeric errors"""

import csv
import numpy as np
from matplotlib import pyplot as plt

def read_output(file):
    """Tool for reading the CmdStan output into Python """
    csvfile = open(file,'rt')
    csvreader = csv.reader(csvfile,delimiter=',')
    
    headerfound = False
    data = []
    header = []

    keepiterating = True
    while keepiterating:
        try:
            row = csvreader.__next__()
            if len(row)==0 or row[0][0] is '#':        
                pass    
            elif not headerfound:        
                header = row                               
                headerfound = True 
            else:       
                data.append([float(i) for i in row])                           
        except StopIteration:
            keepiterating = False
        except: #Some erroneous row in the file
            pass

    data = np.array(data)
    return header,data
    
## Load data, check that lp__ is the first
header0,data0 = read_output("basicGP_extra.csv")
header1,data1 = read_output("SDE_extra.csv")

print(header0[0])
print(header1[0])

##
plt.plot(np.arange(11,201),data0[10:200,0],'b-')
plt.plot(np.arange(11,201),data1[10:200,0],'r--')
plt.ylabel('lp__')
plt.xlabel('Chain step')
plt.legend(['basic GP','SDE'])
plt.show()
