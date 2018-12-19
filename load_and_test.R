# Install pacman if it isn't already installed
if ("pacman" %in% rownames(installed.packages()) == FALSE) install.packages("pacman")


# Install analysis packages using pacman
# Pacman will load the packages and install
# the packaes not available
pacman::p_load(devtools, RCurl, readr, rmarkdown, testthat, tidyverse, DBI, RPostgreSQL,
               RSQLite, reticulate, devtools, RMariaDB)

install.packages(".", repos = NULL, type="source")
# devtools::test(reporter = c("summary", "fail"))
devtools::test()