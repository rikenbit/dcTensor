X <- dcTensor::toyModel("dNMF")
M1 <- kFoldMaskTensor(X, seeds=12345)[[1]]
M2 <- kFoldMaskTensor(X, seeds=54321)[[1]]

out1 <- dNMF(X, M=M1, J=3, algorithm="Frobenius", num.iter=10)
out2 <- dNMF(X, M=M1, J=3, algorithm="KL", num.iter=10)
out3 <- dNMF(X, M=M1, J=3, algorithm="IS", num.iter=10)
out4 <- dNMF(X, M=M1, J=3, algorithm="Beta", Beta=-1,  num.iter=10)

expect_equivalent(length(out1), 10)
expect_equivalent(length(out2), 10)
expect_equivalent(length(out3), 10)
expect_equivalent(length(out4), 10)

out5 <- dNMF(X, M=M2, J=3, algorithm="Frobenius", num.iter=10)
out6 <- dNMF(X, M=M2, J=3, algorithm="KL", num.iter=10)
out7 <- dNMF(X, M=M2, J=3, algorithm="IS", num.iter=10)
out8 <- dNMF(X, M=M2, J=3, algorithm="Beta", Beta=-1, num.iter=10)

expect_true(rev(out1$TestRecError)[1] != rev(out5$TestRecError)[1])
expect_true(rev(out2$TestRecError)[1] != rev(out6$TestRecError)[1])
expect_true(rev(out3$TestRecError)[1] != rev(out7$TestRecError)[1])
expect_true(rev(out4$TestRecError)[1] != rev(out8$TestRecError)[1])

out9 <- dNMF(X, M=M1, J=5, algorithm="Frobenius", num.iter=10)
out10 <- dNMF(X, M=M1, J=5, algorithm="KL", num.iter=10)
out11 <- dNMF(X, M=M1, J=5, algorithm="IS", num.iter=10)
out12 <- dNMF(X, M=M1, J=5, algorithm="Beta", Beta=-1, num.iter=10)

expect_true(rev(out1$TestRecError)[1] != rev(out9$TestRecError)[1])
expect_true(rev(out2$TestRecError)[1] != rev(out10$TestRecError)[1])
expect_true(rev(out3$TestRecError)[1] != rev(out11$TestRecError)[1])
expect_true(rev(out4$TestRecError)[1] != rev(out12$TestRecError)[1])
