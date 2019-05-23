context("regression tests version 1.0.0")

source("test_helper.R")

testthat::test_that("datasets returns some known values", {
  skip_if_no_python()
  expect_identical("car-eval" %in% rdataretriever::datasets(), TRUE)
})


test_that("Download the raw portal dataset into './data/'", {
  skip_if_no_python()
  portal <- list("3299474", "3299483", "5603981")
  rdataretriever::download('portal', './data/')
  for (file in portal)
  {
    file_path <- full_normalized_path(mustWork = FALSE,
      getwd(), "tests/testthat/data", file)
    expect_identical(identical(file.info(file_path)$size, integer(0)), FALSE)
  }
})


test_that("Install the portal into csv", {
  skip_if_no_python()
  # Install portal into csv files in your working directory
  portal <- list("portal_main", "portal_plots", "portal_species")
  rdataretriever::install('portal', 'csv')
  for (file in portal)
  {
    file_path <- full_normalized_path(mustWork = FALSE,
      getwd(), "tests/testthat", paste(file, "csv", sep = "."))
    expect_identical(identical(file.info(file_path)$size, integer(0)), FALSE)
  }
})


test_that("Install the portal into json", {
  skip_if_no_python()
  # Install portal into json
  portal <- list("portal_main", "portal_plots", "portal_species")
  rdataretriever::install('portal', 'json')
  for (file in portal)
  {
    file_path <- full_normalized_path(mustWork = FALSE,
        getwd(), "tests/testthat", paste(file, "json", sep = "."))
    expect_identical(identical(file.info(file_path)$size, integer(0)), FALSE)
  }
})


test_that("Install the portal into xml", {
  skip_if_no_python()
  # Install portal into xml
  portal <- list("portal_main", "portal_plots", "portal_species")
  rdataretriever::install('portal', 'xml')
  for (file in portal)
  {
    file_path <- full_normalized_path(mustWork = FALSE,
        getwd(), "tests/testthat", paste(file, "xml", sep = "."))
    expect_identical(identical(file.info(file_path)$size, integer(0)), FALSE)
  }
})


test_that("Install dataset into Postgres", {
  skip_if_no_python()
  skip_on_cran()
  # Install the portal into Postgres
  if (docker_or_travis == "true") {
    # These tests only run on travis and not locally
    try(system(
      paste("psql -U postgres -d testdb_retriever -p 5432 -h" , pgdb_rdata,
            " -w -c \"DROP SCHEMA IF EXISTS testschema CASCADE\""),
      intern = TRUE,
      ignore.stderr = TRUE
    ))
    portal <- c("main", "plots", "species")
    rdataretriever::install('portal', "postgres")
    con <- dbConnect(
      dbDriver("PostgreSQL"),
      user = 'postgres',
      host = pgdb_rdata,
      password = os_password,
      port = 5432,
      dbname = 'testdb_retriever'
    )
    result <- dbGetQuery(con,
        "SELECT table_name FROM information_schema.tables WHERE table_schema='testschema'"
      )
    dbDisconnect(con)
    expect_identical(all(result$table_name %in%  portal), TRUE)
  }
})



test_that("Install the dataset into Mysql", {
  skip_if_no_python()
  skip_on_cran()
  # Use msql client to drop the database
  if (docker_or_travis == "true") {
    # These tests only run on travis and not locally
    try(err <- system(
      paste("mysql -u travis --host" , mysqldb_rdata,
            "--port 3306 -Bse 'DROP DATABASE IF EXISTS testdb_retriever'"),
      intern = TRUE,
      ignore.stderr = TRUE
    ))
    portal <- c("main", "plots", "species")
    rdataretriever::install('portal', 'mysql')
    ## RMariaDB api may need more tweaking
    #   con <- dbConnect(
    #     RMariaDB::MariaDB(),
    #     user = 'travis',
    #     host = mysqldb_rdata,
    #     password = os_password,
    #     port = 3306,
    #     dbname = 'testdb_retriever'
    #   )
    #   result <- dbListTables(con)
    #   dbDisconnect(con)
    #   expect_setequal(result, portal)
  }
})


test_that("Install the portal into sqlite", {
  skip_if_no_python()
  # Install the portal into Sqlite
  portal <- c("portal_main", "portal_plots", "portal_species")
  rdataretriever::install('portal', 'sqlite', db_file = "test.sqlite")
  con <- dbConnect(RSQLite::SQLite(), dbname = "test.sqlite")
  result <- dbListTables(con)
  dbDisconnect(con)
  all_tables_installed = all(portal %in% result)
  expect_true(all_tables_installed)
})
