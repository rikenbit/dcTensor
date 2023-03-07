\name{toyModel}
\docType{methods}
\alias{toyModel}

\title{
Toy model data for using dNMF, dSVD, dsiNMF, djNMF, dPLS, dNTF, and dNTD
}
\description{
The data is used for confirming the algorithm are properly working.
}
\usage{
toyModel(model = "dNMF", seeds=123)
}

\arguments{
  \item{model}{
Single character string is specified.
"dNMF", "dSVD", "dsiNMF_Easy", "dsiNMF_Hard", "dPLS_Easy", "dPLS_Hard", "dNTF", and "dNTD" are available (Default: "dNMF").
}
  \item{seeds}{
Random number for setting set.seeds in the function (Default: 123).
}
}

\value{
If model is specified as "dNMF" or "dSVD", a matrix is generated.
If model is specified as "dsiNMF_Easy", "dsiNMF_Hard",
"dPLS_Easy", or "dPLS_Hard" three matrices are generated.
Otherwise, a tensor is generated.
}
\author{Koki Tsuyuzaki}

\seealso{\code{\link{dNMF}},\code{\link{dSVD}}}
\examples{
matdata <- toyModel(model = "dNMF", seeds=123)
}

\keyword{methods}