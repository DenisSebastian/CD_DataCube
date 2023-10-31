library(raster)
library(igraph)



img1 <- raster("data/samples/tif/1_1.tif")
img2 <- raster("data/samples/tif/1_2.tif")


nb <- adjacent(img1, cells = 1:ncell(img1), directions = 8, pairs = T, sorted=TRUE)
plot(nb)


mat <- as.matrix(nb)

numclass <- 2
mrf <- matrix(0, nrow = ncell(img1), ncol = numclass)

for (i in 1:numclass) {
  for (j in 1:numclass) {
    if (i == j) {
      mrf[,i] <- mrf[,i] + log(mean(values(img1 == i)))
    } else {
      mrf[,i] <- mrf[,i] + log(mean(values(img1 == i) * (values(img2 == j) == 1)))
    }
  }
}

mrf <- exp(mrf)


g <- graph.adjacency(mat, mode = "undirected")
adj <- get.adjacency(g, sparse = FALSE)

for (i in 1:numclass) {
  prob <- as.numeric(adj %*% mrf[,i])
  mrf[,i] <- mrf[,i] * prob
}

res <- apply(mrf, 1, which.max)
res <- matrix(res, nrow = nrow(img1), ncol = ncol(img1))