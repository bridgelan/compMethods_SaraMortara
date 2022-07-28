# Which are the 5 most abundant species overall in the dataset? ================
#read abundance table
abundanceTable <- read.csv(file = "./data/raw/cestes/comm.csv",
                           header = TRUE)


# just want to sum the values in each column
# so I use apply only for the
abundanceSpecies <- apply(X = abundanceTable[3:ncol(abundanceTable)],
                          MARGIN = 2,
                          FUN = sum,
                          na.rm = TRUE)

sortedAbundance <- sort(abundanceSpecies)
fiveHighestAbundances <- tail(x=sortedAbundance, n=5)

# hold the names of the 5
# the names are in crescent order, so I have to invert the vector
fiveHighestNames <- rev(attributes(fiveHighestAbundances)$names)

#  How many species are there in each site? (Richness) =========================
# We have to create a new version of the matrix
# in which every value higher than one will be converted to one
binaryAbundanceTable <- ifelse(abundanceTable[,2:ncol(abundanceTable)] > 1, 1, 0)
# this does not work
# I know that this is not working because
# binaryAbundanceTable[1] is not a vector


abundanceSites <- apply(X=abundanceTable[,2:ncol(abundanceTable)],
                        MARGIN=1,
                        FUN=sum,
                        na.rm = TRUE)
