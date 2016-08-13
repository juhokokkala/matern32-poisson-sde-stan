@ECHO OFF
REM Copyright (c) 2016 Juho Kokkala
REM This file is licensed under the MIT License.

REM Generate data
PYTHON generatedata.py

REM Run the samplers, save warmup
MATERN32POISSON_SDE sample save_warmup=1 init=0 random seed=1 data file=small.data output file=SDE_extra.csv
MATERN32POISSON_BASICGP sample save_warmup=1 init=0 random seed=1 data file=small.data output file=basicGP_extra.csv