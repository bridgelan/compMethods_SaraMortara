# Scientific programming course ICTP-Serrapilheira July-2022
# Class #01: Introduction to R
# Introductory script to play with R data types

# See where you are working at
getwd()

# Exploring R ------------------------------------------------------------------
sqrt(10)
round(3.14159)
args(round)
?round

print("Hi!")
print("Hello, world!")


## ----datatypes----------------------------------------------------------------
animals  <- c("mouse", "rat", "dog", "cat")
weight_g <- c(50, 60, 65, 82)


## ----class1-------------------------------------------------------------------
class(animals)


## ----class2-------------------------------------------------------------------
class(weight_g)


## ---- vectors-----------------------------------------------------------------
animals
animals[2]


## ----subset-------------------------------------------------------------------
animals[c(3, 2)]


## ----subset-logical-----------------------------------------------------------
weight_g <- c(21, 34, 39, 54)
weight_g[c(TRUE, FALSE, FALSE, TRUE)]
weight_g[weight_g > 35]


## ----recycling----------------------------------------------------------------
more_animals <- c("rat", "cat", "dog", "duck", "goat")
animals %in% more_animals

## subset with grep ------------------------------------------------------------
# return the elements of the vector with start with the letter "d"
more_animals[grepl("^d", more_animals)]

## ----recycling2---------------------------------------------------------------
animals
more_animals
animals == more_animals

#shows the elements that are in animals that are not present in more_animals
setdiff(animals, more_animals)

## ----na-----------------------------------------------------------------------
heights <- c(2, 4, 4, NA, 6)
mean(heights)
max(heights)
mean(heights, na.rm = TRUE)
max(heights, na.rm = TRUE)

# Data structures --------------------------------------------------------------

# Factor
animals
animals_cls <- factor(c("small", "intermediate", "intermediate", "large"))
levels(animals_cls)
levels(animals_cls) <- c("small", "intermediate", "large")
animals_cls

# what if we substitute one of the levels?
# the object will substitute each ocurrence of "medium" inside the vector
# by the substitute value "average"
levels(animals_cls) <- c("small", "medium", "large")

# Matrices
# to maintain replicability between computers,
# we use the same seed to generate the random values
set.seed(42)
matrix(runif(20), ncol = 2)

matrix(nrow = 4, ncol = 3)

nums <- 1:12

matrix(data = nums, nrow = 3)

matrix(data = nums, nrow = 3, byrow = T)

names_matrix <- list(c("row1", "row2", "row3"),
                     c("col1", "col2", "col3", "col4"))
names_matrix

matrix(data = nums, nrow = 3, byrow = T, dimnames = names_matrix)

m <- matrix(data = nums, nrow = 3, byrow = T, dimnames = names_matrix)

dim(m)
dimnames(m)

df <- data.frame(m)
class(df)
class(m)


# Data frames
animals_df <- data.frame(name = animals,
                         weight = weight_g,
                         weight_class = animals_cls)
animals_df
animals_df[2, 1]


# filters the lines to show which ones has "medium" in its "weight_class" column
animals_df[animals_df$weight_class == "medium", ]
# filters, but only collect the values of the "weight" column
animals_df[animals_df$weight_class == "medium", "weight"]

# let's see how it changes when we have two lines resulting from the filter
animals_df[animals_df$weight_class == "small", ]
# filters, but only collect the values of the "weight" column
animals_df[animals_df$weight_class == "small", "weight"]


# List
animals_list <- list(animals_df, animals)
animals_list[[1]]

# Importing data ---------------------------------------------------------------

# Reading data using read.csv
surveys <- read.csv(file = "./data/raw/portal_data_joined.csv")

head(surveys)

# Reading data using read.table
surveys_check <- read.table(
  file = "./data/raw/portal_data_joined.csv",
  sep = ",",
  header = TRUE)
head(surveys_check)

# Checking if both files are equal
all(surveys == surveys_check)

# inspecting
str(surveys) # returns the structure of the dataset
dim(surveys)
nrow(surveys)
ncol(surveys)

head(surveys)
tail(surveys)

names(surveys)
rownames(surveys)
length(surveys) #len in this case returns the number of cols

# subsetting
sub <- surveys[1:10, ] # return the interval in lines
sub[1, 1]
sub[1, 6]

# two different syntaxes for the same selection
sub[["record_id"]]
sub$record_id

sub[1:3, 7]

sub[3, ]

# [row, columns]

surveys[ , 6] # selects only the 6th column
surveys[1, ] # selects only the 1st row
surveys[4, 13] # selects only the value of the 13th column on the 4th row

surveys[1:4, 1:3] # selects the sub-data.frame that includes columns 1,2,3,
                  # and rows 1,2,3,4

surveys[, -1] # last column
nrow(surveys)
surveys[-(7:34786), ] # selects all lines, except the ones between the ()
head(surveys)
surveys[-(7:nrow(surveys)), ]


is(surveys$species_id)
is(surveys["species_id"])
is(surveys[["species_id"]])

#check if they are the same object
identical(surveys[["species_id"]], surveys$species_id)
identical(surveys[["species_id"]], surveys["species_id"])

# return a data.frame
da <- surveys["species_id"]
class(da)

#return a vector
de <- surveys[ ,"species_id"]
str(de)
class(de)

##
sub <- surveys[1:10,]
str(sub)

is(sub$hindfoot_length)

# inadequate: NA values will return NA to every test,
# even the test "is this value NA?"
sub$hindfoot_length == NA

# a correct form to discriminate NA values
is.na(sub$hindfoot_length)
!is.na(sub$hindfoot_length)

# now you can subset eliminating NA values
sub$hindfoot[!is.na(sub$hindfoot_length)]

# statistical measures are affected by presence of NA values
mean(sub$hindfoot_length)
mean(sub$hindfoot_length, na.rm = T)

# complex syntax: returns the lines of the "surveys" dataframe
# whose "weight" value is not NA
non_NA_w <- surveys[!is.na(surveys$weight),]
dim(non_NA_w)
dim(surveys)


#you can select for more than one condition
non_NA <- surveys[!is.na(surveys$weight) &
                    !is.na(surveys$hindfoot_length), ]
dim(non_NA)

# return the logical result of the verification "this line has missing values?"
complete.cases(surveys)

# now you can select for the lines without NAs
surveys1 <- surveys[complete.cases(surveys), ]
dim(surveys1)

# a special form of removing lines with NA values
# one of the attributes of the na.omit output,
# the attribute "na.action", holds the index of the removed lines
surveys2 <- na.omit(surveys)
attributes(surveys2)
dim(surveys2)

if (!dir.exists("data/processed")) dir.create("data/processed")
write.csv(surveys1, "data/processed/01_surveys_mod.csv")
