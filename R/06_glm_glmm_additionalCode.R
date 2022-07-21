library(bblme)


cuckoo <- read.csv("data/raw/valletta_cuckoo.csv")

h1 <- glm(Beg ~ Mass, data = cuckoo,
          family = poisson(link = log))

h2 <- glm(Beg ~ Mass + Species, data = cuckoo,
          family = poisson(link = log))

h3 <- glm(Beg ~ Mass * Species, data = cuckoo,
          family = poisson(link = log))

h0 <- glm(Beg ~ 0, data = cuckoo,
          family = poisson(link = log))


bbmle::AICtab(h0, h1, h2, h3, base = TRUE, weights = TRUE)

