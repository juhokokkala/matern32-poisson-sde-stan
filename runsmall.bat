@ECHO OFF
REM Copyright (c) 2016 Juho Kokkala
REM This file is licensed under the MIT License.

REM Generate data
PYTHON generatedata.py

REM Run the samplers with the thinned data
MATERN32POISSON_SDE sample num_warmup=20000 num_samples=2000000 init=0 random seed=1 data file=small.data output file=output_small_SDE.csv
MATERN32POISSON_BASICGP sample num_warmup=20000 num_samples=2000000 init=0 random seed=1 data file=small.data output file=output_small_basicGP.csv
MATERN32POISSON_SDE_REPARAMETRIZED sample num_warmup=20000 num_samples=2000000 init=0 random seed=1 data file=small.data output file=output_small_SDE_reparametrized.csv
MATERN32POISSON_BASICGP_REPARAMETRIZED sample num_warmup=20000 num_samples=2000000 init=0 random seed=1 data file=small.data output file=output_small_basicGP_reparametrized.csv

REM Produce the stansummaries
\STAN\CMDSTAN-2.11.0\BIN\STANSUMMARY output_small_SDE.csv > summary_small_SDE.txt
\STAN\CMDSTAN-2.11.0\BIN\STANSUMMARY output_small_basicGP.csv > summary_small_basicGP.txt
\STAN\CMDSTAN-2.11.0\BIN\STANSUMMARY output_small_SDE_reparametrized.csv > summary_small_SDE_reparametrized.txt
\STAN\CMDSTAN-2.11.0\BIN\STANSUMMARY output_small_basicGP_reparametrized.csv > summary_small_basicGP_reparametrized.txt