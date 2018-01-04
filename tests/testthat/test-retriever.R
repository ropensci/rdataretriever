context("regression tests")

library(DBI)
library(RPostgreSQL)
library(RMySQL)


test_that("datasets returns some known values", {
  skip_on_cran()
  expect_identical("car-eval" %in% rdataretriever::datasets(), TRUE)
})


test_that("Download the raw portal dataset into './data/'", {
  portal <- list("3299474", "3299483", "5603981")
  rdataretriever::download('portal', './data/')
  for (file in portal)
  {
    file_path <-
      normalizePath(
        file.path(getwd(), "tests/testthat/data", file),
        winslash = "//",
        mustWork = FALSE
      )
    expect_identical(identical(file.info(file_path)$size, integer(0)), FALSE)
  }
})


test_that("Install the portal into csv", {
  # Install portal into csv files in your working directory
  portal <- list("portal_main", "portal_plots", "portal_species")
  # rdataretriever::install('portal', 'csv')
  for (file in portal)
  {
    file_path <-
      normalizePath(
        file.path(getwd(), "tests/testthat", paste(file, "csv", sep = ".")),
        winslash = "//",
        mustWork = FALSE
      )

    expect_identical(identical(file.info(file_path)$size, integer(0)), FALSE)
  }
})


test_that("Install the portal into json", {
  # Install portal into json
  portal <- list("portal_main", "portal_plots", "portal_species")
  rdataretriever::install('portal', 'json')
  for (file in portal)
  {
    file_path <-
      normalizePath(
        file.path(getwd(), "tests/testthat", paste(file, "json", sep = ".")),
        winslash = "//",
        mustWork = FALSE
      )
    expect_identical(identical(file.info(file_path)$size, integer(0)), FALSE)
  }
})


test_that("Install the portal into xml", {
  # Install portal into xml
  portal <- list("portal_main", "portal_plots", "portal_species")
  rdataretriever::install('portal', 'xml')
  for (file in portal)
  {
    file_path <-
      normalizePath(
        file.path(getwd(), "tests/testthat", paste(file, "xml", sep = ".")),
        winslash = "//",
        mustWork = FALSE
      )
    expect_identical(identical(file.info(file_path)$size, integer(0)), FALSE)
  }
})


test_that("Install the portal into sqlite", {
  # Install the portal into Sqlite
  portal <- c("portal_main", "portal_plots", "portal_species")
  rdataretriever::install('portal', 'sqlite', db_file = "test.sqlite")
  con <- dbConnect(RSQLite::SQLite(), dbname = "test.sqlite")
  result <- dbListTables(con)
  dbDisconnect(con)
  expect_setequal(result, portal)
})


test_that("Install dataset into Postgres", {
  # Install the portal into Postgres
  try(system(
    "psql -U postgres -d testdb -h localhost -c \"DROP SCHEMA IF EXISTS testschema CASCADE\"",
    intern = TRUE,
    ignore.stderr = TRUE
  ))
  portal <- c("main", "plots", "species")
  rdataretriever::install('portal', "postgres")
  con <- dbConnect(
    dbDriver("PostgreSQL"),
    user = 'postgres',
    host = 'localhost',
    password = "",
    port = 5432,
    dbname = 'testdb'
  )
  result <-
    dbGetQuery(
      con,
      "SELECT table_name FROM information_schema.tables WHERE table_schema='testschema'"
    )
  dbDisconnect(con)
  expect_identical(all(result$table_name %in%  portal), TRUE)
})


test_that("Install the dataset into Mysql", {
  try(system(
    "mysql -u travis -Bse \"DROP DATABASE IF EXISTS testdb\"",
    intern = TRUE,
    ignore.stderr = TRUE
  ))
  portal <- c("main", "plots", "species")
  rdataretriever::install('portal', 'mysql')
  con <- dbConnect(
    RMySQL::MySQL(),
    user = 'travis',
    host = 'localhost',
    password = "",
    port = 3306,
    dbname = 'testdb'
  )
  result <- dbListTables(con)
  dbDisconnect(con)
  expect_setequal(result, portal)
})


test_that("Install and load a dataset as a list", {
  portal_data <- c("main", "plots", "species")
  portal = rdataretriever::fetch('portal')
  expect_identical(all(names(portal) %in%  portal_data), TRUE)
})
