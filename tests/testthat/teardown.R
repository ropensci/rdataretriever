# During teardown, testthat uses the file's current directory
downloads <- dir(path = ".",
                 pattern = "((portal)|(test.sqlite)|(sqlite.db)|(\\d+\\d))")
file.remove(downloads)
unlink("data", recursive = TRUE)
