dNTF <- function(X, M=NULL, pseudocount=.Machine$double.eps,
    initA=NULL, fixA=FALSE,
    Bin_A=rep(1e-10, length=length(dim(X))),
    Ter_A=rep(1e-10, length=length(dim(X))),
    L1_A=rep(1e-10, length=length(dim(X))),
    L2_A=rep(1e-10, length=length(dim(X))),
    rank = 3,
    algorithm = c("Frobenius", "KL", "IS", "Beta"),
    init = c("dNMF", "Random"),
    Beta = 2, thr = 1e-10, num.iter = 100, viz = FALSE, figdir = NULL,
    verbose = FALSE){
    # Argument check
    algorithm <- match.arg(algorithm)
    init <- match.arg(init)
    chk <- .checkdNTF(X, M, pseudocount, initA, fixA,
        Bin_A, Ter_A, L1_A, L2_A, rank, Beta,
        thr, num.iter, viz, figdir, verbose)
    X <- chk$X
    M <- chk$M
    pM <- chk$pM
    fixA <- chk$fixA
    N <- chk$N
    # Initialization of An
    int <- .initdNTF(X, N, rank, init, initA, Bin_A, Ter_A, L1_A, L2_A, Beta,
        algorithm, thr, verbose)
    A <- int$A
    RecError <- int$RecError
    TrainRecError <- int$TrainRecError
    TestRecError <- int$TestRecError
    RelChange <- int$RelChange
    Beta <- int$Beta
    algorithm <- int$algorithm
    iter <- 1
    while ((RelChange[iter] > thr) && (iter <= num.iter)) {
        # Before Update An
        X_bar <- recTensor(rep(1, length = rank), A, idx=seq(N))
        pre_Error <- .recError(X, X_bar)
        # Fill with Machine Epsilon
        for (n in seq(N)) {
            A[[n]][which(A[[n]] < pseudocount)] <- pseudocount
            A[[n]][which(is.infinite(A[[n]]))] <- pseudocount
            A[[n]][which(is.nan(A[[n]]))] <- pseudocount
            A[[n]][which(is.nan(A[[n]]))] <- pseudocount
        }
        # Update An
        if (algorithm == "Beta") {
            X_bar <- recTensor(rep(1, length = rank), A, idx=seq(N))
            for (n in seq(N)) {
                if(!fixA[n]){
                    A_notn <- .KhatriRao_notn(A, n)
                    numer <- t(A_notn) %*% (cs_unfold(pM*X, m = n)@data/cs_unfold(pM*X_bar^(Beta - 1), m = n)@data)
                    numer <- numer + 3 * Bin_A[n] * A[[n]]^2
                    numer <- numer + 30 * Ter_A[n] * A[[n]]^4 + 36 * Ter_A[n] * A[[n]]^2
                    denom <- t(A_notn) %*% cs_unfold(X_bar^(Beta), m = n)@data
                    denom <- denom + L1_A[n] + L2_A[n] * A[[n]]
                    denom <- denom + 2 * Bin_A[n] * A[[n]]^3 + Bin_A[n] * A[[n]]
                    denom <- denom + 6 * Ter_A[n] * A[[n]]^5 + 52 * Ter_A[n] * A[[n]]^3 + 8 * Ter_A[n] * A[[n]]
                    A[[n]] <- A[[n]] * (numer / denom)^.rho(Beta)
                }
            }
        }
        # Fill with Machine Epsilon
        for (n in seq(N)) {
            A[[n]][which(A[[n]] < pseudocount)] <- pseudocount
            A[[n]][which(is.infinite(A[[n]]))] <- pseudocount
            A[[n]][which(is.nan(A[[n]]))] <- pseudocount
            A[[n]][which(is.nan(A[[n]]))] <- pseudocount
        }
        # After Update U, V
        iter <- iter + 1
        X_bar <- recTensor(rep(1, length = rank), A, idx=seq(N))
        RecError[iter] <- .recError(X, X_bar)
        TrainRecError[iter] <- .recError(M*X, M*X_bar)
        TestRecError[iter] <- .recError((1-M)*X, (1-M)*X_bar)
        RelChange[iter] <- abs(pre_Error - RecError[iter]) / RecError[iter]

        if (viz && !is.null(figdir) && N == 3) {
            png(filename = paste0(figdir, "/", iter, ".png"))
            plotTensor3D(X_bar)
            dev.off()
        }
        if (viz && is.null(figdir) && N == 3) {
            plotTensor3D(X_bar)
        }
        if (verbose) {
            cat(paste0(iter-1, " / ", num.iter, " |Previous Error - Error| / Error = ",
                RelChange[iter], "\n"))
        }
        if (is.nan(RelChange[iter])) {
            stop("NaN is generated. Please run again or change the parameters.\n")
        }
    }
    if (viz && !is.null(figdir) && N == 3) {
        png(filename = paste0(figdir, "/finish.png"))
        plotTensor3D(X_bar)
        dev.off()
        png(filename = paste0(figdir, "/original.png"))
        plotTensor3D(X)
        dev.off()
    }
    if (viz && is.null(figdir) && N == 3) {
        plotTensor3D(X_bar)
    }
    names(RecError) <- c("offset", seq_len(iter-1))
    names(TrainRecError) <- c("offset", seq_len(iter-1))
    names(TestRecError) <- c("offset", seq_len(iter-1))
    names(RelChange) <- c("offset", seq_len(iter-1))
    # normalization
    S <- apply(A[[N]], 1, function(an){
        norm(as.matrix(an), "F")
    })
    A[[N]] <- A[[N]] / S

    return(list(S = S, A = A,
        RecError = RecError,
        TrainRecError = TrainRecError,
        TestRecError = TestRecError,
        RelChange = RelChange))
}

