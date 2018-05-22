#Usage of Reticulate instead of command line interface of Data Retriever

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
