[![DOI](https://zenodo.org/badge/602806504.svg)](https://zenodo.org/badge/latestdoi/602806504)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/dcTensor)](
https://cran.r-project.org/package=dcTensor)
[![Downloads](https://cranlogs.r-pkg.org/badges/dcTensor)](https://CRAN.R-project.org/package=dcTensor)
[![Total Downloads](https://cranlogs.r-pkg.org/badges/grand-total/dcTensor?color=orange)](https://CRAN.R-project.org/package=dcTensor)
[![:name status badge](https://rikenbit.r-universe.dev/badges/:name)](https://rikenbit.r-universe.dev)
[![:registry status badge](https://rikenbit.r-universe.dev/badges/:registry)](https://rikenbit.r-universe.dev)
[![:total status badge](https://rikenbit.r-universe.dev/badges/:total)](https://rikenbit.r-universe.dev)
[![dcTensor status badge](https://rikenbit.r-universe.dev/badges/dcTensor)](https://rikenbit.r-universe.dev)
![GitHub Actions](https://github.com/rikenbit/dcTensor/actions/workflows/build_test_push.yml/badge.svg)

# dcTensor
R package for Discrete Matrix/Tensor Decomposition

Installation
======
~~~~
git clone https://github.com/rikenbit/dcTensor/
R CMD INSTALL dcTensor
~~~~
or type the code below in the R console window
~~~~
library(devtools)
devtools::install_github("rikenbit/dcTensor")
~~~~

References
======
- **Binary Matrix Factorization (BMF)**
  - Z. Zhang, T. Li, C. Ding and X. Zhang, "Binary Matrix Factorization with Applications," Seventh IEEE International Conference on Data Mining (ICDM 2007), Omaha, NE, USA, 2007, pp. 391-400, doi: 10.1109/ICDM.2007.99.
- **Singular Value Decomposition (SVD) based on Gradient Descent**
  - Tsuyuzaki K, et al., Benchmarking principal component analysis for large-scale single-cell RNA-sequencing. BMC Genome Biology. 21(1), 9, 2020
- **Simultaneous Non-negative Matrix Factorization (siNMF)**
  - Badea, L. Extracting Gene Expression Profiles Common to Colon and Pancreatic Adenocarcinoma using Simultaneous nonnegative matrix factorization, Pacific Symposium on Biocomputing, 279-290, 2008
  - Zhang, S. et al., Discovery of multi-dimensional modules by integrative analysis of cancer genomic data. Nucleic Acids Research, 40(19), 9379-9391, 2012
  - Yilmaz, Y. K. et al., Probabilistic Latent Tensor Factorization, IVA/ICA 2010, 346-353, 2010
- **Joint Non-negative Matrix Factorization (jNMF)**
  - Zi, Yang, et al., A non-negative matrix factorization method for detecting modules in heterogeneous omics multi-modal data, Bioinformatics, 32(1), 1-8, 2016
- **Partial Least Squares (PLS) based on Gradient Descent**
  - Arora, R. et al., Stochastic Optimization for PCA and PLS, 2012 50th Annual Allerton Conference on Communication, Control, and Computing (Allerton), 861-868, 2012
- **Non-negative CP Decomposition (NTF)**
   - *α-Divergence (KL, Pearson, Hellinger, Neyman) / β-Divergence (KL, Frobenius, IS)*
     - Cichocki, A. et al., Non-negative Tensor Factorization using Alpha and Beta Divergence, ICASSP '07, III-1393-III-1396, 2007
     - [mathieubray/TensorKPD.R](https://gist.github.com/mathieubray/d83ce9c13fcb60f723f957c13ad85ac5)
   - *Fast HALS*
     - Phan, A. H. et al.,  Multi-way Nonnegative Tensor Factorization Using Fast Hierarchical Alternating Least Squares Algorithm (HALS), NOLTA 2008, 2008
   - *α-HALS/β-HALS*
     - Cichocki, A. et al., Fast Local Algorithms for Large Scale Nonnegative Matrix and Tensor Factorizations, IEICE Transactions, 92-A, 708-721, 2009
- **Non-negative Tucker Decomposition (NTD)**
   - *Frobenius/KL*
     - Kim, Y.-D. et al., Nonnegative Tucker Decomposition, IEEE CVPR, 1-8, 2007
   - *α-Divergence (KL, Pearson, Hellinger, Neyman) / β-Divergence (KL, Frobenius, IS)*
     - Kim, Y.-D. et al., Nonneegative Tucker Decomposition with Alpha-Divergence, 2008
     - Phan, A. H. et al., Fast and efficient algorithms for nonnegative Tucker decomposition, ISNN 2008, 772-782, 2008
   - *Fast HALS*
     - Phan, A. H. et al., Extended HALS algorithm for nonnegative Tucker decomposition and its applications for multiway analysis and classification, Neurocomputing, 74(11), 1956-1969, 2011

## Authors
- Koki Tsuyuzaki