# --------------------------------------------------#
# Scientific computing
# ICTP/Serrapilheira 2022
# Script to fit linear model in R
# First version 2022-07-18
# --------------------------------------------------#

# loading packages
library(ggplot2)

# reading data
# cat is the keyword of a function from the "base" package
# so we substituted each occurence of "cat" by "crawley"
crawley <- read.csv("data/raw/crawley_regression.csv")

# Do leaf chemical compounds affect the growth of caterpillars? ----------------

# the response variable
boxplot(crawley$growth, col = "darkgreen")

# the predictor variable
unique(crawley$tannin)

# creating the linear model
mod_crawley <- lm(growth ~ tannin, data = crawley)

summary(mod_crawley)


## ----lm-plot------------------------------------------------------------------
plot(growth ~ tannin, data = crawley, bty = 'l', pch = 19)

a <- coef(mod_crawley)[0]
b <- coef(mod_crawley)[1]


abline(mod_crawley, col = "red", lwd = 2)
abline(a = a, b = b, col = "blue", lwd = 2)

## ----lm-ggplot----------------------------------------------------------------
ggplot(data = crawley, mapping = aes(x = tannin, y = growth)) +
  geom_point() +
  geom_smooth(method = lm) +
  theme_classic()



## AOV table
# AOV is the same as ANOVA
summary.aov(mod_crawley)


## fitted values
predict(mod_crawley)
crawley$fitted <- predict(mod_crawley)

# Comparing fitted vs. observed values
ggplot(data = crawley) +
  geom_point(aes(x = growth, y = fitted)) +
  geom_abline(aes(slope = 1,  intercept = 0)) +
  theme_classic()


## Model diagnostics -----------------------------------------------------------
# This option generates 4 graphs:
# Residuals vs. Fitted
# Normal Q-Q
# Scale-Location
# Residuals vs. Leverage
par(mfrow = c(2, 2))
plot(mod_crawley)
par(mfrow = c(1, 1))


# Comparing statistical distributions ------------------------------------------
library(fitdistrplus)

data("groundbeef")
?groundbeef
str(groundbeef)

# plot the histogram of the distribution,
# accompanied by the density regression line
# and cumulative distribution points
plotdist(groundbeef$serving, histo = TRUE, demp = TRUE)

# it displays a Cullen and Frey graph
# to show if the distribution is close to a classic one
# (Gaussian, uniform, exponential, logistic, beta, lognormal, gamma or weibull)
descdist(groundbeef$serving, boot = 1000)

fw <- fitdist(groundbeef$serving, "weibull")
summary(fw)

fg <- fitdist(groundbeef$serving, "gamma")
fln <- fitdist(groundbeef$serving, "lnorm")

par(mfrow = c(2, 2))
plot_legend <- c("Weibull", "lognormal", "gamma")
# histogram and theoretical density graph
denscomp(list(fw, fln, fg), legendtext = plot_legend)
# Q-Q plot graph
qqcomp(list(fw, fln, fg), legendtext = plot_legend)
# Empirical and theoretical CDFs
cdfcomp(list(fw, fln, fg), legendtext = plot_legend)
# P-P plot
ppcomp(list(fw, fln, fg), legendtext = plot_legend)

# execute goodness-of-fit statistics and criteria analysis
# including Kolmogorov-Smirnov, Cramer-von Mises and Anderson-Darling statistics
# and Akaike's and Bayesian Information Criterions
gofstat(list(fw, fln, fg))


