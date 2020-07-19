context("regression tests")

source("test_helper.R")

testthat::test_that("datasets returns some known values", {
  skip_if_no_retriever()
  skip_on_cran()
  offline_datasets = rdataretriever::datasets()['offline']
  offline_dataset_names = c()
  for (dataset in offline_datasets) {
    offline_dataset_names = c(offline_dataset_names, dataset)
  }
  expect_identical("car-eval" %in% offline_dataset_names, TRUE)
})


test_that("Download the raw portal dataset using path", {
  skip_if_no_retriever()
  portal <- list("3299474", "3299483", "5603981")
  path = tempdir()
  rdataretriever::download(dataset = 'portal', path = path)
  for (file in portal)
  {
    file_path <- full_normalized_path(path, file, mustWork = FALSE)
    expect_identical(identical(file.info(file_path)$size, integer(0)), FALSE)
  }
})


test_that("Download the raw portal dataset using path and sub_dir", {
  skip_if_no_retriever()
  portal <- list("3299474", "3299483", "5603981")
  path = tempdir()
  sub_dir = 'sub_dir'
  rdataretriever::download(dataset = 'portal', path = path, sub_dir = sub_dir)
  for (file in portal)
  {
    file_path <- full_normalized_path(path, sub_dir, file, mustWork = FALSE)
    expect_identical(identical(file.info(file_path)$size, integer(0)), FALSE)
  }
})


test_that("Install portal into csv", {
  skip_if_no_retriever()
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
  skip_if_no_retriever()
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
  skip_if_no_retriever()
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
  skip_if_no_retriever()
  skip_if_no_postgres()
  skip_on_cran()
  # Install portal into Postgres at host
  try(system(
    paste("psql -U postgres -d testdb_retriever -p 5432 -h" , pgdb_rdata,
          " -w -c \"DROP SCHEMA IF EXISTS testschema CASCADE\""),
    intern = TRUE,
    ignore.stderr = TRUE
  ))
  portal <- c("main", "plots", "species")
  rdataretriever::install_postgres('portal', host= pgdb_rdata,
    password = os_password, database_name = 'testdb_retriever')
  con <- dbConnect(
    dbDriver("PostgreSQL"),
    user = 'postgres',
    host = pgdb_rdata,
    password = os_password,
    port = 5432,
    dbname = 'testdb_retriever'
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
  skip_if_no_retriever()
  skip_on_cran()
  try(err<-system(
    paste("mysql -u travis --host" , mysqldb_rdata,
          "--port 3306 -Bse 'DROP DATABASE IF EXISTS testdb_retriever'"),
    intern = TRUE,
    ignore.stderr = TRUE
  ))
  portal <- c("main", "plots", "species")
  rdataretriever::install_mysql('portal', database_name = 'testdb_retriever',
    host = mysqldb_rdata)
  #con <- dbConnect(RMariaDB::MariaDB(), default.file = mysql_conf)
  #result <- dbListTables(con)
  #dbDisconnect(con)
  #expect_setequal(result, portal)
})


test_that("Install portal into sqlite", {
  skip_if_no_sqlite()
  skip_if_no_retriever()
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
  skip_if_no_retriever()
  portal_data <- c("main", "plots", "species")
  portal = rdataretriever::fetch('portal')
  expect_identical(all(names(portal) %in%  portal_data), TRUE)
})

test_that("Reset a dataset script", {
  skip_if_no_retriever()
  skip_on_cran()
  dataset = "iris"
  rdataretriever::reset(dataset)
  rdataretriever::reload_scripts()
  json_path = paste("~/.retriever/scripts/", "iris", ".json", sep="")
  py_path = paste("~/.retriever/scripts/", "iris", ".py", sep="")
  expect_identical(file.exists(json_path), FALSE)
  expect_identical(file.exists(py_path), FALSE)
  rdataretriever::get_updates()
  rdataretriever::reload_scripts()
  offline_datasets = rdataretriever::datasets()['offline']
  offline_dataset_names = c()
  for (dataset in offline_datasets) {
    offline_dataset_names = c(offline_dataset_names, dataset)
  }
  expect_identical("iris" %in% offline_dataset_names, TRUE)
})

test_that("Citation info is correct", {
  skip_if_no_retriever()
  portal_citation <- rdataretriever::get_citation('portal')
  expect_true(is.character(portal_citation))
  expect_match(portal_citation[1],
               "Citation:   S. K. Morgan Ernest, Thomas J. Valone, and James H. Brown. 2009. Long-term monitoring and experimental manipulation of a Chihuahuan Desert ecosystem near Portal, Arizona, USA. Ecology 90:1708.", 
               fixed = TRUE)
})

test_that("Citation of scripts", {
  skip_if_no_retriever()
  portal_citation <- rdataretriever::get_script_citation('portal')
  expect_true(is.character(portal_citation))
  expect_match(portal_citation[1],
               "S. K. Morgan Ernest, Thomas J. Valone, and James H. Brown. 2009. Long-term monitoring and experimental manipulation of a Chihuahuan Desert ecosystem near Portal, Arizona, USA. Ecology 90:1708.",
               fixed = TRUE)
})

test_that("Minimum retriever version is installed", {
  skip_if_no_retriever()
  expect_true(rdataretriever::check_retriever_availability())
})