# rdataretriever

<!-- badges: start -->
[![Build Status](https://travis-ci.org/ropensci/rdataretriever.svg?branch=main)](https://travis-ci.org/ropensci/rdataretriever)
[![Build status](https://ci.appveyor.com/api/projects/status/de1badmnrt6goamh?svg=true)](https://ci.appveyor.com/project/ethanwhite/rdataretriever)[![cran version](https://www.r-pkg.org/badges/version/rdataretriever)](https://CRAN.R-project.org/package=rdataretriever)
[![Documentation Status](https://readthedocs.org/projects/retriever/badge/?version=latest)](https://retriever.readthedocs.io/en/latest/rdataretriever.html#)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/rdataretriever)](https://CRAN.R-project.org/package=rdataretriever) +
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/ecoretriever)](https://CRAN.R-project.org/package=ecoretriever)
(old package name)
[![DOI](https://zenodo.org/badge/18155090.svg)](https://zenodo.org/badge/latestdoi/18155090)
[![DOI](https://joss.theoj.org/papers/10.21105/joss.02800/status.svg)](https://doi.org/10.21105/joss.02800)

<!-- badges: end -->

R interface to the [Data Retriever](https://retriever.readthedocs.io/en/latest/).

The `rdataretriever` provides access to cleaned versions of hundreds of commonly used public datasets with a single line of code. 

These datasets come from many different sources and most of them require some cleaning and restructuring prior to analysis.
The `rdataretriever` uses a set of actively maintained recipes for downloading, cleaning, and restructing these datasets using a combination of the [Frictionless Data Specification](https://specs.frictionlessdata.io/) and custom data cleaning scripts. 

The `rdataretriever` also facilitates the automatic storage of these datasets in a choice of database management systems (PostgreSQL, SQLite, MySQL, MariaDB) or flat file formats (CSV, XML, JSON) for later use and integration with large data analysis pipelines.

The `rdatretriever` also facilitates reproducibile science by providing tools to archive and rerun the precise version of a dataset and associated cleaning steps that was used for a specific analysis.

The `rdataretriever` handles the work of cleaning, storing, and archiving data so that you can focus on analysis, inference and visualization.


## Table of Contents

  - [Installation](#installation)
      - [Basic Installation (no Python experience needed)](#basic-installation)
      - [Advanced Installation for Python Users](#advanced-installation-for-python-users)
  - [Installing Tabular Datasets](#installing-tabular-datasets)
  - [Installing Spatial Datasets](#installing-spatial-datasets)
  - [Using Docker Containers](#using-docker-containers)
  - [Provenance](#provenance)
  - [Acknowledgements](#acknowledgements)

## Installation

The `rdataretriever` is an R wrapper for the Python package, [Data Retriever](https://retriever.readthedocs.io/en/latest/). This means
that *Python* and the `retriever` Python package need to be installed first.

### Basic Installation

If you just want to use the Data Retriever from within R follow these
instuctions run the following commands in R. This will create a local Python
installation that will only be used by R and install the needed Python package
for you.

```coffee
install.packages('reticulate') # Install R package for interacting with Python
reticulate::install_miniconda() # Install Python
reticulate::py_install('retriever') # Install the Python retriever package
install.packages('rdataretriever') # Install the R package for running the retriever
rdataretriever::get_updates() # Update the available datasets
```

**After running these commands restart R.**

### Advanced Installation for Python Users

If you are using Python for other tasks you can use `rdataretriever` with your
existing Python installation (though the [basic installation](#basic-installation)
above will also work in this case by creating a separate miniconda install and
Python environment).

#### Install the `retriever` Python package

Install the `retriever` Python package into your prefered Python environment
using either `conda` (64-bit conda is required):

  ```bash
  conda install -c conda-forge retriever
  ```

  or `pip`:

  ```bash
  pip install retriever
  ```

#### Select the Python environment to use in R

`rdataretriever` will try to find Python environments with `retriever` (see the
`reticulate` documentation on
[order of discovery](https://rstudio.github.io/reticulate/articles/versions.html#order-of-discovery-1)
for more details) installed. Alternatively you can select a Python environment
to use when working with `rdataretriever` (and other packages using
`reticulate`).

The most robust way to do this is to set the `RETICULATE_PYTHON` environment
variable to point to the preferred Python executable:

```coffee
Sys.setenv(RETICULATE_PYTHON = "/path/to/python")
```

This command can be run interactively or placed in `.Renviron` in your home
directory.

Alternatively you can do select the Python environment through the `reticulate`
package for either `conda`:

```coffee
library(reticulate)
use_conda('name_of_conda_environment')
```

or `virtualenv`:

```coffee
library(reticulate)
use_virtualenv("path_to_virtualenv_environment")
```

You can check to see which Python environment is being used with:

```coffee
py_config()
```

#### Install the `rdataretriever` R package

```coffee
install.packages("rdataretriever") # latest release from CRAN
```

```coffee
remotes::install_github("ropensci/rdataretriever") # development version from GitHub
```

## Installing Tabular Datasets

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

## Installing Spatial Datasets

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


## Provenance

To ensure reproducibility the `rdataretriever` supports creating snapshots of the data and the script in time.

Use the commit function to create and store the snapshot image of the data in time. Provide a descriptive message for the created commit. This is comparable to a git commit, however the function bundles the data and scripts used as a backup.

With provenace, you will be able to reproduce the same analysis in the future.

**Commit a dataset**

By default commits will be stored in the provenance directory `.retriever_provenance`, but this directory can be changed by setting the environment variable `PROVENANCE_DIR`.

```coffee
rdataretriever::commit('abalone-age',
                       commit_message='A snapshot of Abalone Dataset as of 2020-02-26')
```

You can also set the path for an individual commit:

```coffee
rdataretriever::commit('abalone-age',
                       commit_message='Data and recipe archive for Abalone Data on 2020-02-26',
					   path='.')
```

**View a log of committed datasets in the provenance directory**

```coffee
rdataretriever::commit_log('abalone-age')
```

**Install a committed dataset**

To reanalyze a committed dataset, rdataretriever will obtain the data and script from the history and rdataretriever will install this particular data into the given back-end. For example, SQLite:

```coffee
rdataretriever::install_sqlite('abalone-age-a76e77.zip') 
```
Datasets stored in provenance directory can be installed directly using hash value
```coffee
rdataretriever::install_sqlite('abalone-age', hash_value='a76e77')
``` 

## Using Docker Containers

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
Development of this software was funded by the [National Science Foundation](https://nsf.gov/)
as part of a [CAREER award to Ethan White](https://nsf.gov/awardsearch/showAward.do?AwardNumber=0953694).

---
[![ropensci footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
