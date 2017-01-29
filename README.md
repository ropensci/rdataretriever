dataretriever [![Build Status](http://cranlogs.r-pkg.org/badges/grand-total/dataretriever)](http://cran.rstudio.com/web/packages/dataretriever/index.html)
============

R interface to the [Data Retriever](http://data-retriever.org).

The Data Retriever automates the tasks of finding, downloading, and cleaning
up publicly available data, and then stores them in a local database
or csv files. This lets data analysts spend less time cleaning up and managing
data, and more time analyzing it.

This package lets you access the Retriever using R, so that the Retriever's data
handling can easily be integrated into R workflows.

Installation
------------
To use the R package `dataretriever` you first need to install the Retriever.
Installers are available for all major operating systems from the [Download page](http://data-retriever.org/download.html)
or it can be installed from [source](https://github.com/weecology/retriever).

Add Retriever to the path
-------------------------
The R package takes advantage of the Data Retriever's command line interface
which must be enabled by adding it to the path on Mac platforms.
On a Windows platform the Retriever should be added automatically to the path.

Install R package
-----------------

To install the development version of the R package `dataretriever`, use the `devtools` package:

```coffee
# install.packages("devtools")
library(devtools)
install_github("ropensci/dataretriever")
```

Examples
--------
```coffee
library(dataretriever)

# List the datasets available via the Retriever
dataretriever::datasets()

# Install the Gentry dataset into csv files in your working directory
dataretriever::install('Gentry', 'csv')

# Download the raw Gentry dataset files without any processing to the 
# subdirectory named data
dataretriever::download('Gentry', './data/')

# Install and load a dataset as a list
Gentry = dataretriever::fetch('Gentry')
names(Gentry)
head(Gentry$counts)
```

To get citation information for the `dataretriever` in R use `citation(package = 'dataretriever')`

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
