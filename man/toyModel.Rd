\name{toyModel}
\docType{methods}
\alias{toyModel}

\title{
Toy model data for using dNMF, dGDSVD, dsiNMF, dNTF, and dNTD
}
\description{
The data is used for confirming the algorithm are properly working.
}
\usage{
toyModel(model = "CP", seeds=123)
}

\arguments{
  \item{model}{
Single character string is specified.
"NMF", "siNMF_Easy", "siNMF_Hard", "CP", and "Tucker" are available (Default: "CP").
}
  \item{seeds}{
Random number for setting set.seeds in the function (Default: 123).
}
}

\value{
If model is specified as "NMF", a matrix is generated.
If model is specified as "siNMF_Easy" or "siNMF_Hard",
three matrices are generated.
Otherwise, a tensor is generated.
}
\author{Koki Tsuyuzaki}

\seealso{\code{\link{dNMF}},\code{\link{dGDSVD}}}
\examples{
matdata <- toyModel(model = "CP", seeds=123)
}

\keyword{methods}