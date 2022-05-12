#' Check for updates
#'
#' @param repo path to the repository
#'
#' @return No return value, checks for updates \code{repo}
#' @examples
#' \dontrun{
#' rdataretriever::check_for_updates()
#' }
#' @importFrom reticulate import r_to_py
#' @export
check_for_updates <- function(repo = "") {
  writeLines(strwrap("Please wait while the retriever updates its scripts, ..."))
  if (repo == "") {
    retriever$check_for_updates()
  } else {
    retriever$check_for_updates(repo)
  }
}

#' Commit a dataset
#'
#' @param dataset name of the dataset
#' @param commit_message commit message for the commit
#' @param path path to save the committed dataset, if no path given save in provenance directory
#' @param quiet logical, if true retriever runs in quiet mode
#'
#' @return No return value, provides confirmation for commit
#' @examples
#' \dontrun{
#' rdataretriever::commit("iris")
#' }
#' @importFrom reticulate import r_to_py
#' @export
commit <- function(dataset, commit_message = "", path = NULL, quiet = FALSE) {
  retriever$commit(dataset, commit_message, path, quiet)
  cat("Successfully committed.")
}

#' See the log of committed dataset stored in provenance directory
#'
#' @param dataset name of the dataset stored in provenance directory
#'
#' @return No return value, prints message after commit
#' @examples
#' \dontrun{
#' rdataretriever::commit_log("iris")
#' }
#' @importFrom reticulate import r_to_py
#' @export
commit_log <- function(dataset) {
  log_out <- retriever$commit_log(dataset)
  res <- unlist(log_out)
  names(res) <- c("date", "commit_message", "hash_value")
  message(paste0("Commit message: ", res$commit_message))
  message(paste0("Hash: ", res$hash_value))
  message(paste0("Date: ", res$date))
}

#' Name all available dataset scripts.
#'
#' Additional information on the available datasets can be found at url https://retriever.readthedocs.io/en/latest/datasets.html
#'
#' @return returns a character vector with the available datasets for download
#' @examples
#' \dontrun{
#' rdataretriever::dataset_names()
#' }
#' @importFrom reticulate import r_to_py
#' @export
dataset_names <- function() {
  # Accessing datasets() function from Python API
  all_datasets <- retriever$datasets()
  offline_datasets <- c()
  online_datasets <- c()
  for (dataset in all_datasets["offline"]) {
    for (d in dataset) {
      offline_datasets <- c(offline_datasets, d$name)
    }
  }
  for (dataset in all_datasets["online"]) {
    online_datasets <- c(online_datasets, dataset)
  }
  datasets_list <- list("offline" = offline_datasets, "online" = online_datasets)
  return(datasets_list)
}

#' Get retriever citation
#'
#' @return No return value, outputs citation of the Data Retriever Python package
#' @examples
#' \dontrun{
#' rdataretriever::get_retriever_citation()
#' }
#' @export
get_retriever_citation <- function() {
  retriever$get_retriever_citation()
}

#' Get citation of a script
#'
#' @param dataset dataset to obtain citation
#'
#' @return No return value, gets citation of a script
#' @examples
#' \dontrun{
#' rdataretriever::get_script_citation(dataset = "")
#' }
#' @export
get_script_citation <- function(dataset = NULL) {
  retriever$get_script_citation(dataset)
}

#' Get dataset names from upstream
#'
#' @param keywords filter datasets based on keywords
#' @param licenses filter datasets based on license
#' @param repo path to the repository
#'
#' @return No return value, gets dataset names from upstream
#' @examples
#' \dontrun{
#' rdataretriever::get_dataset_names_upstream(keywords = "", licenses = "", repo = "")
#' }
#' @export
get_dataset_names_upstream <- function(keywords = "", licenses = "", repo = "") {
  if (repo == "") {
    retriever$get_dataset_names_upstream(keywords = keywords, licenses = licenses)
  } else {
    retriever$get_dataset_names_upstream(keywords = keywords, licenses = licenses, repo)
  }
}

#' Get scripts upstream
#'
#' @param dataset name of the dataset
#' @param repo path to the repository
#'
#' @return No return value, gets upstream scripts
#' @examples
#' \dontrun{
#' rdataretriever::get_script_upstream("iris")
#' }
#' @importFrom reticulate import r_to_py
#' @export
get_script_upstream <- function(dataset, repo = "") {
  if (repo == "") {
    retriever$get_script_upstream(dataset)
  } else {
    retriever$check_for_updates(dataset, repo)
  }
}

