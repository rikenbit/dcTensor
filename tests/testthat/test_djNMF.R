test_that("djNMF", {
	X <- dcTensor::toyModel("dsiNMF_Easy")

	out1 <- djNMF(X, J=3, algorithm="Frobenius", num.iter=2)
	out2 <- djNMF(X, J=3, algorithm="KL", num.iter=2)
	out3 <- djNMF(X, J=3, algorithm="IS", num.iter=2)
	out4 <- djNMF(X, J=3, algorithm="PLTF", num.iter=2)

	expect_equivalent(length(out1), 7)
	expect_equivalent(length(out2), 7)
	expect_equivalent(length(out3), 7)
	expect_equivalent(length(out4), 7)
})