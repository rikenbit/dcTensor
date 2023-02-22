dNMF <- function(X, M=NULL, pseudocount=.Machine$double.eps,
    initU=NULL, initV=NULL, fixU=FALSE, fixV=FALSE,
    Bin_U=1e-10, Bin_V=1e-10, Ter_U=1e-10, Ter_V=1e-10,
    L1_U=1e-10, L1_V=1e-10, L2_U=1e-10, L2_V=1e-10, J = 3,
    algorithm = c("Frobenius", "KL", "IS", "Beta"), Beta = 2,
    thr = 1e-10, num.iter = 100,
    viz = FALSE, figdir = NULL, verbose = FALSE){
    # Argument check
    algorithm <- match.arg(algorithm)
    chk <- .checkdNMF(X, M, pseudocount, initU, initV, fixU, fixV, 
    	Bin_U, Bin_V, Ter_U, Ter_V,
        L1_U, L1_V, L2_U, L2_V, J,
        Beta, thr, num.iter, viz, figdir, verbose)
    X <- chk$X
    M <- chk$M
    pM <- chk$pM
    # Initialization of U, V
    int <- .initdNMF(X, M, pseudocount, initU, initV, fixU, fixV,
    Bin_U, Bin_V, Ter_U, Ter_V,
    L1_U, L1_V, L2_U, L2_V, J, algorithm, Beta, thr, num.iter, viz, figdir, verbose)
    U <- int$U
    V <- int$V
    RecError <- int$RecError
    TrainRecError <- int$TrainRecError
    TestRecError <- int$TestRecError
    RelChange <- int$RelChange
    Beta <- int$Beta
    iter <- 1
    while ((RecError[iter] > thr) && (iter <= num.iter)) {
        # Update U, V
        X_bar <- .recMatrix(U, V)
        pre_Error <- .recError(X, X_bar)
		U <- .updateU_dNMF(X, pM, U, V, fixU, Bin_U, Ter_U, L1_U, L2_U, Beta)
		V <- .updateV_dNMF(X, pM, U, V, fixV, Bin_V, Ter_V, L1_V, L2_V, Beta)
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

.checkdNMF <- function(X, M, pseudocount, initU, initV, fixU, fixV,
    Bin_U, Bin_V, Ter_U, Ter_V,
    L1_U, L1_V, L2_U, L2_V, J, Beta, thr, num.iter, viz, figdir, verbose){
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
    if(Bin_U < 0){
        stop("Please specify the Bin_U that larger than 0")
    }
    if(Bin_V < 0){
        stop("Please specify the Bin_V that larger than 0")
    }
    if(Ter_U < 0){
        stop("Please specify the Ter_U that larger than 0")
    }
    if(Ter_V < 0){
        stop("Please specify the Ter_V that larger than 0")
    }
    if(L1_U < 0){
        stop("Please specify the L1_U that larger than 0")
    }
    if(L1_V < 0){
        stop("Please specify the L1_V that larger than 0")
    }
    if(L2_U < 0){
        stop("Please specify the L2_U that larger than 0")
    }
    if(L2_V < 0){
        stop("Please specify the L2_V that larger than 0")
    }
    stopifnot(is.numeric(J))
    stopifnot(is.numeric(Beta))
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

.initdNMF <- function(X, M, pseudocount, initU, initV, fixU, fixV,
    Bin_U, Bin_V, Ter_U, Ter_V,
    L1_U, L1_V, L2_U, L2_V, J, algorithm, Beta, thr, num.iter, viz, figdir, verbose){
	if(is.null(initU) || is.null(initV)){
		tmp <- NMF(X=X, M=M, pseudocount=pseudocount, initU=initU, initV=initV, fixU=fixU, fixV=fixV, L1_U=L1_U, L1_V=L1_V, L2_U=L2_U, L2_V=L2_U, J=J, algorithm=algorithm, Beta=Beta, thr1=thr, num.iter=100)
		Du <- diag(apply(tmp$U, 2, max))
		Dv <- diag(apply(tmp$V, 2, max))
		U <- tmp$U %*% diag(1/sqrt(diag(Du))) %*% sqrt(Dv)
		V <- tmp$V %*% diag(1/sqrt(diag(Dv))) %*% sqrt(Du)
		UV <- list()
		UV$U <- U
		UV$V <- V
	}
    if(is.null(initU)){
        U <- UV$U
    }else{
        U <- initU
    }
    if(is.null(initV)){
        V <- UV$V
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
    if (algorithm == "Frobenius") {
        Beta = 2
    }
    if (algorithm == "KL") {
        Beta = 1
    }
    if (algorithm == "IS") {
        Beta = 0
    }
    if (verbose) {
        cat("Iterative step is running...\n")
    }
    list(U=U, V=V, RecError=RecError,
        TrainRecError=TrainRecError,
        TestRecError=TestRecError, RelChange=RelChange,
        Beta=Beta)
}

.updateU_dNMF <- function(X, pM, U, V, fixU, Bin_U, Ter_U, L1_U, L2_U, Beta){
	if(!fixU){
		numer <- ((pM * U %*% t(V))^(Beta - 2) * (pM * X)) %*% V + 3 * Bin_U * U^2 + Ter_U * (30 * U^4 + 36 * U^2)
		denom <- (pM * U %*% t(V) )^(Beta - 1) %*% V + L1_U + L2_U * U + Bin_U * (2 * U^3 + U) + Ter_U * (6 * U^5 + 52 * U^3 + 8 * U)
		U <- U * (numer / denom)^.rho(Beta)
	}
	U
}

.updateV_dNMF <- function(X, pM, U, V, fixV, Bin_V, Ter_V, L1_V, L2_V, Beta){
    if(!fixV){
        numer <- t((pM * U %*% t(V))^(Beta - 2) * (pM * X)) %*% U + 3 * Bin_V * V^2 + Ter_V * (30 * V^4 + 36 * V^2)
        denom <- t((pM * U %*% t(V))^(Beta - 1)) %*% U + L1_V + L2_V * V + Bin_V * (2 * V^3 + V) + Ter_V * (6 * V^5 + 52 * V^3 + 8 * V)
        V <- V * (numer / denom)^.rho(Beta)
    }
    V
}
