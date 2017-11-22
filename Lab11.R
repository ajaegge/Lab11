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