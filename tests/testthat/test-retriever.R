context("regression tests")

source("test_helper.R")

testthat::test_that("datasets returns some known values", {
  skip_on_cran()
  expect_identical("car-eval" %in% rdataretriever::datasets(), TRUE)
})


test_that("Download the raw portal dataset into './data/'", {
  portal <- list("3299474", "3299483", "5603981")
  rdataretriever::download('portal', './data/')
  for (file in portal)
  {
    file_path <- full_normalized_path(mustWork = FALSE,
      getwd(), "tests/testthat/data", file)
    expect_identical(identical(file.info(file_path)$size, integer(0)), FALSE)
  }
})


test_that("Install portal into csv", {
  # Install portal into csv files in your working directory
  portal <- list("portal_main", "portal_plots", "portal_species")
  rdataretriever::install_csv('portal')
  for (file in portal)
  {
    file_path <- full_normalized_path(mustWork = FALSE,
      getwd(), "tests/testthat", paste(file, "csv", sep = "."))
    expect_identical(identical(file.info(file_path)$size, integer(0)), FALSE)
  }
})


test_that("Install portal into json", {
  # Install portal into json
  portal <- list("portal_main", "portal_plots", "portal_species")
  rdataretriever::install_json('portal')
  for (file in portal)
  {
    file_path <- full_normalized_path(mustWork = FALSE,
        getwd(), "tests/testthat", paste(file, "json", sep = "."))
    expect_identical(identical(file.info(file_path)$size, integer(0)), FALSE)
  }
})


test_that("Install portal into xml", {
  # Install portal into xml
  portal <- list("portal_main", "portal_plots", "portal_species")
  rdataretriever::install_xml('portal')
  for (file in portal)
  {
    file_path <- full_normalized_path(mustWork = FALSE,
        getwd(), "tests/testthat", paste(file, "xml", sep = "."))
    expect_identical(identical(file.info(file_path)$size, integer(0)), FALSE)
  }
})

test_that("Install dataset into Postgres", {
  # Install portal into Postgres at host
  try(system(
    paste("psql -U postgres -d testdb -p 5432 -h" , pgdb,
          " -w -c \"DROP SCHEMA IF EXISTS testschema CASCADE\""),
    intern = TRUE,
    ignore.stderr = TRUE
  ))
  portal <- c("main", "plots", "species")
  rdataretriever::install_postgres('portal', host= pgdb,
    password = os_password, database_name = 'testdb')
  con <- dbConnect(
    dbDriver("PostgreSQL"),
    user = 'postgres',
    host = pgdb,
    password = os_password,
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
  try(err<-system(
    paste("mysql -u travis --host" , mysqldb,
          "--port 3306 -Bse 'DROP DATABASE IF EXISTS testdb'"),
    intern = TRUE,
    ignore.stderr = TRUE
  ))
  portal <- c("main", "plots", "species")
  rdataretriever::install_mysql('portal', database_name = 'testdb',
    host = mysqldb)
  # con <- dbConnect(RMariaDB::MariaDB(), default.file = mysql_conf)
  # result <- dbListTables(con)
  # dbDisconnect(con)
  # expect_setequal(result, portal)
})


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
