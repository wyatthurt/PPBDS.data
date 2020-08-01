# Zero, testing is hard, as a deleted comment mentions. The environment when
# executing interactively is not the same as the one for R CMD check. See
# comments below. Interactive use seems OK with ... put any old place. R CMD
# check is not.

# First, we have the problem of finding all the Rmd files which we want to test.
# There are three approaches to finding files in a package when you don't know
# where the package is going to be. First, you can use relative paths, but that
# can be tricky because you don't quite know where the process will be located
# when it runs the tests. Second, you can use "system.file" as we do below. This
# is OK, but you can't use wild cards, which would make this code more elegant.
# Third, I bet the **here** package could solve this, but I was hestitant to go
# down that road.

# Second, once you know where the Rmd file is, you have to "test" it somehow. As
# you can see, our definition of "test" is to be knittable without causing an
# error. There is no check to see if "tutorial.html" looks OK, just that that
# string is returned.

# Third, might we do more here? For example, what we really want to confirm is
# that, when a student presses the "Run Document" button, things will work. I am
# not sure if render() is the same thing.

context("Tutorials")
library(PPBDS.data)

tut.0.Rmd <- system.file(package = "PPBDS.data", "tutorials/00-shopping-week/tutorial.Rmd")

test_that(".Rmd of tutorial 0 knits without error", {
  expect_output(rmarkdown::render(tut.0.Rmd, output_file = "tutorial.html"),
                "tutorial.html")
})

# Both 1 and 3 work interactively, but not with R CMD check. Error for both is:

# '...' used in an incorrect context

# THIS MAKES ME NERVOUS. We use ... in lots of hints. Maybe we shouldn't?

#
# tut.1.Rmd <- system.file(package = "PPBDS.data", "tutorials/01-visualization/tutorial.Rmd")
#
# test_that(".Rmd of tutorial 1 knits without error", {
#   expect_output(rmarkdown::render(tut.1.Rmd, output_file = "tutorial.html"),
#                 "tutorial.html")
# })

# tut.2.Rmd <- system.file(package = "PPBDS.data", "tutorials/02-tidyverse/tutorial.Rmd")
#
# test_that(".Rmd of tutorial 2 knits without error", {
#   expect_output(rmarkdown::render(tut.2.Rmd, output_file = "tutorial.html"),
#                 "tutorial.html")
# })

# This works interactively, but not with R CMD check. Error is:
# non-numeric argument to binary operator

# tut.3.Rmd <- system.file(package = "PPBDS.data", "tutorials/03-rubin-causal-model/tutorial.Rmd")
#
# test_that(".Rmd of tutorial 3 knits without error", {
#   expect_output(rmarkdown::render(tut.3.Rmd, output_file = "tutorial.html"),
#                 "tutorial.html")
# })

# And then we need 4.

