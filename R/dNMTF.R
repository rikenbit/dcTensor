dNMTF <- function(X, M=NULL,
    pseudocount=.Machine$double.eps,
    initU=NULL, initS=NULL, initV=NULL,
    fixU=FALSE, fixS=FALSE, fixV=FALSE,
    Bin_U=1e-10, Bin_S=1e-10, Bin_V=1e-10,
    Ter_U=1e-10, Ter_S=1e-10, Ter_V=1e-10,
    L1_U=1e-10, L1_S=1e-10, L1_V=1e-10,
    L2_U=1e-10, L2_S=1e-10, L2_V=1e-10,
    rank = c(3, 4),
    algorithm = c("Frobenius", "KL", "IS", "Beta"),
    Beta = 2, root = FALSE, thr = 1e-10, num.iter = 100,
    viz = FALSE, figdir = NULL, verbose = FALSE){
    # Argument check
    algorithm <- match.arg(algorithm)
    .checkdNMTF(X, M, pseudocount, initU, initS, initV,
    fixU, fixS, fixV, Bin_U, Bin_S, Bin_V, Ter_U, Ter_S, Ter_V,
    L1_U, L1_S, L1_V, L2_U, L2_S, L2_V,
    rank, Beta, root, thr, num.iter, viz, figdir, verbose)
    # Initizalization
    int <- .initdNMTF(X, M, pseudocount, rank, initU, initS, initV,
    algorithm, Beta, thr, verbose)
    X <- int$X
    M <- int$M
    pM <- int$pM
    M_NA <- int$M_NA
    U <- int$U
    S <- int$S
    V <- int$V
    RecError <- int$RecError
    TrainRecError <- int$TrainRecError
    TestRecError <- int$TestRecError
    RelChange <- int$RelChange
    Beta <- int$Beta
    algorithm <- int$algorithm
    # Iteration
    iter <- 1
    while ((RecError[iter] > thr) && (iter <= num.iter)) {
        # Reconstruction
        X_bar <- U %*% S %*% t(V)
        pre_Error <- .recError(X, X_bar)
        # Update U
        if(!fixU){
            U <- .updateU_dNMTF(X, pM, U, S, V, Bin_U, Ter_U,
                L1_U, L2_U, Beta, root)
        }
        # Update V
        if(!fixV){
            V <- .updateV_dNMTF(X, pM, U, S, V, Bin_V, Ter_V,
                L1_V, L2_V, Beta, root)
        }
        # Update S
        if(!fixS){
            S <- .updateS_dNMTF(X, pM, U, S, V, Bin_S, Ter_S,
                L1_S, L2_S, Beta, root)
        }
        # After Update U, S, V
        iter <- iter + 1
        X_bar <- U %*% S %*% t(V)
        RecError[iter] <- .recError(X, X_bar)
        TrainRecError[iter] <- .recError((1-M_NA+M)*X, (1-M_NA+M)*X_bar)
        TestRecError[iter] <- .recError((M_NA-M)*X, (M_NA-M)*X_bar)
        RelChange[iter] <- abs(pre_Error - RecError[iter]) / RecError[iter]
        if (viz && !is.null(figdir)) {
            png(filename = paste0(figdir, "/", iter-1, ".png"))
            .multiImagePlots(list(X, X_bar, U, S, t(V)))
            dev.off()
        }
        if (viz && is.null(figdir)) {
            .multiImagePlots(list(X, X_bar, U, S, t(V)))
        }
        if (verbose) {
            cat(paste0(iter-1, " / ", num.iter,
                " |Previous Error - Error| / Error = ",
                RelChange[iter], "\n"))
        }
        if (is.nan(RelChange[iter])) {
            stop("NaN is generated. Please run again or change the parameters.\n")
        }
    }
    # After iteration
    if (viz && !is.null(figdir)) {
        png(filename = paste0(figdir, "/finish.png"))
        image.plot2(X_bar)
        dev.off()
        png(filename = paste0(figdir, "/original.png"))
        image.plot2(X)
        dev.off()
    }
    if (viz && is.null(figdir)) {
            .multiImagePlots(list(X, X_bar, U, S, t(V)))
    }
    names(RecError) <- c("offset", seq_len(iter-1))
    names(TrainRecError) <- c("offset", seq_len(iter-1))
    names(TestRecError) <- c("offset", seq_len(iter-1))
    names(RelChange) <- c("offset", seq_len(iter-1))
    # Output
    list(U = U, S = S, V = V, rank = rank,
        RecError = RecError,
        TrainRecError = TrainRecError,
        TestRecError = TestRecError,
        RelChange = RelChange)
}

