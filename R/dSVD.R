dSVD <- function(X, M=NULL, pseudocount=.Machine$double.eps,
    initU=NULL, initV=NULL, fixU=FALSE, fixV=FALSE, Ter_U=1e-10,
    L1_U=1e-10, L2_U=1e-10, eta=1e+10, J = 3,
    thr = 1e-10, num.iter = 100,
    viz = FALSE, figdir = NULL, verbose = FALSE){
    # Argument check
    chk <- .checkdSVD(X, M, pseudocount, initU, initV, fixU, fixV,
        Ter_U, L1_U, L2_U, eta, J, thr, num.iter, viz, figdir, verbose)
    X <- chk$X
    M <- chk$M
    pM <- chk$pM
    # Initialization of U, V
    int <- .initdSVD(X, initU, initV, J, thr, verbose)
    U <- int$U
    V <- int$V
    RecError <- int$RecError
    TrainRecError <- int$TrainRecError
    TestRecError <- int$TestRecError
    RelChange <- int$RelChange
    iter <- 1
    while ((RecError[iter] > thr) && (iter <= num.iter)) {
        # Update U, V
        X_bar <- .recMatrix(U, V)
        pre_Error <- .recError(X, X_bar)
		U <- .updateU_dSVD(X, pM, U, V, fixU, Ter_U, L1_U, L2_U, eta, iter)
        V <- .updateV_dSVD(X, pM, U, V, fixV)
        # After Update U, V
        iter <- iter + 1
        X_bar <- .recMatrix(U, V)
        RecError[iter] <- .recError(X, X_bar)
        TrainRecError[iter] <- .recError(M*X, M*X_bar)
        TestRecError[iter] <- .recError((1-M)*X, (1-M)*X_bar)
        RelChange[iter] <- abs(pre_Error - RecError[iter]) / RecError[iter]
        if (viz && !is.null(figdir)) {
            png(filename = paste0(figdir, "/", iter-1, ".png"))
            image.plot(X_bar)
            dev.off()
        }
        if (viz && is.null(figdir)) {
            image.plot(X_bar)
        }
        if (verbose) {
            cat(paste0(iter-1, " / ", num.iter, " |Previous Error - Error| / Error = ",
                RelChange[iter], "\n"))
        }
        if (is.nan(RelChange[iter])) {
            stop("NaN is generated. Please run again or change the parameters.\n")
        }
    }
    if (viz && !is.null(figdir)) {
        png(filename = paste0(figdir, "/finish.png"))
        image.plot(X_bar)
        dev.off()
        png(filename = paste0(figdir, "/original.png"))
        image.plot(X)
        dev.off()
    }
    if (viz && is.null(figdir)) {
        image.plot(X_bar)
    }
    names(RecError) <- c("offset", seq_len(iter-1))
    names(TrainRecError) <- c("offset", seq_len(iter-1))
    names(TestRecError) <- c("offset", seq_len(iter-1))
    names(RelChange) <- c("offset", seq_len(iter-1))

    list(U = U, V = V, RecError = RecError,
        TrainRecError = TrainRecError,
        TestRecError = TestRecError,
        RelChange = RelChange)
}

.checkdSVD <- function(X, M, pseudocount, initU, initV, fixU, fixV,
        Ter_U, L1_U, L2_U, eta, J, thr, num.iter, viz, figdir, verbose){
    stopifnot(is.matrix(X))
    if(!is.null(M)){
        if(!identical(dim(X), dim(M))){
            stop("Please specify the dimensions of X and M are same")
        }
    }else{
        M <- X
        M[,] <- 1
    }
    stopifnot(is.numeric(pseudocount))
    if(!is.null(initU)){
        if(!identical(nrow(X), nrow(initU))){
            stop("Please specify nrow(X) and nrow(initU) are same")
        }
    }
    if(!is.null(initV)){
        if(!identical(ncol(X), nrow(initV))){
            stop("Please specify ncol(X) and nrow(initV) are same")
        }
    }
    stopifnot(is.logical(fixU))
    stopifnot(is.logical(fixV))
    if(Ter_U < 0){
        stop("Please specify the Ter_U that larger than 0")
    }
    if(L1_U < 0){
        stop("Please specify the L1_U that larger than 0")
    }
    if(L2_U < 0){
        stop("Please specify the L2_U that larger than 0")
    }
    if(eta < 0){
        stop("Please specify the eta that larger than 0")
    }
    stopifnot(is.numeric(J))
    stopifnot(is.numeric(thr))
    stopifnot(is.numeric(num.iter))
    stopifnot(is.logical(viz))
    if(!is.character(figdir) && !is.null(figdir)){
        stop("Please specify the figdir as a string or NULL")
    }
    stopifnot(is.logical(verbose))
    pM <- M
    X[which(X == 0)] <- pseudocount
    pM[which(pM == 0)] <- pseudocount
    list(X=X, M=M, pM=pM)
}

.initdSVD <- function(X, initU, initV, J, thr, verbose){
    if(is.null(initU)){
        U <- matrix(runif(nrow(X)*J), nrow=nrow(X), ncol=J)
    }else{
        U <- initU
    }
    if(is.null(initV)){
        V <- matrix(runif(ncol(X)*J), nrow=ncol(X), ncol=J)
    }else{
        V <- initV
    }
    RecError = c()
    TrainRecError = c()
    TestRecError = c()
    RelChange = c()
    RecError[1] <- thr * 10
    TrainRecError[1] <- thr * 10
    TestRecError[1] <- thr * 10
    RelChange[1] <- thr * 10
    if (verbose) {
        cat("Iterative step is running...\n")
    }
    list(U=U, V=V, RecError=RecError,
        TrainRecError=TrainRecError,
        TestRecError=TestRecError, RelChange=RelChange)
}

.updateU_dSVD <- function(X, pM, U, V, fixU, Ter_U, L1_U, L2_U, eta, iter){
	if(!fixU){
        stepSize <- eta / iter
        grad <- (X * pM) %*% t(X * pM) %*% U %*% diag(ncol(U):1)
        L1Term <- L1_U
        L2Term <- L2_U * U
        TerTerm <- Ter_U * (3 * U^5 - 4 * U^3 + U)
		U <- .scaleQR(U + stepSize * grad - L1Term - L2Term - TerTerm)
	}
	U
}

.updateV_dSVD <- function(X, pM, U, V, fixV){
    if(!fixV){
        V <- t(X * pM) %*% U
    }
    V
}
