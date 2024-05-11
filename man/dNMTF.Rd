\name{dNMTF}
\docType{methods}
\alias{dNMTF}

\title{
Discretized Non-negative Matrix Tri-Factorization Algorithms (dNMTF)
}
\description{
This function is the discretized version of nnTensor::NMTF.
The input data is assumed to be non-negative matrix.
dNMTF decompose the matrix to three low-dimensional factor matices.
}
\usage{
dNMTF(X, M=NULL, pseudocount=.Machine$double.eps,
    initU=NULL, initS=NULL, initV=NULL,
    fixU=FALSE, fixS=FALSE, fixV=FALSE,
    Bin_U=1e-10, Bin_S=1e-10, Bin_V=1e-10,
    Ter_U=1e-10, Ter_S=1e-10, Ter_V=1e-10,
    L1_U=1e-10, L1_S=1e-10, L1_V=1e-10,
    L2_U=1e-10, L2_S=1e-10, L2_V=1e-10,
    rank = c(3, 4),
    algorithm = c("Frobenius", "KL", "IS", "Beta"),
    Beta = 2, root = FALSE, thr = 1e-10, num.iter = 100,
    viz = FALSE, figdir = NULL, verbose = FALSE)
}

\arguments{
\item{X}{
The input matrix which has N-rows and M-columns.
}
\item{M}{
The mask matrix which has N-rows and M-columns. If the input matrix has
missing values, specify the elements as 0 (otherwise 1).
}
\item{pseudocount}{
The pseudo count to avoid zero division, when the element is zero (Default: Machine Epsilon).
}
\item{initU}{
The initial values of factor matrix U, which has N-rows and J1-columns
(Default: NULL).
}
\item{initS}{
The initial values of factor matrix S, which has J1-rows and J2-columns
(Default: NULL).
}
\item{initV}{ The initial values of factor matrix V, which
has M-rows and J2-columns (Default: NULL).
}
\item{fixU}{ Whether the factor matrix U is updated in each iteration step
(Default: FALSE).
}
\item{fixS}{ Whether the factor matrix S is updated in each iteration step
(Default: FALSE).
}
\item{fixV}{
Whether the factor matrix V is updated in each iteration step
(Default: FALSE).
}
\item{Bin_U}{
Paramter for binary (0,1) regularitation (Default: 1e-10).
}
\item{Bin_S}{
Paramter for binary (0,1) regularitation (Default: 1e-10).
}
\item{Bin_V}{
Paramter for binary (0,1) regularitation (Default: 1e-10).
}
\item{Ter_U}{
Paramter for terary (0,1,2) regularitation (Default: 1e-10).
}
\item{Ter_S}{
Paramter for terary (0,1,2) regularitation (Default: 1e-10).
}
\item{Ter_V}{
Paramter for terary (0,1,2) regularitation (Default: 1e-10).
}
\item{L1_U}{
Paramter for L1 regularitation (Default: 1e-10).
}
\item{L1_S}{
Paramter for L1 regularitation (Default: 1e-10).
}
\item{L1_V}{
Paramter for L1 regularitation (Default: 1e-10).
}
\item{L2_U}{
Paramter for L2 regularitation (Default: 1e-10).
}
\item{L2_S}{
Paramter for L2 regularitation (Default: 1e-10).
}
\item{L2_V}{
Paramter for L2 regularitation (Default: 1e-10).
}
\item{rank}{
The number of low-dimension (J1 (< N) and J2 (< M)) (Default: c(3,4)).
}
\item{algorithm}{
dNMTF algorithms. "Frobenius", "KL", "IS", and "Beta" are available (Default: "Frobenius").
}
\item{Beta}{
The parameter of Beta-divergence (Default: 2, which means "Frobenius").
}
\item{root}{
Whether square root is calculed in each iteration (Default: FALSE).
}
\item{thr}{
When error change rate is lower than thr, the iteration is terminated (Default: 1E-10).
}
\item{num.iter}{
The number of interation step (Default: 100).
}
\item{viz}{
If viz == TRUE, internal reconstructed matrix can be visualized.
}
\item{figdir}{
The directory for saving the figure, when viz == TRUE.
}
\item{verbose}{
If verbose == TRUE, Error change rate is generated in console window.
}
}

\value{
  U : A matrix which has N-rows and J1-columns (J1 < N).
  S : A matrix which has J1-rows and J2-columns.
  V : A matrix which has M-rows and J2-columns (J2 < M).
  rank : The number of low-dimension (J1 (< N) and J2 (< M)).
  RecError : The reconstruction error between data tensor and reconstructed
  tensor from U and V.
  TrainRecError : The reconstruction error calculated by training set
  (observed values specified by M).
  TestRecError : The reconstruction error calculated by test set
  (missing values specified by M).
  RelChange : The relative change of the error.
  algorithm: algorithm specified.
}

\references{
Fast Optimization of Non-Negative Matrix Tri-Factorization: Supporting Information, Andrej Copar, et. al., \emph{PLOS ONE}, 14(6), e0217994, 2019

Co-clustering by Block Value Decomposition, Bo Long et al., \emph{SIGKDD'05}, 2005

Orthogonal Nonnegative Matrix Tri-Factorizations for Clustering, Chris Ding et. al., \emph{12th ACM SIGKDD}, 2006
}
\author{Koki Tsuyuzaki}

\examples{
  if(interactive()){
    # Test data
    matdata <- toyModel(model = "dNMF")

    # Simple usage
    out <- dNMTF(matdata, rank=c(4,4))
  }
}
\keyword{methods}