library(testthat)
library(devtools)
library(rdataretriever)


testthat::test_check("rdataretriever", reporter = c("check"))
