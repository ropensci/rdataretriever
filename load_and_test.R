# Used for continous testing platform
# Install analysis packages using pacman
# Pacman will load the packages and install
# the packaes not available

if (Sys.getenv("IN_DOCKER") == "true") {
  # Install pacman if it isn't already installed
  if ("pacman" %in% rownames(installed.packages()) == FALSE) install.packages("pacman")
  suppressMessages(install.packages("RMariaDB",  quiet = TRUE))
  suppressMessages(
    pacman::p_load(devtools, readr, rmarkdown,
                   testthat, tidyverse, DBI, RPostgreSQL,
                   RSQLite, reticulate, devtools, RMariaDB,
                   semver)
  )

  devtools::install_local(".", force = TRUE)
  # Test package
  test_dir("tests/testthat", reporter = c("check", "progress"))  
}

 