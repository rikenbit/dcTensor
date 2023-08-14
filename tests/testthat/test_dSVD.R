test_that("dSVD", {
	X <- dcTensor::toyModel("dSVD")

	out <- dSVD(X, J=3, num.iter=2)

	expect_equivalent(length(out), 6)
})