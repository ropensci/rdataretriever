install.packages("DBI")
install.packages("RPostgreSQL")
install.packages("RMySQL")

library(testthat)
library(rdataretriever)


test_check("rdataretriever")