#' Get Data Retriever version
#' @param clean boolean return cleaned version appropriate for semver
#'
#' @return returns a string with the version information
#' @examples
#' \dontrun{
#' rdataretriever::data_retriever_version()
#' }
#' @importFrom reticulate import r_to_py
#' @export
data_retriever_version <- function(clean = TRUE) {
  raw_version <- retriever$"__version__"
  if (clean) {
    clean_version <- gsub("v", "", raw_version)
    return(clean_version)
  } else {
    return(raw_version)
  }
}

#' Check to see if minimum version of retriever Python package is installed
#' @return boolean
#' @examples
#' \dontrun{
#' rdataretriever::check_retriever_availability()
#' }
#' @importFrom reticulate import r_to_py
#' @importFrom semver parse_version
#' @importFrom utils packageDescription
#' @export
check_retriever_availability <- function() {
  if (requireNamespace("reticulate", quietly = TRUE) && reticulate::py_module_available("retriever")) {
    retriever_version <- data_retriever_version()
    retriever_semver <- parse_version(retriever_version)
    sys_req_raw <- packageDescription('rdataretriever', fields = "SystemRequirements")
    regex_pattern <- "retriever \\([>=< ]*([0-9.]*)\\)"
    matches <- regexec(regex_pattern, sys_req_raw)
    min_version <- regmatches(sys_req_raw, matches)[[1]][2]
    min_semver <- parse_version(min_version)
    if (retriever_semver < min_semver) {
      warning("\nNewer version of retriever required.\n\n",
        "This version of rdataretriever requires a newer version of the retriever package.\n",
        "Please upgrade the Python retriever package to at least ", min_version, "\n",
        "You can do this using Python or by using the R command:\n",
        "> reticulate::py_install('retriever')")
      return(FALSE)
    } else {
      return(TRUE)
    }
  } else if(nchar(Sys.getenv('IN_PKGDOWN')) || nchar(Sys.getenv('CI'))){
    return(system("pip install git+https://git@github.com/weecology/retriever.git") == 0)
  } else {
    message("The retriever Python package needs to be installed.\nSee: https://docs.ropensci.org/rdataretriever/#installation")
    return(FALSE)
  }
}

#' Fetch a dataset via the Data Retriever
#'
#' Each datafile in a given dataset is downloaded to a temporary directory and
#' then imported as a data.frame as a member of a named list.
#'
#' @param dataset the names of the dataset that you wish to download
#' @param quiet logical, if true retriever runs in quiet mode
#' @param data_names the names you wish to assign to cells of the list which
#' stores the fetched dataframes. This is only relevant if you are
#' downloading more than one dataset.
#'
#' @return Returns a dataframe of \code{dataset}
#' @examples
#' \dontrun{
#' ## fetch the portal Database
#' portal <- rdataretriever::fetch("portal")
#' class(portal)
#' names(portal)
#' ## preview the data in the portal species datafile
#' head(portal$species)
#' vegdata <- rdataretriever::fetch(c("plant-comp-ok", "plant-occur-oosting"))
#' names(vegdata)
#' names(vegdata$plant_comp_ok)
#' }
#' @importFrom reticulate import r_to_py
#' @export
fetch <- function(dataset, quiet = TRUE, data_names = NULL) {
  data_sets <- list()
  # Accessing dataset_names() function from Python API
  all_datasets <- retriever$dataset_names()
  offline_datasets <- all_datasets["offline"]
  for (x in offline_datasets) {
    data_sets <- c(data_sets, x)
  }
  if (!dataset %in% data_sets) {
    stop(
      "The dataset requested isn't currently available in the rdataretriever.\n
      Run rdataretriever::datasets() to get a list of available datasets\n
      Or run rdataretriever::get_updates() to get the newest available datasets."
    )
  }
  temp_path <- tolower(tempdir())
  if (!dir.exists(temp_path)) {
    dir.create(temp_path)
  }
  datasets <- vector("list", length(dataset))
  if (is.null(data_names)) {
    names(datasets) <- dataset
    names(datasets) <- gsub("-", "_", names(datasets))
  }
  else {
    if (length(data_names) != length(dataset)) {
      stop("Number of names must match number of datasets")
    }
    else if ((length(data_names) == 1) & (length(dataset) == 1)) {
      stop("Assign name through the output instead (e.g., yourname = fetch('dataset')")
      names(datasets) <- data_names
    }
  }
  for (i in seq_along(dataset)) {
    if (quiet) {
      # Accessing install() function from Python API
      retriever$install_csv(
        dataset = dataset[i],
        table_name = "{db}_{table}.csv", data_dir = temp_path
      )
    } else {
      retriever$install_csv(
        dataset = dataset[i],
        table_name = "{db}_{table}.csv", data_dir = temp_path,
        debug = TRUE
      )
    }
    files <- dir(temp_path)
    dataset_underscores <- gsub("-", "_", dataset[i])
    files <- files[grep(dataset_underscores, files)]
    tempdata <- vector("list", length(files))
    list_names <- sub(".csv", "", files)
    list_names <- sub(
      paste(dataset_underscores, "_", sep = ""),
      "", list_names
    )
    names(tempdata) <- list_names
    for (j in seq_along(files)) {
      tempdata[[j]] <- utils::read.csv(file.path(temp_path, files[j]))
    }
    datasets[[i]] <- tempdata
  }
  if (length(datasets) == 1) {
    datasets <- datasets[[1]]
  }
  return(datasets)
}

