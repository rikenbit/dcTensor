#
# 3-order tensor
#
X <- dcTensor::toyModel("dNTF")
X@data[sample(seq(length(X@data)), 0.1*length(X@data))] <- NA

out1_1 <- dNTD(X, rank=c(1,2,3), algorithm="Frobenius", num.iter=2)
out1_2 <- dNTD(X, rank=c(1,2,3), algorithm="Frobenius", init="dNMF", num.iter=2)
out1_3 <- dNTD(X, rank=c(1,2,3), algorithm="Frobenius", init="Random", num.iter=2)
out2 <- dNTD(X, rank=c(1,2,3), algorithm="KL", num.iter=2)
out3 <- dNTD(X, rank=c(1,2,3), algorithm="IS", num.iter=2)
out4 <- dNTD(X, rank=c(1,2,3), algorithm="Beta", num.iter=2)

out_NTD2_1 <- dNTD(X, rank=c(2,3), modes=1:2, algorithm="Frobenius", num.iter=2)
out_NTD2_2 <- dNTD(X, rank=c(3,4), modes=2:3, algorithm="Frobenius", num.iter=2)
out_NTD2_3 <- dNTD(X, rank=c(4,6), modes=c(1,3), algorithm="Frobenius", num.iter=2)

out_NTD1_1 <- dNTD(X, rank=3, modes=1, algorithm="Frobenius", num.iter=2)
out_NTD1_2 <- dNTD(X, rank=4, modes=2, algorithm="Frobenius", num.iter=2)
out_NTD1_3 <- dNTD(X, rank=5, modes=3, algorithm="Frobenius", num.iter=2)

expect_equivalent(length(out1_1), 8)
expect_equivalent(length(out1_2), 8)
expect_equivalent(length(out1_3), 8)
expect_equivalent(length(out2), 8)
expect_equivalent(length(out3), 8)
expect_equivalent(length(out4), 8)

expect_equivalent(length(out_NTD2_1), 8)
expect_equivalent(length(out_NTD2_2), 8)
expect_equivalent(length(out_NTD2_3), 8)

expect_equivalent(length(out_NTD1_1), 8)
expect_equivalent(length(out_NTD1_2), 8)
expect_equivalent(length(out_NTD1_3), 8)
