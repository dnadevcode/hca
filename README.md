# HCA

Separate project folder for the HCA (Human Chromosome Analysis) and Bacterial chromosome analysis tool


# Structure

- src/+CBT/+HCA   	Code developed specifically for this project 
- bin/			Other code imported from different projects

- documentation/	Documentation
- data/			Data

# How to run:
matlab
addpath(genpath(pwd));

# GUI'S:
Hca_theory - theory
Hca_gui - experiments
Hca_run - same as gui but allows adding consensus and p-val calc
# /src/Scripts/ has a number of test scripts

## Test
results = runtests('pcc_compute_test.m') - other tests will be included in later versions
