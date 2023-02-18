library("testthat")
library("nnTensor")
library("rTensor")

options(testthat.use_colours = FALSE)

# Basic usage
test_file("testthat/test_toyModel.R")
test_file("testthat/test_dNMF.R")
test_file("testthat/test_dGDSVD.R")