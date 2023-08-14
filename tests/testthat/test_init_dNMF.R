test_that("dNMF (Init)", {
	X <- dcTensor::toyModel("dNMF")

	#
	# initU
	#
	initU <- matrix(runif(nrow(X)*3),
		nrow=nrow(X), ncol=3)

	out1 <- dNMF(X, initU=initU,
		J=3, algorithm="Frobenius", num.iter=2)
	out2 <- dNMF(X, initU=initU,
		J=3, algorithm="KL", num.iter=2)
	out3 <- dNMF(X, initU=initU,
		J=3, algorithm="IS", num.iter=2)
	out4 <- dNMF(X, initU=initU,
		J=3, algorithm="Beta", Beta=-1, num.iter=2)

	expect_equivalent(length(out1), 6)
	expect_equivalent(length(out2), 6)
	expect_equivalent(length(out3), 6)
	expect_equivalent(length(out4), 6)

	#
	# initV
	#
	initV <- matrix(runif(ncol(X)*3),
		nrow=ncol(X), ncol=3)

	out5 <- dNMF(X, initV=initV,
		J=3, algorithm="Frobenius", num.iter=2)
	out6 <- dNMF(X, initV=initV,
		J=3, algorithm="KL", num.iter=2)
	out7 <- dNMF(X, initV=initV,
		J=3, algorithm="IS", num.iter=2)
	out8 <- dNMF(X, initV=initV,
		J=3, algorithm="Beta", Beta=-1, num.iter=2)

	expect_equivalent(length(out5), 6)
	expect_equivalent(length(out6), 6)
	expect_equivalent(length(out7), 6)
	expect_equivalent(length(out8), 6)
})