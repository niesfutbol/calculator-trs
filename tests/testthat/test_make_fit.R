setwd("/workdir")
library(geci.rjags)

in_file <- "tests/data/statistics_262_2019.csv"
input_file <- read.csv(in_file)
testthat::test_that("dummy test", {
  testthat::expect_equal(input_file,input_file)
})

out_file <- "tests/data/expected_statistics_262_2019.csv"
output_file <- read.csv(out_file)
testthat::test_that("obtained expected data", {
  testthat::expect_equal(input_file, output_file)
})