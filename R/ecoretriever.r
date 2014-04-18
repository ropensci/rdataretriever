#' Install datasets via the EcoData Retriever.
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
#' mysql.conn or postgres.conn respectively. The connection file is a comma
#' seperated file with four fields: user, password, host, and port. 
#' @param log_dir the location where the retriever log should be stored if
#' the progress is not printed to the console
#' @export
#' @examples
#' ## Use an explicit namespace call when using install() to avoid conflicts
#' ecoretriever::install('MCDB', 'csv')
#' ## list the files that were downloaded
#' dir(pattern='MCDB')
install = function(dataset, connection, db_file=NULL, conn_file=NULL, log_dir=NULL){
  if (missing(connection)) {
    stop("The argument 'connection' must be set to one of the following options: 'mysql', 'postgres', 'sqlite', 'msaccess', or 'csv'")
  }
  else if (connection == 'mysql' | connection == 'postgres') {
    if (is.null(conn_file))
      conn_file = paste('./', connection, '.conn', sep='')
    conn = read.csv(conn_file, stringsAsFactors=F)
    cmd = paste('retriever install', connection, dataset, '--user', conn$user,
                '--password', conn$password, '--host', conn$host, '--port',
                conn$port)
  }
  else if (connection == 'sqlite' | connection == 'msaccess') {
    if (is.null(db_file))
      cmd = paste('retriever install', connection, dataset)
    else
      cmd = paste('retriever install', connection, dataset, '--file', db_file)
  }
  else if (connection == 'csv')
    cmd = paste('retriever install csv', dataset)
  else
    stop("The argument 'connection' must be set to one of the following options: 'mysql', 'postgres', 'sqlite', 'msaccess', or 'csv'")
  if (!is.null(log_dir)) {
    log_file = file.path(log_dir, paste(dataset, '_download.log', sep=''))
    cmd = paste(cmd, '>', log_file, '2>&1')
  }
  system(cmd)
}

#' Fetch a dataset via the EcoData Retriever
#'
#' Each datafile in a given dataset is downloaded to a temporary directory and
#' then imported as a data.frame as a member of a named list.
#'
#' @param dataset the name of the dataset that you wish to download
#' @export
#' @examples
#' ## Use an explicit namespace call when using fetch() to avoid conflicts
#' ## fetch the Mammal Community Database (MCDB)
#' MCDB = ecoretriever::fetch('MCDB')
#' class(MCDB)
#' names(MCDB)
#' ## preview the data in the MCDB communities datafile
#' head(MCDB$communities)
fetch = function(dataset, quiet=TRUE){
  start_dir = getwd()
  setwd(tempdir())
  if (quiet)
    system(paste('retriever -q install csv', dataset))
  else
    install_data(dataset, 'csv')
  files = dir('.')
  files = files[grep(dataset, files)]
  out = vector('list', length(files))
  list_names = sub('.csv', '', files)
  list_names = sub(paste(dataset, '_', sep=''), '', list_names)
  names(out) = list_names
  for (i in seq_along(files))
    out[[i]] = read.csv(files[i])
  setwd(start_dir)
  return(out)
}

#' Download datasets via the EcoData Retriever.
#'
#' Directly downloads data files with no processing, allowing downloading of
#' non-tabular data.
#'
#' @param dataset the name of the dataset that you wish to download
#' @param path the path where the data should be downloaded to
#' @param log_dir the location where the retriever log should be stored if
#' the progress is not printed to the console
#' @export
#' @examples
#' ## Use an explicit namespace call when using download() to avoid conflicts
#' ecoretriever::download('MCDB', './data')
#' ## list files downloaded
#' dir('./data', pattern='MCDB')
download = function(dataset, path='.', log_dir=NULL) {
    cmd = paste('retriever download', dataset, '-p', path)
    if (!is.null(log_dir)) {
        log_file = file.path(log_dir, paste(dataset, '_download.log', sep=''))
        cmd = paste(cmd, '>', log_file, '2>&1')
    }
    system(cmd)
}

#' Display a list all available dataset scripts
#' @return returns the log of the available datasets for download
#' @export
#' @examples 
#' ## Use an explicit namespace call when using datasets() to avoid conflicts
#' ecoretriever::datasets()
datasets = function(){
  system('retriever ls') 
}

.onLoad = function(...) {
  packageStartupMessage(
    "\n  New to ecoretriever? Examples at
    https://github.com/ropensci/ecoretriever/
    Use citation(package='ecoretriever') for the package citation
    Use suppressPackageStartupMessages() to suppress these
    messages in the future")
  print('Please wait while retriever updates its scripts, ...')
  system('retriever update', ignore.stdout=TRUE, ignore.stderr=TRUE)
  print('Retriever script update complete!')
}
