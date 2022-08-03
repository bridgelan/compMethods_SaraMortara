# Which are the 5 most abundant species overall in the dataset? ================
#read abundance table
abundanceTable <- read.csv(file = "./data/raw/cestes/comm.csv",
                           header = TRUE)
numColAbunTable <- ncol(abundanceTable)
numRowAbunTable <- nrow(abundanceTable)

# Transform the first column to the row names
# Because if I treat them as names now,
# the numbers in this column will not be included
# in the next analyses
# 1. Capture the name
rownames(abundanceTable) <- abundanceTable[,1]
#2. Annulate the first column
abundanceTable[,1] <- NULL

# just want to sum the values in each column
# so I use apply only for the species after
abundanceSpecies <- apply(X = abundanceTable[2:ncol(abundanceTable)],
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
boolAbunTable <- abundanceTable > 1

abundanceSites <- apply(X=abundanceTable[,2:ncol(abundanceTable)],
                        MARGIN=1,
                        FUN=sum,
                        na.rm = TRUE)

#  Which species are the most abundant in each site? ===========================
# Eu terei de capturar o header da coluna que apresentar
# a maior abundancia para a especie



