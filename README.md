# rdataretriever

[![Build Status](https://travis-ci.org/ropensci/rdataretriever.png)](https://travis-ci.org/ropensci/rdataretriever)
[![cran version](https://www.r-pkg.org/badges/version/rdataretriever)](https://CRAN.R-project.org/package=rdataretriever)
[![Documentation Status](https://readthedocs.org/projects/retriever/badge/?version=latest)](https://retriever.readthedocs.io/en/latest/rdataretriever.html#)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/rdataretriever)](https://CRAN.R-project.org/package=rdataretriever) +
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/ecoretriever)](https://CRAN.R-project.org/package=ecoretriever)
(old package name)

R interface to the [Data Retriever](http://data-retriever.org).

The Data Retriever automates the tasks of finding, downloading, and cleaning up
publicly available data, and then stores them in a local database or csv
files. This lets data analysts spend less time cleaning up and managing data,
and more time analyzing it.

This package lets you access the Retriever using R, so that the Retriever's data
handling can easily be integrated into R workflows.

## Table of Contents

  - [Installation](#installation)
      - [Installation with `conda` or virtual environments](#installation-with-conda-or-virtual-environments)
      - [Installation using Python standard distribution](#Installation-using-Python-standard-distribution)
  - [Examples](#examples)
  - [Spatial data installation](#spatial-data-installation)
  - [Using Dockers](#using-dockers)
  - [Acknowledgements](#acknowledgements)

## Installation

Requirements:

The `rdataretriever` is an R wrapper for the Python package, [Data Retriever](http://data-retriever.org). This means
that *Python* and the `retriever` Python package need to be installed first.

- R (A recent release is recommended)
- reticulate R package
- Python 3.6 and above
- The Data Retriever Python package

#### Installation with Conda or virtual environments

1. Install the Python 3.7 version of the miniconda Python distribution from https://docs.conda.io/en/latest/miniconda.html
2. In R install the `reticulate` package (the current release, 1.13, does not work on Windows so installation using devtools is recommended):

  ```coffee
  devtools::install_github("rstudio/reticulate") # from GitHub
  ```

Verify that the path used by reticulate is correct

  ```coffee
  Sys.which('Python')
  library(reticulate)
  py_config()
  ```

Sample output:

  ```coffee
  > py_config()
  python:         /Users/Documents/Environments/py36/bin/python
  virtualenv:     /Users/Documents/Environments/py36/bin/activate_this.py
  numpy:          /Users/Documents/Environments/py36/lib/python3.6/site-packages/numpy..
  numpy_version:  1.15.4
  python versions found:
   /Users/Documents/Environments/py36/bin/python
   /usr/bin/python
   /usr/local/bin/python
  ```

If the values of python are not pointing to the correct python environment,

```
  Restart R
  Load reticulate `library(reticulate)`
  Use the functions `use_python()`, `use_virtualenv()`, `use_condaenv()` to set the path.
  Check py_config(). The order is important, py_config() is found to avoid resetting the path for the current session
```
Note: Currently these functions are not working as smooth as expected, we do recommended that you obtain the path of python for the
active virtual enviroment and set it using `use_python(PATH_TO_ENV)`.
It is also recommended to set the value of `RETICULATE_PYTHON` to the Python location if possible

3. Install the Python package `retriever`. You can use reticulate's python package installer or pip or conda.

  ```coffee
  library(reticulate)
  py_available(initialize = TRUE)
  py_install("retriever")
  ```

4. Install the `rdataretriever` R package using one of the commands below:

  ```coffee
  install.packages("rdataretriever") # from CRAN
  devtools::install_github("ropensci/rdataretriever") # from GitHub
  install.packages(".", repos = NULL, type="source") # from source
  ```

#### Installation using Python standard distribution

Set the path for *Python* and *RETICULATE_PYTHON* to the Python location
Install reticulate in R , Load retriculate and verify the python path used, see 2 above
Install retriever as in 3 and 4 above

Examples
--------
```coffee
library(rdataretriever)

# List the datasets available via the Retriever
rdataretriever::datasets()

# Install the portal into csv files in your working directory
rdataretriever::install_csv('portal')

# Download the raw portal dataset files without any processing to the
# subdirectory named data
rdataretriever::download('portal', './data/')

# Install and load a dataset as a list
portal = rdataretriever::fetch('portal')
names(portal)
head(portal$species)

```

Spatial data Installation
-------------------------

**Set-up and Requirements**

**Tools**

-  PostgreSQL with PostGis, psql(client), raster2pgsql, shp2pgsql, gdal,

The `rdataretriever` supports installation of spatial data into `Postgres DBMS`.

1. **Install PostgreSQL and PostGis**

	To install `PostgreSQL` with `PostGis` for use with spatial data please refer to the
	[OSGeo Postgres installation instructions](https://trac.osgeo.org/postgis/wiki/UsersWikiPostGIS21UbuntuPGSQL93Apt).

	We recommend storing your PostgreSQL login information in a `.pgpass` file to
	avoid supplying the password every time.
	See the [`.pgpass` documentation](https://wiki.postgresql.org/wiki/Pgpass) for more details.

	After installation, Make sure you have the paths to these tools added to your system's `PATHS`.
	Please consult an operating system expert for help on how to change or add the `PATH` variables.

	**For example, this could be a sample of paths exported on Mac:**

	```shell
	#~/.bash_profile file, Postgres PATHS and tools.
	export PATH="/Applications/Postgres.app/Contents/MacOS/bin:${PATH}"
	export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/10/bin"

	```

2. **Enable PostGIS extensions**

	If you have `Postgres` set up, enable `PostGIS` extensions.
	This is done by using either `Postgres CLI` or `GUI(PgAdmin)` and run

	**For psql CLI**
	```shell
	psql -d yourdatabase -c "CREATE EXTENSION postgis;"
	psql -d yourdatabase -c "CREATE EXTENSION postgis_topology;"
	```

	**For GUI(PgAdmin)**

	```sql
	CREATE EXTENSION postgis;
	CREATE EXTENSION postgis_topology
	```
	For more details refer to the
	[PostGIS docs](https://postgis.net/docs/postgis_installation.html#install_short_version).

**Sample commands**

```R
rdataretriever::install_postgres('harvard-forest') # Vector data
rdataretriever::install_postgres('bioclim') # Raster data

# Install only the data of USGS elevation in the given extent
rdataretriever::install_postgres('usgs-elevation', list(-94.98704597353938, 39.027001800158615, -94.3599408119917, 40.69577051867074))

```


Provenance
----------
`rdataretriever` allows users to save a dataset in its current state which can be used later.

Note: You can save your datasets in provenance directory by setting the environment variable `PROVENANCE_DIR`

**Commit a dataset**
```coffee
rdataretriever::commit('abalone-age', commit_message='Sample commit', path='/home/user/')
```
To commit directly to provenance directory:
```coffee
rdataretriever::commit('abalone-age', commit_message='Sample commit')
```
**Log of committed dataset in provenance directory**
```coffee
rdataretriever::commit_log('abalone-age')
```

**Install a committed dataset**
```coffee
rdataretriever::install_sqlite('abalone-age-a76e77.zip') 
```
Datasets stored in provenance directory can be installed directly using hash value
```coffee
rdataretriever::install_sqlite('abalone-age', hash_value='a76e77`)
``` 

Using Dockers
-------------

To run the image interactively

`docker-compose run --service-ports rdata /bin/bash`

To run tests

`docker-compose  run rdata Rscript load_and_test.R`

Release
-------

Make sure you have tests passing on R-oldrelease, current R-release and R-devel

To check the package

```Shell
R CMD Build #build the package
R CMD check  --as-cran --no-manual rdataretriever_[version]tar.gz
```

To Test

```R
setwd("./rdataretriever") # Set working directory
# install all deps
# install.packages("reticulate")
library(DBI)
library(RPostgreSQL)
library(RSQLite)
library(reticulate)
library(RMariaDB)
install.packages(".", repos = NULL, type="source")
roxygen2::roxygenise()
devtools::test()
```

To get citation information for the `rdataretriever` in R use `citation(package = 'rdataretriever')`

Acknowledgements
----------------
A big thanks to Ben Morris for helping to develop the Data Retriever.
Thanks to the rOpenSci team with special thanks to Gavin Simpson,
Scott Chamberlain, and Karthik Ram who gave helpful advice and fostered
the development of this R package.
Development of this software was funded by the [National Science Foundation](http://nsf.gov/)
as part of a [CAREER award to Ethan White](http://nsf.gov/awardsearch/showAward.do?AwardNumber=0953694).

---
[![ropensci footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
