# Check whether M avoids 0 or NA elements in data matrix/tensor X
#
.checkZeroNA <- function(X, M, type=c("matrix", "Tensor")){
    if("matrix" %in% is(M)){
        .checkZeroNA_mat(X, M)
    }
    if("Tensor" %in% is(M)){
        .checkZeroNA_tns(X, M)
    }
}

.checkZeroNA_mat <- function(X, M){
    # NA => 0
    stopifnot(length(
        setdiff(which(is.na(X)),
        which(M == 0))) == 0)
    # 0 => 1
    stopifnot(length(
        setdiff(which(X == 0),
        which(M == 1))) == 0)
}

.checkZeroNA_tns <- function(X, M){
    # NA => 0
    stopifnot(length(
        setdiff(which(is.na(X@data)),
        which(M@data == 0))) == 0)
    # 0 => 1
    stopifnot(length(
        setdiff(which(X@data == 0),
        which(M@data == 1))) == 0)
}

.columnNorm <- function(X){
    X_norm <- apply(X, 2, function(x){
        norm(as.matrix(x), "F")
    })
    t(t(X) / X_norm)
}

.recError <- function (X = NULL, X_bar = NULL, notsqrt = FALSE){
    if (is(X)[1] == "matrix" && is(X_bar)[1] == "matrix") {
        v <- as.vector(X_bar - X)
    }
    else if (is(X)[1] == "Tensor" && is(X_bar)[1] == "Tensor") {
        v <- vec(X_bar - X)
    }
    if(notsqrt){
        sum(v * v, na.rm=TRUE)
    }else{
        sqrt(sum(v * v, na.rm=TRUE))
    }
}

.positive <- function(X, thr = .Machine$double.eps){
    if (is(X)[1] == "matrix") {
        X[which(X < thr)] <- thr
    }
    else if (is(X)[1] == "Tensor") {
        X@data[which(X@data < thr)] <- thr
    }
    else if ("numeric" %in% is(X) && length(X) != 1) {
        X[which(X < thr)] <- thr
    }
    else if ("numeric" %in% is(X) && length(X) == 1) {
        X <- max(X, thr)
    }
    X
}

.recMatrix <- function(U = NULL, V = NULL){
    if (is(U)[1] != "matrix" || is(V)[1] != "matrix") {
        stop("Please specify the appropriate U and V\n")
    }
    return(U %*% t(V))
}

.insertNULL <- function(rank, Iposition, N){
    out <- rep(0, length=N)
    out[setdiff(1:N, Iposition)] <- rank
    out
}

.pseudocount <- function(X, pseudocount = 1e-10){
    X@data[which(X@data == 0)] <- pseudocount
    X
}

.KhatriRao_notn <- function(A, n){
    idx <- setdiff(seq_len(length(A)), n)
    out <- t(A[[idx[1]]])
    for(notn in setdiff(idx, idx[1])){
        out <- khatri_rao(out, t(A[[notn]]))
    }
    out
}

.slice <- function(X, mode = 1, column = 1){
    N <- length(dim(X))
    notmode <- setdiff(seq(N), mode)
    d <- dim(X)[notmode]
    modes <- rep(1, length=N)
    modes[notmode] <- d
    out <- rand_tensor(modes)
    tmp1 <- rep("", length=N)
    tmp2 <- rep("", length=N)
    tmp1[mode] <- 1
    tmp2[mode] <- "column"
    cmd <- paste0(
        "out[",
        paste0(tmp1, collapse=","),
        "] <- X[",
        paste0(tmp2, collapse=","),
        "]"
    )
    out
}

.contProd <- function(A, B, mode = 1){
    l <- dim(A)
    N <- length(l)
    out <- rep(0, length=l[mode])
    tmp1 <- rep("", length=N)
    tmp2 <- rep("", length=N)
    tmp1[mode] <- "i"
    tmp2[mode] <- 1
    cmd <- paste0(
        "out[i] <- sum(A[",
        paste(tmp1, collapse=","),
        "]@data * B[",
        paste(tmp2, collapse=","),
        "]@data)"
    )
    for(i in seq(l[mode])){
        eval(parse(text=cmd))
    }
    out
}

.rho <- function(Beta, root=FALSE){
    if(root){
        out <- 0.5
    }else{
        if(Beta < 1){
            out <- 1 / (2 - Beta)
        }
        if((1 <= Beta) && (Beta <= 2)){
            out <- 1
        }
        if(Beta > 2){
            out <- 1 / (Beta - 1)
        }
    }
    out
}

.scaleQR <- function(A){
    # QR decomp
    out <- qr(A)
    Q_ <- qr.Q(out)
    R <- qr.R(out)
    Q <- t(t(Q_) * sign(diag(R)))
    # Scaling
    normQ <- apply(Q, 2, function(x){
        1 / max(abs(x))
    })
    t(t(Q) * normQ)
}