#' Download datasets via the Data Retriever.
#'
#' Directly downloads data files with no processing, allowing downloading of
#' non-tabular data.
#'
#' @param dataset the name of the dataset that you wish to download
#' @param path the path where the data should be downloaded to
#' @param quiet logical, if true retriever runs in quiet mode
#' @param sub_dir downloaded dataset is stored into a custom subdirectory.
#' @param debug setting TRUE helps in debugging in case of errors
#' @param use_cache Setting FALSE reinstalls scripts even if they are already installed
#'
#' @return No return value, downloads the raw dataset
#' @examples
#' \dontrun{
#' rdataretriever::download("plant-comp-ok")
#' # downloaded files will be copied to your working directory
#' # when no path is specified
#' dir()
#' }
#' @importFrom reticulate import r_to_py
#' @export
download <- function(dataset, path = "./", quiet = FALSE, sub_dir = "", debug = FALSE, use_cache = TRUE) {
  retriever$download(dataset, path, quiet, sub_dir, debug, use_cache)
}

#' Name all available dataset scripts.
#'
#' Additional information on the available datasets can be found at url https://retriever.readthedocs.io/en/latest/datasets.html
#'
#' @return returns a character vector with the available datasets for download
#' @param keywords search all datasets by keywords
#' @param licenses search all datasets by licenses
#'
#' @return Returns the names of all available dataset scripts
#' @examples
#' \dontrun{
#' rdataretriever::datasets()
#' }
#' @importFrom reticulate import r_to_py
#' @export
datasets <- function(keywords = "", licenses = "") {
  # Accessing datasets() function from Python API
  all_datasets <- retriever$datasets(keywords, licenses)
  offline_datasets <- c()
  online_datasets <- c()
  for (dataset in all_datasets["offline"]) {
    for (d in dataset) {
      offline_datasets <- c(offline_datasets, d$name)
    }
  }
  for (dataset in all_datasets["online"]) {
    online_datasets <- c(online_datasets, dataset)
  }
  datasets_list <- list("offline" = offline_datasets, "online" = online_datasets)
  return(datasets_list)
}

#' Install datasets via the Data Retriever.
#'
#' Data is stored in CSV files
#'
#' @param dataset the name of the dataset that you wish to install or path to a committed dataset zip file
#' @param table_name the name of the database file to store data
#' @param data_dir the dir path to store data, defaults to working dir
#' @param debug setting TRUE helps in debugging in case of errors
#' @param use_cache Setting FALSE reinstalls scripts even if they are already installed
#' @param force setting TRUE doesn't prompt for confirmation while installing committed datasets when changes are discovered in environment
#' @param hash_value the hash value of committed dataset when installing from provenance directory
#'
#' @return No return value, installs datasets into CSV
#' @examples
#' \dontrun{
#' rdataretriever::install_csv("iris")
#' }
#' @importFrom reticulate import r_to_py
#' @export
install_csv <- function(dataset, table_name = "{db}_{table}.csv", data_dir = getwd(), debug = FALSE, use_cache = TRUE, force = FALSE, hash_value = NULL) {
  retriever$install_csv(dataset, table_name, data_dir, debug, use_cache, force, hash_value)
}

