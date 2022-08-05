# IMPORTING LIBRARIES
library(tidyverse)
library(dplyr)
library(vegan)

# ABSORBING FILES FROM CESTES DATABASE =========================================

# listar arquivos da pasta "data/raw/cestes"
comm <- read.csv(file = "data/raw/cestes/comm.csv")
traits <- read.csv(file = "data/raw/cestes/traits.csv")


# PROCESS THE COLUMNS OF DATA.FRAME=============================================
# let's confirm that the first column of "comm" is numeric
attributes(comm)

# it is numeric... we have to transform them in "character"
rownames(comm) <- paste0("Site", comm[,1])
comm <- comm[,-1]
head(comm)[,1:6]

# STARTING THE PROCESS =========================================================
richness <- vegan::specnumber(comm)


