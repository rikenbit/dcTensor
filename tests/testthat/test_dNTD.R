test_that("dNTD", {
	X <- dcTensor::toyModel("dNTF")

	out1 <- dNTD(X, rank=c(3,3,3), algorithm="Frobenius", num.iter=2)
	out2 <- dNTD(X, rank=c(3,3,3), algorithm="KL", num.iter=2)
	out3 <- dNTD(X, rank=c(3,3,3), algorithm="IS", num.iter=2)
	out4 <- dNTD(X, rank=c(3,3,3), algorithm="Beta", num.iter=2)

	expect_equivalent(length(out1), 6)
	expect_equivalent(length(out2), 6)
	expect_equivalent(length(out3), 6)
	expect_equivalent(length(out4), 6)
})