.checkdNTF <- function(X, M, pseudocount, initA, fixA,
    Bin_A, Ter_A, L1_A, L2_A, rank, Beta,
    thr, num.iter, viz, figdir, verbose){
    stopifnot(is.array(X@data))
    if(!is.null(M)){
        if(!identical(dim(X), dim(M))){
            stop("Please specify the dimensions of X and M are same")
        }
    }else{
        M <- X
        M@data[] <- 1
    }
    stopifnot(is.numeric(pseudocount))
    if(!is.null(initA)){
        dimX <- dim(X)
        ncolA <- as.vector(unlist(lapply(initA, ncol)))
        if(!identical(dimX, ncolA)){
            stop("Please specify the dimensions of X and ncol(A[[k]]) are same")
        }
    }
    if(!is.logical(fixA)){
        if(!is.vector(fixA)){
            stop("Please specify the fixA as a logical or a logical vector such as c(TRUE, FALSE, TRUE)")
        }else{
            if(length(dim(X)) != length(fixA)){
                stop("Please specify the length of fixA same as the order of X")
            }
        }
    }else{
        fixA <- rep(fixA, length=length(dim(X)))
    }
    stopifnot(length(Bin_A) == length(dim(X)))
    stopifnot(length(Ter_A) == length(dim(X)))
    stopifnot(length(L1_A) == length(dim(X)))
    stopifnot(length(L2_A) == length(dim(X)))
    stopifnot(all(unlist(lapply(Bin_A, function(x){x > 0}))))
    stopifnot(all(unlist(lapply(Ter_A, function(x){x > 0}))))
    stopifnot(all(unlist(lapply(L1_A, function(x){x > 0}))))
    stopifnot(all(unlist(lapply(L2_A, function(x){x > 0}))))
    stopifnot(is.numeric(rank))
    stopifnot(is.numeric(Beta))
    stopifnot(is.numeric(thr))
    stopifnot(is.numeric(num.iter))
    stopifnot(is.logical(viz))
    stopifnot(is.logical(verbose))
    if(!is.character(figdir) && !is.null(figdir)){
        stop("Please specify the figdir as a string or NULL")
    }
    if (verbose) {
        cat("Initialization step is running...\n")
    }
    X <- .pseudocount(X, pseudocount)
    pM <- .pseudocount(M, pseudocount)
    N <- length(dim(X))
    list(X=X, M=M, pM=pM, fixA=fixA, N=N)
}

.initdNTF <- function(X, N, rank, init, initA, Bin_A, Ter_A, L1_A, L2_A, Beta,
    algorithm, thr, verbose){
    T1 <- NULL
    E <- NULL
    if(is.null(initA)){
        A <- list()
        length(A) <- N
        for (n in seq(N)) {
            if (init == "dNMF") {
                Xn <- cs_unfold(X, m = n)@data
                res.nmf <- dNMF(Xn, J = rank,
                    Bin_U=min(Bin_A[-n]), Ter_U=min(Ter_A[-n]),
                    L1_U=min(L1_A[-n]), L2_U=min(L2_A[-n]),
                    Bin_V=Bin_A[n], Ter_V=Ter_A[n],
                    L1_V=L1_A[n], L2_V=L2_A[n],
                    algorithm = algorithm)
                A[[n]] <- t(res.nmf$V)
                orderA <- order(sapply(seq(rank), function(x) {
                    norm(as.matrix(res.nmf$V[, x], "F")) * norm(as.matrix(res.nmf$U[,
                      x]), "F")
                }), decreasing = TRUE)
                if(rank != 1){
                    A[[n]] <- A[[n]][orderA, ]
                }
            } else if (init == "Random") {
                A[[n]] <- matrix(runif(rank * dim(X)[n]), nrow = rank,
                    ncol = dim(X)[n])
                orderA <- order(apply(A[[n]], 1, function(x) {
                    norm(as.matrix(x), "F")
                }), decreasing = TRUE)
            }
        }
    }else{
        A <- initA
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
    list(A=A, RecError=RecError, TrainRecError=TrainRecError, TestRecError=TestRecError, RelChange=RelChange, Beta=Beta, algorithm=algorithm)
}