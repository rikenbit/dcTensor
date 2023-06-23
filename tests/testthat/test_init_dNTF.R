#
# 3-order tensor
#
X <- dcTensor::toyModel("dNTF")

initA <- list(
	A1=matrix(runif(3*dim(X)[1]),
		nrow=3, ncol=dim(X)[1]),
	A2=matrix(runif(3*dim(X)[2]),
		nrow=3, ncol=dim(X)[2]),
	A3=matrix(runif(3*dim(X)[3]),
		nrow=3, ncol=dim(X)[3])
	)

out1_1 <- dNTF(X, initA=initA,
	rank=3, algorithm="Frobenius", num.iter=2)
out1_2 <- dNTF(X, initA=initA,
	rank=3, algorithm="Frobenius", init="dNMF", num.iter=2)
out1_3 <- dNTF(X, initA=initA,
	rank=3, algorithm="Frobenius", init="Random", num.iter=2)
out2 <- dNTF(X, initA=initA,
	rank=3, algorithm="KL", num.iter=2)
out3 <- dNTF(X, initA=initA,
	rank=3, algorithm="IS", num.iter=2)
out4 <- dNTF(X, initA=initA,
	rank=3, algorithm="Beta", num.iter=2)

expect_equivalent(length(out1_1), 8)
expect_equivalent(length(out1_2), 8)
expect_equivalent(length(out1_3), 8)
expect_equivalent(length(out2), 8)
expect_equivalent(length(out3), 8)
expect_equivalent(length(out4), 8)
