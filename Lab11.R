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
var <-"chlor_a"

#list netCDF files
f <- list.files("/Users/andreajaegge/Desktop/Lab11/chlor_a",pattern=".nc",full.names=F) #What pattern can you use to identify all the netCDF files?

#d <- plyr::adply(f, 1, function(file) {

#open netCDF file
data<-nc_open(file.choose('A2017291.L3m_DAY_CHL_chlor_a_4km.nc'), write = FALSE)

# extract data
lon<-ncvar_get(data,"lon")
lat<- ncvar_get(data, "lat")# get the latitude
tmp.array <- ncvar_get(data, var)
dunits <- ncatt_get(data, var, "units")$value
fillvalue <-NA #set the fill value for cells with no data
  
dim(tmp.array)

# remove the missing data
tmp.array[tmp.array == fillvalue] <- NA

#  matrix to data.frame
dimnames(tmp.array)<-list(lon=lon,lat=lat)
dat.var<-melt(tmp.array,id="lon")


# select data from the study area
dat.varSAtmp<-subset(dat.var, lon<=lonmax & lon>=lonmin & lat<=latmax & lat>=latmin)

# extract date information
dateini<-ncatt_get(data,0,"time_coverage_start")$value
dateend<-ncatt_get(data,0,"time_coverage_end")$value
datemean<-mean(c(as.Date(dateend,"%Y-%m-%dT%H:%M:%OSZ"),as.Date(dateini,"%Y-%m-%dT%H:%M:%OSZ")))
year <- format(as.Date(datemean, "%Y-%m-%dT%H:%M:%OSZ"), "%Y") # get the year
month <- format(as.Date(datemean, "%Y-%m-%dT%H:%M:%OSZ"), "%m") # get the month
day <- format(as.Date(datemean, "%Y-%m-%dT%H:%M:%OSZ"), "%d")# get the day
  
# prepare final data set. Include the day (it is missing in the code below)
dat.varSA<-data.frame(rep(as.integer(year,nrow(dat.varSAtmp))),rep(as.integer(month,nrow(dat.varSAtmp))), dat.varSAtmp, rep(dunits,nrow(dat.varSAtmp)), 
                      rep(var, nrow(dat.varSAtmp)))
names(dat.varSA)<-c("year","month","day","lon","value","unit","var")

