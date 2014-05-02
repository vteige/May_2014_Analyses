### Make sure the timezone environment variable is set to UTC (the default time zone for BeACON data)
### if this is not done, R will assume all imported timestamps are in local time, which is defined by
### your computer clock.

Sys.setenv(TZ='UTC')

# import data from .csv....
# name the columns
names(arborvitae) <- c("Timestamp","CO2raw","rawerr","CO2wT","wTerr","CO2wTP","wTPerr","CO2corrr","correrr","v1","v2","v3","v4","v5","v6","v7")

# transform the times to R-readable format
arborvitae <- transform(arborvitae, Timestamp = as.POSIXct(Timestamp, format='%m-%d-%Y %H:%M:%S', tzone="UTC"))

# remove garbage data
arborvitae <- subset(arborvitae, CO2corrr != -999)
arborvitae <- subset(arborvitae, CO2corrr < 1000)

#change tzone attribute:
attr(arborvitae$Timestamp, "tzone") <- "America/Los_Angeles"

# calculate the hour of day and day of week values
arborvitae$dayofweek <- as.POSIXlt(arborvitae$Timestamp)$wday
arborvitae$hour <- as.POSIXlt(arborvitae$Timestamp)$hour

# prove that it worked by looking for a sensible diurnal cycle...

hour <- c(0:23)

arborvitae_median <- tapply(arborvitae$CO2corrr, arborvitae$hour, median)

arborvitae_median_df <- data.frame(hour,arborvitae_median)
colnames(arborvitae_median_df) <- c("hour","median")

arborvitae_diurnal <- ggplot(arborvitae_mean_df, aes(x=hour, y=mean)) +
  geom_point()
x11()
print(arborvitae_diurnal)


# Some other useful time-related commands

# Check the class of the timestamp (also useful for checking classes of other objects)
###   attributes(arborvitae$Timestamp)$class
# Check the timezone of the timestamp
###   attributes(arborvitae$Timestamp)$tzone
#change tzone attribute:
###   attr(arborvitae$Timestamp, "tzone") <- "UTC"