.checkdNMTF <- function(X, M, pseudocount, initU, initS, initV,
    fixU, fixS, fixV, Bin_U, Bin_S, Bin_V, Ter_U, Ter_S, Ter_V,
    L1_U, L1_S, L1_V, L2_U, L2_S, L2_V,
    rank, Beta, root, thr, num.iter, viz, figdir, verbose){
    stopifnot(is.matrix(X))
    if(!is.null(M)){
        if(!identical(dim(X), dim(M))){
            stop("Please specify the dimensions of X and M are same")
        }
    }
    .checkZeroNA(X, M, type="matrix")
    stopifnot(is.numeric(pseudocount))
    if(!is.null(initU)){
        if(!identical(nrow(X), nrow(initU))){
            stop("Please specify nrow(X) and nrow(initU) are same")
        }
    }
    if(!is.null(initS)){
        if(rank[1] != nrow(initS)){
            stop("Please specify rank[1] and nrow(initS) are same")
        }
        if(rank[2] != ncol(initS)){
            stop("Please specify rank[2] and ncol(initS) are same")
        }
    }
    if(!is.null(initV)){
        if(!identical(ncol(X), nrow(initV))){
            stop("Please specify ncol(X) and nrow(initV) are same")
        }
    }
    stopifnot(is.logical(fixU))
    stopifnot(is.logical(fixS))
    stopifnot(is.logical(fixV))
    if(Bin_U < 0){
        stop("Please specify the Bin_U that larger than 0")
    }
    if(Bin_S < 0){
        stop("Please specify the Bin_S that larger than 0")
    }
    if(Bin_V < 0){
        stop("Please specify the Bin_V that larger than 0")
    }
    if(Ter_U < 0){
        stop("Please specify the Ter_U that larger than 0")
    }
    if(Ter_S < 0){
        stop("Please specify the Ter_S that larger than 0")
    }
    if(Ter_V < 0){
        stop("Please specify the Ter_V that larger than 0")
    }
    if(L1_U < 0){
        stop("Please specify the L1_U that larger than 0")
    }
    if(L1_S < 0){
        stop("Please specify the L1_S that larger than 0")
    }
    if(L1_V < 0){
        stop("Please specify the L1_V that larger than 0")
    }
    if(L2_U < 0){
        stop("Please specify the L2_U that larger than 0")
    }
    if(L2_S < 0){
        stop("Please specify the L2_S that larger than 0")
    }
    if(L2_V < 0){
        stop("Please specify the L2_V that larger than 0")
    }
    stopifnot(is.numeric(rank))
    stopifnot(is.numeric(Beta))
    stopifnot(is.logical(root))
    stopifnot(is.numeric(thr))
    stopifnot(is.numeric(num.iter))
    stopifnot(is.logical(viz))
    if(!is.character(figdir) && !is.null(figdir)){
        stop("Please specify the figdir as a string or NULL")
    }
    stopifnot(is.logical(verbose))
}

