test_that("dSVD (Init)", {
	X <- dcTensor::toyModel("dSVD")

	#
	# initU
	#
	initU <- matrix(runif(nrow(X)*3),
		nrow=nrow(X), ncol=3)

	out1 <- dSVD(X, initU=initU, J=3, num.iter=2)

	expect_equivalent(length(out1), 6)

	#
	# initV
	#
	initV <- matrix(runif(ncol(X)*3),
		nrow=ncol(X), ncol=3)

	out2 <- dSVD(X, initV=initV, J=3, num.iter=2)

	expect_equivalent(length(out2), 6)
})