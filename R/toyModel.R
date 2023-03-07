.dNMF <- function(){
    X <- matrix(0, nrow = 100, ncol = 300)
    X[1:50, 1:50] <- 1
    X[50:70, 51:100] <- 1
    X[60:65, 151:170] <- 1
    X[25:35, 200:220] <- 1
    X[51:100, 220:300] <- 1
    X
}

.dSVD <- function(){
    X <- matrix(rpois(100 * 300, lambda=1),
        nrow = 100, ncol = 300)
    X[1:50, 1:50] <- rpois(50*50, lambda=100)
    X[50:70, 51:100] <- - rpois(21*50, lambda=200)
    X[60:65, 151:170] <- - rpois(6*20, lambda=150)
    X[25:35, 200:220] <- - rpois(11*21, lambda=150)
    X[51:100, 220:300] <- rpois(50*81, lambda=150)
    X
}

.dsiNMF_Easy <- function(){
    X1 <- matrix(0, nrow = 100, ncol = 300)
    X2 <- matrix(0, nrow = 100, ncol = 200)
    X3 <- matrix(0, nrow = 100, ncol = 150)

    X1[1:30, 1:90] <- 1
    X1[31:60, 91:180] <- 1
    X1[61:90, 181:270] <- 1

    X2[1:30, 61:120] <- 1
    X2[31:60, 121:180] <- 1
    X2[61:90, 1:60] <- 1

    X3[1:30, 81:120] <- 1
    X3[31:60, 1:40] <- 1
    X3[61:90, 41:80] <- 1

    list(X1=X1, X2=X2, X3=X3)
}

.dsiNMF_Hard <- function(){
    X1 <- matrix(0, nrow = 100, ncol = 300)
    X2 <- matrix(0, nrow = 100, ncol = 200)
    X3 <- matrix(0, nrow = 100, ncol = 150)

    X1[1:30, 1:90] <- 1
    X1[31:60, 91:180] <- 1
    X1[61:90, 181:270] <- 1

    X1[61:75, 1:90] <- 1
    X1[1:15, 181:270] <- 1
    X1[31:45, 181:270] <- 1

    X2[1:30, 61:120] <- 1
    X2[31:60, 121:180] <- 1
    X2[61:90, 1:60] <- 1

    X2[76:90, 61:120] <- 1
    X2[16:30, 121:180] <- 1

    X3[1:30, 81:120] <- 1
    X3[31:60, 1:40] <- 1
    X3[61:90, 41:80] <- 1

    X3[1:15, 1:40] <- 1
    X3[76:90, 1:40] <- 1
    X3[16:30, 41:80] <- 1
    X3[46:60, 41:80] <- 1
    X3[61:75, 81:120] <- 1

    list(X1=X1, X2=X2, X3=X3)
}

.dPLS_Easy <- function(){
    X1 <- matrix(rpois(100 * 300, lambda=1),
        nrow = 100, ncol = 300)
    X2 <- matrix(rpois(100 * 200, lambda=1),
        nrow = 100, ncol = 200)
    X3 <- matrix(rpois(100 * 150, lambda=1),
        nrow = 100, ncol = 150)

    X1[1:30, 1:90] <- rpois(30*90, lambda=100)
    X1[31:60, 91:180] <- - rpois(30*90, lambda=100)
    X1[61:90, 181:270] <- rpois(30*90, lambda=100)

    X2[1:30, 61:120] <- rpois(30*60, lambda=100)
    X2[31:60, 121:180] <- - rpois(30*60, lambda=100)
    X2[61:90, 1:60] <- rpois(30*60, lambda=100)

    X3[1:30, 81:120] <- rpois(30*40, lambda=100)
    X3[31:60, 1:40] <- - rpois(30*40, lambda=100)
    X3[61:90, 41:80] <- rpois(30*40, lambda=100)

    list(X1=X1, X2=X2, X3=X3)
}

.dPLS_Hard <- function(){
    X1 <- matrix(rpois(100 * 300, lambda=1),
        nrow = 100, ncol = 300)
    X2 <- matrix(rpois(100 * 200, lambda=1),
        nrow = 100, ncol = 200)
    X3 <- matrix(rpois(100 * 150, lambda=1),
        nrow = 100, ncol = 150)

    X1[1:30, 1:90] <- rpois(30*90, lambda=100)
    X1[31:60, 91:180] <- - rpois(30*90, lambda=100)
    X1[61:90, 181:270] <- rpois(30*90, lambda=100)

    X1[61:75, 1:90] <- rpois(15*90, lambda=50)
    X1[1:15, 181:270] <- rpois(15*90, lambda=50)
    X1[31:45, 181:270] <- - rpois(15*90, lambda=50)

    X2[1:30, 61:120] <- rpois(30*60, lambda=100)
    X2[31:60, 121:180] <- - rpois(30*60, lambda=100)
    X2[61:90, 1:60] <- rpois(30*60, lambda=100)

    X2[76:90, 61:120] <- rpois(15*60, lambda=50)
    X2[16:30, 121:180] <- - rpois(15*60, lambda=50)

    X3[1:30, 81:120] <- rpois(30*40, lambda=100)
    X3[31:60, 1:40] <- - rpois(30*40, lambda=100)
    X3[61:90, 41:80] <- rpois(30*40, lambda=100)

    X3[1:15, 1:40] <- rpois(15*40, lambda=50)
    X3[76:90, 1:40] <- rpois(15*40, lambda=50)
    X3[16:30, 41:80] <- - rpois(15*40, lambda=50)
    X3[46:60, 41:80] <- rpois(15*40, lambda=50)
    X3[61:75, 81:120] <- - rpois(15*40, lambda=50)

    list(X1=X1, X2=X2, X3=X3)
}

.dNTF <- function(){
    X <- array(0, dim=rep(30,3))
    X[1:5, 1:5, 1:5] <- 1
    X[10:14, 10:14, 10:14] <- 1
    X[18:22, 18:22, 18:22] <- 1
    X[26:30, 26:30, 26:30] <- 1
    as.tensor(X)
}

.dNTD <- function(){
    X <- array(0, dim=rep(50,3))
    X[1:5, 1:5, 1:50] <- 1
    X[46:50, 46:50, 1:50] <- 1
    X[1:50, 16:20, 1:5] <- 1
    X[1:50, 30:35, 46:50] <- 1
    X[10:15, 1:50, 16:20] <- 1
    X[30:35, 1:50, 30:35] <- 1
    as.tensor(X)
}

.flist <- list(
    dNMF = .dNMF,
    dSVD = .dSVD,
    dsiNMF_Easy = .dsiNMF_Easy,
    dsiNMF_Hard = .dsiNMF_Hard,
    dPLS_Easy = .dPLS_Easy,
    dPLS_Hard = .dPLS_Hard,
    dNTF = .dNTF,
    dNTD = .dNTD
)

toyModel <- function(model = "dNMF", seeds=123){
    set.seed(seeds)
    out <- .flist[[model]]()
    set.seed(NULL)
    out
}