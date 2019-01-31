if (!requireNamespace("reticulate", quietly = TRUE)) {
  return()
}

suppressPackageStartupMessages(require(reticulate))
suppressPackageStartupMessages(require(DBI))
# suppressPackageStartupMessages(require(RMariaDB))
suppressPackageStartupMessages(require(RPostgreSQL))
suppressPackageStartupMessages(require(RSQLite))

# Set passwords and host names depending on test environment
os_password = ""
pgdb = "localhost"
mysqldb = "localhost"
mysql_conf = "~/.my.cnf"
docker_or_travis = Sys.getenv("IN_DOCKER")

# Check if the environment variable "IN_DOCKER" is set to "true"
if (docker_or_travis == "true") {
  os_password = 'Password12!'
  pgdb = "pgdb"
  mysqldb = "mysqldb"
  mysql_conf = "/cli_tools/.my.cnf"
}

full_normalized_path = function(paths, ..., mustWork = FALSE) {
  # Join and Normalize a path
  # Checks if the path exists if mustWork = TRUE
  file_path <- normalizePath(file.path(paths, ...), 
                             winslash = "/",
                             mustWork = mustWork)
}
