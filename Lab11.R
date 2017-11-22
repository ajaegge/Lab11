#install libraries
install.packages("ncdf4")
install.packages("reshape2")
library(ncdf4)
library(reshape2)

setwd("/Users/andreajaegge/Desktop/Lab11/chlor_a")

#set study area
lonmax <- -98.2 #top northern most coordinate
lonmin <- -80.9 #bott0m southern coordinate
latmax <- 30.7 #left eastern coordinate
latmin <- 17.9#right western coordinate

# identify the variable you want to extract data for
var <-"chlor_a"

#list netCDF files
f <- list.files(pattern=".nc",full.names=F) #What pattern can you use to identify all the netCDF files?

f

#d <- plyr::adply(f, 1, function(file) {

#open netCDF file
data<-nc_open(file)

# extract data
lon<-ncvar_get(data,"lon")
lat<- ncvar_get(data, "lat")# get the latitude
tmp.array <- ncvar_get(data, var)
dunits <- ncatt_get(data, var, "units")$value
fillvalue <- -999 #set the fill value for cells with no data

dim(tmp.array)

# remove the missing data
tmp.array[tmp.array == fillvalue] <- NA

#  matrix to data.frame
dimnames(tmp.array)<-list(lon=lon,lat=lat)
dat.var<-melt(tmp.array,id="lon")


# select data from the study area
dat.varSAtmp<-subset(dat.var, lon>=lonmax & lon<=lonmin & lat<=latmax & lat>=latmin)

# extract date information
dateini<-ncatt_get(data,0,"time_coverage_start")$value
dateend<-ncatt_get(data,0,"time_coverage_end")$value
datemean<-mean(c(as.Date(dateend,"%Y-%m-%dT%H:%M:%OSZ"),as.Date(dateini,"%Y-%m-%dT%H:%M:%OSZ")))
year <- format(as.Date(datemean, "%Y-%m-%dT%H:%M:%OSZ"), "%Y") # get the year
month <- format(as.Date(datemean, "%Y-%m-%dT%H:%M:%OSZ"), "%m") # get the month
day <- format(as.Date(datemean, "%Y-%m-%dT%H:%M:%OSZ"), "%d")# get the day
  
# prepare final data set. Include the day (it is missing in the code below)
dat.varSA<-data.frame(rep(as.integer(year,nrow(dat.varSAtmp))), rep(as.integer(month,nrow(dat.varSAtmp))), 
                      rep(as.integer(day,nrow(dat.varSAtmp))), dat.varSAtmp, rep(dunits,nrow(dat.varSAtmp)), 
                      rep(var, nrow(dat.varSAtmp)))
names(dat.varSA)<-c("year","month","day","lon","value","unit","var")

# close connection
nc_close(data)

return(dat.varSA)

}, .progress="text", .inform = T)

d <- d[,-1]

#save csv

summary(d)
write.table(d, "chl_a.txt", sep="\t", row.names=FALSE)
write.table(summary(d), "chl_a.txt", sep="\t", row.names=FALSE)
