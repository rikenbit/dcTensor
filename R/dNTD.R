dNTD <- function(X, M=NULL, pseudocount=.Machine$double.eps,
    initS=NULL, initA=NULL, fixS=FALSE, fixA=FALSE,
    Bin_A=rep(1e-10, length=length(dim(X))),
    Ter_A=rep(1e-10, length=length(dim(X))),
    L1_A=rep(1e-10, length=length(dim(X))),
    L2_A=rep(1e-10, length=length(dim(X))),
    rank = rep(3, length=length(dim(X))),
    modes = seq_along(dim(X)),
    algorithm = c("Frobenius", "KL", "IS", "Beta"),
    init = c("dNMF", "Random"),
    Beta = 2, thr = 1e-10, num.iter = 100,
    viz = FALSE,
    figdir = NULL, verbose = FALSE){
    # Argument check
    algorithm <- match.arg(algorithm)
    init <- match.arg(init)
    .checkdNTD(X, M, pseudocount, initS, initA, fixS, fixA,
        Bin_A, Ter_A, L1_A, L2_A, rank, modes, Beta, thr, num.iter, viz, figdir, verbose)
    # Initialization of An and S
    int <- .initdNTD(X, M, pseudocount, fixA, rank, modes, init, initS, initA,
        Bin_A, Ter_A, L1_A, L2_A, Beta, algorithm, thr, verbose)
    X <- int$X
    M <- int$M
    pM <- int$pM
    M_NA <- int$M_NA
    fixA <- int$fixA
    modes <- int$modes
    N <- int$N
    A <- int$A
    S <- int$S
    rank <- int$rank
    RecError <- int$RecError
    TrainRecError <- int$TrainRecError
    TestRecError <- int$TestRecError
    RelChange <- int$RelChange
    Beta <- int$Beta
    algorithm <- int$algorithm
    iter <- 1
    while ((RecError[iter] > thr) && (iter <= num.iter)) {
        X_bar <- recTensor(S=S, A=A, idx=modes)
        pre_Error <- .recError(X, X_bar)
        # Update An
        for (n in modes) {
            if(!fixA[n]){
                S_A <- t(cs_unfold(S, m = n)@data) %*% kronecker_list(sapply(rev(setdiff(1:N,
                  n)), function(x) {
                  A[[x]]
                }, simplify = FALSE))
                Xn <- cs_unfold(X, m = n)@data
                pMn <- cs_unfold(pM, m = n)@data
                Xn_bar <- cs_unfold(recTensor(S=S, A=A), m = n)@data
                numer <- S_A %*% ((pMn * Xn) * (pMn * Xn_bar^(Beta - 1)))
                numer <- numer + 3 * Bin_A[n] * A[[n]]^2
                numer <- numer + 30 * Ter_A[n] * A[[n]]^4 + 36 * Ter_A[n] * A[[n]]^2
                denom <- S_A %*% (t(S_A) %*% A[[n]])^Beta + L1_A[n] + L2_A[n] * A[[n]]
                denom <- denom + 2 * Bin_A[n] * A[[n]]^3 + Bin_A[n] * A[[n]]
                denom <- denom + 6 * Ter_A[n] * A[[n]]^5 + 52 * Ter_A[n] * A[[n]]^3 + 8 * Ter_A[n] * A[[n]]
                A[[n]] <- A[[n]] * (numer / denom)^.rho(Beta)
            }
        }
        # Update Core tensor
        if(!fixS){
            X_bar <- recTensor(S=S, A=A, idx=modes)
            numer <- pM * X * X_bar^(Beta - 1)
            denom <- pM * X_bar^Beta
            for (n in 1:N) {
                numer <- ttm(numer, A[[n]], m = n)
                denom <- ttm(denom, A[[n]], m = n)
            }
            S <- S * numer/denom
        }
        # NaN
        for (n in modes) {
            if (any(is.infinite(A[[n]])) || any(is.nan(A[[n]]))) {
                stop("Inf or NaN is generated!\n")
            }
        }
        # After Update U, V
        iter <- iter + 1
        X_bar <- recTensor(S=S, A=A, idx=modes)
        RecError[iter] <- .recError(X, X_bar)
        TrainRecError[iter] <- .recError((1-M_NA+M)*X, (1-M_NA+M)*X_bar)
        TestRecError[iter] <- .recError((M_NA-M)*X, (M_NA-M)*X_bar)
        RelChange[iter] <- abs(pre_Error - RecError[iter]) / RecError[iter]
        # Visualization
        if (viz && !is.null(figdir) && N == 3) {
            png(filename = paste0(figdir, "/", iter, ".png"))
            plotTensor3D(X_bar)
            dev.off()
        }
        if (viz && is.null(figdir) && N == 3) {
            plotTensor3D(X_bar)
        }
        # Verbose Message
        if (verbose) {
            cat(paste0(iter-1, " / ", num.iter, " |Previous Error - Error| / Error = ",
                RelChange[iter], "\n"))
        }
        # Exception Handling
        if (is.nan(RelChange[iter])) {
            stop("NaN is generated. Please run again or change the parameters.\n")
        }
    }
    # Visualization
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
    # Output
    names(RecError) <- c("offset", seq_len(iter-1))
    names(TrainRecError) <- c("offset", seq_len(iter-1))
    names(TestRecError) <- c("offset", seq_len(iter-1))
    names(RelChange) <- c("offset", seq_len(iter-1))
    list(S = S, A = A,
        RecError = RecError,
        TrainRecError = TrainRecError,
        TestRecError = TestRecError,
        RelChange = RelChange)
}

