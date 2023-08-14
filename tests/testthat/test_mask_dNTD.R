test_that("dsiNTD (Mask)", {
	#
	# 3-order tensor
	#
	X <- dcTensor::toyModel("dNTF")
	M1 <- kFoldMaskTensor(X, seeds=12345)[[1]]
	M2 <- kFoldMaskTensor(X, seeds=54321)[[1]]

	out1_1 <- dNTD(X, M=M1, rank=c(1,2,3), algorithm="Frobenius", num.iter=2)
	out1_2 <- dNTD(X, M=M1, rank=c(1,2,3), algorithm="Frobenius", init="dNMF", num.iter=2)
	out1_3 <- dNTD(X, M=M1, rank=c(1,2,3), algorithm="Frobenius", init="Random", num.iter=2)
	out2 <- dNTD(X, M=M1, rank=c(1,2,3), algorithm="KL", num.iter=2)
	out3 <- dNTD(X, M=M1, rank=c(1,2,3), algorithm="IS", num.iter=2)
	out4 <- dNTD(X, M=M1, rank=c(1,2,3), algorithm="Beta", num.iter=2)

	expect_equivalent(length(out1_1), 6)
	expect_equivalent(length(out1_2), 6)
	expect_equivalent(length(out1_3), 6)
	expect_equivalent(length(out2), 6)
	expect_equivalent(length(out3), 6)
	expect_equivalent(length(out4), 6)

	out5_1 <- dNTD(X, M=M2, rank=c(1,2,3), algorithm="Frobenius", num.iter=2)
	out5_2 <- dNTD(X, M=M2, rank=c(1,2,3), algorithm="Frobenius", init="dNMF", num.iter=2)
	out5_3 <- dNTD(X, M=M2, rank=c(1,2,3), algorithm="Frobenius", init="Random", num.iter=2)
	out6 <- dNTD(X, M=M2, rank=c(1,2,3), algorithm="KL", num.iter=2)
	out7 <- dNTD(X, M=M2, rank=c(1,2,3), algorithm="IS", num.iter=2)
	out8 <- dNTD(X, M=M2, rank=c(1,2,3), algorithm="Beta", num.iter=2)

	expect_true(rev(out1_1$TestRecError)[1] != rev(out5_1$TestRecError)[1])
	expect_true(rev(out1_2$TestRecError)[1] != rev(out5_2$TestRecError)[1])
	expect_true(rev(out1_3$TestRecError)[1] != rev(out5_3$TestRecError)[1])
	expect_true(rev(out2$TestRecError)[1] != rev(out6$TestRecError)[1])
	expect_true(rev(out3$TestRecError)[1] != rev(out7$TestRecError)[1])
	expect_true(rev(out4$TestRecError)[1] != rev(out8$TestRecError)[1])

	out9_1 <- dNTD(X, M=M1, rank=c(2,3,4), algorithm="Frobenius", num.iter=2)
	out9_2 <- dNTD(X, M=M1, rank=c(2,3,4), algorithm="Frobenius", init="dNMF", num.iter=2)
	out9_3 <- dNTD(X, M=M1, rank=c(2,3,4), algorithm="Frobenius", init="Random", num.iter=2)
	out10 <- dNTD(X, M=M1, rank=c(2,3,4), algorithm="KL", num.iter=2)
	out11 <- dNTD(X, M=M1, rank=c(2,3,4), algorithm="IS", num.iter=2)
	out12 <- dNTD(X, M=M1, rank=c(2,3,4), algorithm="Beta", num.iter=2)

	expect_true(rev(out1_1$TestRecError)[1] != rev(out9_1$TestRecError)[1])
	expect_true(rev(out1_2$TestRecError)[1] != rev(out9_2$TestRecError)[1])
	expect_true(rev(out1_3$TestRecError)[1] != rev(out9_3$TestRecError)[1])
	expect_true(rev(out2$TestRecError)[1] != rev(out10$TestRecError)[1])
	expect_true(rev(out3$TestRecError)[1] != rev(out11$TestRecError)[1])
	expect_true(rev(out4$TestRecError)[1] != rev(out12$TestRecError)[1])
})