#' Install datasets via the Data Retriever.
#'
#' Data is stored in JSON files
#'
#' @param dataset the name of the dataset that you wish to install or path to a committed dataset zip file
#' @param table_name the name of the database file to store data
#' @param data_dir the dir path to store data, defaults to working dir
#' @param debug setting TRUE helps in debugging in case of errors
#' @param use_cache setting FALSE reinstalls scripts even if they are already installed
#' @param force setting TRUE doesn't prompt for confirmation while installing committed datasets when changes are discovered in environment
#' @param hash_value the hash value of committed dataset when installing from provenance directory
#' @return No return value, installs datasets in to JSON
#' @examples
#' \dontrun{
#' rdataretriever::install_json("iris")
#' }
#' @importFrom reticulate import r_to_py
#' @export
install_json <- function(dataset, table_name = "{db}_{table}.json", data_dir = getwd(), debug = FALSE, use_cache = TRUE, force = FALSE, hash_value = NULL) {
  retriever$install_json(dataset, table_name, data_dir, debug, use_cache, force, hash_value)
}

#' Install datasets via the Data Retriever.
#'
#' Data is stored in XML files
#'
#' @param dataset the name of the dataset that you wish to install or path to a committed dataset zip file
#' @param table_name the name of the database file to store data
#' @param data_dir the dir path to store data, defaults to working dir
#' @param debug setting TRUE helps in debugging in case of errors
#' @param use_cache Setting FALSE reinstalls scripts even if they are already installed
#' @param force setting TRUE doesn't prompt for confirmation while installing committed datasets when changes are discovered in environment
#' @param hash_value the hash value of committed dataset when installing from provenance directory
#'
#' @return No return value, installs datasets into XML
#' @examples
#' \dontrun{
#' rdataretriever::install_xml("iris")
#' }
#' @importFrom reticulate import r_to_py
#' @export
install_xml <- function(dataset, table_name = "{db}_{table}.xml", data_dir = getwd(), debug = FALSE, use_cache = TRUE, force = FALSE, hash_value = NULL) {
  retriever$install_xml(dataset, table_name, data_dir, debug, use_cache, force, hash_value)
}

#' Install datasets via the Data Retriever.
#'
#' Data is stored in MySQL database
#'
#' @param dataset the name of the dataset that you wish to install or path to a committed dataset zip file
#' @param user username for database connection
#' @param password password for database connection
#' @param host hostname for connection
#' @param port port number for connection
#' @param database_name database name in which dataset will be installed
#' @param table_name table name specified especially for datasets
#' containing one file
#' @param debug setting TRUE helps in debugging in case of errors
#' @param use_cache setting FALSE reinstalls scripts even if they are already installed
#' @param force setting TRUE doesn't prompt for confirmation while installing committed datasets when changes are discovered in environment
#' @param hash_value the hash value of committed dataset when installing from provenance directory
#'
#' @return No return value, installs datasets into MySQL database
#' @examples
#' \dontrun{
#' rdataretriever::install_mysql(dataset = "portal", user = "postgres", password = "abcdef")
#' }
#' @importFrom reticulate import r_to_py
#' @export
install_mysql <- function(dataset, user = "root", password = "", host = "localhost",
                          port = 3306, database_name = "{db}", table_name = "{db}.{table}",
                          debug = FALSE, use_cache = TRUE, force = FALSE, hash_value = NULL) {
  retriever$install_mysql(
    dataset, user, password, host,
    port, database_name, table_name,
    debug, use_cache, force, hash_value
  )
}

#' Install datasets via the Data Retriever.
#'
#' Data is stored in PostgreSQL database
#'
#' @param dataset the name of the dataset that you wish to install or path to a committed dataset zip file
#' @param user username for database connection
#' @param password password for database connection
#' @param host hostname for connection
#' @param port port number for connection
#' @param database the database name default is postres
#' @param database_name database schema name in which dataset will be installed
#' @param table_name table name specified especially for datasets
#' containing one file
#' @param bbox optional extent values used to fetch data from the spatial dataset
#' @param debug setting TRUE helps in debugging in case of errors
#' @param use_cache setting FALSE reinstalls scripts even if they are already installed
#' @param force setting TRUE doesn't prompt for confirmation while installing committed datasets when changes are discovered in environment
#' @param hash_value the hash value of committed dataset when installing from provenance directory
#'
#' @return No return value, installs datasets into PostgreSQL database
#' @examples
#' \dontrun{
#' rdataretriever::install_postgres(dataset = "portal", user = "postgres", password = "abcdef")
#' }
#' @importFrom reticulate import r_to_py
#' @export
install_postgres <- function(dataset, user = "postgres", password = "",
                             host = "localhost", port = 5432, database = "postgres",
                             database_name = "{db}", table_name = "{db}.{table}",
                             bbox = list(), debug = FALSE, use_cache = TRUE, force = FALSE, hash_value = NULL) {
  # Use the R list function explicitly
  bbox <- reticulate::r_to_py(bbox)
  retriever$install_postgres(
    dataset, user, password, host,
    port, database, database_name,
    table_name, bbox, debug, use_cache, force, hash_value
  )
}

