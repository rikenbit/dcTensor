X <- toyModel("NMF")

out1 <- NMF(X, J=3, algorithm="Frobenius", num.iter=2)
out2 <- NMF(X, J=3, algorithm="KL", num.iter=2)
out3 <- NMF(X, J=3, algorithm="IS", num.iter=2)
out4 <- NMF(X, J=3, algorithm="Beta", num.iter=2)

expect_equivalent(length(out1), 10)
expect_equivalent(length(out2), 10)
expect_equivalent(length(out3), 10)
expect_equivalent(length(out4), 10)
