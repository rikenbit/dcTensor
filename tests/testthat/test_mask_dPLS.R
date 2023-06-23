X <- dcTensor::toyModel("dPLS_Easy")
M1 <- list()
M2 <- list()
length(M1) <- length(X)
length(M2) <- length(X)
for(i in seq(length(X))){
	M1[[i]] <- kFoldMaskTensor(X[[i]], seed=12345)[[i]]
	M2[[i]] <- kFoldMaskTensor(X[[i]], seed=54321)[[i]]
}


out1 <- dPLS(X, M=M1, J=3, num.iter=2)
expect_equivalent(length(out1), 7)

out2 <- dPLS(X, M=M2, J=3, num.iter=2)
expect_true(rev(out1$TestRecError)[1] != rev(out2$TestRecError)[1])

out3 <- dPLS(X, M=M1, J=4, num.iter=2)
expect_true(rev(out1$TestRecError)[1] != rev(out3$TestRecError)[1])
