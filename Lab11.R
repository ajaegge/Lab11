#install libraries
install.packages("ncdf4")
install.packages("reshape2")
library(ncdf4)
library(reshape2)

#set study area
lonmax <- 30.7 #top northern most coordinate
lonmin <-17.9 #bott0m southern coordinate
latmax <- -98.2 #left eastern coordinate
latmin <- -80.9#right western coordinate

# identify the variable you want to extract data for
var <-"chl_a"

#list netCDF files
f <- list.files("/Users/andreajaegge/Desktop/Lab11/chlor_a",pattern=".nc",full.names=F) #What pattern can you use to identify all the netCDF files?

#d <- plyr::adply(f, 1, function(file) {

#open netCDF file
data<-nc_open(file.choose('A2017291.L3m_DAY_CHL_chlor_a_4km.nc'), write = FALSE)

