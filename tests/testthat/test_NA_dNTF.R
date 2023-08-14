test_that("dNTF (NA)", {
	#
	# 3-order tensor
	#
	X <- dcTensor:::toyModel("dNTF")
	X@data[sample(seq(length(X@data)), 0.1*length(X@data))] <- NA

	out1_1 <- dNTF(X, rank=3, algorithm="Frobenius", num.iter=2)
	out1_2 <- dNTF(X, rank=3, algorithm="Frobenius", init="dNMF", num.iter=2)
	out1_3 <- dNTF(X, rank=3, algorithm="Frobenius", init="Random", num.iter=2)
	out2 <- dNTF(X, rank=3, algorithm="KL", num.iter=2)
	out3 <- dNTF(X, rank=3, algorithm="IS", num.iter=2)
	out4 <- dNTF(X, rank=3, algorithm="Beta", Beta=-1, num.iter=2)

	expect_equivalent(length(out1_1), 6)
	expect_equivalent(length(out1_2), 6)
	expect_equivalent(length(out1_3), 6)
	expect_equivalent(length(out2), 6)
	expect_equivalent(length(out3), 6)
	expect_equivalent(length(out4), 6)
})