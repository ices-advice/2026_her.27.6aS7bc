## Prepare plots and tables for report

library(icesTAF)
library(cat3advice)

mkdir("report")

#load model outputs

load("./output/her6aS7bc_chr.RData")


# save the advice summary data to a file
sink('./report/advice_summary.txt')
advice(advice)
sink()

sink('./report/indicator.csv')
indicator(f)
sink()

# Save the plots
taf.png("biomass_index.png")
plot(advice@b)
dev.off()

taf.png("Fproxymsy_LBI_HR.png")
plot(advice@F)
dev.off()

taf.png("harvest_rate.png")
plot(hr)
dev.off()

taf.png("inverse_fishing_pressure_proxy.png")
plot(f, inverse = TRUE)
dev.off()

taf.png("Lmean_byYear.png")
plot(lmean)
dev.off()




