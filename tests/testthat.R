library("testthat")
library("nnTensor")
library("rTensor")

options(testthat.use_colours = FALSE)

# Basic usage
test_file("testthat/test_toyModel.R")
test_file("testthat/test_dNMF.R")
test_file("testthat/test_dSVD.R")
test_file("testthat/test_dsiNMF.R")
test_file("testthat/test_djNMF.R")
test_file("testthat/test_dPLS.R")
test_file("testthat/test_dNTF.R")
test_file("testthat/test_dNTD.R")
