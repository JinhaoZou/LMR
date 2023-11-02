# LMR
Simulation code for longitudinal Mendelian Randomization model based on mixed effects model        
This is the 1.0 version of the LMR simulation code          
Simulation code are in the folder R/            
You can install it using code:         
`library(devtools)`     
`install_github("JinhaoZou/LMR")`  

## Overview
Other required packages can be installed through
`install.package("nlme")` (version 3.1-162 was used for manuscript)
Before run the code, package should be load
`library(nlme)`
`library(LMR)`

There are major three functions:
- Gen_Data.R, a function to generate simulated data
    - Example: `dat = Gen_Data(g11.0 = 0, g11.1 = 0)`, generating data with no causal effects of exposure on outcome
    - Example: `dat = Gen_Data(g11.0 = 1, g11.1 = 0)`, generating data with time-constant causal effects of exposure on outcome
    - Example: `dat = Gen_Data(g11.0 = 0, g11.1 = 0.05/12)`, generating data with time-varying causal effects of exposure on outcome
- Est_all.R, a function to estimate causal effects from generated data set
    - Example: `Est_all(dat)`
- Sim_all.R, a function to generate simulation replicates with estimated causal effects for selected scenrio setting
    - Example: `Sim_all(1, 100)`

## Examples for estimation
The sample data will be added in the folder /data
Name of data is called example_dat, which is a list include seven data frames: `t`, `Tt`, `X1`, `Y1`, `Y2`, `Z1`, `Z2`
