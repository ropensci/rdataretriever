# Set passwords and host names depending on test environment
os_password = ""
pgdb_rdata = "localhost"
mysqldb_rdata = "localhost"
mysql_conf = "~/.my.cnf"
docker_or_travis = Sys.getenv("IN_DOCKER")

# Check if the environment variable "IN_DOCKER" is set to "true"
if (docker_or_travis == "true") {
  os_password = 'Password12!'
  pgdb_rdata = "pgdb_rdata"
  mysqldb_rdata = "mysqldb_rdata"
  mysql_conf = "/cli_tools/.my.cnf"
}

full_normalized_path = function(paths, ..., mustWork = FALSE) {
  # Join and Normalize a path
  # Checks if the path exists if mustWork = TRUE
  file_path <- normalizePath(file.path(paths, ...), 
                             winslash = "/",
                             mustWork = mustWork)
}

# helper to skip tests if python is not avaialable
skip_if_no_retriever <- function() {
  # check for reticulate
  if (!requireNamespace("reticulate", quietly = TRUE)) {
    testthat::skip("reticulate not available for testing")
  }
  retriever_available <- FALSE
  try({
    retriever_available <- reticulate::py_module_available("retriever")
  }, silent = TRUE)
  if (!retriever_available) {
    testthat::skip("retriever not available for testing")
  }
}

skip_if_no_postgres <- function() {
  deps_available <- suppressPackageStartupMessages(require(DBI) && 
                                                   require(RPostgreSQL))
  if (!deps_available) {
    testthat::skip("DBI and RPostgreSQL not available for testing")
  }
}

skip_if_no_sqlite <- function() {
  deps_available <- suppressPackageStartupMessages(require(DBI) && 
                                                   require(RSQLite))
  if (!deps_available) {
    testthat::skip("RSQLite not available for testing")
  }
}

