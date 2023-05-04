# README

This folder contains code for algorithms and experiments for the
paper "Overlapping and Robust Edge-Colored Clustering in Hypergraphs."

For questions about the code, contact alex.crane@utah.edu

## Replication
### System Requirements:
1. Docker
### Instructions:
0. Obtain a Gurobi WLS License and download the `gurobi.lic` file.
1. `docker build --build-arg LOCAL_GUROBI_LICENSE_PATH=<path-to-gurobi.lic> .`
2. `docker -v <local-path-to-data-directory>:Exp1-Algorithm-Evaluation/Output run <image-id> sh -c "<command>"`

