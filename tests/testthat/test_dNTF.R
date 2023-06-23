X <- dcTensor::toyModel("dNTF")

out1 <- dNTF(X, rank=3, algorithm="Frobenius", num.iter=2)
out2 <- dNTF(X, rank=3, algorithm="KL", num.iter=2)
out3 <- dNTF(X, rank=3, algorithm="IS", num.iter=2)
out4 <- dNTF(X, rank=3, algorithm="Beta", num.iter=2)

expect_equivalent(length(out1), 8)
expect_equivalent(length(out2), 8)
expect_equivalent(length(out3), 8)
expect_equivalent(length(out4), 8)
