context("regression tests")

if (!requireNamespace("reticulate", quietly = TRUE)) {
  return()
}
suppressPackageStartupMessages(require(reticulate))
suppressPackageStartupMessages(require(DBI))
# suppressPackageStartupMessages(require(RMariaDB))
suppressPackageStartupMessages(require(RPostgreSQL))
suppressPackageStartupMessages(require(RSQLite))


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


test_that("Install portal into csv", {
  # Install portal into csv files in your working directory
  portal <- list("portal_main", "portal_plots", "portal_species")
  rdataretriever::install_csv('portal')
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


test_that("Install portal into json", {
  # Install portal into json
  portal <- list("portal_main", "portal_plots", "portal_species")
  rdataretriever::install_json('portal')
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


test_that("Install portal into xml", {
  # Install portal into xml
  portal <- list("portal_main", "portal_plots", "portal_species")
  rdataretriever::install_xml('portal')
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

test_that("Install dataset into Postgres", {
  # Install portal into Postgres
  try(system(
    "psql -U postgres -d testdb -h localhost -c \"DROP SCHEMA IF EXISTS testschema CASCADE\"",
    intern = TRUE,
    ignore.stderr = TRUE
  ))
  portal <- c("main", "plots", "species")
  rdataretriever::install_postgres('portal')
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


# test_that("Install the dataset into Mysql", {
#   try(system(
#     "mysql -u travis -Bse 'DROP DATABASE IF EXISTS testdb'",
#     intern = TRUE,
#     ignore.stderr = TRUE
#   ))
#   portal <- c("main", "plots", "species")
#   rdataretriever::install_mysql('portal', database_name = 'testdb')
#   con <- dbConnect(
#     RMariaDB::MariaDB(),
#     user = 'travis',
#     host = 'localhost',
#     password = '',
#     port = 3306,
#     dbname = 'testdb'
#   )
#   result <- dbListTables(con)
#   dbDisconnect(con)
#   expect_setequal(result, portal)
# })


test_that("Install portal into sqlite", {
  # Install the portal into Sqlite
  portal <- c("portal_main", "portal_plots", "portal_species")
  rdataretriever::install_sqlite('portal')
  con <- dbConnect(RSQLite::SQLite(),dbname = "sqlite.db")
  result <- dbListTables(con)
  dbDisconnect(con)
  #expect_setequal(result, portal)
  all_tables_installed = all(portal %in% result)
  expect_true(all_tables_installed)
})


test_that("Install and load a dataset as a list", {
  portal_data <- c("main", "plots", "species")
  portal = rdataretriever::fetch('portal')
  expect_identical(all(names(portal) %in%  portal_data), TRUE)
})
