# Scientific programming course ICTP-Serrapilheira July-2022
# Class #03: Scientific workflows
# Reading raw data, writing processed data, functions of apply family, for loop, writing outputs: tables and figs

# Reading data -----------------------------------------------------------------

# Listing all files from the dir whose name ends with ".csv"
cestes_files <- list.files(path = "data/raw/cestes",
                           pattern = "csv$",
                           full.names = TRUE)

# process the filenames,
# removing the directory path through basename()
# and removing the string ".csv" at the end of the filename
# parameter "fixed" makes the characters to be processed exactly how they are
# i.e., special regex characters are interpreted as normal ones
cestes_names <- gsub(".csv", "", basename(cestes_files), fixed = TRUE)

# to show how read.csv works
envir <- read.csv(cestes_files[3])

# process all files using read.csv()
data_list <- lapply(cestes_files, read.csv)
# attribute to each element of data_list
# the processed names contained in cestes_names
names(data_list) <- cestes_names
length(data_list)

# Inspecting data
head(data_list$envir)
dim(data_list$envir)
summary(data_list$envir)

# Output 1: summary table ------------------------------------------------------

# Creating summary table for all environmental variables
sd(envir$Clay)
#envir[, -1] is envir without the first column "Site"
envir_mean <- apply(envir[, -1], 2, mean)
envir_sd <- apply(envir[, -1], 2, sd)

# Creating a function in R -----------------------------------------------------
std <- function(x, round = FALSE, ...) {
  std <- sd(x) / sqrt(length(x))
  if (round) std <- round(std, ...)
  return(std)
}

std(envir$Clay, round = TRUE, digits = 2)

envir_std <- apply(envir[, -1], 2, std, round = TRUE, digits = 2)

# montar um dataframe com a media e a variancia de cada data.frame
envir_tbl <- data.frame(variable = names(envir_mean),
                        mean = round(envir_mean, 2),
                        std = envir_std,
                        row.names = NULL)

# Writing summary table
if (!dir.exists("output/")) dir.create("output/", recursive = TRUE)
write.csv(envir_tbl,
          "output/02_envir_summary.csv", row.names = FALSE)

# Output 2: figure -------------------------------------------------------------

# Species vs sites table
head(data_list$comm)

comm <- data_list$comm

head(comm)

# Sum of species abundances across sites
# the result is a dataframe with only one line
# each column name is a species
# and the value for the species is
# the sum of abundances for each species in all sites
comm_sum <- apply(comm[, -1], 2, sum)
colSums(comm[, -1])

# Plotting a species abundance curve
plot(sort(comm_sum, decreasing = TRUE),
     las = 1,
     bty = "l",
     xlab = "Species",
     ylab = "Abundance")

# Exporting the figure
res <- 300
fig_size <- (res * 240) / 72

if (!dir.exists("figs")) dir.create("figs")
png("figs/02_species_abundance.png",
    res = res,
    height = fig_size,
    width = 1.5 * fig_size)
plot(sort(comm_sum, decreasing = TRUE),
     las = 1,
     bty = "l",
     xlab = "Species",
     ylab = "Abundance")

# para inserir rotulos nos outliers
text(substitute(paste(italic("Bolboschoenus maritimus"))), x = 14, y = 126,
     cex = 0.8)
text(substitute(paste(italic("Phalaris coerulescens"))), x = 14, y = 80,
     cex = 0.8)
dev.off()

# for loop in R ----------------------------------------------------------------
# as.data.frame() transforms the columns in rows
# that means that one column is for the name of the species,
# and the other is for the sum of abundances
comm_df <- as.data.frame(comm_sum)
# create a new column in the data.frame
# and fills every position with NA value
comm_df$TaxonName <- NA


# for each value in rownames of comm_df,
# the value atributed to the column "TaxonName" in comm_df
# will be the value from the column "TaxonName" in splist
# for whose value in the column "TaxCode" is equal to the rowname in comm_df

comm_df[sp, "TaxonName"]
for (sp in rownames(comm_df)) {
  comm_df[sp, "TaxonName"] <- data_list$splist$TaxonName[data_list$splist$TaxCode == sp]
}

comm_df
