# ----------------------------------------------------------------------
# R Commands to read and prepare the data
# ----------------------------------------------------------------------
# Unzip the file
unzip("exdata%2Fdata%2Fhousehold_power_consumption.zip")

# The unzipped file has 126MB
# Checked and confirmed there is enought memory available

# Read the file and create a Dataframe
# After head(df) I realized the file is ";" separated
df <- read.csv("household_power_consumption.txt", sep=";")

# Check the class of the column Date
class(df$Date)
# Because it is not a Date column, convert it to date
df$Date <- as.Date(df$Date, "%d/%m/%Y")

# Now subset the dataframe selecting only the rows with the given dates
df <- subset(df, df$Date >= as.Date('2007-02-01') & df$Date <= as.Date('2007-02-02'))

# Now check the Dim to make sure I have a smaller file
dim(df)
# 2880 rows and 9 columns
head(df)

# Save the new df in disk using the write function (using sep=";" as the orignal file)
write.csv2(df, "HPC_2007-02-0102.txt", sep=";")

# convert the Date and Time into one column timestamp
library(lubridate)
dfd <- df %>% mutate(MyTimestamp = parse_date_time(paste(df$Date, df$Time), orders="Ymd HMS"))

# check whether the is any "?" character in any of the columns. To do that use subset(dfd, dfd[i] == "?")
subset(dfd, dfd[2] == "?")

# Convert columns to numeric
dfd$Global_active_power = as.numeric(as.character(dfd$Global_active_power))
dfd$Global_reactive_power = as.numeric(as.character(dfd$Global_reactive_power))
dfd$Sub_metering_1 = as.numeric(as.character(dfd$Sub_metering_1))
dfd$Sub_metering_2 = as.numeric(as.character(dfd$Sub_metering_2))
dfd$Sub_metering_3 = as.numeric(as.character(dfd$Sub_metering_3))
dfd$Voltage = as.numeric(as.character(dfd$Voltage))

# ----------------------------------------------------------------------
# R Commands to create the PLOT1
# ----------------------------------------------------------------------
par(mfcol=c(1,1))
hist(dfd$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")
dev.copy(png, "plot1.png")
dev.off()