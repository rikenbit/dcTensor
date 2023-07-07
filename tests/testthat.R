library("testthat")
library("nnTensor")
library("dcTensor")
library("rTensor")

options(testthat.use_colours = FALSE)

# Basic usage
test_file("testthat/test_toyModel.R")
test_file("testthat/test_dNMF.R")
test_file("testthat/test_dSVD.R")
# test_file("testthat/test_dsiNMF.R")
# test_file("testthat/test_djNMF.R")
# test_file("testthat/test_dPLS.R")
# test_file("testthat/test_dNTF.R")
# test_file("testthat/test_dNTD.R")

# # Mask matrix/tensor for imputation
# test_file("testthat/test_mask_dNMF.R")
# test_file("testthat/test_mask_dSVD.R")
# test_file("testthat/test_mask_dsiNMF.R")
# test_file("testthat/test_mask_djNMF.R")
# test_file("testthat/test_mask_dPLS.R")
# test_file("testthat/test_mask_dNTF.R")
# test_file("testthat/test_mask_dNTD.R")

# # NA avoidance
# test_file("testthat/test_NA_dNMF.R")
# test_file("testthat/test_NA_dSVD.R")
# test_file("testthat/test_NA_dsiNMF.R")
# test_file("testthat/test_NA_djNMF.R")
# test_file("testthat/test_NA_dPLS.R")
# test_file("testthat/test_NA_dNTF.R")
# test_file("testthat/test_NA_dNTD.R")

# # Initialization
# test_file("testthat/test_init_dNMF.R")
# test_file("testthat/test_init_dSVD.R")
# test_file("testthat/test_init_dsiNMF.R")
# test_file("testthat/test_init_djNMF.R")
# test_file("testthat/test_init_dPLS.R")
# test_file("testthat/test_init_dNTF.R")
# test_file("testthat/test_init_dNTD.R")

# # Fix options for transfer learning
# test_file("testthat/test_fix_dNMF.R")
# test_file("testthat/test_fix_dSVD.R")
# test_file("testthat/test_fix_dsiNMF.R")
# test_file("testthat/test_fix_djNMF.R")
# test_file("testthat/test_fix_dPLS.R")
# test_file("testthat/test_fix_dNTF.R")
# test_file("testthat/test_fix_dNTD.R")
