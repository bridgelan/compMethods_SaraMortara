# 12_diversity_metrics_1.R
# Professor Andrea Sanchez-Tapia
# 2022-07-28
# <https://scientific-computing.netlify.app/12_diversity_metrics_1.html>

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
abundanceSpecies <- apply(X = abundanceTable,
                          MARGIN = 2,
                          FUN = sum,
                          na.rm = TRUE)

# hold the names of the 5
# the names are in crescent order, so I have to invert the vector
sortedAbundance <- sort(abundanceSpecies)
fiveHighestAbundances <- tail(x=sortedAbundance, n=5)
fiveHighestNames <- rev(attributes(fiveHighestAbundances)$names)

#REMAINING TASKS: EXTRACT THE REAL NAME OF THE SPECIES FROM THE CESTES DATASET

#  How many species are there in each site? (Richness) =========================
# We have to create a new version of the matrix
# in which every value higher than one will be converted to one
boolAbunTable <- abundanceTable > 1

abundanceSites <- apply(X=abundanceTable[,2:ncol(abundanceTable)],
                        MARGIN=1,
                        FUN=sum,
                        na.rm = TRUE)


# Which species are the most abundant in each site? ===========================
# Eu terei de capturar o header da coluna que apresentar
# a maior abundancia para a especie
# O problema eh que a funcao which.max
# retorna o index do primeiro valor maximo do vetor

# agora eu tenho um conjunto de valores maximos
maxValues <- apply(X = abundanceTable,
                   MARGIN = 1,
                   FUN = max)

# discover the index positions of the maximum values
# first, create a logic matrix to retain the indexes of the maxValues in each line
# The positions of the matrix that have TRUE value
# are the positions with maxValues of
maxIndexes <- matrix(data=FALSE,
                    nrow=nrow(abundanceTable),
                    ncol=ncol(abundanceTable))


for (i in 1:nrow(abundanceTable)) {
  maxIndexes[i,] <- abundanceTable[i,] == maxValues[i]
}

# now,
for (i in 1:nrow(maxIndexes)) {

}



vetorzin <- matrix(ncol=2, nrow=2)
ncol=2


max(vetorzin)
matchPos <- match(vetorzin,max(vetorzin))
matchPos <- vetorzin == max(vetorzin)
#which() accepts only logical vectors
which(as.logical(matchPos))
names(abundanceTable)

abundanceTable$Sites

