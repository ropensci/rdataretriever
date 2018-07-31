#Usage of Reticulate instead of command line interface of Data Retriever

#fetch function

#' Title
#'
#' @param dataset 
#' @param quiet 
#' @param data_names 
#'
#' @return
#' @export
#'
#' @examples
fetch = function(dataset, quiet=TRUE, data_names=NULL){
  library(reticulate)
  r_data_retriever = import('retriever')
  data_sets = list()
  #Accessing datasets() function from Python API
  for(x in r_data_retriever$datasets()){
    data_sets = c(data_sets,x$name)
  }
  if(!dataset %in% data_sets){
    stop("The dataset requested isn't currently available in the rdataretriever.\nYou can run rdataretriever::datasets() to 
         get a list of available datasets\nOr run rdataretriver::get_updates() to get the newest available datasets.")
  }
  temp_path = tolower(tempdir())
  if(!dir.exists(temp_path)){
    dir.create(temp_path) 
  }
  datasets = vector('list', length(dataset))
  if (is.null(data_names)) {
    names(datasets) = dataset
    names(datasets) = gsub('-', '_', names(datasets))
  } 
  else {
    if (length(data_names) != length(dataset))
      stop('Number of names must match number of datasets')
    else ((length(data_names) == 1) & (length(dataset) == 1))
    stop("Assign name through the output instead (e.g., yourname = fetch('dataset')")
    names(datasets) = data_names
  }
  for (i in seq_along(dataset)) {
    if (quiet)
      #Accessing install() function from Python API
      r_data_retriever$install_csv(dataset = dataset[i],table_name = file.path(temp_path, '{db}_{table}.csv'))
    else 
      install(dataset[i], connection='csv', data_dir=temp_path)
    files = dir(temp_path)
    dataset_underscores = gsub('-', '_', dataset[i])
    files = files[grep(dataset_underscores, files)]
    tempdata = vector('list', length(files))
    list_names = sub('.csv', '', files)
    list_names = sub(paste(dataset_underscores, '_', sep = ''), 
                     '', list_names)
    names(tempdata) = list_names
    for (j in seq_along(files)) {
      tempdata[[j]] = utils::read.csv(file.path(temp_path, files[j]))
    }
    datasets[[i]] = tempdata
  }
  if (length(datasets) == 1)
    datasets = datasets[[1]]
  return(datasets)
  }

#download function

#' Title
#'
#' @param dataset 
#' @param path 
#' @param quiet 
#' @param sub_dir 
#' @param debug 
#'
#' @return
#' @export
#'
#' @examples
download = function(dataset, path='./', quiet=FALSE, sub_dir=FALSE, debug=FALSE) {
  library(reticulate)
  r_data_retriever = import('retriever')
  if (sub_dir)
    r_data_retriever$download(dataset = dataset,path = path)
  else 
    r_data_retriever$download(dataset = dataset)
  }

#datasets function

#' Title
#'
#' @return
#' @export
#'
#' @examples
datasets = function(){
  library(reticulate)
  r_data_retriever = import('retriever')
  data_sets = c()
  #Accessing datasets() function from Python API
  for(x in r_data_retriever$datasets()){
    data_sets = c(data_sets,x$name)
  }
  print(data_sets)
  }

#install functions 

#' Title
#'
#' @param dataset 
#' @param table_name 
#' @param debug 
#' @param use_cache 
#'
#' @return
#' @export
#'
#' @examples
install_csv = function(dataset,table_name='{db}_{table}.csv',debug=FALSE, use_cache=TRUE){
  library(reticulate)
  r_data_retriever = import('retriever')
  r_data_retriever$install_csv(dataset, table_name ,debug,use_cache)
  }

#' Title
#'
#' @param dataset 
#' @param table_name 
#' @param debug 
#' @param use_cache 
#'
#' @return
#' @export
#'
#' @examples
install_json = function(dataset,table_name='{db}_{table}.json',debug=FALSE, use_cache=TRUE){
  r_data_retriever = import('retriever')
  r_data_retriever$install_json(dataset, table_name ,debug,use_cache)
  }

#' Title
#'
#' @param dataset 
#' @param table_name 
#' @param debug 
#' @param use_cache 
#'
#' @return
#' @export
#'
#' @examples
install_xml = function(dataset,table_name='{db}_{table}.xml',debug=FALSE, use_cache=TRUE){
  library(reticulate)
  r_data_retriever = import('retriever')
  r_data_retriever$install_xml(dataset, table_name ,debug,use_cache)
  }

#' Title
#'
#' @param dataset 
#' @param user 
#' @param password 
#' @param host 
#' @param port 
#' @param database_name 
#' @param table_name 
#' @param debug 
#' @param use_cache 
#'
#' @return
#' @export
#'
#' @examples
install_mysql = function(dataset, user='root', password='', host='localhost',
                          port=3306, database_name='{db}', table_name='{db}.{table}',
                          debug=FALSE, use_cache=TRUE){
  library(reticulate)
  r_data_retriever = import('retriever')
  r_data_retriever$install_mysql(dataset, user, password, host,
                                 port, database_name, table_name,
                                 debug, use_cache)
  }

#' Title
#'
#' @param dataset 
#' @param user 
#' @param password 
#' @param host 
#' @param port 
#' @param database 
#' @param database_name 
#' @param table_name 
#' @param debug 
#' @param use_cache 
#'
#' @return
#' @export
#'
#' @examples
install_postgres = function(dataset, user='postgres', password='',
                            host='localhost', port=5432, database='postgres',
                            database_name='{db}', table_name='{db}.{table}',
                            debug=FALSE, use_cache=TRUE){
  library(reticulate)
  r_data_retriever = import('retriever')
  r_data_retriever$install_postgres(dataset, user, password, host,
                                    port, database, database_name, 
                                    table_name, debug, use_cache)
  }

#' Title
#'
#' @param dataset 
#' @param file 
#' @param table_name 
#' @param debug 
#' @param use_cache 
#'
#' @return
#' @export
#'
#' @examples
install_sqlite = function(dataset, file = 'sqlite.db',
                          table_name='{db}_{table}',
                          debug=FALSE, use_cache=TRUE){
  library(reticulate)
  r_data_retriever = import('retriever')
  r_data_retriever$install_sqlite(dataset, file, table_name, debug, use_cache)
  }

#' Title
#'
#' @param dataset 
#' @param file 
#' @param table_name 
#' @param debug 
#' @param use_cache 
#'
#' @return
#' @export
#'
#' @examples
install_msaccess = function(dataset, file='access.mdb',
                            table_name='[{db} {table}]',
                            debug=FALSE, use_cache=TRUE){
  library(reticulate)
  r_data_retriever = import('retriever')
  r_data_retriever$install_msaccess(dataset,file,table_name,debug,use_cache)
  }

#get_citation

#' Title
#'
#' @param dataset 
#'
#' @return
#' @export
#'
#' @examples
get_citation = function(dataset) {
    run_cli(paste('retriever citation', dataset))
  }

reset = function(scope='all') {
  os = Sys.info()[['sysname']]
  home_dir = Sys.getenv('HOME')
  print(paste("This will delete", toupper(scope), "cached infomation"))
  choice.name <- readline(prompt = "Do you want to proceed? (y/N)")
  if (tolower(scope) == "all" & tolower(choice.name) == "y") {
    if (file.exists(file.path(home_dir, ".retriever"))) {
      unlink(file.path(home_dir, ".retriever"), recursive = TRUE)
    }
  } else if (tolower(scope) == "scripts" &
             tolower(choice.name) == "y") {
    if (file.exists(file.path(home_dir, ".retriever", "scripts"))) {
      unlink(file.path(home_dir, ".retriever", "scripts"), recursive = TRUE)
    }
  }else if (tolower(scope) == "data" & tolower(choice.name) == "y") {
    if (file.exists(file.path(home_dir, ".retriever", "raw_data"))) {
      unlink(file.path(home_dir, ".retriever", "raw_data"), recursive = TRUE)
    }
  }else if (tolower(scope) == "connections" &
            tolower(choice.name) == "y") {
    if (file.exists(file.path(home_dir, ".retriever", "connections"))) {
      unlink(file.path(home_dir, ".retriever", "connections"), recursive = TRUE)
    }
  }
  }

#' Title
#'
#' @return
#' @export
#'
#' @examples
get_updates = function() {
    writeLines(strwrap('Please wait while the retriever updates its scripts, ...'))
    update_log = run_cli('retriever update')
    writeLines(strwrap(update_log[3]))
  }

#' Title
#'
#' @param path 
#'
#' @return
#' @export
#'
#' @examples
use_RetrieverPath = function(path){
  Sys.setenv(PATH = paste(path,':',Sys.getenv('PATH'),sep = ''))
}

print.update_log = function(x, ...) {
    if (length(x) == 0) {
        cat('No scripts downloaded')
    } 
    else {
        # clean up and print the update log output
        object = strsplit(paste(x, collapse = ' ; '), 'Downloading script: ')
        object = sort(sapply(strsplit(object[[1]][-1], ' ; '), 
                       function(x) x[[1]][1]))
        object[1] = paste('Downloaded scripts:', object[1])
        cat(object, fill=TRUE, sep=', ')
    }
  }

.onAttach = function(...) {
    packageStartupMessage(
        "\n  Use get_updates() to download the most recent release of download scripts
     
    New to rdataretriever? Examples at
      https://github.com/ropensci/rdataretriever/
      Use citation(package='rdataretriever') for the package citation
    \nUse suppressPackageStartupMessages() to suppress these messages in the future")
  }

.onLoad = function(...) {
    check_for_retriever()
  }

set_home = function(...) {
    current_home = normalizePath(Sys.getenv('HOME'), winslash = "/")
    Sys.setenv(HOME = gsub("/Documents", "", Sys.getenv('HOME')))
  }

check_for_retriever = function(...) {
  library(reticulate)
  python_paths = py_config()[13][[1]]
  python_paths = unique(unlist(lapply(python_paths,dirname)))
  python_paths = paste(python_paths,collapse = ':')
  Sys.setenv(PATH = paste(python_paths,':',Sys.getenv('PATH'),sep=''))
  retriever_path = Sys.which('retriever')  
  if (retriever_path == '') {
    path_warn = 'The retriever is not on your path and may not be installed.'
    mac_instr = 'Follow the instructions for installing and manually adding the Data Retriever to your path at http://www.data-retriever.org/#install'
    download_instr = 'Please upgrade to the most recent version of the Data Retriever, which will automatically add itself to the path http://www.data-retriever.org/#install'
    os = Sys.info()[['sysname']]
    if (os == 'Darwin')
      packageStartupMessage(paste(path_warn, mac_instr))
    else 
      packageStartupMessage(paste(path_warn, download_instr))
    }    
  }

run_cli = function(...) {
    os = Sys.info()[['sysname']]
    if (os == "Windows") {
        shell(...)
    } else {
        system(...)
    }
  }

get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin')
      os <- "osx"
  } else { ## mystery machine
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os))
      os <- "osx"
    if (grepl("linux-gnu", R.version$os))
      os <- "linux"
  }
  tolower(os)
  }
