context("regression tests version 1.0.0")

suppressPackageStartupMessages(require(reticulate))
suppressPackageStartupMessages(require(DBI))
# suppressPackageStartupMessages(require(RMariaDB))
suppressPackageStartupMessages(require(RPostgreSQL))
suppressPackageStartupMessages(require(RSQLite))


# Set passwords and host names deppending on test environment
os_password = ""
pgdb = "localhost"
mysqldb = "localhost"
doker_or_travis = Sys.getenv("TRAVIS_OR_DOCKER")


# Check if the environment variable "TRAVIS_OR_DOCKER" is set to "true"
if (doker_or_travis %in% "doker_or_travis") {
  os_password = 'Password12!'
  pgdb = "pgdb"
  mysqldb = "mysqldb"
}


testthat::test_that("datasets returns some known values", {
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
  rdataretriever::install('portal', 'csv')
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


test_that("Install dataset into Postgres", {
  # Install the portal into Postgres
  try(system(
    paste("psql -U postgres -d testdb -p 5432 -h" , pgdb,
          " -w -c \"DROP SCHEMA IF EXISTS testschema CASCADE\""),
    intern = TRUE,
    ignore.stderr = TRUE
  ))
  portal <- c("main", "plots", "species")
  rdataretriever::install('portal', "postgres")
  con <- dbConnect(
    dbDriver("PostgreSQL"),
    user = 'postgres',
    host = pgdb,
    password = os_password,
    port = 5432,
    dbname = 'testdb'
  )
  result <- dbGetQuery(con,
      "SELECT table_name FROM information_schema.tables WHERE table_schema='testschema'"
    )
  dbDisconnect(con)
  expect_identical(all(result$table_name %in%  portal), TRUE)
})


test_that("Install the dataset into Mysql", {
  #Use msql client to drop the database
  try(err<-system(
    paste("mysql -u travis --host" , mysqldb,
          "--port 3306 - Bse 'DROP DATABASE IF EXISTS testdb'"),
    intern = TRUE,
    ignore.stderr = TRUE
  ))
  portal <- c("main", "plots", "species")
  rdataretriever::install('portal', 'mysql')
## RMariaDB api may need more tweaking
#   con <- dbConnect(
#     RMariaDB::MariaDB(),
#     user = 'travis',
#     host = mysqldb,
#     password = os_password,
#     port = 3306,
#     dbname = 'testdb'
#   )
#   result <- dbListTables(con)
#   dbDisconnect(con)
#   expect_setequal(result, portal)
})


test_that("Install the portal into sqlite", {
  # Install the portal into Sqlite
  portal <- c("portal_main", "portal_plots", "portal_species")
  rdataretriever::install('portal', 'sqlite', db_file = "test.sqlite")
  con <- dbConnect(RSQLite::SQLite(), dbname = "test.sqlite")
  result <- dbListTables(con)
  dbDisconnect(con)
  all_tables_installed = all(portal %in% result)
  expect_true(all_tables_installed)
})
