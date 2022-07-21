# PLOTTING TIME SERIES

# IMPORTING LIBRARIES ========================================================
library(dplyr)
library(ggplot2)
library(lubridate) #manipulate dates
library(zoo) # calculate rolling mean of a variable

# IMPORTING DATA TABLE =======================================================
# this data came from Recife, https://brasil.io/
covid <- read.csv("data/raw/covid19-dd7bc8e57412439098d9b25129ae6f35.csv")
head(covid)

# CONVERTING DATE INFORMATION ===============================================
# First checking the class
class(covid$date)
# Changing to date format
covid$date <- as_date(covid$date)
# Checking the class
class(covid$date)
# Now we can make numeric operations
range(covid$date)


# PLOTTING THE GRAPH =========================================================
ggplot(covid) +
  geom_line(aes(x = date, y = new_confirmed)) +
  theme_minimal()

# Something unexpected... There are some observations
# with negative values for new confirmed cases
# the solution we will use is to convert negative values to zero
# Understand the operation:
# A. "covid$new_confirmed < 0" is a vector
# containing a logic value resultant of the verification
# "is the value of new_confirmed less than zero?"
# B. We use this vector of logic values to convert
# all observations with value less than zero to zero
covid$new_confirmed[covid$new_confirmed < 0] <- 0

#plot again
ggplot(covid) +
  geom_line(aes(x = date, y = new_confirmed)) +
  theme_minimal() +
  scale_x_date(date_breaks = "4 months", date_labels = "%y-%m") +
  labs(x = "Date", y = "New cases")

# CALCULATING AND PLOTTING ROLLING MEAN =====================================================
# rolling mean calculate the mean value for
# a specific quantity interval of days around each data point
# for each time point

# the "fill" parameter determines how the column should be filled
# if there's no mean to calculate (e.g., the first days of the dataset)
covid$roll_mean <- zoo::rollmean(covid$new_confirmed, 14, fill = NA)

ggplot(covid) +
  geom_line(aes(x = date, y = new_confirmed)) +
  theme_minimal() +
  scale_x_date(date_breaks = "4 months", date_labels = "%y-%m") +
  labs(x = "Date", y = "New cases") +
  geom_line(aes(x = date, y = roll_mean, color = "red"))
