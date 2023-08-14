test_that("dNMF", {
	X <- dcTensor::toyModel("dNMF")

	# Normal Test
	out1 <- dNMF(X, J=3, algorithm="Frobenius", num.iter=2)
	out2 <- dNMF(X, J=3, algorithm="KL", num.iter=2)
	out3 <- dNMF(X, J=3, algorithm="IS", num.iter=2)
	out4 <- dNMF(X, J=3, algorithm="Beta", num.iter=2)

	expect_equivalent(length(out1), 6)
	expect_equivalent(length(out2), 6)
	expect_equivalent(length(out3), 6)
	expect_equivalent(length(out4), 6)

	# Mask Test
	M <- kFoldMaskTensor(X, k=5)
	out1_M <- dNMF(X, M=M[[1]], J=3, algorithm="Frobenius", num.iter=2)
	out2_M <- dNMF(X, M=M[[1]], J=3, algorithm="KL", num.iter=2)
	out3_M <- dNMF(X, M=M[[1]], J=3, algorithm="IS", num.iter=2)
	out4_M <- dNMF(X, M=M[[1]], J=3, algorithm="Beta", num.iter=2)

	expect_equivalent(length(out1_M), 6)
	expect_equivalent(length(out2_M), 6)
	expect_equivalent(length(out3_M), 6)
	expect_equivalent(length(out4_M), 6)
})