.initdNMTF <- function(X, M, pseudocount, rank, initU, initS, initV,
    algorithm, Beta, thr, verbose){
    # NA mask
    M_NA <- X
    M_NA[] <- 1
    M_NA[which(is.na(X))] <- 0
    if(is.null(M)){
        M <- M_NA
    }
    pM <- M
    # Pseudo count
    X[which(is.na(X))] <- pseudocount
    X[which(X == 0)] <- pseudocount
    pM[which(pM == 0)] <- pseudocount
    if(is.null(initU)){
        U <- matrix(runif(nrow(X)*rank[1]), nrow=nrow(X), ncol=rank[1])
    }else{
        U <- initU
    }
    if(is.null(initV)){
        V <- matrix(runif(ncol(X)*rank[2]), nrow=ncol(X), ncol=rank[2])
    }else{
        V <- initV
    }
    if(is.null(initS)){
        S <- matrix(runif(prod(rank)), nrow=rank[1], ncol=rank[2])
    }else{
        S <- initS
    }
    RecError = c()
    TrainRecError = c()
    TestRecError = c()
    RelChange = c()
    RecError[1] <- thr * 10
    TrainRecError[1] <- thr * 10
    TestRecError[1] <- thr * 10
    RelChange[1] <- thr * 10
    # Algorithm
    if (algorithm == "Frobenius") {
        Beta = 2
        algorithm = "Beta"
    }
    if (algorithm == "KL") {
        Beta = 1
        algorithm = "Beta"
    }
    if (algorithm == "IS") {
        Beta = 0
        algorithm = "Beta"
    }
    if (verbose) {
        cat("Iterative step is running...\n")
    }
    list(X=X, M=M, pM=pM, M_NA=M_NA, U=U, S=S, V=V, RecError=RecError,
        TrainRecError=TrainRecError, TestRecError=TestRecError,
        RelChange=RelChange,
        Beta=Beta, algorithm=algorithm)
}

.updateU_dNMTF <- function(X, pM, U, S, V, Bin_U, Ter_U,
    L1_U, L2_U, Beta, root){
    VS <- V %*% t(S)
    numer <- (pM * ((U %*% t(VS))^(Beta-2)) * (pM * X)) %*% VS
    numer <- numer + 3 * Bin_U * U^2
    numer <- numer + Ter_U * (30 * U^4 + 36 * U^2)
    denom <- (pM * (U %*% t(VS))^(Beta-1)) %*% VS
    denom <- denom + L1_U + L2_U * U
    denom <- denom + Bin_U * (2 * U^3 + U)
    denom <- denom + Ter_U * (6 * U^5 + 52 * U^3 + 8 * U)
    U * (numer / denom)^.rho(Beta, root)
}

.updateV_dNMTF <- function(X, pM, U, S, V, Bin_V, Ter_V,
    L1_V, L2_V, Beta, root){
    SU <- t(S) %*% t(U)
    VV <- V %*% t(V)
    numer <- SU %*% ((t(SU) %*% t(V))^(Beta - 2) * (pM * X))
    numer <- numer + t(3 * Bin_V * V^2)
    numer <- numer + t(Ter_V * (30 * V^4 + 36 * V^2))
    denom <- SU %*% ((t(SU) %*% t(V))^(Beta - 1) * pM)
    denom <- denom + L1_V + L2_V * t(V)
    denom <- denom + Bin_V * (2 * t(V)^3 + t(V))
    denom <- denom + Ter_V * (6 * t(V)^5 + 52 * t(V)^3 + 8 * t(V))
    V * t((numer / denom)^.rho(Beta, root))
}

.updateS_dNMTF <- function(X, pM, U, S, V, Bin_S, Ter_S,
    L1_S, L2_S, Beta, root){
    US <- U %*% S
    numer <- t(U) %*% ((US %*% t(V))^(Beta-2) * (pM * X)) %*% V
    numer <- numer + 3 * Bin_S * S^2
    numer <- numer + Ter_S * (30 * S^4 + 36 * S^2)
    denom <- t(U) %*% (US %*% t(V))^(Beta-1) %*% V
    denom <- denom + L1_S + L2_S * S
    denom <- denom + Bin_S * (2 * S^3 + S)
    denom <- denom + Ter_S * (6 * S^5 + 52 * S^3 + 8 * S)
    S * (numer / denom)^.rho(Beta, root)
}

.trace <- function(mat){
    sum(diag(mat))
}

.multiImagePlots <- function(inputList){
    layout(rbind(1:3, 4:6))
    image.plot2(inputList[[1]], main="X")
    image.plot2(inputList[[2]], main="rec X")
    plot.new()
    image.plot2(inputList[[3]], main="U")
    image.plot2(inputList[[4]], main="S")
    image.plot2(inputList[[5]], main="t(V)")
}

image.plot2 <- function(A, ...){
    image.plot(t(A[nrow(A):1,]), ...)
}