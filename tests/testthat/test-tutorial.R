
# This file contains several tests to check if the tutorials
# actually work. Whenever we run check() or hit the check
# button in the 'Build' tab, R will automatically run all
# tests contained in this test file. Note that each test is
# run in its own environment to keep the whole process clean.
# This means that all packages to be used in the tests must
# be loaded within this file first. Also, all files to be
# accessed must either be contained in the directory in which
# the test is run (which is /testthat), or a relative path must
# be provided to show where a file can be found (which is what
# I did, see below).

# PROBLEM: Currently, the tests below succeed when running test(),
# but they fail when using check(). The issue seems to be that the
# two commands use different environments. This means that relative
# file paths that work for one function, here test(), do not work
# for the other. As a result, check() always returns an error as
# it cannot find the tutorial.Rmd files at the indicated path. I
# tried using absolute paths, but that caused both check() and test()
# to fail. Need to find out what exactly check() does with directories
# like /inst and /tests - see this https://bit.ly/3fpX62t.

# I turned the tests to comments until this is fixed, otherwise we'll
# get some errors whenever running check(). However, when removing
# the # below, you can already run the tests by using test().

context("Tutorials")
library(PPBDS.data)
library(fueleconomy)
library(learnr)


# Tutorial 0.

# test_that(".Rmd of tutorial 0 is knitted", {
#   expect_output(rmarkdown::render("../../inst/tutorials/00-shopping-week/tutorial.Rmd"), "tutorial.html")
# })


# Tutorial 1.

# test_that(".Rmd of tutorial 1 is knitted", {
#   expect_output(rmarkdown::render("../../inst/tutorials/01-visualization/tutorial.Rmd"), "tutorial.html")
# })


# Tutorial 2.

# test_that(".Rmd of tutorial 2 is knitted", {
#   expect_output(rmarkdown::render("../../inst/tutorials/02-tidyverse/tutorial.Rmd"), "tutorial.html")
# })


# Tutorial 3.

# test_that(".Rmd of tutorial 3 is knitted", {
#   expect_output(rmarkdown::render("../../inst/tutorials/03-rubin-causal-model/tutorial.Rmd"), "tutorial.html")
# })


# Tutorial 4.

# test_that(".Rmd of tutorial 4 is knitted", {
#   expect_output(rmarkdown::render("../../inst/tutorials/04-functions/tutorial.Rmd"), "tutorial.html")
# })





