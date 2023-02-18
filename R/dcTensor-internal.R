.recMatrix <- function(U = NULL, V = NULL){
    if (is(U)[1] != "matrix" || is(V)[1] != "matrix") {
        stop("Please specify the appropriate U and V\n")
    }
    return(U %*% t(V))
}

.recError <- function (X = NULL, X_bar = NULL, notsqrt = FALSE){
    if (is(X)[1] == "matrix" && is(X_bar)[1] == "matrix") {
        v <- as.vector(X_bar - X)
    }
    else if (is(X)[1] == "Tensor" && is(X_bar)[1] == "Tensor") {
        v <- vec(X_bar - X)
    }
    if(notsqrt){
        sum(v * v)
    }else{
        sqrt(sum(v * v))
    }
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
