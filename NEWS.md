rdataretriever 3.1.1
====================

## Minor Improvements

* Update Authors' list

rdataretriever 3.1.0
====================

### New Features

* Add rdatasets and Socrata API
* Remove Travis and use GitHub actions
* Change default branch from master to main
* Add Joss Paper and DOI badge
* Update and simplify installation instructions
* Remove windows specific install instructions
* Update the vignettes

## Minor Improvements

* Rename the function to data_retriever_version
* Add get_version function
* Automatically reload the scripts
* Reactivate MariaDB tests
* Use Cloud CRAN mirror in Docker-based testing
* Simplify the interface to retriever module add function to install retriever
* Add tests for get-script-citation
* Add get citation function

rdataretriever 3.0.1
====================

### New Coauthors

We welcome Apoorva Pandey and Hao Ye as coauthors on the package.
Thanks for the great contributions!

### New Features

* Add provenance support
* Add support for new online/offline dataset feature in retriever
* Automatically update dataset status
* Check that the retriever Python package is sufficiently up-to-date
* Update and simplify installation instructions
* Add get citation function
* Update and simplify internals to benefit from updates to reticulate
* Add vignettes
## Minor Improvements

* Improvements to code style and documentation
* Use Cloud CRAN mirror in Docker-based testing for stability
* Add get_version function, returns the version of the Data Retriever

rdataretriever 3.0.0
====================

### New Coauthors

We welcome Apoorva Pandey and Hao Ye as coauthors on the package.
Thanks for the great contributions!

### New Features

* Add provenance support
* Add support for new online/offline dataset feature in retriever
* Automatically update dataset status
* Check that the retriever Python package is sufficiently up-to-date
* Update and simplify installation instructions
* Add get citation function
* Update and simplify internals to benefit from updates to reticulate

## Minor Improvements

* Improvements to code style and documentation
* Use Cloud CRAN mirror in Docker-based testing for stability
* Add get_version function, returns the version of the Data Retriever

rdataretriever 2.0.0
====================

### New Coauthors

We welcome Harshit Bansal as a coauthor on the package. 
Thanks for the great help!

### New Features

* Add a customize installation to directory using data dir
* Use Dockers for testing
* Add spatial support using Postgis
* Using reticulate
* Add get_citation function
* Update Reset retriever to include reseting specific scripts or data

### Minor Improvements

* Improve the test platform and use reticulate in the tests
* Test using custom service names specific to project
* Add potential path for retriever in Windows

### Bug Fixes
* No scripts when using reticulate based install on retriever


rdataretriever 1.1.0
====================

NEW COAUTHORS

* We welcome Pranita Sharma and David J. Harris as coauthors on the package. Thanks
for the great help Pranita and David!

NEW FEATURES

* Use reticulate to integrate with retriever Python
* Spatial dataset processing Beta version using PostGis

MINOR IMPROVEMENTS

* Use Docker compose for testing
* Switch to Python 3 for testing
* Enhance path search on Windows
* Add a debug script for reporting the environment variables
* Update documentation to match latest version
* Add license file

rdataretriever 1.0.0
====================

NEW PACKAGE NAME

* The `EcoData Retriever` has been renamed to `Data Retriever` to reflect its
utility outside of ecological data and consequently we have renamed the R package
from `ecoretriever` to `rdataretriever`

NEW COAUTHORS

* We welcome Henry Senyondo and Shawn Taylor as coauthors on the package. Thanks
for the great help Henry and Shawn!

NEW FEATURES

* Add `reset` which allows a user to delete all the `Data Retriever` downloaded
files
* Add `json` and `xml` as output options

MINOR IMPROVEMENTS

* Accommodate new retriever naming conventions in fetch
* Don't change the class or return the update log
* Specify in documentation which functions are for internal use.
* Change dataset names in source and README.md

BUG FIXES

* Search for Anaconda installs of the `Data Retriever`
* Obtain correct home path in RStudio on Windows

ecoretriever 0.3.0
==================

MINOR IMPROVEMENTS

* Improve documentation for using the connection file

BUG FIXES

* Fix issues with running on some Windows machines by using `shell()` instead of
  `system()` on Windows
* Fix new `--subdir` functionality (released in 0.2.2)


ecoretriever 0.2
================

NEW FEATURES
* We added a new function `get_updates` which can be used to update the `retriever` scripts. This is a big improvement for users because it avoids automatically updating the scripts every time the package is imported. The log of the scripts update can be printed in a cleaner format as well.
* Added support for maintaining subdirectory structure when using the function `download`.

MINOR IMPROVEMENTS

* default data_dir argument is now set to working directory rather than NULL for the function `install()`

BUG FIXES

* On windows machine if the data directory was not specified for a dataset install an error would occur. Now the dataset directory is always specified in external calls to `retriever install ...`

