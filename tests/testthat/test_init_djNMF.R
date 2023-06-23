X <- dcTensor::toyModel("dsiNMF_Hard")

#
# initW
#
initW <- matrix(runif(nrow(X[[1]])*3),
	nrow=nrow(X[[1]]), ncol=3)
out1 <- djNMF(X, initW=initW,
	J=3, algorithm="Frobenius", num.iter=2)
out2 <- djNMF(X, initW=initW,
	J=3, algorithm="KL", num.iter=2)
out3 <- djNMF(X, initW=initW,
	J=3, algorithm="IS", num.iter=2)
out4 <- djNMF(X, initW=initW,
	J=3, algorithm="PLTF", p=1, num.iter=2)

expect_equivalent(length(out1), 13)
expect_equivalent(length(out2), 13)
expect_equivalent(length(out3), 13)
expect_equivalent(length(out4), 13)

#
# initH
#
initH <- list(
	H1=matrix(runif(ncol(X[[1]])*3),
		nrow=ncol(X[[1]]), ncol=3),
	H2=matrix(runif(ncol(X[[2]])*3),
		nrow=ncol(X[[2]]), ncol=3),
	H3=matrix(runif(ncol(X[[3]])*3),
		nrow=ncol(X[[3]]), ncol=3)
)
out5 <- djNMF(X, initH=initH,
	J=3, algorithm="Frobenius", num.iter=2)
out6 <- djNMF(X, initH=initH,
	J=3, algorithm="KL", num.iter=2)
out7 <- djNMF(X, initH=initH,
	J=3, algorithm="IS", num.iter=2)
out8 <- djNMF(X, initH=initH,
	J=3, algorithm="PLTF", p=1, num.iter=2)

expect_equivalent(length(out5), 13)
expect_equivalent(length(out6), 13)
expect_equivalent(length(out7), 13)
expect_equivalent(length(out8), 13)

#
# initV
#
initV <- list(
	V1=matrix(runif(nrow(X[[1]])*3),
		nrow=nrow(X[[1]]), ncol=3),
	V2=matrix(runif(nrow(X[[2]])*3),
	nrow=nrow(X[[2]]), ncol=3),
	V3=matrix(runif(nrow(X[[3]])*3),
	nrow=nrow(X[[3]]), ncol=3)
	)
out9 <- djNMF(X, initV=initV,
	J=3, algorithm="Frobenius", num.iter=2)
out10 <- djNMF(X, initV=initV,
	J=3, algorithm="KL", num.iter=2)
out11 <- djNMF(X, initV=initV,
	J=3, algorithm="IS", num.iter=2)
out12 <- djNMF(X, initV=initV,
	J=3, algorithm="PLTF", p=1, num.iter=2)

expect_equivalent(length(out9), 13)
expect_equivalent(length(out10), 13)
expect_equivalent(length(out11), 13)
expect_equivalent(length(out12), 13)
