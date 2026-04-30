##############################################################################################
## Read in and Prepare Survey (index), Catch and Length Frequency Input Files
#############################################################################################

library(icesTAF)

mkdir("data")


## Import data - Survey biomass index, catch data; length frequency data -----

(her6aS7bc_catch <- read.csv("./boot/initial/data/her6aS7bc_catch.csv",header = TRUE ) )

(her6aS7bc_index <- read.csv("./boot/initial/data/her6aS7bc_index.csv") )

(her6aS7bc_length <- read.csv("./boot/initial/data/her6aS7bc_length.csv") )



## Write out the csv files
write.taf(her6aS7bc_catch, dir="data")
write.taf(her6aS7bc_index, dir="data")
write.taf(her6aS7bc_length, dir="data")
