# PLOTTING DIFFERENTIAL EQUATIONS - LOGISTIC GROWTH

# IMPORTING LIBRARIES ========================================================
library(deSolve) #for ode function
library(ggplot2) # because we will plot things
library(tidyr) # because we will manipulate some data
source("R_modules/logGrowth.R")

# DEFINING PARAMETERS FOR LOGISTIC GROWTH DIFF. EQUATIONS ====================
# named vector with parameters
p <- c(r = 1, a = 0.001)
# initial condition
y0 <- c(N = 10)
# time steps
t <- 1:20

# CALCULATE THE ODE ===========================================================
# give the function and the parameters to the ode function
out_log <- ode(y = y0, times = t, func = logGrowth, parms = p)

# CHECK THE STRUCTURE OF THE OUTPUT ===========================================
head(out_log)
class(out_log) #out_log is not a data.frame, but a deSolve matrix

# PLOTTING THE GRAPH =========================================================

# convert out_log to data.frame
df_log <- as.data.frame(out_log)
ggplot(df_log) +
  geom_line(aes(x = time, y = N)) +
  theme_classic()


