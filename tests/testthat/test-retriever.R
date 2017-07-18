library(testthat)
library(rdataretriever)

test_that("datasets returns some known values", {
  skip_on_cran()
  expect_identical("car-eval" %in% rdataretriever::datasets(), TRUE)
})