#' Install datasets via the Data Retriever.
#'
#' Data is stored in SQLite database
#'
#' @param dataset the name of the dataset that you wish to install or path to a committed dataset zip file
#' @param file Sqlite database file name or path
#' @param table_name table name for installing of dataset
#' @param data_dir the dir path to store the db, defaults to working dir
#' @param debug setting TRUE helps in debugging in case of errors
#' @param use_cache setting FALSE reinstalls scripts even if they are already installed
#' @param force setting TRUE doesn't prompt for confirmation while installing committed datasets when changes are discovered in environment
#' @param hash_value the hash value of committed dataset when installing from provenance directory
#'
#' @return No return value, installs datasets into SQLite database
#' @examples
#' \dontrun{
#' rdataretriever::install_sqlite(dataset = "iris", file = "sqlite.db")
#' }
#' @importFrom reticulate import r_to_py
#' @export
install_sqlite <- function(dataset, file = "sqlite.db", table_name = "{db}_{table}",
                           data_dir = getwd(), debug = FALSE, use_cache = TRUE, force = FALSE, hash_value = NULL) {
  tryCatch(withCallingHandlers(
    {
      retriever$install_sqlite(dataset, file, table_name, data_dir, debug, use_cache, force, hash_value)
    },
    error = function(error_message) {
      message("Full error trace:")
      message(error_message)
      return(NA)
    }
  ))
}

#' Install datasets via the Data Retriever.
#'
#' Data is stored in MSAccess database
#'
#' @param dataset the name of the dataset that you wish to install or path to a committed dataset zip file
#' @param file file name for database
#' @param table_name table name for installing of dataset
#' @param debug setting TRUE helps in debugging in case of errors
#' @param use_cache Setting FALSE reinstalls scripts even if they are already installed
#' @param force setting TRUE doesn't prompt for confirmation while installing committed datasets when changes are discovered in environment
#' @param hash_value the hash value of committed dataset when installing from provenance directory
#'
#' @return No return value, installs datasets into MSAccess database
#' @examples
#' \dontrun{
#' rdataretriever::install_msaccess(dataset = "iris", file = "sqlite.db")
#' }
#' @importFrom reticulate import r_to_py
#' @export
install_msaccess <- function(dataset, file = "access.mdb", table_name = "[{db} {table}]",
                             debug = FALSE, use_cache = TRUE, force = FALSE, hash_value = NULL) {
  retriever$install_msaccess(dataset, file, table_name, debug, use_cache)
}

