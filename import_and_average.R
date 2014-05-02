Sys.setenv(TZ='UTC')

# import data from .csv....

sequoia <- read.csv("C:/Users/Jill/Google Drive/Data Analysis/04-23-2014/sequoia.csv", header=F)

# name the columns
names(sequoia) <- c("Timestamp","CO2raw","rawerr","CO2wT","wTerr","CO2wTP","wTPerr","CO2corr","correrr","v1","v2","v3","v4","v5","v6","v7")

# transform the times to R-readable format
sequoia <- transform(sequoia, Timestamp = as.POSIXct(Timestamp, format='%m-%d-%Y %H:%M:%S', tzone="UTC"))

# remove garbage data
sequoia <- subset(sequoia, CO2corr != -999)
sequoia <- subset(sequoia, CO2corr < 1000)

#change tzone attribute:
attr(sequoia$Timestamp, "tzone") <- "America/Los_Angeles"

# calculate the hour of day and day of week values
sequoia$dayofweek <- as.POSIXlt(sequoia$Timestamp)$wday
sequoia$hour <- as.POSIXlt(sequoia$Timestamp)$hour

# prove that it worked by looking for a sensible diurnal cycle...

hour <- c(0:23)

# calculate statistics on the data, then produce a data.frame from the statistics
hourly_sequoia_median <- tapply(sequoia$CO2corr, sequoia$hour, median)
hourly_sequoia_mean <- tapply(sequoia$CO2corr, sequoia$hour, mean)
hourly_sequoia_min <- tapply(sequoia$CO2corr, sequoia$hour, min)
hourly_sequoia_max <- tapply(sequoia$CO2corr, sequoia$hour, max)
hourly_sequoia_sd <- tapply(sequoia$CO2corr, sequoia$hour, sd)
sequoia_df <- data.frame(hour, hourly_sequoia_mean, hourly_sequoia_median, 
                         hourly_sequoia_min, hourly_sequoia_max, hourly_sequoia_sd)
colnames(sequoia_df) <- c("hour","meanCO2","medianCO2","minCO2","maxCO2","stdev")

toChron <- function(Timestamp) as.chron(paste(Timestamp))
sequoia_chron <- read.zoo(sequoia, FUN = toChron)

sequoia_5 <- aggregate(sequoia_chron, trunc(time(sequoia_chron), "00:05:00"), mean)
sequoia_5_df <- fortify.zoo(sequoia_5, melt=FALSE)
remove(sequoia_5)
sequoia_5_df <- transform(sequoia_5_df, Timestamp = as.POSIXct(Index, format='%m-%d-%Y %H:%M:%S', tz='UTC'))
attr(sequoia_5_df$Timestamp, "tzone") <- "America/Los_Angeles"

sequoia_15 <- aggregate(sequoia_chron, trunc(time(sequoia_chron), "00:15:00"), mean)
sequoia_15_df <- fortify.zoo(sequoia_15, melt=FALSE)
remove(sequoia_15)
sequoia_15_df <- transform(sequoia_15_df, Timestamp = as.POSIXct(Index, format='%m-%d-%Y %H:%M:%S', tz='UTC'))
attr(sequoia_15_df$Timestamp, "tzone") <- "America/Los_Angeles"

sequoia_60 <- aggregate(sequoia_chron, trunc(time(sequoia_chron), "01:00:00"), mean)
sequoia_60_df <- fortify.zoo(sequoia_60, melt=FALSE)
remove(sequoia_60)
sequoia_60_df <- transform(sequoia_60_df, Timestamp = as.POSIXct(Index, format='%m-%d-%Y %H:%M:%S', tz='UTC'))
attr(sequoia_60_df$Timestamp, "tzone") <- "America/Los_Angeles"

sequoia_day <- aggregate(sequoia_chron, trunc(time(sequoia_chron), "23:59:59"), mean)
sequoia_day_df <- fortify.zoo(sequoia_day, melt=FALSE)
remove(sequoia_day)
sequoia_day_df <- transform(sequoia_day_df, Timestamp = as.POSIXct(Index, format='%m-%d-%Y %H:%M:%S', tz='UTC'))
attr(sequoia_day_df$Timestamp, "tzone") <- "America/Los_Angeles"