## Linear time evaluation of Matérn 3/2 GP density in Stan using the SDE representation

A demonstration of how the density of a one-dimensional Matérn 3/2 Gaussian process may be evaluated sequentially in Stan (http://mc-stan.org), which in turn speeds up inference if the number of input points is high. A detailed description/documentation shall is in my blog, http://www.juhokokkala.fi/blog/posts/linear-time-evaluation-of-matern-32-gp-density-in-stan-using-the-sde-representation/. 

The .stan files are the versions of the Stan model. summary*.txt contains the outputs of the stansummary tool of CmdStan with my precomputed results. Simulated data is generated with generatedata.py, which requires GPy (https://github.com/SheffieldML/GPy/). Alternatively, this repository contains pregenerated .data files. 

## Replication Instructions

Given as MS-DOS/Windows style batch files -- runsmall.bat runs the samplers with thinned data and runbig.bat with complete data. These files should be readable (thouch not executable) replication instructions for CmdStan users on other platforms, too. 

The additional test related to numeric inaccuracies is run by runextra.bat and the file processextra.py is used for drawing. 

The files run*.bat have the following prerequisites:
- CmdStan 2.11.0 needs to be installed at \stan\cmdstan-2.11.0\
- The .stan files need to be compiled so that the current directory contains Matern32Poisson_basicGP.exe, Matern32Poisson_SDE.exe, Matern32Poisson_basicGP_reparametrization.exe, and Matern32Poisson_SDE_reparametrization.exe.

## License information

Copyright (c) Juho Kokkala 2016. All files in this repository are licensed under the MIT License. See the file LICENSE or http://opensource.org/licenses/MIT. 