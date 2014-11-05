### Construct plot 4 for course project 1 in Coursera course: Exploratory Data Analysis
### The file containing the data must be copied to the working directory

plot4 <- function() {
  ### Read in the data
  file <- 'household_power_consumption.txt'
  if(!file.exists(file)) stop('Data not found')
  colNames <- c('Date','Time','Global_active_power','Global_reactive_power','Voltage','Global_intensity','Sub_metering_1','Sub_metering_2','Sub_metering_3')
  ### Read in only data for 1/2/2007 and 2/2/2007
  ### 1/2/2007 00:00:00 is at line 66636
  start <- 66636
  ## Measurements are made at intervals of 1 minute (1 measurement corresponds to 1 row in the file)
  ### 1 measurement/minute * 60 minutes/hour * 24 hours/day * 2 days of observation = 2880 lines to 2/2/2007 23:59:00
  nobs <- 2880
  data <- read.csv(file, 
                   sep=';', 
                   col.names=colNames,
                   na.strings='?',
                   skip=start, 
                   nrows=nobs)
  data <- data.table(data)
  ### Create a datetime column containing the POSIXct time corresponding to the concatenated data and time
  data <- data[, datetime:=as.POSIXct(paste(Date, Time, sep=' '), format='%d/%m/%Y %H:%M:%S')]
  
  ### Make the plot
  png(file='plot4.png')
  par(mfrow=c(2,2))
  with(data, {
    plot(Global_active_power ~ datetime, type='l', xlab='', ylab='Global Active Power')
    plot(Voltage ~ datetime, type='l')
    {plot(Sub_metering_1 ~ datetime, type='l', col='black', xlab='', ylab='Energy sub metering')
     lines(Sub_metering_2 ~ datetime, col='red' )
     lines(Sub_metering_3 ~ datetime, col='blue')
     legend('topright', legend=c('Sub_metering_1', 'Sub_metering_2','Sub_metering_3'), col=c('black','red','blue'), lty=c(1,1,1), bty='n')  ### lty corresponds to line widths, bty='n' means no box is drawn around the legend 
    }
    plot(Global_reactive_power ~ datetime, type='l')
  })
  dev.off()
}