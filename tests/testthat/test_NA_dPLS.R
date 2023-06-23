X <- dcTensor::toyModel("dPLS_Easy")
X[[1]][sample(seq(length(X[[1]])), 0.1*length(X[[1]]))] <- NA
X[[2]][sample(seq(length(X[[2]])), 0.1*length(X[[2]]))] <- NA
X[[3]][sample(seq(length(X[[3]])), 0.1*length(X[[3]]))] <- NA

out <- dPLS(X, J=3, num.iter=2)
expect_equivalent(length(out), 7)

