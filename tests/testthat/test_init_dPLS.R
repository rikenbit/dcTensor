test_that("dPLS (Init)", {
	X <- dcTensor::toyModel("dPLS_Easy")

	#
	# initV
	#
	initV <- list(
		V1=matrix(runif(ncol(X[[1]])*3),
			nrow=ncol(X[[1]]), ncol=3),
		V2=matrix(runif(ncol(X[[2]])*3),
			nrow=ncol(X[[2]]), ncol=3),
		V3=matrix(runif(ncol(X[[3]])*3),
			nrow=ncol(X[[3]]), ncol=3)
	)

	out <- dPLS(X, initV=initV, J=3, num.iter=2)

	expect_equivalent(length(out), 6)
})