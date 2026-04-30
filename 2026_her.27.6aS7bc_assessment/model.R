## Run analysis, write model results

## Before: her6aS7bc_catch _index & _length
## After:

library(icesTAF)
library(cat3advice)

mkdir("model")


## Set life history parameters and natural mortality estimates calculated externally
k_value <- 0.339 #von bertalanfy k calculated from catch sampling length data
Loo <- 305 #L infinity calculated from catch sampling length data (mm)
M <- 0.220 #average natural mortality ages 3-6
gamma <- 1 # gamma value set to 1
theta <- k_value/M # theta value set to k over M

# set year of lowest observed survey SSB at time of benchmark
Iloss <- 2016


### load  catch data
her6aS7bc_catch <- read.csv("./data/her6aS7bc_catch.csv")
her6aS7bc_catch

### get reference catch
A <- A(her6aS7bc_catch, units = "tonnes")
A


### load index data
her6aS7bc_index <- read.csv("./data/her6aS7bc_index.csv")
her6aS7bc_index


### get most recent index value
i <- I(her6aS7bc_index, units = "tonnes")
i


### application in first year with new calculation of Itrigger
#b <- b(her6aS7bc_index, units = "tonnes")
#b

### in following years, Itrigger should NOT be updated
### i.e. provide value for Itrigger
### alternatively, the reference year for Iloss can be used
b <- b(her6aS7bc_index, units = "tonnes", yr_ref = Iloss)
b

### ICES advice style table
advice(b)

### plot index, Iloss and Itrigger
plot(b)

### Length at first capture
# load length data
her6aS7bc_length <- read.csv("./data/her6aS7bc_length.csv")
her6aS7bc_length

# calculate Lc for all years
lc <- Lc(her6aS7bc_length)
lc
plot(lc)

# Lc can change from year to year. Therefore, it is recommended to pool data from several (e.g. 5) years
lc <- Lc(her6aS7bc_length, pool = 2014:2021)
lc
plot(lc)

### Once defined, Lc should be kept constant and the same value used for all data years. 
### Lc should only be changed if there are strong changes in the fishery or data.

# WKCSNS benchmark 2022 used 2014:2022 data

### calculate annual mean length
lmean <- Lmean(data = her6aS7bc_length, Lc = lc, units = "mm")
lmean

plot(lmean)

### Target reference length 

# standard equation L(F=M)
# lref <- Lref(Lc = 235, Linf = 305, units = "mm")
# lref

#Deviations from the assumptions of F = M and M/k = 1.5 are possible following 
#Equation A.3 of Jardim, Azevedo, and Brites (2015) and can be used by providing 
#arguments gamma and theta to Lref().
# This approach was approved by the WKCSNS benchmark in 2022
lref <- Lref(Lc = lc, Linf = Loo, gamma = gamma, theta = theta, units = "mm")
lref

# Indicator
f <- f(Lmean = lmean, Lref = lref, units = "mm")
plot(f)

# ICES advice sheets typically show the inverse indicator ratio. 
# This can be plotted by adding an inverse = TRUE argument to plot():

plot(f, inverse = TRUE)


# The time series of the indicator values 
indicator(f)
# inverse_indicator(f)

### Harvest Rate

# combine catch and index data into single data.frame
df <- merge(her6aS7bc_catch, her6aS7bc_index, all = TRUE) # combine catch & index data

# calculate harvest rate
hr <- HR(df, units_catch = "tonnes", units_index = "tonnes")
hr
plot(hr)


### Harvest Rate Target: FproxyMSY
# Now we can use the indicator and (relative) harvest rate time series to 
# calculate the target harvest rate:

#calculate (relative) target harvest rate
F <- F(hr, f) 
F
plot(F)
# Note: The years selected for the target harvest rate are indicated by orange points

# POST 2024 STOCK SPECIFIC SIMULATION WORK WAS USED TO ESTIMATE Fproxy MSY
# THIS VALUE IS NOW SET At 0.13 
# (previous to 2026 this was 0.26 but WKLIFE recommended in 2026 not to artificially inflate this. 
#  They recommended to set m to 1 and Fmsy proxy, or HR msy proxy to 0.13, as had been calculated) 
class(F)
F@value
F@data
F@yr_ref
F@units
F@HR
F@indicator
F@hcr

F@value <- 0.13   # Set Fproxy at 0.13
F
plot(F)

### Multiplier m
# a tuning parameter and ensures that the catch advice is precautionary in the long term.
# By default, the value of m is set to 0.5. . The multiplier can be calculated 
# with the function m():
# m <- m(hcr = "chr")
# as per WKLIFE above, m is now set to 1
# m <- m(1)
m <- chr_m(1)
m

### Application of chr rule
advice <- chr(A = A, I = i, F = F, b = b, m = m)
advice
advice@m

# m still not set correctly, therefore manual override:
advice@m <- chr_m(1)
advice <- chr(advice)

advice(advice)



# Save settings
save(A, advice, b, f, F, hr, lmean, lref, lc, lmean, file='model/her6aS7bc_chr.Rdata')



