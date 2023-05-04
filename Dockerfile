# syntax=docker/dockerfile:1

FROM gurobi/optimizer:latest as gurobi-stage
FROM julia:1.4.1 AS julia-stage
COPY install.jl install.jl
RUN julia install.jl
ARG LOCAL_GUROBI_LICENSE_PATH
ADD ${LOCAL_GUROBI_LICENSE_PATH} /opt/gurobi/gurobi.lic
ADD Exp1-Algorithm-Evaluation/ Exp1-Algorithm-Evaluation/
ADD src/ src/
ADD data/ data/
WORKDIR /Exp1-Algorithm-Evaluation/

# CMD julia Run_LoECC_Algorithms.jl
