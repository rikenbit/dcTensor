#
# 3-order tensor
#
X <- dcTensor::toyModel("dNTF")
M1 <- kFoldMaskTensor(X, seeds=12345)[[1]]
M2 <- kFoldMaskTensor(X, seeds=54321)[[1]]

out1_1 <- dNTF(X, M=M1, rank=3, algorithm="Frobenius", num.iter=1)
out1_2 <- dNTF(X, M=M1, rank=3, algorithm="Frobenius", init="dNMF", num.iter=1)
out1_3 <- dNTF(X, M=M1, rank=3, algorithm="Frobenius", init="Random", num.iter=1)
out2 <- dNTF(X, M=M1, rank=3, algorithm="KL", num.iter=1)
out3 <- dNTF(X, M=M1, rank=3, algorithm="IS", num.iter=1)
out4 <- dNTF(X, M=M1, rank=3, algorithm="Beta", Beta=-1, num.iter=1)

expect_equivalent(length(out1_1), 8)
expect_equivalent(length(out1_2), 8)
expect_equivalent(length(out1_3), 8)
expect_equivalent(length(out2), 8)
expect_equivalent(length(out3), 8)
expect_equivalent(length(out4), 8)

out5_1 <- dNTF(X, M=M2, rank=3, algorithm="Frobenius", num.iter=1)
out5_2 <- dNTF(X, M=M2, rank=3, algorithm="Frobenius", init="dNMF", num.iter=1)
out5_3 <- dNTF(X, M=M2, rank=3, algorithm="Frobenius", init="Random", num.iter=1)
out6 <- dNTF(X, M=M2, rank=3, algorithm="KL", num.iter=1)
out7 <- dNTF(X, M=M2, rank=3, algorithm="IS", num.iter=1)
out8 <- dNTF(X, M=M2, rank=3, algorithm="Beta", Beta=-1, num.iter=1)

expect_true(rev(out1_1$TestRecError)[1] != rev(out5_1$TestRecError)[1])
expect_true(rev(out1_2$TestRecError)[1] != rev(out5_2$TestRecError)[1])
expect_true(rev(out1_3$TestRecError)[1] != rev(out5_3$TestRecError)[1])
expect_true(rev(out2$TestRecError)[1] != rev(out6$TestRecError)[1])
expect_true(rev(out3$TestRecError)[1] != rev(out7$TestRecError)[1])
# expect_true(rev(out4$TestRecError)[1] != rev(out8$TestRecError)[1])

out9_1 <- dNTF(X, M=M2, rank=5, algorithm="Frobenius", num.iter=1)
out9_2 <- dNTF(X, M=M2, rank=5, algorithm="Frobenius", init="dNMF", num.iter=1)
out9_3 <- dNTF(X, M=M2, rank=5, algorithm="Frobenius", init="Random", num.iter=1)
out10 <- dNTF(X, M=M2, rank=5, algorithm="KL", num.iter=1)
out11 <- dNTF(X, M=M2, rank=5, algorithm="IS", num.iter=1)
out12 <- dNTF(X, M=M2, rank=5, algorithm="Beta", Beta=-1, num.iter=1)

expect_true(rev(out1_1$TestRecError)[1] != rev(out9_1$TestRecError)[1])
expect_true(rev(out1_2$TestRecError)[1] != rev(out9_2$TestRecError)[1])
expect_true(rev(out1_3$TestRecError)[1] != rev(out9_3$TestRecError)[1])
expect_true(rev(out2$TestRecError)[1] != rev(out10$TestRecError)[1])
expect_true(rev(out3$TestRecError)[1] != rev(out11$TestRecError)[1])
# expect_true(rev(out4$TestRecError)[1] != rev(out12$TestRecError)[1])
