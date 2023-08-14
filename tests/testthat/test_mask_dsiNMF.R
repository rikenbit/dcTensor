test_that("dsiNMF (Mask)", {
	X <- dcTensor::toyModel("dsiNMF_Easy")
	M1 <- list()
	M2 <- list()
	length(M1) <- length(X)
	length(M2) <- length(X)
	for(i in seq(length(X))){
		M1[[i]] <- kFoldMaskTensor(X[[i]], seed=12345)[[i]]
		M2[[i]] <- kFoldMaskTensor(X[[i]], seed=54321)[[i]]
	}

	out1 <- dsiNMF(X, M=M1, J=3, algorithm="Frobenius", num.iter=2)
	out2 <- dsiNMF(X, M=M1, J=3, algorithm="KL", num.iter=2)
	out3 <- dsiNMF(X, M=M1, J=3, algorithm="IS", num.iter=2)
	out4 <- dsiNMF(X, M=M1, J=3, algorithm="PLTF", p=1, num.iter=2)

	expect_equivalent(length(out1), 6)
	expect_equivalent(length(out2), 6)
	expect_equivalent(length(out3), 6)
	expect_equivalent(length(out4), 6)

	out5 <- dsiNMF(X, M=M2, J=3, algorithm="Frobenius", num.iter=2)
	out6 <- dsiNMF(X, M=M2, J=3, algorithm="KL", num.iter=2)
	out7 <- dsiNMF(X, M=M2, J=3, algorithm="IS", num.iter=2)
	out8 <- dsiNMF(X, M=M2, J=3, algorithm="PLTF", p=1, num.iter=2)

	expect_true(rev(out1$TestRecError)[1] != rev(out5$TestRecError)[1])
	expect_true(rev(out2$TestRecError)[1] != rev(out6$TestRecError)[1])
	expect_true(rev(out3$TestRecError)[1] != rev(out7$TestRecError)[1])
	expect_true(rev(out4$TestRecError)[1] != rev(out8$TestRecError)[1])

	out9 <- dsiNMF(X, M=M1, J=4, algorithm="Frobenius", num.iter=2)
	out10 <- dsiNMF(X, M=M1, J=4, algorithm="KL", num.iter=2)
	out11 <- dsiNMF(X, M=M1, J=4, algorithm="IS", num.iter=2)
	out12 <- dsiNMF(X, M=M1, J=4, algorithm="PLTF", p=1, num.iter=2)

	expect_true(rev(out1$TestRecError)[1] != rev(out9$TestRecError)[1])
	expect_true(rev(out2$TestRecError)[1] != rev(out10$TestRecError)[1])
	expect_true(rev(out3$TestRecError)[1] != rev(out11$TestRecError)[1])
	expect_true(rev(out4$TestRecError)[1] != rev(out12$TestRecError)[1])
})