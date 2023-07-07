\name{dNTF}
\docType{methods}
\alias{dNTF}

\title{
Discretized Non-negative CP Decomposition Algorithms (dNTF)
}
\description{
The input data is assumed to be non-negative tensor.
dNTF decompose the tensor to the diagonal core tensor (S) and low-dimensional
factor matices (A).
}
\usage{
dNTF(X, M=NULL, pseudocount=.Machine$double.eps,
    initA=NULL, fixA=FALSE,
    Bin_A=rep(1e-10, length=length(dim(X))),
    Ter_A=rep(1e-10, length=length(dim(X))),
    L1_A=rep(1e-10, length=length(dim(X))),
    L2_A=rep(1e-10, length=length(dim(X))),
    rank = 3,
    algorithm = c("Frobenius", "KL", "IS", "Beta"),
    init = c("dNMF", "Random"),
    Beta = 2, thr = 1e-10, num.iter = 100, viz = FALSE, figdir = NULL,
    verbose = FALSE)
}

\arguments{
  \item{X}{
K-order input tensor which has I_1, I_2, ..., and I_K dimensions.
}
  \item{M}{
K-order mask tensor which has I_1, I_2, ..., and I_K dimensions. If the mask tensor has
missing values, specify the element as 0 (otherwise 1).
}
  \item{pseudocount}{
The pseudo count to avoid zero division, when the element is zero (Default: Machine Epsilon).
}
  \item{initA}{
A list containing the initial values of K factor matrices
(A_k, <Ik*Jk>, k=1..K, Default: NULL).
}
  \item{fixA}{
Whether the factor matrices Ak are updated in each iteration step
(Default: FALSE).
}
\item{Bin_A}{
A K-length vector containing the paramters for binary (0,1) regularitation
(Default: rep(1e-10, length=length(dim(X)))).
}
\item{Ter_A}{
A K-length vector containing the paramters for terary (0,1,2) regularitation
(Default: rep(1e-10, length=length(dim(X)))).
}
  \item{L1_A}{
A K-length vector containing the paramters for L1 regularitation
(Default: rep(1e-10, length=length(dim(X)))).
This also works as small positive constant to prevent division by zero,
so should be set as 0.
}
  \item{L2_A}{
A K-length vector containing the paramters for L2 regularitation
(Default: rep(1e-10, length=length(dim(X)))).
}
  \item{rank}{
The number of low-dimension in each mode (Default: 3).
}
  \item{algorithm}{
dNTF algorithms. "Frobenius", "KL", "IS", and "Beta" are available
(Default: "Frobenius").
}
  \item{init}{
The initialization algorithms. "dNMF", and "Random" are available
(Default: "dNMF").
}
  \item{Beta}{
The parameter of Beta-divergence.
}
  \item{thr}{
When error change rate is lower than thr1, the iteration is terminated
(Default: 1E-10).
}
  \item{num.iter}{
The number of interation step (Default: 100).
}
  \item{viz}{
If viz == TRUE, internal reconstructed tensor can be visualized.
}
  \item{figdir}{
the directory for saving the figure, when viz == TRUE (Default: NULL).
}
  \item{verbose}{
If verbose == TRUE, Error change rate is generated in console windos.
}
}

\value{
  S : K-order tensor object, which is defined as S4 class of rTensor package.
  A : A list containing K factor matrices.
  RecError : The reconstruction error between data tensor and reconstructed
  tensor from S and A.
  TrainRecError : The reconstruction error calculated by training set
  (observed values specified by M).
  TestRecError : The reconstruction error calculated by test set
  (missing values specified by M).
  RelChange : The relative change of the error.
}

\references{
Andrzej CICHOCKI et. al., (2007). Non-negative Tensor Factorization using
Alpha and Beta Divergence. \emph{IEEE ICASSP 2007}

Anh Huy PHAN et. al., (2008). Multi-way Nonnegative Tensor Factorization
Using Fast Hierarchical Alternating Least Squares Algorithm (HALS). \emph{NOLTA2008}

Andrzej CICHOCKI et. al., (2008). Fast Local Algorithms for Large Scale
Nonnegative Matrix and Tensor Factorizations.
\emph{IEICE Transactions on Fundamentals of Electronics, Communications
and Computer Sciences}
}
\author{Koki Tsuyuzaki}

\seealso{
\code{\link{plotTensor3D}}
}
\examples{
tensordata <- toyModel(model = "dNTF")
out <- dNTF(tensordata, rank=3, num.iter=2)
}

\keyword{methods}