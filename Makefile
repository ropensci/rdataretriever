PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)

all: install

build:
	cd ..;\
	R CMD build $(PKGSRC)

install:
	cd ..;\
	R CMD INSTALL $(PKGSRC)

check:
	Rscript -e "install.packages("testthat")"
	Rscript -e "devtools::check(document = FALSE, args = '--as-cran')"

test:
	Rscript -e "library('testthat',quietly=TRUE);library('rdataretriever',quietly=TRUE);options(warn=2);test_dir('tests/tests')"


