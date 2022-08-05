# 14_multivariate_analysis_1.R
# Built in 2022-08-05

# LOADING THE DATASET AND PACKAGES ==============================================
library(vegan)
data(dune)
data(dune.env)
table(dune.env$Management)



# CLUSTERING DUNE VEGETATION DATA ==============================================
bray_distance <- vegdist(dune)
# Chord distance, euclidean distance normalized to 1.
chord_distance <- dist(decostand(dune, "norm"))




# clustering
library(cluster)
b_cluster <- hclust(bray_distance, method = "average")
c_cluster <- hclust(chord_distance, method = "average")


# plot the hierarchical clustering trees
par(mfrow = c(1, 2))
plot(b_cluster)
plot(c_cluster)

par(mfrow = c(1, 1))


# readjust the graph
par(mfrow = c(1, 2))
plot(b_cluster, hang = -1, main = "", axes = F)
axis(2, at = seq(0, 1, 0.1), labels = seq(0, 1, 0.1), las = 2)
plot(c_cluster, hang = -1, main = "", axes = F)
axis(2, at = seq(0, 1, 0.1), labels = seq(0, 1, 0.1), las = 2)

# ORDINATION METHODS =========================================================
# For R
#prcomp()
#vegan::rda()
# PCA and ordination are methods for unsupervised statistical learning

chord_distance <- dist(decostand(dune, "norm"))
is(chord_distance)


# we standardize community data with decostand
norm <- decostand(dune, "norm")
# rda() is the constrained version of the PCA so it's the same function
pca <- rda(norm)

plot(pca, choices = c(2,3))
summary(pca)

#these columns are character, we have to change them to numeric
library(dplyr)
apply(dune.env,2,class)
dune.env$Moisture <- as.numeric(dune.env$Moisture)
dune.env$A1 <- as.numeric(dune.env$A1)
dune.env$Manure <- as.numeric(dune.env$Manure)


#Let's do a PCA of the environmental matrix
pca_env <- rda(dune.env[, c("A1", "Moisture", "Manure")])
plot(pca_env)
cor(dune.env)
