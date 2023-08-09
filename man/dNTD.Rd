\name{dNTD}
\docType{methods}
\alias{dNTD}

\title{
Discretized Non-negative Tucker Decomposition Algorithms (dNTD)
}
\description{
This function is the discretized version of nnTensor::NTD.
The input data X is assumed to be a non-negative tensor
and decomposed to a product of a dense core tensor (S) and
low-dimensional factor matrices (A_k, k=1..K).
Unlike regular NTD, in dNTD,
each A_k is estimated by adding binary regularization
so that the values are 0 or 1 as much as possible.
Likewise, each A_k are estimated by adding ternary regularization
so that the values are 0, 1, or 2 as much as possible.
}
\usage{
dNTD(X, M=NULL, pseudocount=.Machine$double.eps,
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
    figdir = NULL, verbose = FALSE)
}

\arguments{
  \item{X}{
K-order input tensor which has I_1, I_2, ..., and I_K dimensions.
}
  \item{M}{
K-order mask tensor which has I_1, I_2, ..., and I_K dimensions.
If the mask tensor has missing values, specify the element as 0 (otherwise 1).
}
  \item{pseudocount}{
The pseudo count to avoid zero division, when the element is zero
(Default: Machine Epsilon).
}
  \item{initS}{
The initial values of core tensor which has I_1, I_2, ..., and I_K dimensions
(Default: NULL).
}
  \item{initA}{
A list containing the initial values of K factor matrices
(A_k, <Ik*Jk>, k=1..K, Default: NULL).
}
  \item{fixS}{
Whether the core tensor S is updated in each iteration step (Default: FALSE).
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
The number of low-dimension in each mode (Default: 3 for each mode).
}
  \item{modes}{
The vector of the modes on which to perform the decomposition
(Default: 1:K <all modes>).
}
  \item{algorithm}{
dNTD algorithms. "Frobenius", "KL", "IS", and "Beta" are available
(Default: "Frobenius").
}
  \item{init}{
The initialization algorithms. "NMF", "ALS", and "Random" are available
(Default: "NMF").
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
Yong-Deok Kim et. al., (2007). Nonnegative Tucker Decomposition.
\emph{IEEE Conference on Computer Vision and Pattern Recognition}

Yong-Deok Kim et. al., (2008). Nonneegative Tucker Decomposition With
Alpha-Divergence. \emph{IEEE International Conference on Acoustics,
Speech and Signal Processing}

Anh Huy Phan, (2008). Fast and efficient algorithms for nonnegative
Tucker decomposition. \emph{Advances in Neural Networks - ISNN2008}

Anh Hyu Phan et. al. (2011). Extended HALS algorithm for nonnegative
Tucker decomposition and its applications for multiway analysis and classification.
\emph{Neurocomputing}
}
\author{Koki Tsuyuzaki}

\seealso{
\code{\link{plotTensor3D}}
}
\examples{
tensordata <- toyModel(model = "dNTD")
out <- dNTD(tensordata, rank=c(2,2,2), algorithm="Frobenius",
  init="Random", num.iter=2)
}

\keyword{methods}