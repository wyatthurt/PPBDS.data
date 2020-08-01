# Any code in a tutorial, including in a hint, which produces an error when run
# on its own will cause an error if you use R CMD check. Most common example is
# when you have ... to indicate to the student that they should replace the ...
# with something. Best solution is to set eval=FALSE in all hint chunks.

# Testing is hard. There are (at least) two different environments in which we
# run tests. First, and most important, is when we run R CMD check. This is the
# most rigorous check. Most importantly, it seems to require that code written
# in hint code chunks work correctly. So, you can't just have things like
# library(...) around, even though that is an extremely convenient way to
# indicate to the student that they need to use the library function with some
# argument. The second environment is when you press "Test Package". I think
# that all this does is to source tests/testthat.R. (And this environment is
# (mostly) the same as when you just execute tests interactively. At least, the
# two give the same answer.) But, in this second case, the code in hint chunks
# is not evaluated.

# Side note: Because we use the system.package hack, we are only ever testing
# the tutorials which are already installed. If you make a change in a file, you
# need to reinstall before running the test.

# First, we have the problem of finding all the Rmd files which we want to test.
# There are three approaches to finding files in a package when you don't know
# where the package is going to be. First, you can use relative paths, but that
# can be tricky because you don't quite know where the process will be located
# when it runs the tests. Second, you can use "system.file" as we do below. This
# is OK, but you can't use wild cards, which would make this code more elegant.
# Third, I bet the **here** package could solve this, but I was hesitant to go
# down that road.

# Second, once you know where the Rmd file is, you have to "test" it somehow. As
# you can see, our definition of "test" is to be knittable without causing an
# error. There is no check to see if "tutorial.html" looks OK, just that that
# string is returned.

# Third, might we do more here? For example, what we really want to confirm is
# that, when a student presses the "Run Document" button, things will work. I am
# not sure if render() is the same thing.

# Fourth, for now the real problem is that we can't even get this hack working
# with tutorials after zero, mainly because they have ... in lots of hints, I
# think. Be good to figure this out before we write a few hundred more questions
# . . .


context("Tutorials")
library(PPBDS.data)

tut.0.Rmd <- system.file(package = "PPBDS.data", "tutorials/00-shopping-week/tutorial.Rmd")

test_that(".Rmd of tutorial 0 knits without error", {
  expect_output(rmarkdown::render(tut.0.Rmd, output_file = "tutorial.html"),
                "tutorial.html")
})

tut.1.Rmd <- system.file(package = "PPBDS.data", "tutorials/01-visualization/tutorial.Rmd")

test_that(".Rmd of tutorial 1 knits without error", {
  expect_output(rmarkdown::render(tut.1.Rmd, output_file = "tutorial.html"),
                "tutorial.html")
})

tut.2.Rmd <- system.file(package = "PPBDS.data", "tutorials/02-tidyverse/tutorial.Rmd")

test_that(".Rmd of tutorial 2 knits without error", {
  expect_output(rmarkdown::render(tut.2.Rmd, output_file = "tutorial.html"),
                "tutorial.html")
})

tut.3.Rmd <- system.file(package = "PPBDS.data", "tutorials/03-rubin-causal-model/tutorial.Rmd")

test_that(".Rmd of tutorial 3 knits without error", {
  expect_output(rmarkdown::render(tut.3.Rmd, output_file = "tutorial.html"),
                "tutorial.html")
})


tut.4.Rmd <- system.file(package = "PPBDS.data", "tutorials/04-functions/tutorial.Rmd")

test_that(".Rmd of tutorial 4 knits without error", {
  expect_output(rmarkdown::render(tut.4.Rmd, output_file = "tutorial.html"),
                "tutorial.html")
})

