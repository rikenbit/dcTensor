---
title: 'dcTensor: An R package for discrete matrix/tensor decomposition'
tags:
  - R
  - discrete matrix factorization
  - discrete tensor factorization
  - dimension reduction
authors:
  - name: Koki Tsuyuzaki
    orcid: 0000-0003-3797-2148
    affiliation: "1, 2"
affiliations:
 - name: Department of Artificial Intelligence Medicine, Graduate School of Medicine, Chiba University, Japan
   index: 1
 - name: Laboratory for Bioinformatics Research, RIKEN Center for Biosystems Dynamics Research, Japan
   index: 2
date: 27 June 2023
bibliography: paper.bib
---

# Summary
Matrix factorization (MF) is a widely used approach to extract significant patterns in a data matrix. MF is formalized as the approximation of a data matrix $X$ by the matrix product of two factor matrices $U$ and $V$. Because this formalization has a large number of degrees of freedom, some constraints are imposed on the solution. Non-negative matrix factorization (NMF) imposing a non-negative solution for the factor matrices is a widely used algorithm to decompose non-negative matrix data matrix. Due to the interpretability of its non-negativity and the convenience of using decomposition results as clustering, there are many applications of NMF in image processing, audio processing, and bioinformatics [@amari].

A discrete version of NMF can also be considered by imposing a binary solution (e.g., {0,1}) for the factor matrices extracted from the data matrix and it is called binary matrix factorization (BMF) [@bmf]. BMF is recently featured in some data science domains such as market basket data, document-term data, Web click-stream data, DNA microarray expression profiles, or protein-protein complex interaction networks.

Although BMF is becoming more used, in the current data analysis, further extensions are required. For example, we may need a ternary solution (e.g., {0,1,2}) instead of a binary one. Here, I call it ternary matrix factorization (TMF). TMF would contribute to the extraction of ordered patterns, such as stages of disease severity. It is also possible to apply the discretization to only one of the two factor matrices ($U$ or $V$) and here I call it semi-binary matrix factorization (SBMF) [@semi] or semi-ternary matrix factorization (STMF). This extension contributes to the extraction of discrete patterns in continuous-valued matrix data. Finally, there is a growing demand to extend MF to the simultaneous factorization of multiple matrices or tensors (high-dimensional arrays) [@amari]. Such heterogeneous data sets are obtained when multiple measurements with a common data structure are performed under different experimental conditions. Therefore, it is very convenient if discretization is available to such heterogeneous data structures. To meet these requirements, I originally developed \texttt{dcTensor}, which is an R/CRAN package to perform some discrete matrix/tensor decomposition algorithms (\url{https://cran.r-project.org/web/packages/dcTensor/index.html}).

# Statement of need

There are some tools to perform BMF such as \texttt{Nimfa}, \texttt{libmf}, \texttt{recosystem}, and \texttt{Origami.jl} but there is no implementation to perform TMF, SBMF, STMF, or extensions of MF to multiple matrices or tensor. For this reason, I originally implemented such discrete matrix/tensor decomposition algorithms in R language, which is one of the popular open-source programming languages.

\texttt{dcTensor} provides the matrix/tensor decomposition functions as follows:

- MF against a matrix data
  - \texttt{dNMF}: Discretized Non-negative Matrix Factorization [@amari; @nmf]
  - \texttt{dSVD}: Discretized Singular Value Decomposition [@svd]
- MF against multiple matrices data
  - \texttt{dsiNMF}: Discretized Simultaneous Non-negative Matrix Factorization [@amari; @sinmf1; @sinmf2; @sinmf3]
  - \texttt{djNMF}: Discretized Joint Non-negative Matrix Factorization [@amari; @jnmf]
  - \texttt{dPLS}: Discretized Partial Least Squares [@pls]
- Tensor Decomposition
  - \texttt{dNTF}: Discretized Non-negative CP Decomposition [@amari; @ntf]
  - \texttt{dNTD}: Discretized Non-negative Tucker Decomposition [@amari; @ntd]

# Example

For the demonstration, here I show that SBMF can be easily performed on any machine where R is pre-installed by using the following commands in R:

```r
# Install package required (one per computer)
install.packages("dcTensor")

# Load required package (once per R instance)
library("dcTensor")
library("nnTensor")
library("fields")

# Load Toy data
data <- toyModel("NMF")

# Perform SBMF
set.seed(1234)
out <- dNMF(data, Bin_U=1E+6, J=5)

# Reconstruction of the data matrix
rec.data <- out$U %*% t(out$V)

# Visualization
layout(rbind(1:2, 3:4))
image.plot(data, main="Original Data", legend.mar=8, zlim=c(0, max(data)))
image.plot(rec.data, main="Reconstructed Data", legend.mar=8, zlim=c(0,max(data)))
hist(out$U, breaks=100)
hist(out$V, breaks=100)
```

![Semi-binary Matrix Factorization (SBMF).\label{fig:sbmf}](figure.png){ width=100% }

In the top left of \autoref{fig:sbmf}, we can see that the demo data has five significant patterns as blocks. In the top right of \autoref{fig:sbmf}, we can see that the reconstructed data, which is the matrix product of the factor matrices $U$ and $V$, also has the same patterns and this means the optimization of SBMF is properly converged. In the bottom left of \autoref{fig:sbmf}, we can see that $U$ is binary ({0,1}), but $V$ is not (the bottom right of \autoref{fig:sbmf}), which means the solution is semi-binary. This solution is imposed by setting a large value against Bin_U argument in dNMF function, which is the binary regularization parameter for $U$. dNMF also has Bin_V argument, which is the binary regularization parameter for $V$. Setting large values against Bin_U and Bin_V, BMF can also be obtained. Likewise, the ternary solutions (TMF and STMF) can be obtained by ternary regularization parameters such as Ter_U and Ter_V.

# References
