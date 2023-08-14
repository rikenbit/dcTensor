test_that("dNMF (NA)", {
	X <- dcTensor::toyModel("dNMF")
	X[sample(seq(length(X)), 0.1*length(X))] <- NA

	out1 <- dNMF(X, J=3, algorithm="Frobenius", num.iter=2)
	out2 <- dNMF(X, J=3, algorithm="KL", num.iter=2)
	out3 <- dNMF(X, J=3, algorithm="IS", num.iter=2)
	out4 <- dNMF(X, J=3, algorithm="Beta", Beta=-1, num.iter=2)

	expect_equivalent(length(out1), 6)
	expect_equivalent(length(out2), 6)
	expect_equivalent(length(out3), 6)
	expect_equivalent(length(out4), 6)
})