#' Install datasets via the Data Retriever (deprecated).
#'
#' Data is stored in either CSV files or one of the following database management
#' systems: MySQL, PostgreSQL, SQLite, or Microsoft Access.
#'
#' @param dataset the name of the dataset that you wish to download
#' @param connection what type of database connection should be used.
#' The options include: mysql, postgres, sqlite, msaccess, or csv'
#' @param db_file the name of the datbase file the dataset should be loaded
#' into
#' @param conn_file the path to the .conn file that contains the connection
#' configuration options for mysql and postgres databases. This defaults to
#' mysql.conn or postgres.conn respectively. The connection file is a file that
#' is formated in the following way:
#' \tabular{ll}{
#'   host     \tab my_server@my_host.com\cr
#'   port     \tab my_port_number       \cr
#'   user     \tab my_user_name         \cr
#'   password \tab my_password
#' }
#' @param data_dir the location where the dataset should be installed.
#' Only relevant for csv connection types. Defaults to current working directory
#' @param log_dir the location where the retriever log should be stored if
#' the progress is not printed to the console
#'
#' @return No return value, main install function
#' @examples
#' \dontrun{
#' rdataretriever::install("iris", "csv")
#' }
#' @importFrom reticulate import r_to_py
#' @export
install <- function(dataset, connection, db_file = NULL, conn_file = NULL,
                    data_dir = ".", log_dir = NULL) {
  # This function is deprecated
  paste("This function it deprecated use, install_",
        connection, "()",
        sep = ""
  )
  if (connection == "mysql" | connection == "postgres") {
    if (is.null(conn_file)) {
      conn_file <- paste("./", connection, ".conn", sep = "")
    }
    if (!file.exists(conn_file)) {
      format <- "\nhost my_server@myhost.com\nport my_port_number\n
                user my_user_name\npassword my_pass_word"
      stop(
        paste(
          "conn_file:",
          conn_file,
          "does not exist. To use a",
          connection,
          "server create a 'conn_file' with the format:",
          format,
          "\nwhere order of arguments does not matter"
        )
      )
    }
    conn <- data.frame(t(utils::read.table(conn_file, row.names = 1)))
    writeLines(strwrap(paste(
      "Using conn_file:", conn_file, "to connect to a",
      connection, "server on host:", conn$host
    )))
    if (connection == "mysql") {
      install_mysql(dataset,
                    user = conn$user, host = conn$host,
                    port = conn$port, password = conn$password
      )
    }
    if (connection == "postgres") {
      install_postgres(dataset,
                       user = conn$user, host = conn$host,
                       port = conn$port, password = conn$password
      )
    }
  } else if (connection == "msaccess") {
    if (is.null(db_file)) {
      install_msaccess(dataset)
    } else {
      install_msaccess(dataset,
                       file = "access.mdb",
                       table_name = "[{db} {table}]", debug = FALSE, use_cache = TRUE
      )
    }
  } else if (connection == "sqlite") {
    if (is.null(db_file)) {
      install_sqlite(dataset)
    }
    else {
      install_sqlite(dataset,
                     file = db_file, table_name = "{db}_{table}",
                     debug = FALSE, use_cache = TRUE
      )
    }
  } else if (connection %in% c("csv", "json", "xml")) {
    table_name <- file.path(data_dir, paste("{db}_{table}", connection, sep = "."))
    if (connection == "csv") {
      install_csv(dataset, table_name = table_name, debug = FALSE, use_cache = TRUE)
    }
    else if (connection == "json") {
      install_json(dataset, table_name = table_name, debug = FALSE, use_cache = TRUE)
    }
    else if (connection == "xml") {
      install_xml(dataset, table_name = table_name, debug = FALSE, use_cache = TRUE)
    }
  }
}

#' Reset the scripts or data(raw_data) directory or both
#' @param scope All resets both scripst and data directory
#'
#' @return No return value, resets the scripts and the data directory
#' @examples
#' \dontrun{
#' rdataretriever::reset("iris")
#' }
#' @importFrom reticulate import r_to_py
#' @export
reset <- function(scope = "all") {
  retriever$reset_retriever(scope)
  reload_scripts()
}

#' Update the retriever's dataset scripts to the most recent versions.
#'
#' This function will check if the version of the retriever's scripts in your local
#' directory \file{~/.retriever/scripts/} is up-to-date with the most recent official
#' retriever release. Note it is possible that even more updated scripts exist
#' at the retriever repository \url{https://github.com/weecology/retriever/tree/main/scripts}
#' that have not yet been incorperated into an official release, and you should
#' consider checking that page if you have any concerns.
#' @keywords utilities
#'
#' @return No return value, updatea the retriever's dataset scripts to the most recent versions
#' @examples
#' \dontrun{
#' rdataretriever::get_updates()
#' }
#' @importFrom reticulate import r_to_py
#' @export
get_updates <- function() {
  writeLines(strwrap("Please wait while the retriever updates its scripts, ..."))
  retriever$check_for_updates()
  reload_scripts()
}

#' Update the retriever's global_script_list with the scripts present
#' in the ~/.retriever directory.
#'
#' @return No return value, fetches most resent scripts
#' @examples
#' \dontrun{
#' rdataretriever::reload_scripts()
#' }
#' @importFrom reticulate import r_to_py
#' @export
reload_scripts <- function() {
  retriever$reload_scripts()
}

