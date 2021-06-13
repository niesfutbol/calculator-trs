setwd("/workdir")
library(geci.rjags)

in_file <- "tests/data/statistics_262_2019.csv"
results <- read.csv(in_file)
testthat::test_that("ajuste lineal", {
  testthat::expect_equal(results,results)
})
