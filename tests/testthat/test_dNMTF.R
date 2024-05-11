X <- dcTensor::toyModel("dNMF")

out1 <- dNMTF(X, rank=c(3,4), algorithm="Frobenius", num.iter=2)
out2 <- dNMTF(X, rank=c(3,4), algorithm="KL", num.iter=2)
out3 <- dNMTF(X, rank=c(3,4), algorithm="IS", num.iter=2)
out4 <- dNMTF(X, rank=c(3,4), algorithm="Beta", Beta=-1, num.iter=2)

expect_equivalent(length(out1), 8)
expect_equivalent(length(out2), 8)
expect_equivalent(length(out3), 8)
expect_equivalent(length(out4), 8)