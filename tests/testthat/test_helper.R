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
skip_if_no_python <- function() {
  modules <- reticulate::py_module_available("retriever")
  if (!modules){
    testthat::skip("retriever not available for testing")
  } else{
  load_required_packages()
  }
}

load_required_packages<- function() {
  if (!requireNamespace("reticulate", quietly = TRUE)) {
    testthat::skip("reticulate not available for testing")
  }
  suppressPackageStartupMessages(require(reticulate))
  suppressPackageStartupMessages(require(DBI))
  # suppressPackageStartupMessages(require(RMariaDB))
  suppressPackageStartupMessages(require(RPostgreSQL))
  suppressPackageStartupMessages(require(RSQLite))
}

