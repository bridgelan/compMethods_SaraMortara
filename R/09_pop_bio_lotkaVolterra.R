# PLOTTING DIFFERENTIAL EQUATIONS - LOTKA VOLTERRA

# IMPORTING LIBRARIES ========================================================
library(deSolve) #for ode function
library(ggplot2) # because we will plot things
library(tidyr) # because we will manipulate some data
source("R_modules/lotkaVolterra.R") # the differential equation function

# DEFINING PARAMETERS FOR LOTKA VOLTERRA DIFF. EQUATIONS ====================
a <- matrix(c(0.02, 0.01, 0.01, 0.03), nrow = 2)
r <- c(1, 1)
p2 <- list(r, a)
N0 <- c(10, 10)
t2 <- c(1:100)

# CALCULATE THE ODE ===========================================================
out_lv <- ode(y = N0, times = t2, func = LVComp, parms = p2)

# CHECK THE STRUCTURE OF THE OUTPUT ===========================================
head(out_lv)
class(out_lv) #out_log is not a data.frame, but a deSolve matrix

# PLOTTING THE GRAPH =========================================================
#First, we have to convert out data in a format
# in which every variable is represented in a column
# and every observation is represented in a row.
# We will use the function pivot_longer() from the package tidyr.

# pivot_longer() function will create a new column,
# called name, which will receive the numberID
# of the selected columns (in this case, the columns titled "1" and "2")
# and then create a line for each observation
# MAKING THE DATA TIDIER
df_lv <- pivot_longer(as.data.frame(out_lv), cols = 2:3)

ggplot(df_lv) +
  geom_line(aes(x = time, y = value, color = name)) +
  labs(x = "Time", y = "N", color = "Species") +
  theme_classic()

