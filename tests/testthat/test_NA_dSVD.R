test_that("dSVD (NA)", {
	X <- dcTensor::toyModel("dSVD")
	X[sample(seq(length(X)), 0.1*length(X))] <- NA

	out <- dSVD(X, J=3, num.iter=2)
	expect_equivalent(length(out), 6)
})
