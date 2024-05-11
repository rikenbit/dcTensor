X <- dcTensor::toyModel("dNMF")
M1 <- kFoldMaskTensor(X, seeds=12345)[[1]]
M2 <- kFoldMaskTensor(X, seeds=54321)[[1]]

out1 <- dNMTF(X, M=M1, rank=c(3,4), algorithm="Frobenius", num.iter=2)
out2 <- dNMTF(X, M=M1, rank=c(3,4), algorithm="KL", num.iter=2)
out3 <- dNMTF(X, M=M1, rank=c(3,4), algorithm="IS", num.iter=2)
out4 <- dNMTF(X, M=M1, rank=c(3,4), algorithm="Beta", Beta=-1, num.iter=2)

expect_equivalent(length(out1), 8)
expect_equivalent(length(out2), 8)
expect_equivalent(length(out3), 8)
expect_equivalent(length(out4), 8)

out5 <- dNMTF(X, M=M2, rank=c(3,4), algorithm="Frobenius", num.iter=2)
out6 <- dNMTF(X, M=M2, rank=c(3,4), algorithm="KL", num.iter=2)
out7 <- dNMTF(X, M=M2, rank=c(3,4), algorithm="IS", num.iter=2)
out8 <- dNMTF(X, M=M2, rank=c(3,4), algorithm="Beta", Beta=-1, num.iter=2)

expect_true(rev(out1$TestRecError)[1] != rev(out5$TestRecError)[1])
expect_true(rev(out2$TestRecError)[1] != rev(out6$TestRecError)[1])
expect_true(rev(out3$TestRecError)[1] != rev(out7$TestRecError)[1])
expect_true(rev(out4$TestRecError)[1] != rev(out8$TestRecError)[1])

out9 <- dNMTF(X, M=M2, rank=c(5,4), algorithm="Frobenius", num.iter=2)
out10 <- dNMTF(X, M=M2, rank=c(5,4), algorithm="KL", num.iter=2)
out11 <- dNMTF(X, M=M2, rank=c(5,4), algorithm="IS", num.iter=2)
out12 <- dNMTF(X, M=M2, rank=c(5,4), algorithm="Beta", Beta=-1, num.iter=2)

expect_true(rev(out1$TestRecError)[1] != rev(out9$TestRecError)[1])
expect_true(rev(out2$TestRecError)[1] != rev(out10$TestRecError)[1])
expect_true(rev(out3$TestRecError)[1] != rev(out11$TestRecError)[1])
expect_true(rev(out4$TestRecError)[1] != rev(out12$TestRecError)[1])
