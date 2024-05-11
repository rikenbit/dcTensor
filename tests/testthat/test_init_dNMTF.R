X <- dcTensor::toyModel("dNMF")

#
# initU
#
initU <- matrix(runif(nrow(X)*3),
	nrow=nrow(X), ncol=3)

out1 <- dNMTF(X, initU=initU, rank=c(3,4), algorithm="Frobenius", num.iter=2)
out2 <- dNMTF(X, initU=initU, rank=c(3,4), algorithm="KL", num.iter=2)
out3 <- dNMTF(X, initU=initU, rank=c(3,4), algorithm="IS", num.iter=2)
out4 <- dNMTF(X, initU=initU, rank=c(3,4), algorithm="Beta", Beta=-1, num.iter=2)

expect_equivalent(length(out1), 8)
expect_equivalent(length(out2), 8)
expect_equivalent(length(out3), 8)
expect_equivalent(length(out4), 8)

#
# initS
#
initS <- matrix(runif(3*4), nrow=3, ncol=4)

out5 <- dNMTF(X, initS=initS, rank=c(3,4), algorithm="Frobenius", num.iter=2)
out6 <- dNMTF(X, initS=initS, rank=c(3,4), algorithm="KL", num.iter=2)
out7 <- dNMTF(X, initS=initS, rank=c(3,4), algorithm="IS", num.iter=2)
out8 <- dNMTF(X, initS=initS, rank=c(3,4), algorithm="Beta", Beta=-1, num.iter=2)

expect_equivalent(length(out5), 8)
expect_equivalent(length(out6), 8)
expect_equivalent(length(out7), 8)
expect_equivalent(length(out8), 8)

#
# initV
#
initV <- matrix(runif(ncol(X)*4), nrow=ncol(X), ncol=4)

out9 <- dNMTF(X, initV=initV, rank=c(3,4), algorithm="Frobenius", num.iter=2)
out10 <- dNMTF(X, initV=initV, rank=c(3,4), algorithm="KL", num.iter=2)
out11 <- dNMTF(X, initV=initV, rank=c(3,4), algorithm="IS", num.iter=2)
out12 <- dNMTF(X, initV=initV, rank=c(3,4), algorithm="Beta", Beta=-1, num.iter=2)

expect_equivalent(length(out9), 8)
expect_equivalent(length(out10), 8)
expect_equivalent(length(out11), 8)
expect_equivalent(length(out12), 8)