#' Setting path of retriever
#'
#' @param path location of retriever in the system
#'
#' @return No return value, setting path of retriever
#' @examples
#' \dontrun{
#' rdataretriever::use_RetrieverPath("/home/<system_name>/anaconda2/envs/py27/bin/")
#' }
#' @export
use_RetrieverPath <- function(path) {
  Sys.setenv(PATH = paste(path, ":", Sys.getenv("PATH"), sep = ""))
}

#' install the python module `retriever`
#' 
#' @inheritParams reticulate::py_install
#' 
#' @return No return value, install the python module `retriever`
#' @export
install_retriever <- function(method = "auto", conda = "auto") {
  reticulate::py_install("retriever", method = method, conda = conda)
}

#' Updates the datasets_url.json from the github repo
#'
#' @param test flag set when testing
#'
#' @return No return value, updates the datasets_url.json
#' @examples
#' \dontrun{
#' rdataretriever::update_rdataset_catalog()
#' }
#' @importFrom reticulate import r_to_py
#' @export
update_rdataset_catalog <-function(test=FALSE){
  retriever$update_rdataset_catalog(test)
}

#' Displays the list of rdataset names present in the list of packages provided
#'
#' Can take a list of packages, or NULL or a string 'all' for all rdataset packages and datasets
#' @param package_name print datasets in the package, default to print rdataset and all to print all
#'
#' @return No return value, displays the list of rdataset names present
#' @examples
#' \dontrun{
#' rdataretriever::display_all_rdataset_names()
#' }
#' @importFrom reticulate import r_to_py
#' @export
display_all_rdataset_names <- function(package_name=NULL){
  retriever$display_all_rdataset_names(package_name)
}

#' Returns a list of all the available RDataset names present
#'
#' @return No return value, list of all the available RDataset
#' @examples
#' \dontrun{
#' rdataretriever::get_rdataset_names()
#' }
#' @importFrom reticulate import r_to_py
#' @export
get_rdataset_names <- function(){
  retriever$get_rdataset_names()
}

#' Returns the list of dataset names after autocompletion
#'
#' @param dataset the name of the dataset
#'
#' @return No return value, show dataset names after autocompletion
#' @examples
#' \dontrun{
#' rdataretriever::socrata_autocomplete_search()
#' }
#' @importFrom reticulate import r_to_py
#' @export
socrata_autocomplete_search <- function(dataset){
  retriever$socrata_autocomplete_search(dataset)
}

#' Get socrata dataset info
#'
#' @param dataset_name dataset name to obtain info
#'
#' @return No return value, shows socrata dataset info
#' @examples
#' \dontrun{
#' rdataretriever::socrata_dataset_info()
#' }
#' @importFrom reticulate import r_to_py
#' @export
socrata_dataset_info <- function(dataset_name){
  retriever$socrata_dataset_info(dataset_name)
}

#' Returns metadata for the following dataset id
#'
#' @param dataset_id id of the dataset
#'
#' @return No return value, shows metadata for the following \code{dataset id}
#' @examples
#' \dontrun{
#' rdataretriever::socrata_dataset_info()
#' }
#' @importFrom reticulate import r_to_py
#' @export
find_socrata_dataset_by_id <- function(dataset_id){
  retriever$find_socrata_dataset_by_id(dataset_id)
}

# Package helper functions

print.update_log <- function(x, ...) {
  if (length(x) == 0) {
    cat("No scripts downloaded")
  }
  else {
    # clean up and print the update log output
    object <- strsplit(paste(x, collapse = " ; "), "Downloading script: ")
    object <- sort(sapply(
      strsplit(object[[1]][-1], " ; "),
      function(x) {
        x[[1]][1]
      }
    ))
    object[1] <- paste("Downloaded scripts:", object[1])
    cat(object, fill = TRUE, sep = ", ")
  }
}

get_os <- function() {
  sysinf <- Sys.info()
  if (!is.null(sysinf)) {
    os <- sysinf["sysname"]
    if (os == "Darwin") {
      os <- "osx"
    }
  } else {
    ## mystery machine
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os)) {
      os <- "osx"
    }
    if (grepl("linux-gnu", R.version$os)) {
      os <- "linux"
    }
  }
  tolower(os)
}

retriever <- NULL

.onLoad <- function(libname, pkgname) {
  ## assignment in parent environment!
  try({
    retriever <<- reticulate::import("retriever", delay_load = TRUE)
    # Disable due to failure to test on win cran dev platform
    # check_retriever_availability()
  }, silent = TRUE)
}
