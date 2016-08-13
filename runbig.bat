@ECHO OFF
REM Copyright (c) 2016 Juho Kokkala
REM This file is licensed under the MIT License.

REM Generate data
PYTHON generatedata.py

REM Run the samplers with the thinned data
MATERN32POISSON_SDE sample init=0 random seed=1 data file=big.data output file=output_big_SDE.csv
MATERN32POISSON_BASICGP sample init=0 random seed=1 data file=big.data output file=output_big_basicGP.csv
MATERN32POISSON_SDE_REPARAMETRIZED sample init=0 random seed=1 data file=big.data output file=output_big_SDE_reparametrized.csv
MATERN32POISSON_BASICGP_REPARAMETRIZED sample init=0 random seed=1 data file=big.data output file=output_big_basicGP_reparametrized.csv

REM Produce the stansummaries
\STAN\CMDSTAN-2.11.0\BIN\STANSUMMARY output_big_SDE.csv > summary_big_SDE.txt
\STAN\CMDSTAN-2.11.0\BIN\STANSUMMARY output_big_basicGP.csv > summary_big_basicGP.txt
\STAN\CMDSTAN-2.11.0\BIN\STANSUMMARY output_big_SDE_reparametrized.csv > summary_big_SDE_reparametrized.txt
\STAN\CMDSTAN-2.11.0\BIN\STANSUMMARY output_big_basicGP_reparametrized.csv > summary_big_basicGP_reparametrized.txt