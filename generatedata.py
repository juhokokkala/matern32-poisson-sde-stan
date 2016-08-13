################################################################################
# Copyright (C) 2016 Juho Kokkala
#
# This file is licensed under the MIT License.
################################################################################
"""Script for simulating the data and writing it into the Stan R format"""

import GPy #GPy 1.0.7 was used
import numpy as np

##Parameters 

dt = 0.01
lscale = 0.2
stdev = 1
mu = 3
T = 100

##Compute the GP covariance

kernel = GPy.kern.Matern32(1,lengthscale=lscale,variance=stdev**2)
Sigma = kernel.K(dt*np.arange(0,T)[:,None],dt*np.arange(0,T)[:,None])

##Simulate data

np.random.seed(1)

intensity = np.exp( np.random.multivariate_normal(np.tile(mu,T),Sigma))
y = np.random.poisson(intensity)

## Function for writing into Stan format

def writedata(outfilename,y,dt):
    outfile = open(outfilename,'w')
    N = y.shape[0]
    outfile.write('N<-'+str(N)+'\n')
    outfile.write('dt<-'+str(dt)+'\n')    
    outfile.write('y<-c(')
    for i in range(N-1):
        outfile.write(str(y[i])+",")
    outfile.write(str(y[-1])+")\n")
    
## Write data into files

writedata("small.data",y[::20],20*dt)
writedata("big.data",y,dt)