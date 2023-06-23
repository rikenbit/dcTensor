X <- dcTensor::toyModel("dPLS_Hard")

#
# fixV
#
initV <- list(
	V1=matrix(runif(ncol(X[[1]])*3),
		nrow=ncol(X[[1]]), ncol=3),
	V2=matrix(runif(ncol(X[[2]])*3),
		nrow=ncol(X[[2]]), ncol=3),
	V3=matrix(runif(ncol(X[[3]])*3),
		nrow=ncol(X[[3]]), ncol=3)
)

out2 <- dPLS(X, initV=initV, fixV=c(TRUE, TRUE, TRUE), J=3, num.iter=2)
out3 <- dPLS(X, initV=initV, fixV=c(FALSE, FALSE, FALSE), J=3, num.iter=2)
out4 <- dPLS(X, initV=initV, fixV=c(TRUE, TRUE, FALSE), J=3, num.iter=2)
out5 <- dPLS(X, initV=initV, fixV=c(TRUE, FALSE, TRUE), J=3, num.iter=2)
out6 <- dPLS(X, initV=initV, fixV=c(FALSE, TRUE, TRUE), J=3, num.iter=2)
out7 <- dPLS(X, initV=initV, fixV=c(FALSE, FALSE, TRUE), J=3, num.iter=2)
out8 <- dPLS(X, initV=initV, fixV=c(FALSE, TRUE, FALSE), J=3, num.iter=2)
out9 <- dPLS(X, initV=initV, fixV=c(TRUE, FALSE, FALSE), J=3, num.iter=2)

expect_equivalent(out2$V$V1, initV$V1)
expect_equivalent(out2$V$V2, initV$V2)
expect_equivalent(out2$V$V3, initV$V3)

expect_equivalent(out4$V$V1, initV$V1)
expect_equivalent(out4$V$V2, initV$V2)

expect_equivalent(out5$V$V1, initV$V1)
expect_equivalent(out5$V$V3, initV$V3)

expect_equivalent(out6$V$V2, initV$V2)
expect_equivalent(out6$V$V3, initV$V3)

expect_equivalent(out7$V$V3, initV$V3)
expect_equivalent(out8$V$V2, initV$V2)
expect_equivalent(out9$V$V1, initV$V1)
