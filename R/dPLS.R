dPLS <- function(X, M=NULL, pseudocount=.Machine$double.eps,
    initV=NULL, fixV=FALSE, Ter_V=1e-10,
    L1_V=1e-10, L2_V=1e-10, eta=1e+10, J = 3,
    thr = 1e-10, num.iter = 100,
    viz = FALSE, figdir = NULL, verbose = FALSE){
    # Argument check
    .checkdPLS(X, M, pseudocount, initV, fixV,
        Ter_V, L1_V, L2_V, eta, J, thr, num.iter, viz, figdir, verbose)
    # Initialization of U, V
    int <- .initdPLS(X, M, pseudocount, fixV, initV, J, thr, verbose)
    X <- int$X
    M <- int$M
    pM <- int$pM
    M_NA <- int$M_NA
    fixV <- int$fixV
    U <- int$U
    V <- int$V
    RecError <- int$RecError
    TrainRecError <- int$TrainRecError
    TestRecError <- int$TestRecError
    RelChange <- int$RelChange
    iter <- 1
    while ((RecError[iter] > thr) && (iter <= num.iter)) {
        # Before Update W, H_k
        X_bar <- lapply(seq_along(X), function(x){
            .recMatrix(U[[x]], V[[x]])
        })
        pre_Error <- sqrt(sum(unlist(lapply(seq_along(X), function(x){
            .recError(X[[x]], X_bar[[x]], notsqrt=TRUE)
        }))))
        # Update U, V
        V <- .updateV_dPLS(X, pM, V, fixV, Ter_V, L1_V, L2_V, eta, iter)
        U <- lapply(seq_along(X), function(x){
            X[[x]] %*% V[[x]]
        })
        # After Update U, V
        iter <- iter + 1
        X_bar <- lapply(seq_along(X), function(x){
            .recMatrix(U[[x]], V[[x]])
        })
        RecError[iter] <- sqrt(sum(unlist(lapply(seq_along(X), function(x){
            .recError(X[[x]], X_bar[[x]], notsqrt=TRUE)
        }))))
        TrainRecError[iter] <- sqrt(sum(unlist(lapply(seq_along(X), function(x){
            .recError((1-M_NA[[x]]+M[[x]]) * X[[x]], (1-M_NA[[x]]+M[[x]]) * X_bar[[x]], notsqrt=TRUE)
        }))))
        TestRecError[iter] <- sqrt(sum(unlist(lapply(seq_along(X), function(x){
            .recError((M_NA[[x]]-M[[x]]) * X[[x]], (M_NA[[x]]-M[[x]]) * X_bar[[x]], notsqrt=TRUE)
        }))))
        RelChange[iter] <- abs(pre_Error - RecError[iter]) / RecError[iter]
        # Visualization
        if (viz && !is.null(figdir)) {
            png(filename = paste0(figdir, "/", iter-1, ".png"))
            lapply(X_bar, image.plot)
            dev.off()
        }
        if (viz && is.null(figdir)) {
            lapply(X_bar, image.plot)
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
    if (viz && !is.null(figdir)) {
        png(filename = paste0(figdir, "/finish.png"))
        lapply(X_bar, image.plot)
        dev.off()
        png(filename = paste0(figdir, "/original.png"))
            lapply(X, image.plot)
        dev.off()
    }
    if (viz && is.null(figdir)) {
        lapply(X_bar, image.plot)
    }
    # Output
    names(RecError) <- c("offset", seq_len(iter-1))
    names(TrainRecError) <- c("offset", seq_len(iter-1))
    names(TestRecError) <- c("offset", seq_len(iter-1))
    names(RelChange) <- c("offset", seq_len(iter-1))
    list(U = U, V = V, RecError = RecError,
        TrainRecError = TrainRecError,
        TestRecError = TestRecError,
        RelChange = RelChange)
}

.checkdPLS <- function(X, M, pseudocount, initV, fixV,
        Ter_V, L1_V, L2_V, eta, J, thr, num.iter, viz, figdir, verbose){
    if(length(X) < 2){
        stop("input list X must have at least two datasets!")
    }
    if(!is.null(M)){
        dimX <- as.vector(unlist(lapply(X, function(x){dim(x)})))
        dimM <- as.vector(unlist(lapply(M, function(x){dim(x)})))
        if(!identical(dimX, dimM)){
            stop("Please specify the dimensions of X and M are same")
        }
        lapply(seq(length(X)), function(i){
            .checkZeroNA(X[[i]], M[[i]], type="matrix")
        })
    }
    stopifnot(is.numeric(pseudocount))
    if(!is.null(initV)){
        if(!identical(ncol(X), nrow(initV))){
            stop("Please specify ncol(X) and nrow(initV) are same")
        }
    }
    stopifnot(is.logical(fixV))
    if(Ter_V < 0){
        stop("Please specify the Ter_V that larger than 0")
    }
    if(L1_V < 0){
        stop("Please specify the L1_V that larger than 0")
    }
    if(L2_V < 0){
        stop("Please specify the L2_V that larger than 0")
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
}

.initdPLS <- function(X, M, pseudocount, fixV, initV, J, thr, verbose){
    if(is.logical(fixV)){
        fixV <- rep(fixV, length=length(X))
    }
    # NA mask
    M_NA <- list()
    length(M_NA) <- length(X)
    for(i in seq_along(X)){
        M_NA[[i]] <- X[[i]]
        M_NA[[i]][] <- 1
        M_NA[[i]][which(is.na(X[[i]]))] <- 0
    }
    if(is.null(M)){
        M <- M_NA
    }
    pM <- M
    # Pseudo count
    for(i in seq_along(X)){
        X[[i]][which(is.na(X[[i]]))] <- pseudocount
        X[[i]][which(X[[i]] == 0)] <- pseudocount
        pM[[i]][which(pM[[i]] == 0)] <- pseudocount
    }
    if(is.null(initV)){
        V <- lapply(seq_along(X), function(x){
            tmp <- matrix(runif(ncol(X[[x]])*J),
                nrow=ncol(X[[x]]), ncol=J)
            .columnNorm(tmp)
        })
    }else{
        V <- initV
    }
    U <- lapply(seq_along(X), function(x){
        X[[x]] %*% V[[x]]
    })
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
    list(X=X, M=M, pM=pM, M_NA=M_NA, fixV=fixV,
        U=U, V=V, RecError=RecError,
        TrainRecError=TrainRecError,
        TestRecError=TestRecError, RelChange=RelChange)
}

.updateV_dPLS <- function(X, pM, V, fixV, Ter_V, L1_V, L2_V, eta, iter){
    stepSize <- eta / iter
    for(i in seq_along(V)){
        if(!fixV[i]){
            grad <- lapply(setdiff(seq_along(V), i), function(j){
                t(X[[i]] * pM[[i]]) %*% (X[[j]] * pM[[j]]) %*% V[[j]] %*% diag(ncol(V[[j]]):1)
            })
            grad <- do.call("+", grad)
            L1Term <- L1_V
            L2Term <- L2_V * V[[i]]
            TerTerm <- Ter_V * (3 * V[[i]]^5 - 4 * V[[i]]^3 + V[[i]])
            V[[i]] <- .scaleQR(V[[i]] + stepSize * grad - L1Term - L2Term - TerTerm)
        }
    }
    V
}
