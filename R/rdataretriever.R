#Usage of Reticulate instead of command line interface of Data Retriever

#fetch function

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

download = function(dataset, path='./', quiet=FALSE, sub_dir=FALSE, debug=FALSE) {
  library(reticulate)
  r_data_retriever = import('retriever')
  if (sub_dir)
    r_data_retriever$download(dataset = dataset,path = path)
  else 
    r_data_retriever$download(dataset = dataset)
  }

#datasets function

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

install_csv = function(dataset,table_name='{db}_{table}.csv',debug=FALSE, use_cache=TRUE){
  library(reticulate)
  r_data_retriever = import('retriever')
  r_data_retriever$install_csv(dataset, table_name ,debug,use_cache)
  }

install_json = function(dataset,table_name='{db}_{table}.json',debug=FALSE, use_cache=TRUE){
  r_data_retriever = import('retriever')
  r_data_retriever$install_json(dataset, table_name ,debug,use_cache)
  }

install_xml = function(dataset,table_name='{db}_{table}.xml',debug=FALSE, use_cache=TRUE){
  library(reticulate)
  r_data_retriever = import('retriever')
  r_data_retriever$install_xml(dataset, table_name ,debug,use_cache)
  }

install_mysql = function(dataset, user='root', password='', host='localhost',
                          port=3306, database_name='{db}', table_name='{db}.{table}',
                          debug=FALSE, use_cache=TRUE){
  library(reticulate)
  r_data_retriever = import('retriever')
  r_data_retriever$install_mysql(dataset, user, password, host,
                                 port, database_name, table_name,
                                 debug, use_cache)
  }

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

install_sqlite = function(dataset, file = 'sqlite.db'),
                          table_name='{db}_{table}',
                          debug=FALSE, use_cache=TRUE){
  library(reticulate)
  r_data_retriever = import('retriever')
  r_data_retriever$install_sqlite(dataset, file, table_name, debug, use_cache)
  }

install_msaccess = function(dataset, file='access.mdb',
                            table_name='[{db} {table}]',
                            debug=FALSE, use_cache=TRUE){
  library(reticulate)
  r_data_retriever = import('retriever')
  r_data_retriever$install_msaccess(dataset,file,table_name,debug,use_cache)
  }

#get_citation

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

get_updates = function() {
    writeLines(strwrap('Please wait while the retriever updates its scripts, ...'))
    update_log = run_cli('retriever update', intern=TRUE, ignore.stdout=FALSE,
                         ignore.stderr=TRUE)
    writeLines(strwrap(update_log[3]))
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
    retriever_path = Sys.which('retriever')
    set_home()
    home_dir = Sys.getenv('HOME')
    #Rstudio will not import any paths configured for anaconda python installs, so add default anaconda paths
    #manually. See http://stackoverflow.com/questions/31121645/rstudio-shows-a-different-path-variable
    if (retriever_path == '') {
        os = Sys.info()[['sysname']]
        possible_pathes = c('/Anaconda3/Scripts',
                            '/Anaconda2/Scripts',
                            '/Anaconda/Scripts',
                            '/Miniconda3/Scripts',
                            '/Miniconda2/Scripts',
                            '/anaconda3/bin',
                            '/anaconda2/bin',
                            '/anaconda/bin',
                            '/miniconda3/bin',
                            '/miniconda2/bin')
        for (i in possible_pathes) {
            Sys.setenv(PATH = paste(Sys.getenv('PATH'), ':', home_dir, i, sep = ''))
        }

        # paths on Windows if installed using executable:
        if (Sys.info()[['sysname']] == "Windows") {
          more_win_paths = c('C:/',
                             'C:/Program files/',
                             'C:/Program files (x86)/')
          for (i in more_win_paths) {
            Sys.setenv(PATH = paste(Sys.getenv('PATH'), ';', i, 'DataRetriever', sep = ''))
          }
        }

    }
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
