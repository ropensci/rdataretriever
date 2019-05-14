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
      - [Installation from CRAN and PyPi](#installation-from-cran-and-pypi)
      - [Installation with devtools and <code>reticulate</code>](#installation-with-devtools-and-reticulate)
  - [Examples](#examples)
  - [Spatial data installation](#spatial-data-installation)
  - [Using Dockers](#using-dockers)
  - [Acknowledgements](#acknowledgements)

## Installation

`rdataretriever` is an R wrapper for the Python based Data Retriever. This means
that Python and the `retriever` package need to be installed first.

#### Installation from `CRAN` and `conda` or `Anaconda`

*Use this if you are new to Python or don't have a local Python installation*

1. Install the Python 3.7 version of the miniconda Python distribution from https://docs.conda.io/en/latest/miniconda.html
2. In R install the `reticulate` package:

  ```coffee
  install.packages("reticulate")
  ```

3. In R run the following to install the `retriever` Python package:

  ```coffee
  library(reticulate)
  py_available(initialize = TRUE)
  py_install("retriever")
  ```

4. Install the `rdataretriever` R package:

  ```coffee
  install.packages("rdataretriever") # from CRAN
  devtools::install_github("ropensci/rdataretriever") # from GitHub
  ```

#### Installation with `devtools`

*Use this if you are already familiar with Python and have a local Python installation*

1. Check that your local Python installation is Python 3.6 and above
2. In R install the `reticulate` package:

  ```coffee
  install.packages("reticulate")
  ```

3. In R run the following (`replacing "/path/to/python" with the path to you Python executeable`) to install the `retriever` Python package:

  ```coffee
  library(reticulate)
  use_python("/path/to/python")
  py_install("retriever")
  ```

4. Install the `rdataretriever` R package:

  ```coffee
  devtools::install_github("ropensci/rdataretriever") # from GitHub
  install.packages("rdataretriever") # from CRAN
  ```

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