.checkdNTD <- function(X, M, pseudocount, initS, initA, fixS, fixA,
        Bin_A, Ter_A, L1_A, L2_A, rank, modes, Beta, thr, num.iter, viz, figdir, verbose){
    stopifnot(is.array(X@data))
    if(!is.null(M)){
        if(!identical(dim(X), dim(M))){
            stop("Please specify the dimensions of X and M are same")
        }
        .checkZeroNA(X, M, type="Tensor")
    }
    stopifnot(is.numeric(pseudocount))
    if(!is.null(initS)){
        dimS <- as.numeric(dim(initS)[modes])
        if(!identical(rank, dimS)){
            stop("Please specify the rank and dim(S) are same")
        }
    }
    if(!is.null(initA)){
        nrowA <- as.numeric(unlist(lapply(initA, nrow)))[modes]
        if(!identical(rank, nrowA)){
            stop("Please specify the rank and nrow(A[[k]]) are same")
        }
    }
    if(!is.logical(fixS)){
        if(!"Tensor" %in% is(X)){
            stop("Please specify the fixS as a logical or a Tensor object")
        }else{
            if(!identical(rank, dim(fixS))){
                stop("Please specify the dimensions of fixS same as the rank")
            }
        }
    }
    if(!is.logical(fixA)){
        if(!is.vector(fixA)){
            stop("Please specify the fixA as a logical or a logical vector such as c(TRUE, FALSE, TRUE)")
        }else{
            if(length(modes) != length(fixA)){
                stop("Please specify the length of fixA same as length(modes)")
            }
        }
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
    stopifnot(is.numeric(modes))
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
}

.initdNTD <- function(X, M, pseudocount, fixA, rank, modes, init, initS, initA,
    Bin_A, Ter_A, L1_A, L2_A, Beta, algorithm, thr, verbose){
    N <- length(dim(X))
    tmp <- rep(FALSE, length=length(dim(X)))
    tmp[modes] <- fixA
    fixA <- tmp
    # modes
    modes <- unique(modes)
    modes <- modes[order(modes)]
    if(length(modes) != length(rank)){
        stop("Please the length(modes) and length(rank) as same")
    }
    # NA mask
    M_NA <- X
    M_NA@data[] <- 1
    M_NA@data[which(is.na(X@data))] <- 0
    if(is.null(M)){
        M <- M_NA
    }
    pM <- M
    # Pseudo count
    X@data[which(is.na(X@data))] <- pseudocount
    X <- .pseudocount(X, pseudocount)
    pM <- .pseudocount(M, pseudocount)
    A <- list()
    length(A) <- N
    Iposition <- setdiff(seq_len(N), modes)
    rank <- .insertNULL(rank, Iposition, N)
    if(is.null(initA)){
        if (init == "dNMF") {
            sapply(modes, function(n) {
                Xn <- cs_unfold(X, m = n)@data
                A[[n]] <<- t(dNMF(Xn, J = rank[n],
                    Bin_U=min(Bin_A[-n]), Ter_U=min(Ter_A[-n]),
                    L1_U=min(L1_A[-n]), L2_U=min(L2_A[-n]),
                    Bin_V=Bin_A[n], Ter_V=Ter_A[n],
                    L1_V=L1_A[n], L2_V=L2_A[n],
                    algorithm = algorithm)$V)
            })
        } else if (init == "Random") {
            sapply(modes, function(n) {
                A[[n]] <<- matrix(runif(rank[n] * dim(X)[n]),
                    nrow = rank[n], ncol = dim(X)[n])
            })
        }
        sapply(Iposition, function(n){
            A[[n]] <<- diag(dim(X)[n])
        })
    }else{
        A <- initA
    }
    names(A)[modes] <- paste0("A", modes)
    names(A)[Iposition] <- paste0("I", seq_along(Iposition))

    if(is.null(initS)){
        S <- recTensor(S=X, A=A, idx=modes, reverse = TRUE)
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
    list(X=X, M=M, pM=pM, M_NA=M_NA,
        fixA=fixA, modes=modes, N=N,
        A=A, S=S, rank=rank, RecError=RecError, TrainRecError=TrainRecError,
        TestRecError=TestRecError, RelChange=RelChange,
        Beta=Beta,
        algorithm=algorithm)
}
