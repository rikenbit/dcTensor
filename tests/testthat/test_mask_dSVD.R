X <- dcTensor::toyModel("dSVD")
M1 <- kFoldMaskTensor(X, seeds=12345)[[1]]
M2 <- kFoldMaskTensor(X, seeds=54321)[[1]]

out1 <- dSVD(X, M=M1, J=3, num.iter=2)
expect_equivalent(length(out1), 7)

out2 <- dSVD(X, M=M2, J=3, num.iter=2)
expect_true(rev(out1$TestRecError)[1] != rev(out2$TestRecError)[1])

out3 <- dSVD(X, M=M1, J=5, num.iter=2)
expect_true(rev(out1$TestRecError)[1] != rev(out3$TestRecError)[1])
